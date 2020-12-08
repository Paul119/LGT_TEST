CREATE PROCEDURE [dbo].[Kernel_SP_Process_ApplyMobilityOnPopulation]
@idPlan int,
@mobilityDate datetime,
@idUser int,
@isFilterUsed bit,
@listOfEmployees  dbo.Kernel_ValueList_INT READONLY

AS


BEGIN TRY
	BEGIN TRANSACTION TR
		-- Insert steps starts from mobility date for new comers
		INSERT INTO k_m_plans_payees_steps (id_plan, id_assignment, id_payee, start_step,end_step, id_user_create, date_create_assignment, locked, frequency_index)
		SELECT 
				@idPlan AS idPlan, 
				(
					select	top 1 
							id_affectation 
						from k_m_plans_affectations aff
						join pop_population p
						on aff.id_assignee = p.idPop
						join pop_VersionContent vc
						on vc.idPopVersion = p.lastVersion
					where	id_plan = @idPlan
							and type_affectation = 'P'
							and idColl = m.idPayee
				) as id_affectation,
				m.idPayee, 
				t.start_step,
				t.end_step,
				@idUser AS id_user_create, 
				getdate() AS date_create_assignment, 
				0 AS locked, 
				frequency_index
		FROM 	Kernel_View_Process_MobilityOnPopulation m
				CROSS JOIN
				(
					SELECT 
							@mobilityDate AS start_step,
							ISNULL
							(
								( -- declare end_date of first step
									SELECT	TOP 1 
											DATEADD(SECOND,-1, start_date) AS end_step
									FROM	k_m_plans_frequency pf
									WHERE	pf.id_plan = @idPlan
											AND
											pf.start_date > @mobilityDate
									ORDER BY frequency_index
								),
								-- if null then set as last frequency step end date
								(Select max(end_Date) from k_m_plans_frequency where id_plan = @idPlan)
							) AS end_step,
							NULL AS frequency_index,
							@idPlan AS id_plan
					UNION
					SELECT 
							start_date AS start_step, 
							end_date AS end_step,
							id_plan,
							frequency_index
					FROM	k_m_plans_frequency pf
					WHERE	pf.id_plan = @idPlan
							AND
							pf.start_date > @mobilityDate
				) t
				WHERE	IdStatus = 1
				AND m.id_plan = @idPlan
				AND (@isFilterUsed = 0 OR Exists (select 1 from @listOfEmployees where ParamValue = m.idPayee))
		ORDER BY m.idPayee, start_step


		-- Insert fisrt payee step of payee into k_m_plans_payees_mobility as new comer
		INSERT INTO k_m_plans_payees_mobility
		SELECT id_step, 1 AS id_status FROM
		(
			SELECT id_step, 
					ROW_NUMBER() OVER (PARTITION BY ps.id_payee ORDER BY end_step ASC) AS rn
			FROM 
				Kernel_View_Process_MobilityOnPopulation m
				join k_m_plans_payees_steps ps
					on m.idPayee = ps.id_payee and m.id_plan = ps.id_plan
			WHERE	1=1
					AND m.IdStatus = 1
					AND m.id_plan = @idPlan
					AND (@isFilterUsed = 0 OR EXISTS (SELECT 1 FROM @listOfEmployees WHERE ParamValue = m.idPayee))
		) t2
		WHERE t2.rn = 1

		

		-- delete steps after mobility date for leavers
		DELETE FROM k_m_plans_payees_steps WHERE id_step IN 
		(
			SELECT 
				id_step
			FROM k_m_plans_payees_steps stp
				JOIN Kernel_View_Process_MobilityOnPopulation m
					ON stp.id_plan = m.id_plan AND m.idPayee = stp.id_payee
			WHERE	stp.id_plan = @idPlan
					AND m.IdStatus = 2
					AND stp.start_step > @mobilityDate
					AND (@isFilterUsed = 0 OR Exists (select 1 from @listOfEmployees where ParamValue = m.idPayee))
		)


		-- update last steps with mobility date for leavers
		UPDATE stp1 SET stp1.end_step = @mobilityDate
		FROM 
		k_m_plans_payees_steps stp1 WHERE id_step in 
		(
			SELECT t.id_step FROM
			(
				SELECT 
					stp2.id_step, 
					ROW_NUMBER() OVER(PARTITION BY id_payee ORDER BY end_step DESC) rw
				FROM k_m_plans_payees_steps stp2
				JOIN Kernel_View_Process_MobilityOnPopulation m
				ON stp2.id_plan = m.id_plan AND stp2.id_payee = m.idPayee
				WHERE	stp2.id_plan = @idPlan
						AND m.IdStatus = 2
						AND (@isFilterUsed = 0 OR Exists (select 1 from @listOfEmployees where ParamValue = m.idPayee))
			) t
			WHERE t.rw = 1
		)



		-- Insert last payee step of payee into k_m_plans_payees_mobility as leaver
		INSERT INTO k_m_plans_payees_mobility
		SELECT id_step, 2 AS id_status FROM
		(
			SELECT id_step, 
					ROW_NUMBER() OVER (PARTITION BY ps.id_payee ORDER BY end_step DESC) AS rn
			FROM 
				Kernel_View_Process_MobilityOnPopulation m
				join k_m_plans_payees_steps ps
					on m.idPayee = ps.id_payee and m.id_plan = ps.id_plan
			WHERE	1=1
					AND m.IdStatus = 2
					AND m.id_plan = @idPlan
					AND (@isFilterUsed = 0 OR EXISTS (SELECT 1 FROM @listOfEmployees WHERE ParamValue = m.idPayee))
		) t2
		WHERE t2.rn = 1




		IF	(
				@isFilterUsed = 0 OR 
				(select count(*) from Kernel_View_Process_MobilityOnPopulation where id_plan = @idPlan) = 0
			)
		BEGIN
			-- Update process assignment with latest version
			UPDATE pa SET pa.idPopVersion = p.lastVersion 
			FROM k_m_plans_affectations pa
			JOIN pop_Population p
			ON p.idPop = pa.id_assignee
			WHERE pa.id_plan = @idPlan
		END

	COMMIT TRANSACTION TR
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION;
		THROW;
	END
END CATCH
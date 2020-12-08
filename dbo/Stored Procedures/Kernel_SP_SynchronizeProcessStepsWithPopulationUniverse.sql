CREATE PROC [dbo].[Kernel_SP_SynchronizeProcessStepsWithPopulationUniverse]
				@idPlan int,
				@idUser int,
				@tbl_payeeList AS [dbo].[Kernel_Type_Population_Universe_Data] READONLY -- Population Universe Data
			AS
				BEGIN TRY
					SET NOCOUNT ON
					SET XACT_ABORT ON
					BEGIN TRANSACTION
						DECLARE @tbl_Steps TABLE ( idPayee int, start_step datetime, end_step datetime, frequency_index int)
						DECLARE @tbl_stepsWillBeInserted TABLE ( idPayee int, start_step datetime, end_step datetime, frequency_index int)
						DECLARE @tbl_idStepsWillBeDeleted TABLE ( id_step int)

						DECLARE @id_assignment int
						SELECT @id_assignment = id_affectation FROM k_m_plans_affectations WHERE id_plan = @idPlan

						-- Compare steps with population universe
						INSERT INTO @tbl_Steps
							SELECT
								ph.idPayee,
								cast(case 
									when ph.start_date_histo > pf.start_date then ph.start_date_histo 
									else pf.start_date 
								end as date) as start_step,
								cast(case 
									when ph.end_date_histo > pf.end_date  then pf.end_date 
									else ph.end_date_histo 
								end as date) as end_step,
								pf.frequency_index
							FROM @tbl_payeeList ph
							CROSS JOIN k_m_plans_frequency pf
							WHERE
								ph.start_date_histo <= pf.end_date 
								and pf.start_date <= ph.end_date_histo
								and pf.id_plan = @idPlan

						-- Find steps that will be deleted
						INSERT INTO @tbl_idStepsWillBeDeleted
							SELECT
								id_step
							FROM k_m_plans_payees_steps  
							WHERE id_plan = @idPlan 
								and not exists(SELECT * FROM @tbl_Steps newSteps WHERE  newSteps.start_step   =  cast(k_m_plans_payees_steps.start_step as date)  and  newSteps.end_step   =  cast(k_m_plans_payees_steps.end_step as date)   and newSteps.idPayee = k_m_plans_payees_steps.id_payee)

						-- Find new steps
						INSERT INTO @tbl_stepsWillBeInserted
							SELECT
								*
							FROM @tbl_Steps steps
							WHERE not exists(SELECT * FROM k_m_plans_payees_steps WHERE id_plan = @idPlan and cast(k_m_plans_payees_steps.start_step as date) = steps.start_step and cast(k_m_plans_payees_steps.end_step as date) = steps.end_step and k_m_plans_payees_steps.id_payee = steps.idPayee)

						-- Add histo to k_m_plans_payees_steps_histo
						INSERT INTO k_m_plans_payees_steps_xhisto( id_user_xhisto, dt_xhisto,	type_xhisto, o_id_step, o_id_plan, o_id_assignment, o_id_payee, o_start_step, o_end_step, o_id_user_create, o_date_create_assignment, o_id_user_update, o_date_update_assignment, o_locked, o_frequency_index)
							SELECT 
								@idUser, GETUTCDATE(), 'DEL', id_step, id_plan, id_assignment, id_payee, start_step, end_step, id_user_create, date_create_assignment, id_user_update, date_update_assignment, locked, frequency_index 
							FROM k_m_plans_payees_steps
							WHERE id_step in (SELECT id_step FROM @tbl_idStepsWillBeDeleted)

						-- Add histo to k_m_values_histo
						INSERT INTO k_m_values_histo(id_value, id_ind, id_field, id_step, input_value, input_value_int, input_value_numeric, input_value_date, input_date, id_user, comment_value, source_value, date_histo, user_histo)
							SELECT 
								id_value, id_ind, id_field, id_step, input_value, input_value_int, input_value_numeric, input_value_date, input_date, id_user, comment_value, source_value, GETUTCDATE(),@idUser 
							FROM k_m_values
							WHERE id_step in (SELECT id_step FROM @tbl_idStepsWillBeDeleted)
			
						-- Delete Step related data
						DELETE FROM k_m_values WHERE id_step in (SELECT id_step FROM @tbl_idStepsWillBeDeleted)
						DELETE FROM k_m_plans_payees_steps_workflow WHERE id_step in (SELECT id_step FROM @tbl_idStepsWillBeDeleted)
						DELETE FROM k_m_plans_payees_mobility WHERE id_step in (SELECT id_step FROM @tbl_idStepsWillBeDeleted)
						DELETE FROM k_m_plans_payees_steps WHERE id_step in (SELECT id_step FROM @tbl_idStepsWillBeDeleted)

						-- Insert new steps and inserting them to k_m_plans_payees_steps_xhisto
						INSERT INTO k_m_plans_payees_steps(id_plan, id_assignment, id_payee, start_step, end_step, id_user_create, locked, frequency_index)
							OUTPUT @idUser, GETUTCDATE(), 'ADD', inserted.id_step, inserted.id_plan, inserted.id_assignment, inserted.id_payee, inserted.start_step, inserted.end_step, inserted.id_user_create, inserted.date_create_assignment, inserted.id_user_update, inserted.date_update_assignment, inserted.locked, inserted.frequency_index  
							INTO k_m_plans_payees_steps_xhisto( id_user_xhisto, dt_xhisto,	type_xhisto, o_id_step, o_id_plan, o_id_assignment, o_id_payee, o_start_step, o_end_step, o_id_user_create, o_date_create_assignment, o_id_user_update, o_date_update_assignment, o_locked, o_frequency_index)
							SELECT
								@idPlan, @id_assignment, idPayee, start_step, DATEADD(second,-1,DATEADD(day, 1, end_step)), @idUser, 0, frequency_index
							FROM @tbl_stepsWillBeInserted
			
					COMMIT
				END TRY
				BEGIN CATCH
					ROLLBACK TRAN
					DECLARE @ERRORMESSAGE NVARCHAR(MAX)
					SELECT @ERRORMESSAGE = ERROR_MESSAGE()
					RAISERROR(@ERRORMESSAGE, 16,1)
				END CATCH
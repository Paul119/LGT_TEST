CREATE PROCEDURE [dbo].[Kernel_SP_Process_BulkValidate]
	@idUser INT,
	@idLoggedInUserPayeeNode INT,
	@idManager INT, -- Current users payee id
	@idNodeType INT,
	@idProfile INT, -- Current Profile
	@idTree INT,
	@idPlan INT,
	@workflowSteps AS [dbo].[Kernel_ValueList_INT] READONLY,
	@levels AS [dbo].[Kernel_ValueList_INT] READONLY,
	@comment NVARCHAR(MAX),
	@idAction INT, -- 1 Validate, 2 Invalidate, 3 Show Data
	@advancedFilterQuery NVARCHAR(4000),
	@endDateFilter DATETIME, 
	@startDateFilter DATETIME,
	@idTreeSecurity INT,
    @idSteps AS [dbo].[Kernel_ValueList_INT] READONLY,
	@selfValue INT,
	@onlyControlValidation BIT -- If 1 then do not execute validation.
AS

SET NOCOUNT ON

-- Other Variables
DECLARE @execStart DATETIME
SET @execStart = GETUTCDATE()

DECLARE @idFirstWorkflowStep INT
DECLARE @idLastWorkflowStep INT
DECLARE @isMinLevel BIT
DECLARE @level INT
DECLARE @validation INT
DECLARE @sortFirstStep INT
DECLARE @idSecondWorkflowStep INT
DECLARE @statusStep INT = -1
DECLARE @nextSortStep int = 1
DECLARE @levelString NVARCHAR(MAX)
DECLARE @isfilterUsed BIT
DECLARE @max_sort INT
DECLARE @execute BIT
DECLARE @validate BIT
DECLARE @userPayeeId INT
DECLARE @isStepBasedValidation BIT = 0

IF EXISTS (SELECT 1 FROM @idSteps)
BEGIN
SET @isStepBasedValidation = 1;
END


IF OBJECT_ID('tempdb.dbo.#EffectivePayeesWithSteps') IS NOT NULL
	DROP TABLE #EffectivePayeesWithSteps

IF OBJECT_ID('tempdb.dbo.#ExceptionWorkFlowPermission') IS NOT NULL
	DROP TABLE #ExceptionWorkFlowPermission

IF OBJECT_ID('tempdb.dbo.#EffectivePayees') IS NOT NULL
	DROP TABLE #EffectivePayees

IF OBJECT_ID('tempdb.dbo.#EffectivePayees_tmp') IS NOT NULL
	DROP TABLE #EffectivePayees_tmp

SET @execute = CASE WHEN @idAction IN (1,2) THEN 1 ELSE 0 END
SET @validate = CASE WHEN @idAction IN (1,3) THEN 1 ELSE 0 END

SELECT @levelString = COALESCE(@levelString + ',', '') + CAST(ParamValue AS nvarchar(max)) FROM @levels
SET @isfilterUsed = CASE WHEN ISNULL(@advancedFilterQuery, '') = '' THEN 0 ELSE 1 END

DECLARE @allSteps TABLE(id_wflstep INT, sort_step INT)
INSERT INTO @allSteps
	SELECT WS.id_wflstep, WS.sort_step FROM [dbo].[k_m_plans] AS P
		JOIN [dbo].[k_m_workflow_step] AS WS ON p.id_workflow = ws.id_workflow 
	WHERE P.id_plan = @idPlan	

SELECT TOP 1 @idFirstWorkflowStep = id_wflstep, @sortFirstStep = sort_step FROM @allSteps ORDER BY sort_step ASC
SELECT TOP 1 @idSecondWorkflowStep = id_wflstep FROM @allSteps WHERE sort_step > @sortFirstStep ORDER BY sort_step ASC
SELECT TOP 1 @idLastWorkflowStep = id_wflstep FROM @allSteps ORDER BY sort_step DESC
SELECT @max_sort = MAX(sort_step) FROM @allSteps

DECLARE @OverrideWorkflowPermission BIT = 0;
DECLARE @EnableMassValidate BIT = 0;
DECLARE @EnableMassInvalidate BIT = 0;

CREATE TABLE #ExceptionWorkFlowPermission
(
	idPayee INT, 
	overrideWorkflowPermission bit,  
	enableMassValidate bit, 
	enableMassInvalidate bit,
	enableValidation bit,
	enableInvalidation bit
)

CREATE TABLE #EffectivePayees_tmp
(
	idPayee INT,
	Level INT
)

DECLARE @payeeBasedLevel BIT = (SELECT TOP 1 is_level_calculation_payee_only FROM k_m_plans WHERE id_plan = @idPlan)
DECLARE @idPayeeNode INT = (SELECT TOP 1 id FROM hm_NodelinkPublished WHERE idTree = @idTree AND idChild = @idManager AND idType = @idNodeType)
DECLARE @userlevel int; DECLARE @managerlevel int; DECLARE @diff int;

select @userlevel = hidLevel from hm_nodelinkPublishedhierarchy where id_nodelinkpublished = @idLoggedInUserPayeeNode
select @managerlevel = hidLevel from hm_nodelinkPublishedhierarchy where id_nodelinkpublished = @idPayeeNode

SET @diff = @managerLevel- @userLevel

IF (@selfValue = -2 AND @idNodeType = 14)
  INSERT INTO #EffectivePayees_tmp VALUES (@idManager, @diff)
ELSE IF (@selfValue = -1 or @selfValue = -3)
BEGIN
	INSERT INTO #EffectivePayees_tmp
	EXECUTE [Kernel_SP_Process_GetPayeeIdListGeneric] @payeeBasedLevel, @idTreeSecurity, @idPayeeNode, @levelString, @advancedFilterQuery

	UPDATE #EffectivePayees_tmp set Level = Level + @diff

	IF (@selfValue = -3)
	BEGIN
		INSERT INTO #EffectivePayees_tmp VALUES (@idManager, @diff)
	END

END
ELSE
BEGIN
 return;
END


DECLARE @isOverrideWorkflowPermission BIT 
IF(@idTreeSecurity != 0)
BEGIN
	;WITH
	TreeData
	AS
	(
		select id, idChild, idType, idParent, idTypeParent
		from hm_NodelinkPublished
		where idTree in 
		(
			select p.idTree from k_tree_security ts
			join hm_NodelinkPublished p
				on p.id = ts.id_tree_node_published
			where ts.id_tree_security =  @idTreeSecurity
		)
	)
	, PlanLevelExceptions
	as
	(
		select np.id, np.idChild, tsple.*
		from k_tree_security_plan_level tspl
		join k_m_plan_data_security pds
			on tspl.id_tree_security_plan_level = pds.id_tree_security_plan_level
		join k_tree_security ts
			on ts.id_tree_security = tspl.id_tree_security
		join k_tree_security_plan_level_exception tsple
			on tsple.id_tree_security_plan_level = tspl.id_tree_security_plan_level
		join hm_NodelinkPublished np
			on np.id = tsple.id_tree_node_published
		where pds.id_process = @idPlan
		AND ts.id_tree_security = @idTreeSecurity
	)
	, TreePlanExceptions
	as
	(
		SELECT 
			tr.*, pe.id_tree_security_plan_level_exception, pe.is_override_workflow_permission, pe.is_validate, pe.is_invalidate, 
			pe.is_mass_invalidate, pe.is_mass_validate, pe.is_edit, pe.is_read
		FROM TreeData tr
		LEFT JOIN PlanLevelExceptions pe
		ON pe.id = tr.id
	)
	, TreePlanExceptionsInherited
	AS
	(
		SELECT 
			 tr.id
			,tr.idChild
			,tr.idType
			,tr.idParent
			,tr.idTypeParent
			,pe.id_tree_security_plan_level_exception
			,pe.is_override_workflow_permission
			,pe.is_validate
			,pe.is_invalidate
			,pe.is_mass_invalidate
			,pe.is_mass_validate
			,pe.is_edit
			,pe.is_read
		FROM TreeData tr
		INNER JOIN PlanLevelExceptions pe
			ON pe.id = tr.id

		UNION ALL

		SELECT 
			 pe.id
			,pe.idChild
			,pe.idType
			,pe.idParent
			,pe.idTypeParent
			,pei.id_tree_security_plan_level_exception
			,pei.is_override_workflow_permission
			,pei.is_validate
			,pei.is_invalidate
			,pei.is_mass_invalidate
			,pei.is_mass_validate
			,pei.is_edit
			,pei.is_read
		FROM
		TreePlanExceptionsInherited pei
		JOIN TreePlanExceptions pe
			ON pei.idChild = pe.idParent AND pei.idType = pe.idTypeParent
		WHERE pe.id_tree_security_plan_level_exception IS NULL
	)
	, ActualPlanLevelExceptions
	AS
	(
		SELECT 
			 tr.id
			,tr.idChild
			,tr.idType
			,tr.idParent
			,tr.idTypeParent
			,pei.id_tree_security_plan_level_exception
			,ISNULL(pei.is_override_workflow_permission, M.main_is_override_workflow_permission) is_override_workflow_permission
			,ISNULL(pei.is_validate, M.main_is_validate) is_validate
			,ISNULL(pei.is_invalidate, M.main_is_invalidate) is_invalidate
			,ISNULL(pei.is_mass_validate, M.main_is_mass_validate) is_mass_validate
			,ISNULL(pei.is_mass_invalidate, M.main_is_mass_invalidate) is_mass_invalidate
			,ISNULL(pei.is_edit, M.main_is_edit) is_edit
			,ISNULL(pei.is_read, M.main_is_read) is_read
			,M.main_is_override_workflow_permission
			,M.main_is_validate
			,M.main_is_invalidate
			,M.main_is_mass_validate
			,M.main_is_mass_invalidate
			,M.main_is_edit
			,M.main_is_read
		FROM TreeData tr
		LEFT JOIN TreePlanExceptionsInherited pei
			ON tr.id = pei.id
		CROSS JOIN 
		(
			SELECT TOP 1
			 is_override_workflow_permission main_is_override_workflow_permission
			,is_edit main_is_edit
			,is_read main_is_read
			,is_mass_validate main_is_mass_validate
			,is_mass_invalidate main_is_mass_invalidate
			,is_invalidate main_is_invalidate
			,is_validate main_is_validate 
			FROM k_tree_security_plan_level where id_tree_security = @idTreeSecurity
		) AS M
	)
	,TreePlanRecursiveExceptionFiltered
	as
	(
		select te.*
		from ActualPlanLevelExceptions te
		join #EffectivePayees_tmp p
			on p.idPayee = te.idChild
		where te.idType = 14
	)
	INSERT INTO #ExceptionWorkFlowPermission
	SELECT f.idChild, f.is_override_workflow_permission, f.is_mass_validate, f.is_mass_invalidate,f.is_validate,f.is_invalidate FROM TreePlanRecursiveExceptionFiltered f
 SET  @isOverrideWorkflowPermission  =(SELECT TOP 1 p.overrideWorkflowPermission FROM #ExceptionWorkFlowPermission p)
END



CREATE TABLE #EffectivePayees 
(
	idPayee INT,
	Level INT
)
CREATE UNIQUE CLUSTERED INDEX Cl_Ix_idPayee ON #EffectivePayees
(idPayee)

CREATE INDEX [Level] ON #EffectivePayees
([Level])

INSERT INTO #EffectivePayees SELECT DISTINCT idPayee, Level FROM #EffectivePayees_tmp



CREATE TABLE #EffectivePayeesWithSteps 
(
	idPayee INT, 
	id_step INT, 
	id_workflow_step INT NULL, 
	payees_steps_workflow_exists BIT, 
	id_workflow_group INT NULL,	
	current_sort_step INT,
	allowed BIT, 
	terminalStep BIT NULL, 
	next_id_workflow_step INT NULL, 
	next_sort_step INT NULL, 
	next_status INT NULL
)


;WITH ActualSteps
AS
(
	SELECT 
			A.idPayee
		, ISNULL(PSW.id_workflow_step, @idFirstWorkflowStep) AS id_workflow_step
		, CASE WHEN (@validate = 1 AND PSW.id_workflow_step = @idLastWorkflowStep AND PSW.statut_step = -2) OR 
					(@validate = 0 AND ISNULL(PSW.id_workflow_step, @idFirstWorkflowStep) = @idFirstWorkflowStep AND ISNULL(PSW.statut_step, -1) = -1) THEN 1 ELSE 0 END AS [terminalStep]
		, S.sort_step			
		, CASE WHEN PSW.id_step IS NULL THEN 0 ELSE 1 END AS [payees_steps_workflow_exists]
		, PS.id_step
		, S.id_wflstep
		, PSW.statut_step AS [current_step_status]
	FROM #EffectivePayees AS A
		INNER JOIN [dbo].[k_m_plans_payees_steps] AS PS ON A.idPayee = PS.id_payee AND PS.id_plan = @idPlan
		LEFT JOIN [dbo].[k_m_plans_payees_steps_workflow] AS PSW on PS.id_step = PSW.id_step
		LEFT JOIN [dbo].[k_m_workflow_step] AS S ON PSW.id_workflow_step = S.id_wflstep
	WHERE PS.start_step <= @endDateFilter AND PS.end_step >= @startDateFilter
)
, PermissionSteps
AS
(
	SELECT DISTINCT
	      A.idPayee
		, PS.id_step
		, PSW.id_workflow_step AS id_wflstep
		, 
		CASE 
			WHEN @validate = 1 AND ISNULL(E.overrideWorkflowPermission,0) = 1
				THEN 
					CASE WHEN @isStepBasedValidation = 1
						THEN ISNULL(E.enableValidation, 0) 
					ELSE
						ISNULL(E.enableMassValidate, 0) 
					END

			WHEN @validate = 1 AND ISNULL(E.overrideWorkflowPermission,0) = 0
				THEN 
					CASE WHEN @isStepBasedValidation = 1
						THEN SG.enable_validation
					ELSE
						ISNULL(SG.enable_massvalidation, 0)
					END
			WHEN @validate = 0 AND ISNULL(E.overrideWorkflowPermission,0) = 1
					THEN 
					CASE WHEN @isStepBasedValidation = 1
						THEN ISNULL(E.enableInvalidation, 0) 
					ELSE
						ISNULL(E.enableMassInValidate, 0)
					END

			WHEN @validate = 0 AND ISNULL(E.overrideWorkflowPermission,0) = 0
				then
					CASE WHEN @isStepBasedValidation = 1
						THEN SG.enable_invalidation
					ELSE
						 ISNULL(SG.enable_massinvalidation, 0)
					END
		END AS [permission]
		, CASE WHEN (SG.is_min_level = 1 AND A.[Level] = SG.level_step)
					OR (SG.is_min_level = 0 AND A.[Level] >= SG.level_step) THEN 1 ELSE 0 END AS [level_check]
		, SG.id_wflstepgroup AS [id_workflow_group]
	FROM #EffectivePayees AS A
		INNER JOIN [dbo].[k_m_plans_payees_steps] AS PS ON A.idPayee = PS.id_payee AND PS.id_plan = @idPlan
		LEFT JOIN [dbo].[k_m_plans_payees_steps_workflow] AS PSW on PS.id_step = PSW.id_step
		OUTER APPLY (
			SELECT SG.* FROM [dbo].[k_m_workflow_step_group] AS SG 
			INNER JOIN [dbo].[k_m_workflow_step_group_profile] AS SGP
			 ON  (@idTreeSecurity != 0 AND @isOverrideWorkflowPermission =1 ) OR
              (SG.id_wflstepgroup = SGP.id_wflstepgroup AND SGP.id_profile = @idProfile) 
			WHERE ISNULL(PSW.id_workflow_step, @idFirstWorkflowStep) = SG.id_wflstep ) AS SG
		LEFT JOIN #ExceptionWorkFlowPermission E ON A.idPayee = E.idPayee
	WHERE PS.start_step <= @endDateFilter AND PS.end_step >= @startDateFilter
	AND SG.is_min_level = 1 AND  A.[Level] = SG.level_step
	OR (SG.is_min_level = 0 AND A.[Level]  >= SG.level_step)
)
, ResultPermissionLevelCheck
as
(
	SELECT
			A.idPayee
		, A.id_workflow_step
		, A.terminalStep
		, A.sort_step
		, A.payees_steps_workflow_exists
		, A.id_step
		, ISNULL(B.permission, 0) AS [permission]
		, ISNULL(B.level_check, 0) AS [level_check]
		, B.id_workflow_group
		, A.current_step_status
	FROM 
	ActualSteps AS A
	LEFT JOIN 
	PermissionSteps AS B 
	ON A.idPayee = B.idPayee AND A.id_step = B.id_step AND ISNULL(A.id_wflstep, -1) = ISNULL(B.id_wflstep, -1)
)
,PermisionResult
as
(
	SELECT 
		  Q.idPayee
		, Q.id_step
		, Q.id_workflow_step			
		, Q.payees_steps_workflow_exists
		, ISNULL(Q.sort_step, 1) AS current_sort_step
		, CASE WHEN Q.[permission] = 1 AND [level_check] = 1 THEN 1 ELSE 0 END AS [allowed]
		, Q.[terminalStep]
		, CASE WHEN Q.[permission] = 1 AND Q.[terminalStep] = 0
			THEN CASE WHEN @validate = 1 THEN CASE WHEN ISNULL(id_workflow_step, 0) <> @idLastWorkflowStep THEN ISNULL(NS.id_wflstep, @idSecondWorkflowStep) ELSE @idLastWorkflowStep END
					ELSE CASE WHEN Q.current_step_status = -2 THEN Q.id_workflow_step ELSE ISNULL(PS.id_wflstep, @idFirstWorkflowStep) END END ELSE NULL END AS [next_id_workflow_step]
		, CASE WHEN Q.[permission] = 1 THEN 
				CASE WHEN (@validate = 1 AND ISNULL(id_workflow_step, 0) <> @idLastWorkflowStep) OR 
							(@validate = 0 AND id_workflow_step <> @idFirstWorkflowStep) THEN -1 
					ELSE CASE WHEN @validate = 1 THEN -2 ELSE -3 END END ELSE NULL END AS [next_status]
		, id_workflow_group
	FROM 
	ResultPermissionLevelCheck AS Q
	OUTER APPLY (SELECT TOP 1 id_wflstep FROM @allSteps AS S WHERE ISNULL(S.sort_step, -1) > Q.sort_step ORDER BY sort_step ASC) AS NS
	OUTER APPLY (SELECT TOP 1 id_wflstep FROM @allSteps AS S WHERE ISNULL(S.sort_step, -1) < Q.sort_step ORDER BY sort_step DESC) AS PS
)
INSERT INTO #EffectivePayeesWithSteps
	SELECT 
		  idPayee
		, id_step
		, id_workflow_step
		, payees_steps_workflow_exists
		, id_workflow_group
		, A.sort_step AS current_sort_step
		, [allowed]
		, CASE WHEN [allowed] = 1 THEN [terminalStep] ELSE NULL END AS [terminalStep]
		, [next_id_workflow_step]
		, A.sort_step AS [next_sort_step]
		, [next_status]
	FROM PermisionResult Q
	LEFT JOIN @allSteps A ON Q.next_id_workflow_step = A.id_wflstep
	    WHERE
    @isStepBasedValidation = 0
    OR
    Q.id_step in (SELECT ParamValue FROM @idSteps)


/*Process grid filter has been added to validation query, based id_step.*/
IF (@advancedFilterQuery IS NOT NULL) AND (LEN(RTRIM(LTRIM(@advancedFilterQuery)))) > 0 
BEGIN


DECLARE @filteredRecordsQuery NVARCHAR(MAX) = 
'
IF OBJECT_ID(''tempdb.dbo.#FilteredRecords'') IS NOT NULL
	DROP TABLE #FilteredRecords

;WITH ' + @advancedFilterQuery + ' 
SELECT * INTO #FilteredRecords FROM FilteredCTE ;

DELETE T
FROM #EffectivePayeesWithSteps T
WHERE T.id_step NOT IN (SELECT F.id_step
                FROM #FilteredRecords F
                WHERE T.id_step = F.id_step)';

EXEC(@filteredRecordsQuery);	
END

DECLARE @idPayeeSteps AS dbo.Kernel_ValueList_INT
INSERT INTO @idPayeeSteps SELECT id_step FROM #EffectivePayeesWithSteps WHERE ISNULL(allowed,0) = 1


DECLARE @successful_validations INT
SELECT @successful_validations = Count(*) FROM #EffectivePayeesWithSteps WHERE allowed = 1 AND terminalStep = 0

DECLARE @denied_validations INT
SELECT @denied_validations = Count(*) FROM #EffectivePayeesWithSteps WHERE allowed = 0

DECLARE @invalid_validations INT
SELECT @invalid_validations = Count(*) FROM #EffectivePayeesWithSteps WHERE allowed = 1 AND terminalStep = 1

DECLARE @total INT
SELECT @total = Count(*) FROM #EffectivePayeesWithSteps

IF(@onlyControlValidation = 1)
BEGIN
  SELECT @successful_validations AS [Successful], @denied_validations AS [Denied]
  return;
END

DECLARE @tMasterId INT

--PreMassValidation-begin
	CREATE TABLE #PreMassValidationResult
	(
		Continue_Flag bit, 
		Message nvarchar(max), 
		ArgumentsForError nvarchar(max)
	)
	INSERT INTO #PreMassValidationResult EXEC dbo.Kernel_SP_Process_PreMassValidation @idProfile, @idUser, @idTree, @idPayeeSteps, @idManager, @idPlan, @idAction

	IF (SELECT Continue_Flag FROM #PreMassValidationResult) = 0
		BEGIN
			SELECT 'PreMassValidationError' AS Status
			SELECT * FROM #PreMassValidationResult
			return
		END
--PreMassValidation-end


--- Transition ---
IF(@execute = 1) 
BEGIN
BEGIN TRANSACTION
	INSERT INTO [dbo].[k_m_plans_payees_steps_workflow_bulkvalidate_master] 
		([id_user],[id_profile],[id_plan],[id_tree], [is_validation], [start_time], [total_payees], [successful_validations], [denied_validations], [invalid_validations])
	VALUES
		(@idUser, @idProfile, @idPlan, @idTree, CASE WHEN @validate = 1 THEN 1 ELSE 0 END, @execStart, @total, @successful_validations, @denied_validations, @invalid_validations)

	SELECT @tMasterId = SCOPE_IDENTITY() FROM [dbo].[k_m_plans_payees_steps_workflow_bulkvalidate_master]
	
	-- Validation that does not yet have a k_m_plans_payees_steps_workflow (a.k.a. first validation)
	INSERT INTO k_m_plans_payees_steps_workflow
	SELECT 
		  P.id_step as [id_step]
		, P.id_workflow_step as id_wflStep
		, CASE WHEN @validate = 1 THEN -2 ELSE -3 END as statut_step
		, @comment as comment_step
		, GETUTCDATE() as date_step
		, @idUser as id_user
		, @validate as is_consolidated
		, 1 as current_sort
		, CASE WHEN @max_sort > 1 THEN 2 ELSE 1 END AS [max_sort]		
	FROM #EffectivePayeesWithSteps P
	WHERE P.[payees_steps_workflow_exists] = 0 AND p.allowed = 1
		
	INSERT INTO [dbo].[k_m_plans_payees_steps_workflow_xhisto]
		(id_step, id_workflow_step, statut_step, comment_step, date_step, id_user, is_consolidated, current_sort, max_sort, idTree, id_workflow_step_to, validationType, success, denied, id_transaction, id_workflow_group)
	SELECT 
		  PSW.id_step
		, NP.id_workflow_step
		, CASE WHEN @validate = 1 THEN -2 ELSE -3 END as statut_step
		, @comment AS comment_step
		, GETUTCDATE() AS date_step
		, @idUser AS id_user
		, @validate as is_consolidated
		, NP.[current_sort_step] AS [current_sort]
		, CASE WHEN NP.[current_sort_step] + 1 < @max_sort THEN NP.[current_sort_step] + 1 ELSE @max_sort END AS [max_sort]
		, @idTree AS [idTree]
		, next_id_workflow_step AS [id_workflow_step_to]
		, CASE WHEN @validate = 1 THEN 3 ELSE 4 END AS [validationType]
		, CASE WHEN NP.allowed = 1 AND NP.terminalStep = 0 THEN 1 ELSE 0 END AS [success]
		, CASE WHEN NP.allowed = 1 THEN 0 ELSE 1 END AS [denied]
		, @tMasterId as [id_transaction]
		, NP.id_workflow_group AS [id_workflow_group]
	FROM [dbo].[k_m_plans_payees_steps] PS
		INNER JOIN [dbo].[k_m_plans_payees_steps_workflow] PSW ON PS.[id_step] = PSW.[id_step]
		INNER JOIN #EffectivePayeesWithSteps NP ON PS.id_payee = NP.idPayee AND PS.id_step = NP.id_step
	WHERE PS.id_plan = @idPlan

	UPDATE PSW SET 
			PSW.[id_workflow_step] = NP.[next_id_workflow_step]
		, PSW.[current_sort] = NP.[current_sort_step]
		, PSW.[max_sort] = CASE WHEN NP.[current_sort_step] + 1 < @max_sort THEN NP.[current_sort_step] + 1 ELSE @max_sort END
		, PSW.[statut_step] = NP.[next_status]
		, PSW.[comment_step] = @comment
		, PSW.[date_step] = GETUTCDATE()
		, PSW.[id_user] = @idUser
		, PSW.[is_consolidated] = @validate
	FROM [dbo].[k_m_plans_payees_steps] PS
		INNER JOIN [dbo].[k_m_plans_payees_steps_workflow] PSW ON PS.[id_step] = PSW.[id_step]
		INNER JOIN #EffectivePayeesWithSteps NP ON PS.[id_payee] = NP.[idPayee] AND PS.[id_step] = NP.[id_step]
	WHERE PS.[id_plan] = @idPlan AND NP.[allowed] = 1 AND NP.[terminalStep] = 0	
	
	UPDATE [k_m_plans_payees_steps_workflow_bulkvalidate_master] SET end_time = GETUTCDATE() WHERE id = @tMasterId
COMMIT
END

SELECT @total AS [Total], @successful_validations AS [Successful], @denied_validations AS [Denied], @invalid_validations AS [Invalid], @tMasterId AS [MasterId]

--PostMassValidation-begin
	CREATE TABLE #PostMassValidationResult
	(
		Continue_Flag bit, 
		Message nvarchar(max), 
		ArgumentsForError nvarchar(max)
	)
	INSERT INTO #PostMassValidationResult EXEC dbo.Kernel_SP_Process_PostMassValidation @idProfile, @idUser, @idTree, @idPayeeSteps, @idManager, @idPlan, @idAction

	IF (SELECT Continue_Flag FROM #PostMassValidationResult) = 0
		BEGIN
			SELECT 'PostMassValidationError' AS Status
			SELECT * FROM #PostMassValidationResult
			return
		END
	ELSE
		BEGIN
			UPDATE PS 
			SET PS.next_id_workflow_step = PW.id_workflow_step
			FROM #EffectivePayeesWithSteps PS
			INNER JOIN  k_m_plans_payees_steps_workflow PW ON PS.id_step = PW.id_step
			INNER JOIN @idPayeeSteps S ON PW.id_step = S.ParamValue
		END
--PostMassValidation-end

SELECT 
	  G.[NewStep]
	, G.[Transitions]
	, WS.name_step AS [StepName]
FROM (
	SELECT 
			PS.[next_id_workflow_step] AS [NewStep]		
		, COUNT(PS.next_id_workflow_step) AS [Transitions] 
	FROM #EffectivePayeesWithSteps AS PS
	WHERE PS.[allowed] = 1 AND PS.[terminalStep] = 0
	GROUP BY PS.[next_id_workflow_step] ) G
INNER JOIN [dbo].[k_m_workflow_step] AS WS ON G.[NewStep] = WS.[id_wflstep]
CREATE PROCEDURE [dbo].[Kernel_SP_Setup_PushCubeValueToKmValues] 
(
	@id_olap_scheduler_execution INT,
	@id_plan INT,
	@start_step DATETIME,
	@end_step DATETIME,
	@id_user INT,
	@isDelete BIT
)
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @payeeList XML
	DECLARE @ExecutionType TINYINT = 0;

	CREATE TABLE #PayeeList
	(
		PayeeId INT,
		IsError BIT,
		INDEX idx_#PayeeList NONCLUSTERED (PayeeId, IsError)
	)

	INSERT INTO #PayeeList
	(PayeeId, IsError)
	SELECT PayeeId, GenErrored | ExecErrored --Either error happened during query generation or during query execution
	FROM (
		SELECT PL.payee.value('text()[1]', 'int') as PayeeId
				,ISNULL(PL.payee.value('@gen_errored', 'bit'), CAST(0 AS BIT)) as GenErrored
				,ISNULL(PL.payee.value('@exec_errored', 'bit'), CAST(0 AS BIT)) as ExecErrored
		FROM k_m_olap_scheduler_execution_step se
			CROSS APPLY payee_list.nodes('/root/PayeeId') AS PL(payee)
		WHERE se.id_olap_scheduler_execution = @id_olap_scheduler_execution
		) SUB


	
	DECLARE @IsIndicatorFieldSpecified BIT = 0
	IF EXISTS (SELECT * 
				 FROM dbo.k_m_olap_scheduler os
					INNER JOIN dbo.k_m_olap_scheduler_execution ose
						ON os.id = ose.id_olap_scheduler
						AND ose.id_olap_scheduler_execution = @id_olap_scheduler_execution
					INNER JOIN dbo.k_m_olap_scheduler_indicators_field sif
						ON os.id = sif.OlapSchedulerID)
	BEGIN
		SET @IsIndicatorFieldSpecified = 1
	END


	DECLARE @idSim INT = 0

	IF @start_step IS NULL
	BEGIN
		SELECT @start_step = start_date_plan FROM k_m_plans WHERE id_plan = @id_plan
	END

	IF @end_step IS NULL
	BEGIN
		SELECT @end_step = end_date_plan FROM k_m_plans WHERE id_plan = @id_plan
	END

	DECLARE @Delete_k_m_values_detail_Query NVARCHAR(MAX) = N'
	DELETE VD
	FROM dbo.k_m_values_detail VD
	WHERE 1=1
	   AND VD.id_olap_scheduler_execution != @id_olap_scheduler_execution_IN
	   AND VD.id_plan = @id_plan_IN
	   AND (
			CAST(VD.start_step AS DATE) BETWEEN CAST(@start_step_IN AS DATE) AND CAST(@end_step_IN AS DATE)
			OR 
			CAST(VD.end_step AS DATE) BETWEEN CAST(@start_step_IN AS DATE) AND CAST(@end_step_IN AS DATE)
			)
'

	DECLARE @idPayee INT;
	DECLARE @idPop INT;
	SELECT @idPayee = OS.idPayee,
		   @idPop = OS.idPop,
		   @ExecutionType = OSE.execution_type
	  FROM k_m_olap_scheduler_execution AS OSE
		INNER JOIN k_m_olap_scheduler AS OS
			ON OSE.id_olap_scheduler = OS.id
	 WHERE OSE.id_olap_scheduler_execution = @id_olap_scheduler_execution

	IF @ExecutionType = 0
	BEGIN
		--Setting previous executions execution type to 1, since restartability feature did not exists at that time. All executions were done for all payees.
		SET @ExecutionType = 1;
	END

	IF @ExecutionType = 1
	BEGIN
		IF @idPayee IS NOT NULL
		BEGIN
			SET @Delete_k_m_values_detail_Query = @Delete_k_m_values_detail_Query + '
   AND VD.idPayee = @idPayee_IN '
		END

		IF @idPop IS NOT NULL
		BEGIN
			SET @Delete_k_m_values_detail_Query = @Delete_k_m_values_detail_Query + '
   AND VD.idPayee IN (SELECT PVC.idColl FROM pop_Population AS PP INNER JOIN pop_VersionContent PVC ON PP.lastVersion = PVC.idPopVersion WHERE PP.idPop = @idPop_IN)'
		END

		SET @Delete_k_m_values_detail_Query = @Delete_k_m_values_detail_Query + '
   AND VD.idPayee IN ( SELECT PayeeId FROM #PayeeList WHERE IsError = 0)'
	END
	ELSE
	BEGIN
		SET @Delete_k_m_values_detail_Query = @Delete_k_m_values_detail_Query + '
   AND VD.idPayee IN ( SELECT PayeeId FROM #PayeeList WHERE IsError = 0)'
	END

	IF @IsIndicatorFieldSpecified = 1
	BEGIN
		SET @Delete_k_m_values_detail_Query = @Delete_k_m_values_detail_Query + '
   AND EXISTS (SELECT NULL 
				 FROM dbo.k_m_olap_scheduler_indicators_field sif 
					INNER JOIN dbo.k_m_indicators_fields mif
						ON sif.IndicatorFieldID = mif.id_indicator_field
					INNER JOIN dbo.k_m_olap_scheduler os
						ON sif.OlapSchedulerID = os.id
						AND os.idProcess = @id_plan_IN
					INNER JOIN dbo.k_m_olap_scheduler_execution ose
						ON os.id = ose.id_olap_scheduler
						AND ose.id_olap_scheduler_execution = @id_olap_scheduler_execution_IN
				WHERE VD.id_ind = mif.id_ind
				  AND VD.id_field = mif.id_field)'
	END

	DECLARE @Delete_k_m_values_Query NVARCHAR(MAX) = N'
	DELETE KMV
	FROM dbo.k_m_values KMV
		INNER JOIN k_m_plans_payees_steps PPS
			ON KMV.id_step = PPS.id_step
			AND (
					CAST(PPS.start_step AS DATE) BETWEEN CAST(@start_step_IN AS DATE) AND CAST(@end_step_IN AS DATE)
					OR
					CAST(PPS.end_step AS DATE) BETWEEN CAST(@start_step_IN AS DATE) AND CAST(@end_step_IN AS DATE)
				)
			AND PPS.id_plan = @id_plan_IN##DYNAMICPAYEEFILTERS##
	WHERE KMV.idSim = @idSim_IN'

	DECLARE @payeeCriteria NVARCHAR(MAX) = N''

	IF @ExecutionType = 1
	BEGIN
		IF @idPayee IS NOT NULL
		BEGIN
			SET @payeeCriteria = @payeeCriteria + N'
			AND PPS.id_payee = @idPayee_IN'
		END


		IF @idPop IS NOT NULL
		BEGIN
			SET @payeeCriteria = @payeeCriteria + N'
			AND PPS.id_payee IN (SELECT PVC.idColl FROM pop_Population AS PP INNER JOIN pop_VersionContent PVC ON PP.lastVersion = PVC.idPopVersion WHERE PP.idPop = @idPop_IN)'
		END

		SET @payeeCriteria = @payeeCriteria + '
			AND PPS.id_payee IN	( SELECT PayeeId FROM #PayeeList WHERE IsError = 0)'
	END
	ELSE
	BEGIN
		SET @payeeCriteria = @payeeCriteria + '
			AND PPS.id_payee IN	( SELECT PayeeId FROM #PayeeList WHERE IsError = 0)'
	END

	SET @Delete_k_m_values_Query = REPLACE(@Delete_k_m_values_Query, '##DYNAMICPAYEEFILTERS##', @payeeCriteria);


	IF @IsIndicatorFieldSpecified = 1
	BEGIN
		SET @Delete_k_m_values_Query = @Delete_k_m_values_Query + '
		AND EXISTS (SELECT NULL 
					  FROM dbo.k_m_olap_scheduler_indicators_field sif 
						INNER JOIN dbo.k_m_indicators_fields mif
							ON sif.IndicatorFieldID = mif.id_indicator_field
						INNER JOIN dbo.k_m_olap_scheduler os
							ON sif.OlapSchedulerID = os.id
							AND os.idProcess = @id_plan_IN
						INNER JOIN dbo.k_m_olap_scheduler_execution ose
							ON os.id = ose.id_olap_scheduler
							AND ose.id_olap_scheduler_execution = @id_olap_scheduler_execution_IN
					 WHERE KMV.id_ind = mif.id_ind
					   AND KMV.id_field = mif.id_field)'
	END

	DECLARE @ParmDef NVARCHAR(4000) = N'@id_olap_scheduler_execution_IN INT, @id_plan_IN INT, @start_step_IN DATETIME, @end_step_IN DATETIME, @idPayee_IN INT, @idPop_IN INT, @idSim_IN INT'
	EXEC sp_executesql @Delete_k_m_values_detail_Query, @ParmDef, @id_olap_scheduler_execution_IN = @id_olap_scheduler_execution, @id_plan_IN = @id_plan, @start_step_IN = @start_step, @end_step_IN = @end_step, @idPayee_IN = @idPayee, @idPop_IN = @idPop, @idSim_IN = @idSim;
	EXEC sp_executesql @Delete_k_m_values_Query, @ParmDef, @id_olap_scheduler_execution_IN = @id_olap_scheduler_execution, @id_plan_IN = @id_plan, @start_step_IN = @start_step, @end_step_IN = @end_step, @idPayee_IN = @idPayee, @idPop_IN = @idPop, @idSim_IN = @idSim;

	;WITH Aggregated_k_m_values_detail
	AS
	(
		SELECT	KVD.id_ind
				,KVD.id_field
				,PPS.id_step
				,SUM(KVD.input_value) AS input_value
				,SUM(KVD.input_value) AS input_value_numeric
				,GETUTCDATE() as input_date
				,@id_user AS id_user
				,1 AS value_type
				,@idSim AS idSim
		  FROM dbo.k_m_values_detail KVD
			INNER JOIN dbo.k_m_plans_payees_steps PPS
				ON KVD.id_plan = PPS.id_plan
				AND KVD.idPayee = PPS.id_payee
				AND (	CAST(PPS.start_step AS DATE) BETWEEN CAST(KVD.start_step AS DATE) AND CAST(KVD.end_step AS DATE)
						OR
						CAST(PPS.end_step AS DATE) BETWEEN CAST(KVD.start_step AS DATE) AND CAST(KVD.end_step AS DATE)
					)
			INNER JOIN #PayeeList PL
				ON PL.PayeeId = PPS.id_payee
				AND PL.IsError = 0
		 WHERE KVD.id_olap_scheduler_execution = @id_olap_scheduler_execution
		   AND KVD.input_value IS NOT NULL
		 GROUP BY KVD.id_ind, KVD.id_field, PPS.id_step
	)
	MERGE dbo.k_m_values AS T
	USING Aggregated_k_m_values_detail AS S
	ON (
		T.id_ind = S.id_ind
		AND T.id_field = S.id_field
		AND T.id_step = S.id_step 
		)
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (id_ind,id_field,id_step,input_value, input_value_numeric, input_date,id_user,value_type,idSim)
		VALUES(S.id_ind, S.id_field, S.id_step, input_value, input_value_numeric, input_date, id_user, value_type, idSim)
	WHEN MATCHED THEN
		UPDATE SET	T.input_value = S.input_value
					,T.input_value_numeric = S.input_value_numeric
					,T.id_user = S.id_user
					,T.value_type = S.value_type
					,T.idSim = S.idSim;

	DECLARE @PostCreditingSPName NVARCHAR(255)

	SELECT @PostCreditingSPName = MTP.post_crediting_stored_procedure
	  FROM dbo.k_m_olap_scheduler_execution OSE
		INNER JOIN dbo.k_m_olap_scheduler OS
			ON OSE.id_olap_scheduler = OS.id
		INNER JOIN dbo.k_m_plans MP
			ON OS.idProcess = MP.id_plan
		INNER JOIN dbo.k_m_type_plan MTP
			ON MP.id_type_plan = MTP.id_type_plan
	 WHERE OSE.id_olap_scheduler_execution = @id_olap_scheduler_execution

	IF @PostCreditingSPName IS NOT NULL
	BEGIN

		DECLARE @PostSPExecute NVARCHAR(MAX) = N'EXEC ' + @PostCreditingSPName + ' @id_olap_scheduler_execution';
		DECLARE @ParmDefinition NVARCHAR(4000) = '@id_olap_scheduler_execution INT';

		EXEC sp_executesql @PostSPExecute, @ParmDefinition, @id_olap_scheduler_execution = @id_olap_scheduler_execution;
	END

END
CREATE PROC [dbo].[Kernel_SP_Process_PostSave]
		@idProfile int,
		@idUser int,
		@idTree int,
		@kMValuesData AS [dbo].[Kernel_Type_k_m_values] READONLY,
		@selectedIdPayee int,
		@idProcess int
	AS

	Declare @Result bit = 1;
	Declare @Message nvarchar(max) = NULL;
	Declare @argumentsForError nvarchar(max)=NULL

	-- Validation check Logic 
	-- Set @Result and @Message. If desired, set @argumentsForError


	IF EXISTS (SELECT 1 FROM @kMValuesData v JOIN k_m_fields kmf ON kmf.id_field = v.id_field WHERE kmf.code_field = 'CRP-LGT-Base_JLY+1' AND v.input_value IS NOT NULL)
	BEGIN 
	
		UPDATE kmv
		SET input_value = ISNULL(dbo.fn_Round_Salary_Month(CAST(v.input_value AS FLOAT), CAST(rle.nb_months AS FLOAT)),v.input_value),
			input_value_numeric = ISNULL(dbo.fn_Round_Salary_Month(CAST(v.input_value AS FLOAT), CAST(rle.nb_months AS FLOAT)),v.input_value_numeric),
			input_date = GETDATE(),
			id_user = v.id_user,
			comment_value = 'Value Rounded',
			source_value = v.input_value
		FROM @kMValuesData v
		JOIN k_m_values kmv  ON  v.id_ind = kmv.id_ind
							 AND v.id_field = kmv.id_field
							 AND v.id_step = kmv.id_step 
		JOIN k_m_fields kmf ON kmf.id_field = kmv.id_field 
		JOIN k_m_plans_payees_steps kmpps ON kmv.id_step = kmpps.id_step
		JOIN _vw_CRP_Process_Template vcpt ON kmpps.id_plan = vcpt.id_plan AND vcpt.idPayee = kmpps.id_payee
		LEFT JOIN _ref_LegalEntity rle ON rle.CompanyCode = Org_LegalEntity_Code
		WHERE kmf.code_field = 'CRP-LGT-Base_JLY+1'
		AND ISNULL(rle.nb_months,0) <> 0

	END

	select @Result as Continue_Flag , @Message as Message, @argumentsForError as ArgumentsForError
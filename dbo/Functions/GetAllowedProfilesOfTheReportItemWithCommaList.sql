
CREATE FUNCTION [dbo].[GetAllowedProfilesOfTheReportItemWithCommaList]
(
	@id_report int
) RETURNS NVARCHAR(max)
AS
	BEGIN

		DECLARE @profileNames nvarchar(max)=''
		SELECT @profileNames = @profileNames + k_profiles.name_profile + ',' from k_modules
		INNER JOIN k_modules_rights ON k_modules_rights.id_module = k_modules.id_module AND k_modules_rights.id_right=-1
		LEFT JOIN k_profiles_modules_rights ON k_profiles_modules_rights.id_module_right = k_modules_rights.id_module_right
		LEFT JOIN k_profiles ON k_profiles.id_profile = k_profiles_modules_rights.id_profile
		WHERE k_modules.id_item = @id_report AND id_module_type = 12

		IF ISNULL(@profileNames,'')='' RETURN ''
		RETURN SUBSTRING(@profileNames , 1, LEN(@profileNames)-1)
	END
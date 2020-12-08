CREATE VIEW [dbo].[Kernel_View_Admin_Profile]
AS
SELECT     id_profile, name_profile, comments_profile, id_owner, date_created, date_last_modified
FROM         dbo.k_profiles
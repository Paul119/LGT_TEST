CREATE VIEW  Kernel_View_Grid_Publish_History
AS
SELECT 
	grph.id_grid_publish_histo,
	us.firstname_user + ' ' + us.lastname_user as 'user_name',
	grph.publish_date,
	grph.number_of_validated,
	grph.number_of_published,
	grph.number_of_rejected,
	grph.id_grid
FROM k_referential_grid_publish_histo AS grph
INNER JOIN k_users AS us ON us.id_user = grph.id_user 
INNER JOIN k_referential_grids AS rg ON rg.id_grid = grph.id_grid
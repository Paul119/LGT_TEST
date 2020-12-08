CREATE VIEW  Kernel_View_Grid_Import_History
AS
SELECT 
	grih.id_grid_import_histo,
	us.firstname_user + ' ' + us.lastname_user as 'user_name',
	grih.file_name,
	grih.import_date,
	grih.number_of_records_in_file,
	grih.number_of_records_accepted,
	grih.number_of_records_rejected,
	grih.id_grid
FROM k_referential_grid_import_histo AS grih
INNER JOIN k_users AS us ON us.id_user = grih.id_user 
INNER JOIN k_referential_grids AS rg ON rg.id_grid = grih.id_grid
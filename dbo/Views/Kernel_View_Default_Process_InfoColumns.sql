CREATE VIEW [dbo].[Kernel_View_Default_Process_InfoColumns]
AS
SELECT
ISNULL(c.lastname, '') + ' ' + ISNULL(c.firstname, '') AS fullname,
h.id_histo,
h.start_date_histo,
h.end_date_histo,
c.idPayee,
c.codePayee,
h.id_structure_1,
h.id_job,
h.id_gender,
h.base_salary,
h.id_title,
h.weight_structure_1
FROM dbo.py_Payee AS c 
	INNER JOIN dbo.py_PayeeHisto AS h 
		ON c.idPayee = h.idPayee
CREATE VIEW [dbo].[Kernel_View_Payee_History]  
AS  
SELECT        kc.idPayee, kc.codePayee, kc.firstname, kc.lastname, dj.long_name_job, ds.long_name_structure, dg.short_name_geography  
FROM            dbo.py_Payee AS kc LEFT OUTER JOIN  
                         dbo.py_PayeeHisto AS kch ON kc.idPayee = kch.idPayee LEFT OUTER JOIN  
                         dbo.Dim_Job AS dj ON dj.id_job = kch.id_job LEFT OUTER JOIN  
                         dbo.Dim_Structure AS ds ON ds.id_structure = kch.id_structure_1 LEFT OUTER JOIN  
                         dbo.Dim_Geography AS dg ON dg.id_geography = kch.id_geography  
WHERE        (GETDATE() >= kch.start_date_histo and GETDATE() < kch.end_date_histo)
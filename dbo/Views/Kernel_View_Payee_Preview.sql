CREATE VIEW [dbo].[Kernel_View_Payee_Preview] 
WITH SCHEMABINDING 
AS
SELECT pp.idPop,p.firstname,p.lastname,p.codePayee,p.idPayee   FROM [dbo].[py_Payee] p
       INNER JOIN [dbo].[pop_VersionContent] pvc ON pvc.idColl= p.idPayee
       INNER JOIN [dbo].[pop_Population] pp ON pp.lastVersion= pvc.idPopVersion
GO
CREATE UNIQUE CLUSTERED INDEX [UQ_Kernel_View_Payee_Preview]
    ON [dbo].[Kernel_View_Payee_Preview]([idPop] ASC, [idPayee] ASC);


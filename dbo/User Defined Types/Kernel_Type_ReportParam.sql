CREATE TYPE [dbo].[Kernel_Type_ReportParam] AS TABLE (
    [tenantId]      UNIQUEIDENTIFIER NULL,
    [payeeId]       INT              NULL,
    [containerName] NVARCHAR (4000)  NULL,
    [documentId]    INT              NULL,
    [documentName]  NVARCHAR (100)   NULL,
    [fileSize]      INT              NULL);


CREATE TABLE [dbo].[_tb_etl_audit_log_logjob] (
    [AuditId]     INT            NULL,
    [logJobId]    NVARCHAR (50)  NULL,
    [packageName] NVARCHAR (100) NULL,
    [StartDate]   DATETIME       NULL,
    [EndDate]     DATETIME       NULL,
    [Status]      NVARCHAR (50)  NULL
);


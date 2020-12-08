CREATE TABLE [dbo].[tb_etl_audit_log_logjob] (
    [auditId]     INT           NULL,
    [logJobId]    INT           NULL,
    [packageName] NVARCHAR (50) NULL,
    [StartDate]   DATETIME      NULL,
    [DateFin]     DATETIME      NULL,
    [EndDate]     DATETIME      NULL,
    [Status]      NVARCHAR (10) NULL,
    [NbFiles]     NVARCHAR (10) NULL
);


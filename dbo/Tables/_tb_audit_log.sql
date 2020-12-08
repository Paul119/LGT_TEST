CREATE TABLE [dbo].[_tb_audit_log] (
    [LogId]      INT             IDENTITY (1, 1) NOT NULL,
    [Category]   NVARCHAR (255)  NULL,
    [Process]    NVARCHAR (255)  NULL,
    [SubProcess] NVARCHAR (255)  NULL,
    [StartDate]  DATETIME        NULL,
    [EventText]  NVARCHAR (1000) NULL,
    [EventDate]  DATETIME        NULL,
    [AuditId]    INT             NULL,
    [UserId]     INT             NULL,
    [ErrorFlag]  BIT             NULL,
    [ErrorText]  NVARCHAR (MAX)  NULL,
    [ErrorLine]  INT             NULL,
    CONSTRAINT [PK__tb_audit__5E548648DF55206A] PRIMARY KEY CLUSTERED ([LogId] ASC)
);


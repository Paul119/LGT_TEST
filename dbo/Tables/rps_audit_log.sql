CREATE TABLE [dbo].[rps_audit_log] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [id_context]       NVARCHAR (100) NULL,
    [id_user_modified] INT            NULL,
    [id_item]          INT            NULL,
    [table_name]       NVARCHAR (50)  NULL,
    [date_modified]    DATETIME       NULL,
    [audit_type]       NVARCHAR (20)  NULL,
    [source_log]       INT            NULL,
    CONSTRAINT [PK_id2] PRIMARY KEY CLUSTERED ([id] ASC)
);


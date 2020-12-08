CREATE TABLE [dbo].[rps_audit_log_detail] (
    [id_detail]    INT            IDENTITY (1, 1) NOT NULL,
    [id_audit]     INT            NOT NULL,
    [audit_values] NVARCHAR (MAX) NULL,
    [column_value] NVARCHAR (MAX) NULL,
    [column_name]  NVARCHAR (100) NULL,
    CONSTRAINT [PK_id_detail] PRIMARY KEY CLUSTERED ([id_detail] ASC),
    CONSTRAINT [FK_rps_audit_log_detail_rps_audit_log] FOREIGN KEY ([id_audit]) REFERENCES [dbo].[rps_audit_log] ([id])
);


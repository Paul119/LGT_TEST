CREATE TABLE [dbo].[rps_audit] (
    [id]          INT IDENTITY (1, 1) NOT NULL,
    [id_table]    INT NOT NULL,
    [audit_level] INT NOT NULL,
    CONSTRAINT [PK_rps_audit_id] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_rps_audit_k_referential_tables_views] FOREIGN KEY ([id_table]) REFERENCES [dbo].[k_referential_tables_views] ([id_table_view])
);


CREATE TABLE [dbo].[k_program_cond_universe_table] (
    [id]                        INT IDENTITY (1, 1) NOT NULL,
    [id_table_view]             INT NOT NULL,
    [id_table_view_transaction] INT NULL,
    [id_type]                   INT NOT NULL,
    [id_table_view_publication] INT NULL,
    [id_source_tenant]          INT NULL,
    [id_source]                 INT NULL,
    [id_change_set]             INT NULL,
    CONSTRAINT [PK_k_program_cond_universe_table] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_program_cond_universe_table_k_referential_tables_views] FOREIGN KEY ([id_table_view]) REFERENCES [dbo].[k_referential_tables_views] ([id_table_view]),
    CONSTRAINT [FK_k_program_cond_universe_table_k_referential_tables_views1] FOREIGN KEY ([id_table_view_transaction]) REFERENCES [dbo].[k_referential_tables_views] ([id_table_view])
);


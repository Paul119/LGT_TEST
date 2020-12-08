CREATE TABLE [dbo].[k_program_cond_universes] (
    [id_universe]        INT            IDENTITY (1, 1) NOT NULL,
    [name_universe]      NVARCHAR (255) NOT NULL,
    [date_reference]     NVARCHAR (50)  NULL,
    [date_reference_sql] NVARCHAR (50)  NULL,
    [active_universe]    BIT            NULL,
    [id_owner]           INT            NULL,
    [date_created]       SMALLDATETIME  NULL,
    [date_last_modified] SMALLDATETIME  NULL,
    [id_universe_table]  INT            NULL,
    [id_source_tenant]   INT            NULL,
    [id_source]          INT            NULL,
    [id_change_set]      INT            NULL,
    CONSTRAINT [PK_k_condition_view] PRIMARY KEY CLUSTERED ([id_universe] ASC),
    CONSTRAINT [FK_k_program_cond_universes_k_program_cond_universe_table] FOREIGN KEY ([id_universe_table]) REFERENCES [dbo].[k_program_cond_universe_table] ([id])
);


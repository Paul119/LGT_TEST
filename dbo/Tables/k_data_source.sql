CREATE TABLE [dbo].[k_data_source] (
    [id_data_source]      INT            IDENTITY (1, 1) NOT NULL,
    [name_data_source]    NVARCHAR (255) NOT NULL,
    [id_table_view]       INT            NULL,
    [id_plan]             INT            NULL,
    [type_data_source]    NVARCHAR (255) NOT NULL,
    [is_editable]         BIT            CONSTRAINT [DF_k_data_source_is_editable] DEFAULT ((0)) NOT NULL,
    [display_field_alias] VARCHAR (50)   NULL,
    CONSTRAINT [PK_k_data_source] PRIMARY KEY CLUSTERED ([id_data_source] ASC),
    CONSTRAINT [fk_k_data_source_id_plan_k_m_plans_id_plan] FOREIGN KEY ([id_plan]) REFERENCES [dbo].[k_m_plans] ([id_plan]),
    CONSTRAINT [fk_k_data_source_id_table_view_k_referential_tables_views_id_table_view] FOREIGN KEY ([id_table_view]) REFERENCES [dbo].[k_referential_tables_views] ([id_table_view])
);


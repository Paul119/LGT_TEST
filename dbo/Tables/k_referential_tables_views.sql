CREATE TABLE [dbo].[k_referential_tables_views] (
    [id_table_view]                 INT              IDENTITY (1, 1) NOT NULL,
    [name_table_view]               NVARCHAR (255)   NOT NULL,
    [type_table_view]               NVARCHAR (50)    NOT NULL,
    [type_data]                     INT              NULL,
    [is_kernel]                     BIT              CONSTRAINT [DF_k_referential_tables_views_is_kernel] DEFAULT ((0)) NULL,
    [dataset_query]                 NVARCHAR (MAX)   NULL,
    [id_source_tenant]              INT              NULL,
    [id_source]                     INT              NULL,
    [id_change_set]                 INT              NULL,
    [id_object_security_table_view] INT              NULL,
    [is_used_in_report_model]       BIT              CONSTRAINT [DF_k_referential_tables_views_is_used_in_report_model] DEFAULT ((1)) NOT NULL,
    [id_analytics_datasource]       NVARCHAR (50)    NULL,
    [id_analytics_datasource_type]  TINYINT          NULL,
    [uid_datasource]                UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_k_referential_tables_views] PRIMARY KEY CLUSTERED ([id_table_view] ASC),
    CONSTRAINT [FK_k_referential_tables_views_k_referential_tables_views] FOREIGN KEY ([id_object_security_table_view]) REFERENCES [dbo].[k_referential_tables_views] ([id_table_view])
);


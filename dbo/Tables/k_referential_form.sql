CREATE TABLE [dbo].[k_referential_form] (
    [form_id]           INT            IDENTITY (1, 1) NOT NULL,
    [table_view_id]     INT            NULL,
    [form_name]         NVARCHAR (255) NOT NULL,
    [comments]          NVARCHAR (255) NULL,
    [columns_count]     INT            NOT NULL,
    [form_type]         INT            NOT NULL,
    [form_template_id]  INT            NULL,
    [active_trace]      BIT            NULL,
    [isMultipleSource]  BIT            CONSTRAINT [DF_k_referential_form_isMultipleSource] DEFAULT ((0)) NOT NULL,
    [form_container_id] INT            NULL,
    [id_source_tenant]  INT            NULL,
    [id_source]         INT            NULL,
    [id_change_set]     INT            NULL,
    CONSTRAINT [PK_k_referential_form] PRIMARY KEY CLUSTERED ([form_id] ASC),
    CONSTRAINT [FK_k_referential_form_k_referential_tables_views] FOREIGN KEY ([table_view_id]) REFERENCES [dbo].[k_referential_tables_views] ([id_table_view])
);


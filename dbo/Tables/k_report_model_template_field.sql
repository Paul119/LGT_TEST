CREATE TABLE [dbo].[k_report_model_template_field] (
    [id_report_model_template_field]            INT            IDENTITY (1, 1) NOT NULL,
    [name_report_model_template_field]          NVARCHAR (250) NOT NULL,
    [description_report_model_template_field]   NVARCHAR (MAX) NULL,
    [id_table_view_datasource]                  INT            NOT NULL,
    [id_table_view_field_datasource_display]    INT            NOT NULL,
    [id_form_parameter]                         INT            NULL,
    [id_report_model]                           INT            NOT NULL,
    [configuration_report_model_template_field] NVARCHAR (MAX) NOT NULL,
    [date_created]                              DATETIME       NOT NULL,
    [id_owner]                                  INT            NOT NULL,
    CONSTRAINT [PK_k_report_model_template_field] PRIMARY KEY CLUSTERED ([id_report_model_template_field] ASC),
    CONSTRAINT [FK_k_report_model_template_field_id_form_parameter] FOREIGN KEY ([id_form_parameter]) REFERENCES [dbo].[k_referential_form] ([form_id]),
    CONSTRAINT [FK_k_report_model_template_field_id_report_model] FOREIGN KEY ([id_report_model]) REFERENCES [dbo].[k_reports_model] ([id_report_model]),
    CONSTRAINT [FK_k_report_model_template_field_id_table_view_datasource] FOREIGN KEY ([id_table_view_datasource]) REFERENCES [dbo].[k_referential_tables_views] ([id_table_view]),
    CONSTRAINT [FK_k_report_model_template_field_id_table_view_field_datasource_display] FOREIGN KEY ([id_table_view_field_datasource_display]) REFERENCES [dbo].[k_referential_tables_views_fields] ([id_field])
);


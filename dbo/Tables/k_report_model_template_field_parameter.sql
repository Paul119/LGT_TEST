CREATE TABLE [dbo].[k_report_model_template_field_parameter] (
    [id_report_model_template_field_parameter]               INT            IDENTITY (1, 1) NOT NULL,
    [description_report_model_template_field_parameter]      NVARCHAR (MAX) NULL,
    [placeholder_name_report_model_template_field_parameter] NVARCHAR (20)  NOT NULL,
    [id_report_model_template_field]                         INT            NOT NULL,
    [id_form_field_parameter]                                INT            NULL,
    [dynamic_value_type]                                     TINYINT        NULL,
    [static_value]                                           NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_k_report_model_template_field_parameter] PRIMARY KEY CLUSTERED ([id_report_model_template_field_parameter] ASC),
    CONSTRAINT [FK_k_report_model_template_field_parameter_dynamic_value_type] FOREIGN KEY ([dynamic_value_type]) REFERENCES [dbo].[k_report_model_template_field_parameter_dynamic_value_type] ([id_report_model_template_field_parameter_dynamic_value_type]),
    CONSTRAINT [FK_k_report_model_template_field_parameter_id_form_field_parameter] FOREIGN KEY ([id_form_field_parameter]) REFERENCES [dbo].[k_referential_form_field] ([field_id]),
    CONSTRAINT [FK_k_report_model_template_field_parameter_id_report_model_template_field] FOREIGN KEY ([id_report_model_template_field]) REFERENCES [dbo].[k_report_model_template_field] ([id_report_model_template_field])
);


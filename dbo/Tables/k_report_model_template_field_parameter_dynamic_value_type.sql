CREATE TABLE [dbo].[k_report_model_template_field_parameter_dynamic_value_type] (
    [id_report_model_template_field_parameter_dynamic_value_type]   TINYINT       IDENTITY (1, 1) NOT NULL,
    [name_report_model_template_field_parameter_default_value_type] NVARCHAR (25) NOT NULL,
    CONSTRAINT [PK_k_report_model_template_field_parameter_dynamic_value_type] PRIMARY KEY CLUSTERED ([id_report_model_template_field_parameter_dynamic_value_type] ASC)
);


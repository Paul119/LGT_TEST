CREATE TABLE [dbo].[k_report_template_field_value] (
    [id_report_template_field_value]           INT            IDENTITY (1, 1) NOT NULL,
    [input_value]                              NVARCHAR (MAX) NULL,
    [id_report_model_template_field_parameter] INT            NOT NULL,
    [id_report_template_field]                 INT            NOT NULL,
    CONSTRAINT [PK_k_report_template_field_value] PRIMARY KEY CLUSTERED ([id_report_template_field_value] ASC),
    CONSTRAINT [FK_k_report_template_field_value_id_report_model_template_field_parameter] FOREIGN KEY ([id_report_model_template_field_parameter]) REFERENCES [dbo].[k_report_model_template_field_parameter] ([id_report_model_template_field_parameter]),
    CONSTRAINT [FK_k_report_template_field_value_id_report_template_field] FOREIGN KEY ([id_report_template_field]) REFERENCES [dbo].[k_report_template_field] ([id_report_template_field])
);


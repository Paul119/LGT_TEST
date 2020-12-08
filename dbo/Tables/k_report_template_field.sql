CREATE TABLE [dbo].[k_report_template_field] (
    [id_report_template_field]          INT            IDENTITY (1, 1) NOT NULL,
    [name_report_template_field]        NVARCHAR (250) NOT NULL,
    [description_report_template_field] NVARCHAR (MAX) NULL,
    [id_report]                         INT            NULL,
    [id_report_model_template_field]    INT            NOT NULL,
    [date_created]                      DATETIME       NOT NULL,
    [id_owner]                          INT            NOT NULL,
    CONSTRAINT [PK_k_report_template_field] PRIMARY KEY CLUSTERED ([id_report_template_field] ASC),
    CONSTRAINT [FK_k_reports_template_field_id_owner] FOREIGN KEY ([id_owner]) REFERENCES [dbo].[k_users] ([id_user]),
    CONSTRAINT [FK_k_reports_template_field_id_report] FOREIGN KEY ([id_report]) REFERENCES [dbo].[k_reports] ([id_report]),
    CONSTRAINT [FK_k_reports_template_field_id_report_model_template_field] FOREIGN KEY ([id_report_model_template_field]) REFERENCES [dbo].[k_report_model_template_field] ([id_report_model_template_field])
);


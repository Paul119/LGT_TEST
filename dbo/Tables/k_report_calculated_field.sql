CREATE TABLE [dbo].[k_report_calculated_field] (
    [id_report_calculated_field]    INT            IDENTITY (1, 1) NOT NULL,
    [id_report]                     INT            NULL,
    [id_report_model]               INT            NULL,
    [name_report_calculcated_field] NVARCHAR (200) NOT NULL,
    [html_formula]                  NVARCHAR (MAX) NOT NULL,
    [sql_formula]                   NVARCHAR (MAX) NOT NULL,
    [create_date]                   DATETIME       NOT NULL,
    [id_owner]                      INT            NOT NULL,
    [is_valid]                      BIT            CONSTRAINT [DF_k_report_calculated_field_is_valid] DEFAULT ((0)) NOT NULL,
    [type_field]                    NVARCHAR (50)  CONSTRAINT [DF_k_report_calculated_field_type_field] DEFAULT ('DECIMAL') NOT NULL,
    CONSTRAINT [PK_k_report_calculated_field] PRIMARY KEY CLUSTERED ([id_report_calculated_field] ASC),
    CONSTRAINT [FK_k_report_calculated_field_k_reports] FOREIGN KEY ([id_report]) REFERENCES [dbo].[k_reports] ([id_report]),
    CONSTRAINT [FK_k_report_calculated_field_k_reports_model] FOREIGN KEY ([id_report_model]) REFERENCES [dbo].[k_reports_model] ([id_report_model]),
    CONSTRAINT [FK_k_report_calculated_field_k_users] FOREIGN KEY ([id_owner]) REFERENCES [dbo].[k_users] ([id_user])
);


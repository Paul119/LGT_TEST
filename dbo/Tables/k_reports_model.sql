CREATE TABLE [dbo].[k_reports_model] (
    [id_report_model]            INT            IDENTITY (1, 1) NOT NULL,
    [name_report_model]          NVARCHAR (50)  NOT NULL,
    [configuration_report_model] NVARCHAR (MAX) NOT NULL,
    [id_owner]                   INT            NOT NULL,
    [date_creation]              DATETIME       NOT NULL,
    [date_modification]          DATETIME       NULL,
    [id_source_tenant]           INT            NULL,
    [id_source]                  INT            NULL,
    [id_change_set]              INT            NULL,
    CONSTRAINT [PK_k_reports_model] PRIMARY KEY CLUSTERED ([id_report_model] ASC)
);


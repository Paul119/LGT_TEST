CREATE TABLE [dbo].[k_reports_source] (
    [id_report_source] INT            IDENTITY (1, 1) NOT NULL,
    [name]             NVARCHAR (100) NULL,
    CONSTRAINT [PK_k_reports_source] PRIMARY KEY CLUSTERED ([id_report_source] ASC)
);


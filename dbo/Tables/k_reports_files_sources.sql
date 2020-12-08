CREATE TABLE [dbo].[k_reports_files_sources] (
    [id_report_file_source] INT            IDENTITY (1, 1) NOT NULL,
    [id_report]             INT            NULL,
    [id_report_model]       INT            NULL,
    [id_table_view]         INT            NOT NULL,
    [file_name]             NVARCHAR (255) NOT NULL,
    [create_date]           DATE           NOT NULL,
    [id_owner]              INT            NOT NULL,
    CONSTRAINT [PK_k_reports_files_sources] PRIMARY KEY CLUSTERED ([id_report_file_source] ASC),
    CONSTRAINT [FK_k_reports_files_sources_k_referential_tables_views] FOREIGN KEY ([id_table_view]) REFERENCES [dbo].[k_referential_tables_views] ([id_table_view])
);


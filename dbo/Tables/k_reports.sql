CREATE TABLE [dbo].[k_reports] (
    [id_report]                      INT              IDENTITY (1, 1) NOT NULL,
    [id_folder]                      INT              NULL,
    [name_report]                    NVARCHAR (255)   NULL,
    [id_bar]                         INT              NULL,
    [url_report]                     NVARCHAR (200)   NULL,
    [sort_report]                    INT              NULL,
    [type]                           INT              NULL,
    [visual_type]                    INT              NULL,
    [description]                    NVARCHAR (MAX)   NULL,
    [id_owner]                       INT              NULL,
    [id_source_tenant]               INT              NULL,
    [id_source]                      INT              NULL,
    [id_change_set]                  INT              NULL,
    [configuration_report]           NVARCHAR (MAX)   NULL,
    [id_report_model]                INT              NULL,
    [is_password_protection_enabled] BIT              CONSTRAINT [DF_k_reports_is_password_protection_enabled] DEFAULT ((0)) NOT NULL,
    [show_description]               BIT              CONSTRAINT [DF_k_reports_show_description] DEFAULT ((0)) NOT NULL,
    [description_original]           NVARCHAR (MAX)   NULL,
    [use_translate]                  BIT              CONSTRAINT [DF_k_reports_use_translate] DEFAULT ((0)) NOT NULL,
    [id_report_source]               INT              DEFAULT ((-1)) NOT NULL,
    [id_dashboard]                   NVARCHAR (MAX)   DEFAULT (NULL) NULL,
    [id_dashboard_table_view]        INT              NULL,
    [uid_object]                     UNIQUEIDENTIFIER NULL,
    [show_filter_panel]              BIT              DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_k_reports] PRIMARY KEY CLUSTERED ([id_report] ASC),
    CONSTRAINT [FK_k_reports_k_referential_tables_views] FOREIGN KEY ([id_dashboard_table_view]) REFERENCES [dbo].[k_referential_tables_views] ([id_table_view]),
    CONSTRAINT [FK_k_reports_k_reports_folder] FOREIGN KEY ([id_folder]) REFERENCES [dbo].[k_reports_folders] ([id_folder]),
    CONSTRAINT [FK_k_reports_k_reports_model] FOREIGN KEY ([id_report_model]) REFERENCES [dbo].[k_reports_model] ([id_report_model]),
    CONSTRAINT [FK_k_reports_k_reports_source] FOREIGN KEY ([id_report_source]) REFERENCES [dbo].[k_reports_source] ([id_report_source])
);


GO
CREATE NONCLUSTERED INDEX [IX__k_reports__id_folder]
    ON [dbo].[k_reports]([id_folder] ASC);


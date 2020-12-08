CREATE TABLE [dbo].[k_reports_control_link] (
    [id_link]            INT           IDENTITY (0, 1) NOT NULL,
    [id_report]          INT           NULL,
    [id_report_control]  INT           NULL,
    [report_filter_name] NVARCHAR (50) NULL,
    [is_filtered]        BIT           NULL,
    [is_required]        BIT           NULL,
    [sort]               INT           NULL,
    [goto_line]          BIT           NULL,
    [id_source_tenant]   INT           NULL,
    [id_source]          INT           NULL,
    [id_change_set]      INT           NULL,
    CONSTRAINT [PK_k_reports_control_link] PRIMARY KEY CLUSTERED ([id_link] ASC),
    CONSTRAINT [FK_k_reports_control_link_k_reports] FOREIGN KEY ([id_report]) REFERENCES [dbo].[k_reports] ([id_report]),
    CONSTRAINT [FK_k_reports_control_link_k_reports_control] FOREIGN KEY ([id_report_control]) REFERENCES [dbo].[k_reports_control] ([id_report_control])
);


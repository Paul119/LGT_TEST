CREATE TABLE [dbo].[k_reports_control_relation] (
    [id_relation]              INT            IDENTITY (1, 1) NOT NULL,
    [id_report_control]        INT            NULL,
    [id_report_parent_control] INT            NULL,
    [is_required]              BIT            NULL,
    [filter_field]             NVARCHAR (100) NULL,
    CONSTRAINT [PK_k_reports_control_relation] PRIMARY KEY CLUSTERED ([id_relation] ASC)
);


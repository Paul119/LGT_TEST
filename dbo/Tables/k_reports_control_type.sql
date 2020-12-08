CREATE TABLE [dbo].[k_reports_control_type] (
    [id_type]           INT           IDENTITY (1, 1) NOT NULL,
    [name_control_type] NVARCHAR (50) NULL,
    CONSTRAINT [PK_k_reports_control_type] PRIMARY KEY CLUSTERED ([id_type] ASC)
);


CREATE TABLE [dbo].[k_m_plan_excel_summary_column_type] (
    [id_column_type]   INT           IDENTITY (1, 1) NOT NULL,
    [name_column_type] NVARCHAR (50) NULL,
    CONSTRAINT [PK_k_m_plan_excel_summary_column_type] PRIMARY KEY CLUSTERED ([id_column_type] ASC)
);


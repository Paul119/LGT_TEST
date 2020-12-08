CREATE TABLE [dbo].[k_m_plan_excel_summary_column] (
    [id_summary_column]  INT            IDENTITY (1, 1) NOT NULL,
    [id_summary]         INT            NOT NULL,
    [column_uniquename]  NVARCHAR (250) NOT NULL,
    [type_column]        INT            NOT NULL,
    [headertext]         NVARCHAR (250) NOT NULL,
    [order_column]       INT            NULL,
    [excel_formula]      NVARCHAR (MAX) NULL,
    [decimal_precision]  INT            NULL,
    [thousand_separator] BIT            NULL,
    CONSTRAINT [PK_k_m_plan_excel_summary_column] PRIMARY KEY CLUSTERED ([id_summary_column] ASC),
    CONSTRAINT [FK_k_m_plan_excel_summary_column_k_m_plan_excel_summary] FOREIGN KEY ([id_summary]) REFERENCES [dbo].[k_m_plan_excel_summary] ([id_summary]),
    CONSTRAINT [FK_k_m_plan_excel_summary_column_k_m_plan_excel_summary_column_type] FOREIGN KEY ([type_column]) REFERENCES [dbo].[k_m_plan_excel_summary_column_type] ([id_column_type])
);


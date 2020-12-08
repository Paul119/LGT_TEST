CREATE TABLE [dbo].[k_m_plan_layout_type] (
    [id_plan_layout_type]   INT           IDENTITY (1, 1) NOT NULL,
    [name_plan_layout_type] NVARCHAR (25) NULL,
    CONSTRAINT [PK_k_m_plan_layout_type] PRIMARY KEY CLUSTERED ([id_plan_layout_type] ASC)
);


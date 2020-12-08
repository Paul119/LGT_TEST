CREATE TABLE [dbo].[k_m_plan_level] (
    [id_plan_level]    INT           IDENTITY (1, 1) NOT NULL,
    [value_plan_level] NVARCHAR (25) NULL,
    [sort_order]       INT           NOT NULL,
    CONSTRAINT [PK_k_m_plan_level] PRIMARY KEY CLUSTERED ([id_plan_level] ASC)
);


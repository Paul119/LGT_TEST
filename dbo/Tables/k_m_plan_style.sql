CREATE TABLE [dbo].[k_m_plan_style] (
    [id_plan_style] INT            IDENTITY (1, 1) NOT NULL,
    [id_plan]       INT            NOT NULL,
    [id_style]      INT            NOT NULL,
    [column_name]   NVARCHAR (100) NULL,
    CONSTRAINT [PK_k_m_plan_style] PRIMARY KEY CLUSTERED ([id_plan_style] ASC),
    CONSTRAINT [FK_k_m_plan_style_k_m_plans] FOREIGN KEY ([id_plan]) REFERENCES [dbo].[k_m_plans] ([id_plan]),
    CONSTRAINT [FK_k_m_plan_style_k_m_style] FOREIGN KEY ([id_style]) REFERENCES [dbo].[k_m_style] ([id_style])
);


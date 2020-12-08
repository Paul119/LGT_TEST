CREATE TABLE [dbo].[k_m_plan_data_security] (
    [id_plan_data_security]       INT IDENTITY (1, 1) NOT NULL,
    [id_tree_security_plan_level] INT NOT NULL,
    [id_process]                  INT NOT NULL,
    CONSTRAINT [PK_k_m_plan_data_security] PRIMARY KEY CLUSTERED ([id_plan_data_security] ASC),
    CONSTRAINT [FK_k_m_plan_data_security_k_m_plans] FOREIGN KEY ([id_process]) REFERENCES [dbo].[k_m_plans] ([id_plan]),
    CONSTRAINT [FK_k_m_plan_data_security_k_tree_security_plan_level] FOREIGN KEY ([id_tree_security_plan_level]) REFERENCES [dbo].[k_tree_security_plan_level] ([id_tree_security_plan_level])
);


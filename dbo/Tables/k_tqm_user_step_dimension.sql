CREATE TABLE [dbo].[k_tqm_user_step_dimension] (
    [id_user_step_dimension]     INT IDENTITY (1, 1) NOT NULL,
    [id_plan]                    INT NOT NULL,
    [id_user]                    INT NOT NULL,
    [id_template_step_dimension] INT NOT NULL,
    CONSTRAINT [PK_k_tqm_user_step_dimension] PRIMARY KEY CLUSTERED ([id_user_step_dimension] ASC),
    CONSTRAINT [FK_k_tqm_user_dimension_k_m_plans] FOREIGN KEY ([id_plan]) REFERENCES [dbo].[k_m_plans] ([id_plan]),
    CONSTRAINT [FK_k_tqm_user_dimension_k_tqm_template_step_dimension] FOREIGN KEY ([id_template_step_dimension]) REFERENCES [dbo].[k_tqm_template_step_dimension] ([id_template_step_dimension]),
    CONSTRAINT [FK_k_tqm_user_dimension_k_users] FOREIGN KEY ([id_user]) REFERENCES [dbo].[k_users] ([id_user])
);


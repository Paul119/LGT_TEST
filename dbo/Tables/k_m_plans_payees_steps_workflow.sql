CREATE TABLE [dbo].[k_m_plans_payees_steps_workflow] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [id_step]          INT            NOT NULL,
    [id_workflow_step] INT            NOT NULL,
    [statut_step]      INT            NULL,
    [comment_step]     NVARCHAR (MAX) NULL,
    [date_step]        DATETIME       NULL,
    [id_user]          INT            NULL,
    [is_consolidated]  BIT            NOT NULL,
    [current_sort]     INT            NULL,
    [max_sort]         INT            NULL,
    CONSTRAINT [PK_k_m_plans_payees_steps_workflow] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_m_plans_payees_steps_workflow_k_m_plans_payees_steps] FOREIGN KEY ([id_step]) REFERENCES [dbo].[k_m_plans_payees_steps] ([id_step]),
    CONSTRAINT [FK_k_m_plans_payees_steps_workflow_k_m_workflow_step] FOREIGN KEY ([id_workflow_step]) REFERENCES [dbo].[k_m_workflow_step] ([id_wflstep])
);


GO
CREATE NONCLUSTERED INDEX [IX_k_m_plans_payees_steps_workflow_id_step_id_workflow_step]
    ON [dbo].[k_m_plans_payees_steps_workflow]([id_step] ASC)
    INCLUDE([id_workflow_step]);


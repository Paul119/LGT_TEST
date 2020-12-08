CREATE TABLE [dbo].[k_m_plans_payees_mobility] (
    [id]        INT IDENTITY (1, 1) NOT NULL,
    [id_step]   INT NOT NULL,
    [id_status] INT NOT NULL,
    CONSTRAINT [PK_k_m_plans_payees_mobility] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_m_plans_payees_mobility_k_m_plans_payees_steps] FOREIGN KEY ([id_step]) REFERENCES [dbo].[k_m_plans_payees_steps] ([id_step])
);


GO
CREATE NONCLUSTERED INDEX [IX_k_m_plans_payees_mobility]
    ON [dbo].[k_m_plans_payees_mobility]([id_step] ASC);


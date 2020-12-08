CREATE TABLE [dbo].[k_m_plans_payees_steps] (
    [id_step]                INT              IDENTITY (1, 1) NOT NULL,
    [id_plan]                INT              NOT NULL,
    [id_assignment]          INT              NOT NULL,
    [id_payee]               INT              NOT NULL,
    [start_step]             DATETIME         NOT NULL,
    [end_step]               DATETIME         NOT NULL,
    [id_user_create]         INT              NOT NULL,
    [date_create_assignment] DATETIME         NULL,
    [id_user_update]         INT              NULL,
    [date_update_assignment] DATETIME         NULL,
    [locked]                 BIT              NOT NULL,
    [frequency_index]        INT              NULL,
    [uid_reference]          UNIQUEIDENTIFIER CONSTRAINT [DF_k_m_plans_payees_steps_uid_reference] DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_k_m_plans_payees_steps] PRIMARY KEY CLUSTERED ([id_step] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [ncix_idPayee_idPlan_startStep_endStep]
    ON [dbo].[k_m_plans_payees_steps]([id_payee] ASC, [id_plan] ASC, [start_step] ASC, [end_step] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-PayeeStepIdPlan-WithDate]
    ON [dbo].[k_m_plans_payees_steps]([id_plan] ASC, [start_step] ASC, [end_step] ASC)
    INCLUDE([id_payee], [id_step]);


GO
CREATE NONCLUSTERED INDEX [IX_k_m_plans_payees_steps_id_assignment]
    ON [dbo].[k_m_plans_payees_steps]([id_assignment] ASC);


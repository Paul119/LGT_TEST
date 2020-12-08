CREATE TABLE [dbo].[k_m_plans_payees_steps_workflow_xhisto] (
    [id]                  INT            IDENTITY (1, 1) NOT NULL,
    [id_step]             INT            NOT NULL,
    [id_workflow_step]    INT            NOT NULL,
    [statut_step]         INT            NULL,
    [comment_step]        NVARCHAR (MAX) NULL,
    [date_step]           DATETIME       NULL,
    [id_user]             INT            NULL,
    [is_consolidated]     BIT            NOT NULL,
    [current_sort]        INT            NULL,
    [max_sort]            INT            NULL,
    [idTree]              INT            NULL,
    [id_workflow_step_to] INT            NULL,
    [validationType]      SMALLINT       NULL,
    [success]             BIT            CONSTRAINT [DF_k_m_plans_payees_steps_workflow_xhisto_success] DEFAULT ((1)) NULL,
    [denied]              BIT            CONSTRAINT [DF_k_m_plans_payees_steps_workflow_xhisto_denied] DEFAULT ((0)) NULL,
    [id_transaction]      INT            NULL,
    [id_workflow_group]   INT            NULL,
    CONSTRAINT [PK_k_m_plans_payees_steps_workflow_xhisto] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_id_transaction_filtered]
    ON [dbo].[k_m_plans_payees_steps_workflow_xhisto]([id_transaction] ASC)
    INCLUDE([id_step], [id_workflow_step], [id_workflow_step_to]) WHERE ([id_transaction] IS NOT NULL);


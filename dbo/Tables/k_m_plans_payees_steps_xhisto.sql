CREATE TABLE [dbo].[k_m_plans_payees_steps_xhisto] (
    [id_xhisto]                INT           IDENTITY (1, 1) NOT NULL,
    [id_user_xhisto]           INT           NOT NULL,
    [dt_xhisto]                DATETIME      NOT NULL,
    [type_xhisto]              NVARCHAR (10) NOT NULL,
    [o_id_step]                INT           NOT NULL,
    [o_id_plan]                INT           NOT NULL,
    [o_id_assignment]          INT           NOT NULL,
    [o_id_payee]               INT           NOT NULL,
    [o_start_step]             DATETIME      NOT NULL,
    [o_end_step]               DATETIME      NOT NULL,
    [o_id_user_create]         INT           NOT NULL,
    [o_date_create_assignment] DATETIME      NULL,
    [o_id_user_update]         INT           NULL,
    [o_date_update_assignment] DATETIME      NULL,
    [o_locked]                 BIT           NOT NULL,
    [o_frequency_index]        INT           NULL,
    CONSTRAINT [PK_k_m_plans_payees_steps_xhisto] PRIMARY KEY CLUSTERED ([id_xhisto] ASC)
);


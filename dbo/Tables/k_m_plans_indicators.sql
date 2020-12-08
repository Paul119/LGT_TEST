CREATE TABLE [dbo].[k_m_plans_indicators] (
    [id_plan_indicator]   INT            IDENTITY (1, 1) NOT NULL,
    [id_plan]             INT            NULL,
    [id_ind]              INT            NOT NULL,
    [weight_plan_ind]     INT            NULL,
    [comment_plan_ind]    NVARCHAR (MAX) NULL,
    [sort_plan_ind]       INT            NULL,
    [start_date_plan_ind] DATETIME       NOT NULL,
    [end_date_plan_ind]   DATETIME       NOT NULL,
    [id_source_tenant]    INT            NULL,
    [id_source]           INT            NULL,
    [id_change_set]       INT            NULL,
    [is_frozen]           BIT            CONSTRAINT [DF_k_m_plans_indicators_is_frozen] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_k_m_plans_indicators] PRIMARY KEY CLUSTERED ([id_plan_indicator] ASC),
    CONSTRAINT [FK_k_m_plans_indicators_k_m_indicators] FOREIGN KEY ([id_ind]) REFERENCES [dbo].[k_m_indicators] ([id_ind]),
    CONSTRAINT [FK_k_m_plans_indicators_k_m_plans] FOREIGN KEY ([id_plan]) REFERENCES [dbo].[k_m_plans] ([id_plan])
);


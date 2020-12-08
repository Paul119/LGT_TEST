CREATE TABLE [dbo].[k_m_plans_frequency] (
    [id_plan_frequency] INT      IDENTITY (1, 1) NOT NULL,
    [start_date]        DATETIME NULL,
    [end_date]          DATETIME NULL,
    [id_plan]           INT      NULL,
    [frequency_index]   INT      NULL,
    CONSTRAINT [PK_k_m_plans_frequency] PRIMARY KEY CLUSTERED ([id_plan_frequency] ASC)
);


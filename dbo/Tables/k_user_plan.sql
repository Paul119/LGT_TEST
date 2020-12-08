CREATE TABLE [dbo].[k_user_plan] (
    [id_user_plan]    INT           IDENTITY (1, 1) NOT NULL,
    [id_user_profile] INT           NOT NULL,
    [id_plan]         INT           NOT NULL,
    [page_size]       INT           NULL,
    [row_density]     INT           NULL,
    [level]           NVARCHAR (50) NULL,
    [self_appraisal]  INT           NULL,
    CONSTRAINT [PK_k_user_plan] PRIMARY KEY CLUSTERED ([id_user_plan] ASC),
    CONSTRAINT [FK_k_user_plan_k_m_plans] FOREIGN KEY ([id_plan]) REFERENCES [dbo].[k_m_plans] ([id_plan]),
    CONSTRAINT [FK_k_user_plan_k_users_profiles] FOREIGN KEY ([id_user_profile]) REFERENCES [dbo].[k_users_profiles] ([idUserProfile])
);


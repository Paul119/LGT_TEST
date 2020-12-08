CREATE TABLE [dbo].[k_user_plan_view] (
    [id_user_plan_view] INT            IDENTITY (1, 1) NOT NULL,
    [name_view]         NVARCHAR (MAX) NOT NULL,
    [id_plan]           INT            NOT NULL,
    [id_profile]        INT            NOT NULL,
    [id_user]           INT            NOT NULL,
    [is_selected]       BIT            CONSTRAINT [DF_k_user_plan_view_is_selected] DEFAULT ((0)) NOT NULL,
    [page_size]         INT            NULL,
    [row_density]       INT            NULL,
    [level]             NVARCHAR (50)  NULL,
    [self_appraisal]    INT            NULL,
    CONSTRAINT [PK_k_user_plan_view] PRIMARY KEY CLUSTERED ([id_user_plan_view] ASC),
    CONSTRAINT [FK_k_user_plan_view_k_m_plans] FOREIGN KEY ([id_plan]) REFERENCES [dbo].[k_m_plans] ([id_plan]),
    CONSTRAINT [FK_k_user_plan_view_k_profiles] FOREIGN KEY ([id_profile]) REFERENCES [dbo].[k_profiles] ([id_profile]),
    CONSTRAINT [FK_k_user_plan_view_k_users] FOREIGN KEY ([id_user]) REFERENCES [dbo].[k_users] ([id_user])
);


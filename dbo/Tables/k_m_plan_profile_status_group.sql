CREATE TABLE [dbo].[k_m_plan_profile_status_group] (
    [id_plan_profile_status_group] INT            IDENTITY (1, 1) NOT NULL,
    [id_plan]                      INT            NOT NULL,
    [id_profile]                   INT            NOT NULL,
    [description]                  NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_k_m_plan_profile_status_group] PRIMARY KEY CLUSTERED ([id_plan_profile_status_group] ASC),
    CONSTRAINT [FK_k_m_plan_profile_status_group_k_m_plans] FOREIGN KEY ([id_plan]) REFERENCES [dbo].[k_m_plans] ([id_plan]),
    CONSTRAINT [FK_k_m_plan_profile_status_group_k_profiles] FOREIGN KEY ([id_profile]) REFERENCES [dbo].[k_profiles] ([id_profile])
);


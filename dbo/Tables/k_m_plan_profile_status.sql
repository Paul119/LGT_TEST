CREATE TABLE [dbo].[k_m_plan_profile_status] (
    [id_plan_profile_status]       INT            IDENTITY (1, 1) NOT NULL,
    [id_plan_profile_status_group] INT            NOT NULL,
    [id_plan_status]               INT            NOT NULL,
    [start_date]                   DATETIME       NOT NULL,
    [description]                  NVARCHAR (MAX) NULL,
    [last_modified_date]           DATETIME       NOT NULL,
    [last_modified_by]             INT            NOT NULL,
    CONSTRAINT [PK_k_m_plan_profile_status] PRIMARY KEY CLUSTERED ([id_plan_profile_status] ASC),
    CONSTRAINT [FK_k_m_plan_profile_status_k_m_plan_profile_status_group] FOREIGN KEY ([id_plan_profile_status_group]) REFERENCES [dbo].[k_m_plan_profile_status_group] ([id_plan_profile_status_group]),
    CONSTRAINT [FK_k_m_plan_profile_status_k_m_plan_status] FOREIGN KEY ([id_plan_status]) REFERENCES [dbo].[k_m_plan_status] ([id_plan_status]),
    CONSTRAINT [FK_k_m_plan_profile_status_k_users] FOREIGN KEY ([last_modified_by]) REFERENCES [dbo].[k_users] ([id_user])
);


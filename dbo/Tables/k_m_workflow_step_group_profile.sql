CREATE TABLE [dbo].[k_m_workflow_step_group_profile] (
    [id_wflstepgroupprofile] INT IDENTITY (1, 1) NOT NULL,
    [id_wflstepgroup]        INT NOT NULL,
    [id_profile]             INT NOT NULL,
    [id_source_tenant]       INT NULL,
    [id_source]              INT NULL,
    [id_change_set]          INT NULL,
    CONSTRAINT [PK_k_m_workflow_step_group_profile] PRIMARY KEY CLUSTERED ([id_wflstepgroupprofile] ASC),
    CONSTRAINT [FK_k_m_workflow_step_group_profile_k_m_workflow_step] FOREIGN KEY ([id_wflstepgroup]) REFERENCES [dbo].[k_m_workflow_step_group] ([id_wflstepgroup]),
    CONSTRAINT [FK_k_m_workflow_step_group_profile_k_profiles] FOREIGN KEY ([id_profile]) REFERENCES [dbo].[k_profiles] ([id_profile])
);


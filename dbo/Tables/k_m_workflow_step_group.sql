CREATE TABLE [dbo].[k_m_workflow_step_group] (
    [id_wflstepgroup]         INT IDENTITY (1, 1) NOT NULL,
    [id_wflstep]              INT NOT NULL,
    [level_step]              INT NULL,
    [is_min_level]            BIT CONSTRAINT [DF_k_m_workflow_step_group_is_min_level] DEFAULT ((0)) NOT NULL,
    [enable_validation]       BIT CONSTRAINT [DF_k_m_workflow_step_group_enable_validation] DEFAULT ((0)) NOT NULL,
    [enable_invalidation]     BIT CONSTRAINT [DF_k_m_workflow_step_group_enable_invalidation] DEFAULT ((0)) NOT NULL,
    [enable_massvalidation]   BIT CONSTRAINT [DF_k_m_workflow_step_group_enable_massvalidation] DEFAULT ((0)) NOT NULL,
    [enable_massinvalidation] BIT CONSTRAINT [DF_k_m_workflow_step_group_enable_massinvalidation] DEFAULT ((0)) NOT NULL,
    [id_source_tenant]        INT NULL,
    [id_source]               INT NULL,
    [id_change_set]           INT NULL,
    CONSTRAINT [PK_k_m_workflow_step_group] PRIMARY KEY CLUSTERED ([id_wflstepgroup] ASC),
    CONSTRAINT [FK_k_m_workflow_step_group_k_m_workflow_step] FOREIGN KEY ([id_wflstep]) REFERENCES [dbo].[k_m_workflow_step] ([id_wflstep])
);


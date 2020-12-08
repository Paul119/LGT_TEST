CREATE TABLE [dbo].[k_m_workflow_step_group_detail] (
    [id_wflstepgroupdetail] INT IDENTITY (1, 1) NOT NULL,
    [id_wflstepgroup]       INT NOT NULL,
    [id_field]              INT NOT NULL,
    [is_editable]           BIT CONSTRAINT [DF_k_m_workflow_step_group_detail_is_editable] DEFAULT ((0)) NOT NULL,
    [id_ind]                INT NULL,
    [is_readable]           BIT CONSTRAINT [DF_k_m_workflow_step_group_detail_is_readable] DEFAULT ((0)) NOT NULL,
    [id_source_tenant]      INT NULL,
    [id_source]             INT NULL,
    [id_change_set]         INT NULL,
    CONSTRAINT [PK_k_m_workflow_step_group_detail] PRIMARY KEY CLUSTERED ([id_wflstepgroupdetail] ASC),
    CONSTRAINT [FK_k_m_workflow_step_group_detail_k_m_fields] FOREIGN KEY ([id_field]) REFERENCES [dbo].[k_m_fields] ([id_field]),
    CONSTRAINT [FK_k_m_workflow_step_group_detail_k_m_workflow_step_group] FOREIGN KEY ([id_wflstepgroup]) REFERENCES [dbo].[k_m_workflow_step_group] ([id_wflstepgroup])
);


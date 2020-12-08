CREATE TABLE [dbo].[k_m_workflow_step] (
    [id_wflstep]       INT            IDENTITY (1, 1) NOT NULL,
    [id_workflow]      INT            NOT NULL,
    [name_step]        NVARCHAR (255) NOT NULL,
    [sort_step]        INT            CONSTRAINT [DF_k_m_workflow_step_sort_step] DEFAULT ((1)) NOT NULL,
    [id_source_tenant] INT            NULL,
    [id_source]        INT            NULL,
    [id_change_set]    INT            NULL,
    CONSTRAINT [PK_k_m_workflow_step] PRIMARY KEY CLUSTERED ([id_wflstep] ASC),
    CONSTRAINT [FK_k_m_workflow_step_k_m_workflow] FOREIGN KEY ([id_workflow]) REFERENCES [dbo].[k_m_workflow] ([id_workflow])
);


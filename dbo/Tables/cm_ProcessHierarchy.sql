CREATE TABLE [dbo].[cm_ProcessHierarchy] (
    [id]               INT           IDENTITY (1, 1) NOT NULL,
    [idProcess]        INT           NULL,
    [idTree]           INT           NULL,
    [nameTree]         NVARCHAR (50) NULL,
    [id_source_tenant] INT           NULL,
    [id_source]        INT           NULL,
    [id_change_set]    INT           NULL,
    CONSTRAINT [PK_cm_ProcessHierarchy] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_cm_ProcessHierarchy_hm_NodelinkPublished] FOREIGN KEY ([idTree]) REFERENCES [dbo].[hm_NodeTreePublished] ([id]) ON DELETE CASCADE,
    CONSTRAINT [FK_cm_ProcessHierarchy_k_m_plans] FOREIGN KEY ([idProcess]) REFERENCES [dbo].[k_m_plans] ([id_plan]) ON DELETE CASCADE
);


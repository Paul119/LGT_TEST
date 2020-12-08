CREATE TABLE [dbo].[k_tree_security_plan_level_exception] (
    [id_tree_security_plan_level_exception] INT IDENTITY (1, 1) NOT NULL,
    [id_tree_security_plan_level]           INT NOT NULL,
    [id_tree_node_published]                INT NULL,
    [is_override_workflow_permission]       BIT NOT NULL,
    [is_read]                               BIT NOT NULL,
    [is_edit]                               BIT NOT NULL,
    [is_validate]                           BIT NOT NULL,
    [is_invalidate]                         BIT NOT NULL,
    [is_mass_validate]                      BIT NOT NULL,
    [is_mass_invalidate]                    BIT NOT NULL,
    CONSTRAINT [PK_k_tree_security_plan_level_exception] PRIMARY KEY CLUSTERED ([id_tree_security_plan_level_exception] ASC),
    CONSTRAINT [FK_k_tree_security_plan_level_exception_hm_NodelinkPublished] FOREIGN KEY ([id_tree_node_published]) REFERENCES [dbo].[hm_NodelinkPublished] ([id]),
    CONSTRAINT [FK_k_tree_security_plan_level_exception_k_tree_security_plan_level] FOREIGN KEY ([id_tree_security_plan_level]) REFERENCES [dbo].[k_tree_security_plan_level] ([id_tree_security_plan_level])
);


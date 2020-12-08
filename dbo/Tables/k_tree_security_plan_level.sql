CREATE TABLE [dbo].[k_tree_security_plan_level] (
    [id_tree_security_plan_level]     INT            IDENTITY (1, 1) NOT NULL,
    [id_tree_security]                INT            NOT NULL,
    [is_override_workflow_permission] BIT            NOT NULL,
    [is_read]                         BIT            NOT NULL,
    [is_edit]                         BIT            NOT NULL,
    [is_validate]                     BIT            NOT NULL,
    [is_invalidate]                   BIT            NOT NULL,
    [is_mass_validate]                BIT            NOT NULL,
    [is_mass_invalidate]              BIT            NOT NULL,
    [begin_date]                      DATETIME       NOT NULL,
    [end_date]                        DATETIME       NULL,
    [id_owner]                        INT            NOT NULL,
    [create_date]                     DATETIME       NOT NULL,
    [modified_date]                   DATETIME       NULL,
    [modified_id_user]                INT            NULL,
    [comment_security_plan_level]     NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_k_tree_security_plan_level] PRIMARY KEY CLUSTERED ([id_tree_security_plan_level] ASC),
    CONSTRAINT [FK_k_tree_security_plan_level_k_tree_security] FOREIGN KEY ([id_tree_security]) REFERENCES [dbo].[k_tree_security] ([id_tree_security]),
    CONSTRAINT [FK_k_tree_security_plan_level_k_users] FOREIGN KEY ([id_owner]) REFERENCES [dbo].[k_users] ([id_user])
);


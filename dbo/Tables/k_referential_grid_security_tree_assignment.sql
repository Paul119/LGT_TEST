CREATE TABLE [dbo].[k_referential_grid_security_tree_assignment] (
    [id]                    INT IDENTITY (1, 1) NOT NULL,
    [id_grid_security_tree] INT NULL,
    [id_tree_security]      INT NULL,
    [id_user_profile]       INT NULL,
    CONSTRAINT [PK_k_referential_grid_security_tree_assignment] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_referential_grid_security_tree_assignment_k_referential_grid_security_tree] FOREIGN KEY ([id_grid_security_tree]) REFERENCES [dbo].[k_referential_grid_security_tree] ([id_grid_security_tree]),
    CONSTRAINT [FK_k_referential_grid_security_tree_assignment_k_tree_security] FOREIGN KEY ([id_tree_security]) REFERENCES [dbo].[k_tree_security] ([id_tree_security]),
    CONSTRAINT [FK_k_referential_grid_security_tree_assignment_k_users_profiles] FOREIGN KEY ([id_user_profile]) REFERENCES [dbo].[k_users_profiles] ([idUserProfile])
);


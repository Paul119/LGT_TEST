CREATE TABLE [dbo].[k_referential_grid_security_tree] (
    [id_grid_security_tree]   INT            IDENTITY (1, 1) NOT NULL,
    [id_grid]                 INT            NOT NULL,
    [include_selected_node]   BIT            NULL,
    [override_permissions]    BIT            NOT NULL,
    [is_read]                 BIT            NULL,
    [is_edit]                 BIT            NULL,
    [is_create]               BIT            NULL,
    [is_delete]               BIT            NULL,
    [is_execute_sp]           BIT            NULL,
    [name_grid_security_tree] NVARCHAR (100) NOT NULL,
    [is_export]               BIT            NULL,
    [is_import]               BIT            NULL,
    [apply_security_filter]   BIT            NULL,
    [view_type]               INT            NOT NULL,
    [begin_date]              DATETIME       NULL,
    [end_date]                DATETIME       NULL,
    CONSTRAINT [PK_k_referential_grid_security_tree] PRIMARY KEY CLUSTERED ([id_grid_security_tree] ASC),
    CONSTRAINT [FK_k_referential_grid_security_tree_k_referential_grids] FOREIGN KEY ([id_grid]) REFERENCES [dbo].[k_referential_grids] ([id_grid])
);


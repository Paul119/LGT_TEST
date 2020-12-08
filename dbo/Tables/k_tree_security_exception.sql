CREATE TABLE [dbo].[k_tree_security_exception] (
    [id_tree_security_exception] INT IDENTITY (1, 1) NOT NULL,
    [id_tree_security]           INT NOT NULL,
    [id_tree_node_published]     INT NULL,
    [id_parent_tree_security]    INT NULL,
    CONSTRAINT [PK_k_tree_security_exception] PRIMARY KEY CLUSTERED ([id_tree_security_exception] ASC),
    CONSTRAINT [FK_k_tree_security_exception_hm_NodelinkPublished] FOREIGN KEY ([id_tree_node_published]) REFERENCES [dbo].[hm_NodelinkPublished] ([id]),
    CONSTRAINT [FK_k_tree_security_exception_k_tree_security] FOREIGN KEY ([id_tree_security]) REFERENCES [dbo].[k_tree_security] ([id_tree_security])
);


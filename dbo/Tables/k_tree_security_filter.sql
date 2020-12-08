CREATE TABLE [dbo].[k_tree_security_filter] (
    [id_tree_security_filter] INT IDENTITY (1, 1) NOT NULL,
    [id_tree_security]        INT NOT NULL,
    [id_pop]                  INT NOT NULL,
    [id_parent_tree_security] INT NULL,
    CONSTRAINT [PK_k_tree_security_filter] PRIMARY KEY CLUSTERED ([id_tree_security_filter] ASC),
    CONSTRAINT [FK_k_tree_security_filter_k_tree_security] FOREIGN KEY ([id_tree_security]) REFERENCES [dbo].[k_tree_security] ([id_tree_security]),
    CONSTRAINT [FK_k_tree_security_filter_pop_Population] FOREIGN KEY ([id_pop]) REFERENCES [dbo].[pop_Population] ([idPop])
);


GO
CREATE NONCLUSTERED INDEX [ix_k_tree_security_filter_id_tree_security]
    ON [dbo].[k_tree_security_filter]([id_tree_security] ASC);


CREATE TABLE [dbo].[k_tqm_structure] (
    [id_structure] INT IDENTITY (1, 1) NOT NULL,
    [id_template]  INT NULL,
    [id_tree]      INT NULL,
    CONSTRAINT [PK_k_tqm_structure] PRIMARY KEY CLUSTERED ([id_structure] ASC),
    CONSTRAINT [FK_k_tqm_structure_hm_NodeTree] FOREIGN KEY ([id_tree]) REFERENCES [dbo].[hm_NodeTree] ([id]),
    CONSTRAINT [FK_k_tqm_structure_k_tqm_template] FOREIGN KEY ([id_template]) REFERENCES [dbo].[k_tqm_template] ([id_template])
);


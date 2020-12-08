CREATE TABLE [dbo].[k_tree_security_type] (
    [id_tree_security_type]   INT            IDENTITY (1, 1) NOT NULL,
    [name_tree_security_type] NVARCHAR (200) NULL,
    CONSTRAINT [PK_k_tree_security_type] PRIMARY KEY CLUSTERED ([id_tree_security_type] ASC)
);


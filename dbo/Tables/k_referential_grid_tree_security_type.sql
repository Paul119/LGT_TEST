CREATE TABLE [dbo].[k_referential_grid_tree_security_type] (
    [id_grid_security_type]   INT           IDENTITY (1, 1) NOT NULL,
    [name_grid_security_type] NVARCHAR (50) NOT NULL,
    [order]                   INT           NOT NULL,
    CONSTRAINT [PK_k_referential_grid_tree_security_type] PRIMARY KEY CLUSTERED ([id_grid_security_type] ASC)
);


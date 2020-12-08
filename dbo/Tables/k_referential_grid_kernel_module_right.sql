CREATE TABLE [dbo].[k_referential_grid_kernel_module_right] (
    [id_grid_kernel_module_right] INT IDENTITY (1, 1) NOT NULL,
    [id_grid]                     INT NOT NULL,
    [id_module]                   INT NOT NULL,
    [id_right]                    INT NOT NULL,
    CONSTRAINT [PK_k_referential_grid_kernel_module_right] PRIMARY KEY CLUSTERED ([id_grid_kernel_module_right] ASC),
    CONSTRAINT [FK_k_referential_grid_kernel_module_right_k_modules] FOREIGN KEY ([id_module]) REFERENCES [dbo].[k_modules] ([id_module]),
    CONSTRAINT [FK_k_referential_grid_kernel_module_right_k_referential_grids] FOREIGN KEY ([id_grid]) REFERENCES [dbo].[k_referential_grids] ([id_grid]),
    CONSTRAINT [FK_k_referential_grid_kernel_module_right_k_rights] FOREIGN KEY ([id_right]) REFERENCES [dbo].[k_rights] ([id_right])
);


CREATE TABLE [dbo].[k_program_cond_grids] (
    [id]     INT IDENTITY (1, 1) NOT NULL,
    [idCond] INT NOT NULL,
    [idGrid] INT NOT NULL,
    CONSTRAINT [PK_k_program_cond_grids] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_program_cond_grids_k_program_cond] FOREIGN KEY ([idCond]) REFERENCES [dbo].[k_program_cond] ([id_cond]) ON DELETE CASCADE,
    CONSTRAINT [FK_k_program_cond_grids_k_referential_grids] FOREIGN KEY ([idGrid]) REFERENCES [dbo].[k_referential_grids] ([id_grid])
);


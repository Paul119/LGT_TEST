CREATE TABLE [dbo].[k_user_grid] (
    [id_user_grid] INT IDENTITY (1, 1) NOT NULL,
    [id_user]      INT NOT NULL,
    [id_grid]      INT NOT NULL,
    [page_size]    INT NULL,
    [row_density]  INT NULL,
    CONSTRAINT [PK_k_user_grid] PRIMARY KEY CLUSTERED ([id_user_grid] ASC),
    CONSTRAINT [FK_idGrid] FOREIGN KEY ([id_grid]) REFERENCES [dbo].[k_referential_grids] ([id_grid]),
    CONSTRAINT [FK_idUser] FOREIGN KEY ([id_user]) REFERENCES [dbo].[k_users] ([id_user])
);


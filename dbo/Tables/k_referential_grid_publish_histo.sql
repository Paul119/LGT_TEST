CREATE TABLE [dbo].[k_referential_grid_publish_histo] (
    [id_grid_publish_histo] INT      IDENTITY (1, 1) NOT NULL,
    [id_user]               INT      NOT NULL,
    [publish_date]          DATETIME NULL,
    [number_of_validated]   INT      NULL,
    [number_of_published]   INT      NULL,
    [number_of_rejected]    INT      NULL,
    [id_grid]               INT      NOT NULL,
    CONSTRAINT [PK_ k_referential_grid_publish_histo] PRIMARY KEY CLUSTERED ([id_grid_publish_histo] ASC),
    CONSTRAINT [FK_ k_referential_grid_publish_histo_k_users] FOREIGN KEY ([id_user]) REFERENCES [dbo].[k_users] ([id_user]),
    CONSTRAINT [FK_k_referential_grid_publish_histo_k_referential_grids] FOREIGN KEY ([id_grid]) REFERENCES [dbo].[k_referential_grids] ([id_grid])
);


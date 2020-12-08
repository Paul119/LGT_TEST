CREATE TABLE [dbo].[k_user_grid_view] (
    [id_user_grid_view] INT            IDENTITY (1, 1) NOT NULL,
    [name_view]         NVARCHAR (MAX) NOT NULL,
    [id_grid]           INT            NOT NULL,
    [id_user]           INT            NOT NULL,
    [is_selected]       BIT            CONSTRAINT [DF_k_user_grid_view_is_selected] DEFAULT ((0)) NOT NULL,
    [page_size]         INT            NULL,
    [row_density]       INT            NULL,
    CONSTRAINT [PK_k_user_grid_view] PRIMARY KEY CLUSTERED ([id_user_grid_view] ASC),
    CONSTRAINT [FK_k_user_grid_view_k_referential_grids] FOREIGN KEY ([id_grid]) REFERENCES [dbo].[k_referential_grids] ([id_grid]),
    CONSTRAINT [FK_k_user_grid_view_k_users] FOREIGN KEY ([id_user]) REFERENCES [dbo].[k_users] ([id_user])
);


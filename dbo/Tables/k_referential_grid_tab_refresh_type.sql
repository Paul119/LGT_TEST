CREATE TABLE [dbo].[k_referential_grid_tab_refresh_type] (
    [id_grid_tab_refresh_type] INT            IDENTITY (1, 1) NOT NULL,
    [name]                     NVARCHAR (255) NOT NULL,
    [display_order]            INT            NOT NULL,
    CONSTRAINT [PK_k_referential_grid_tab_refresh_type] PRIMARY KEY CLUSTERED ([id_grid_tab_refresh_type] ASC)
);


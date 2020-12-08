CREATE TABLE [dbo].[k_referential_grid_tab] (
    [id_grid_tab]    INT            IDENTITY (1, 1) NOT NULL,
    [id_parent_grid] INT            NOT NULL,
    [id_form]        INT            NULL,
    [id_grid]        INT            NULL,
    [grid_tab_name]  NVARCHAR (255) NOT NULL,
    [refresh_type]   INT            NOT NULL,
    [display_order]  INT            NOT NULL,
    CONSTRAINT [PK_k_referential_grid_tab] PRIMARY KEY CLUSTERED ([id_grid_tab] ASC),
    CONSTRAINT [FK_k_referential_grid_tab_k_referential_form] FOREIGN KEY ([id_form]) REFERENCES [dbo].[k_referential_form] ([form_id]),
    CONSTRAINT [FK_k_referential_grid_tab_k_referential_grid_tab_refresh_type] FOREIGN KEY ([refresh_type]) REFERENCES [dbo].[k_referential_grid_tab_refresh_type] ([id_grid_tab_refresh_type]),
    CONSTRAINT [FK_k_referential_grid_tab_k_referential_grids] FOREIGN KEY ([id_parent_grid]) REFERENCES [dbo].[k_referential_grids] ([id_grid]),
    CONSTRAINT [FK_k_referential_grid_tab_k_referential_grids_1] FOREIGN KEY ([id_grid]) REFERENCES [dbo].[k_referential_grids] ([id_grid])
);


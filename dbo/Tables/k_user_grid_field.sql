CREATE TABLE [dbo].[k_user_grid_field] (
    [id_user_grid_field] INT            IDENTITY (1, 1) NOT NULL,
    [id_user]            INT            NOT NULL,
    [id_grid_field]      INT            NOT NULL,
    [order_grid_field]   INT            NULL,
    [sort_grid_field]    INT            NULL,
    [sort_direction]     INT            NULL,
    [filter_type]        INT            NULL,
    [filter_value]       NVARCHAR (MAX) NULL,
    [is_visible]         BIT            CONSTRAINT [DF_k_user_grid_field_is_visible] DEFAULT ((1)) NOT NULL,
    [width]              INT            NULL,
    [is_grouped]         BIT            NULL,
    [is_frozen]          BIT            NULL,
    CONSTRAINT [PK_k_user_grid_field] PRIMARY KEY CLUSTERED ([id_user_grid_field] ASC),
    CONSTRAINT [FK_k_user_grid_field_k_column_filter_type] FOREIGN KEY ([filter_type]) REFERENCES [dbo].[k_column_filter_type] ([id_column_filter_type]),
    CONSTRAINT [FK_k_user_grid_field_k_referential_grids_fields] FOREIGN KEY ([id_grid_field]) REFERENCES [dbo].[k_referential_grids_fields] ([id_column]),
    CONSTRAINT [FK_k_user_grid_field_k_users] FOREIGN KEY ([id_user]) REFERENCES [dbo].[k_users] ([id_user]),
    CONSTRAINT [UC_k_user_grid_field_id_user_id_grid_field] UNIQUE NONCLUSTERED ([id_user] ASC, [id_grid_field] ASC)
);


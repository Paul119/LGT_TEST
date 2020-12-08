CREATE TABLE [dbo].[k_user_grid_field_view] (
    [id_user_grid_field_view] INT            IDENTITY (1, 1) NOT NULL,
    [id_user_grid_view]       INT            NOT NULL,
    [id_grid_field]           INT            NOT NULL,
    [order_grid_field]        INT            NULL,
    [sort_grid_field]         INT            NULL,
    [sort_direction]          INT            NULL,
    [filter_type]             INT            NULL,
    [filter_value]            NVARCHAR (MAX) NULL,
    [is_visible]              BIT            CONSTRAINT [DF_k_user_grid_field_view_is_visible] DEFAULT ((1)) NOT NULL,
    [width]                   INT            NULL,
    [is_grouped]              BIT            NULL,
    [is_frozen]               BIT            NULL,
    CONSTRAINT [PK_k_user_grid_field_view] PRIMARY KEY CLUSTERED ([id_user_grid_field_view] ASC),
    CONSTRAINT [FK_k_user_grid_field_view_k_column_filter_type] FOREIGN KEY ([filter_type]) REFERENCES [dbo].[k_column_filter_type] ([id_column_filter_type]),
    CONSTRAINT [FK_k_user_grid_field_view_k_referential_grids_fields] FOREIGN KEY ([id_grid_field]) REFERENCES [dbo].[k_referential_grids_fields] ([id_column]),
    CONSTRAINT [FK_k_user_grid_field_view_k_user_grid_view] FOREIGN KEY ([id_user_grid_view]) REFERENCES [dbo].[k_user_grid_view] ([id_user_grid_view])
);


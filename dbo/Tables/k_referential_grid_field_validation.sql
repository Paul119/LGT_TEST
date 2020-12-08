CREATE TABLE [dbo].[k_referential_grid_field_validation] (
    [id_grid_field_validation]          INT            IDENTITY (1, 1) NOT NULL,
    [id_grid]                           INT            NOT NULL,
    [id_field]                          INT            NOT NULL,
    [formula]                           NVARCHAR (MAX) NOT NULL,
    [action_false_allow_saving]         BIT            CONSTRAINT [DF_k_referential_grids_fields_validation_action_false_allow_saving] DEFAULT ((0)) NOT NULL,
    [action_false_show_error]           BIT            CONSTRAINT [DF_k_referential_grids_fields_validation_action_false_show_error] DEFAULT ((1)) NOT NULL,
    [action_false_error_message]        NVARCHAR (MAX) NULL,
    [action_false_use_field_style]      BIT            CONSTRAINT [DF_k_referential_grids_fields_validation_action_false_use_field_style] DEFAULT ((0)) NOT NULL,
    [action_false_text_color]           NVARCHAR (50)  NOT NULL,
    [action_false_border_color]         NVARCHAR (50)  NOT NULL,
    [action_false_background_color]     NVARCHAR (50)  NOT NULL,
    [action_true_use_field_style]       BIT            CONSTRAINT [DF_k_referential_grids_fields_validation_action_true_use_field_style] DEFAULT ((0)) NOT NULL,
    [action_true_text_color]            NVARCHAR (50)  NOT NULL,
    [action_true_border_color]          NVARCHAR (50)  NOT NULL,
    [action_true_background_color]      NVARCHAR (50)  NOT NULL,
    [action_false_show_error_on_change] BIT            NOT NULL,
    CONSTRAINT [PK_k_referential_grid_field_validation] PRIMARY KEY CLUSTERED ([id_grid_field_validation] ASC),
    CONSTRAINT [FK_k_referential_grid_field_validation_k_referential_grids] FOREIGN KEY ([id_grid]) REFERENCES [dbo].[k_referential_grids] ([id_grid]),
    CONSTRAINT [FK_k_referential_grid_field_validation_k_referential_tables_views_fields] FOREIGN KEY ([id_field]) REFERENCES [dbo].[k_referential_tables_views_fields] ([id_field])
);


CREATE TABLE [dbo].[k_referential_grid_field_combotype] (
    [id_grid_field_combotype] INT            IDENTITY (1, 1) NOT NULL,
    [name]                    NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_k_referential_grid_field_combotype] PRIMARY KEY CLUSTERED ([id_grid_field_combotype] ASC)
);


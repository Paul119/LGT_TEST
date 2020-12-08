CREATE TABLE [dbo].[k_referential_grid_folders] (
    [id_folder]          INT            IDENTITY (1, 1) NOT NULL,
    [id_parent_folder]   INT            NULL,
    [name_folder]        NVARCHAR (255) NOT NULL,
    [is_public]          BIT            NULL,
    [visibility]         INT            NULL,
    [id_owner]           INT            NULL,
    [date_create_folder] DATETIME       NULL,
    [id_user_update]     INT            NULL,
    [date_update_folder] DATETIME       NULL,
    [sort_folder]        INT            NULL,
    [id_source_tenant]   INT            NULL,
    [id_source]          INT            NULL,
    [id_change_set]      INT            NULL,
    CONSTRAINT [PK_k_referential_grid_folders] PRIMARY KEY CLUSTERED ([id_folder] ASC),
    CONSTRAINT [FK_k_referential_grid_folders] FOREIGN KEY ([id_parent_folder]) REFERENCES [dbo].[k_referential_grid_folders] ([id_folder])
);


GO
CREATE NONCLUSTERED INDEX [IX__k_referential_grid_folders__id_parent_folder]
    ON [dbo].[k_referential_grid_folders]([id_parent_folder] ASC);


CREATE TABLE [dbo].[nc_Folder] (
    [id_folder]        INT            IDENTITY (1, 1) NOT NULL,
    [id_parent_folder] INT            NULL,
    [name_folder]      NVARCHAR (100) NULL,
    [sort_folder]      INT            NULL,
    [type_folder]      INT            NULL,
    [id_owner]         INT            NOT NULL,
    CONSTRAINT [PK_nc_Folder] PRIMARY KEY CLUSTERED ([id_folder] ASC),
    CONSTRAINT [FK_nc_Folder_cgTreeItemType] FOREIGN KEY ([type_folder]) REFERENCES [dbo].[cgTreeItemType] ([id_itemtype])
);


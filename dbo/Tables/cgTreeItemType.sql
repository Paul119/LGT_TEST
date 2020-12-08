CREATE TABLE [dbo].[cgTreeItemType] (
    [id_itemtype]   INT             IDENTITY (1, 1) NOT NULL,
    [name_itemtype] NVARCHAR (4000) NOT NULL,
    [is_container]  BIT             NOT NULL,
    CONSTRAINT [PK_cgTreeItemType] PRIMARY KEY CLUSTERED ([id_itemtype] ASC)
);


CREATE TABLE [dbo].[cgContextMenuDetail] (
    [id_menudetail]         INT           IDENTITY (1, 1) NOT NULL,
    [id_menuoption]         INT           NOT NULL,
    [id_module]             INT           NOT NULL,
    [allowed]               BIT           NULL,
    [id_itemtreetype]       INT           NOT NULL,
    [display_name]          NVARCHAR (20) NULL,
    [id_insertitemtreetype] INT           NOT NULL,
    [auto_create]           BIT           CONSTRAINT [DF_cgContextMenuDetail_auto_create] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_cgContectMenuDetail] PRIMARY KEY CLUSTERED ([id_menudetail] ASC),
    CONSTRAINT [FK_cgContextMenuDetail_cgContextMenuOption] FOREIGN KEY ([id_menuoption]) REFERENCES [dbo].[cgContextMenuOption] ([id_menuoption]),
    CONSTRAINT [FK_cgContextMenuDetail_cgModules] FOREIGN KEY ([id_module]) REFERENCES [dbo].[cgModules] ([id_modules]),
    CONSTRAINT [FK_cgContextMenuDetail_cgTreeItemType] FOREIGN KEY ([id_itemtreetype]) REFERENCES [dbo].[cgTreeItemType] ([id_itemtype]),
    CONSTRAINT [FK_cgContextMenuDetail_cgTreeItemType1] FOREIGN KEY ([id_insertitemtreetype]) REFERENCES [dbo].[cgTreeItemType] ([id_itemtype])
);


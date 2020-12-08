CREATE TABLE [dbo].[hpShortcut] (
    [idShortcut]        INT            IDENTITY (1, 1) NOT NULL,
    [idShortcutFolder]  INT            NULL,
    [text]              NVARCHAR (500) NULL,
    [itemId]            INT            NOT NULL,
    [itemType]          INT            NOT NULL,
    [HierarchyId]       INT            NULL,
    [AccordionModuleId] INT            NULL,
    [moduleUrl]         NVARCHAR (500) NULL,
    [OrderId]           INT            NOT NULL,
    [processId]         INT            NULL,
    [idOwner]           INT            NULL,
    CONSTRAINT [PK_hpShortcut] PRIMARY KEY CLUSTERED ([idShortcut] ASC),
    CONSTRAINT [FK_hpShortcut_hpShortcutFolder] FOREIGN KEY ([idShortcutFolder]) REFERENCES [dbo].[hpShortcutFolder] ([idShortcutFolder])
);


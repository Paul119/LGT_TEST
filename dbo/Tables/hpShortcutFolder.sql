CREATE TABLE [dbo].[hpShortcutFolder] (
    [idShortcutFolder] INT           IDENTITY (1, 1) NOT NULL,
    [nameFolder]       NVARCHAR (50) NULL,
    [idParentFolder]   INT           NULL,
    [idOwner]          INT           NULL,
    [dateCreated]      DATETIME      NULL,
    [idOrder]          INT           NULL,
    [idFolderType]     INT           NULL,
    [isDeletable]      BIT           NULL,
    [allowedProfile]   INT           NULL,
    CONSTRAINT [PK_hpShortcutFolder] PRIMARY KEY CLUSTERED ([idShortcutFolder] ASC),
    CONSTRAINT [FK_hpShortcutFolder_hpShortcutFolder] FOREIGN KEY ([idParentFolder]) REFERENCES [dbo].[hpShortcutFolder] ([idShortcutFolder])
);


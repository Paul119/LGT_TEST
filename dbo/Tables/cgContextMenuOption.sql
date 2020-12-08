CREATE TABLE [dbo].[cgContextMenuOption] (
    [id_menuoption]   INT           IDENTITY (1, 1) NOT NULL,
    [name_menuoption] NVARCHAR (20) NULL,
    [id_right]        INT           NOT NULL,
    CONSTRAINT [PK_cgContextMenuOption] PRIMARY KEY CLUSTERED ([id_menuoption] ASC),
    CONSTRAINT [FK_cgContextMenuOption_k_rights] FOREIGN KEY ([id_right]) REFERENCES [dbo].[k_rights] ([id_right])
);


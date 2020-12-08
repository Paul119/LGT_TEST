CREATE TABLE [dbo].[hm_Nodelink] (
    [id]                INT      IDENTITY (1, 1) NOT NULL,
    [idTree]            INT      NULL,
    [idChild]           INT      NULL,
    [idType]            INT      NULL,
    [idParent]          INT      NULL,
    [idTypeParent]      INT      NULL,
    [idRealParent]      INT      NULL,
    [date_begin]        DATETIME NULL,
    [date_end]          DATETIME NULL,
    [id_owner]          INT      NULL,
    [date_creation]     DATETIME NULL,
    [date_modification] DATETIME NULL,
    [idUniqueParent]    INT      NULL,
    CONSTRAINT [PK_hm_Nodelink] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_hm_Nodelink_hm_NodeTree] FOREIGN KEY ([idTree]) REFERENCES [dbo].[hm_NodeTree] ([id]) ON DELETE CASCADE
);


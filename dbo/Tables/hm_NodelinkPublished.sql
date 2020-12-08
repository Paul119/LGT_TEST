CREATE TABLE [dbo].[hm_NodelinkPublished] (
    [id]                    INT      IDENTITY (1, 1) NOT NULL,
    [idTree]                INT      NOT NULL,
    [idChild]               INT      NOT NULL,
    [idType]                INT      NOT NULL,
    [idParent]              INT      NULL,
    [idTypeParent]          INT      NULL,
    [idRealParent]          INT      NULL,
    [date_begin]            DATETIME NULL,
    [date_end]              DATETIME NULL,
    [id_owner]              INT      NULL,
    [date_creation]         DATETIME NULL,
    [date_modification]     DATETIME NULL,
    [transferRequestStatus] INT      CONSTRAINT [DF_hm_NodelinkPublished_transferRequestStatus] DEFAULT ((0)) NOT NULL,
    [idUniqueParent]        INT      NULL,
    [sort_order]            INT      CONSTRAINT [DF_hm_NodelinkPublished_sort_order] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_hm_NodelinkPublished] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_hm_NodelinkPublished_hm_NodeTreePublished] FOREIGN KEY ([idTree]) REFERENCES [dbo].[hm_NodeTreePublished] ([id]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_hm_NodelinkPublished_idTree_idType_idRealParent]
    ON [dbo].[hm_NodelinkPublished]([idTree] ASC, [idType] ASC, [idRealParent] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_hm_NodelinkPublished_idChild_idTree_idType]
    ON [dbo].[hm_NodelinkPublished]([idTree] ASC, [idType] ASC, [idChild] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_hm_NodelinkPublished_idTree_idType_idParent]
    ON [dbo].[hm_NodelinkPublished]([idTree] ASC, [idType] ASC, [idParent] ASC);


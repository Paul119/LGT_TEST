CREATE TABLE [dbo].[hm_NodeLinkPublishedHierarchy] (
    [id_NodelinkPublished] INT                 NOT NULL,
    [idTree]               INT                 NOT NULL,
    [idChild]              INT                 NOT NULL,
    [idType]               INT                 NOT NULL,
    [hid]                  [sys].[hierarchyid] NOT NULL,
    [hid_payee]            [sys].[hierarchyid] NULL,
    [hidParent]            AS                  ([hid].[GetAncestor]((1))),
    [hidLevel]             AS                  ([hid].[GetLevel]()),
    CONSTRAINT [PK_hm_NodeLinkPublishedHierarchy] PRIMARY KEY CLUSTERED ([idTree] ASC, [hid] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IXnc_hm_NodeLinkPublishedHierarchy_LevelParent]
    ON [dbo].[hm_NodeLinkPublishedHierarchy]([hidParent] ASC, [hidLevel] ASC);


GO
CREATE NONCLUSTERED INDEX [IXnc_hm_NodeLinkPublishedHierarchy_idNodeLinkPublished]
    ON [dbo].[hm_NodeLinkPublishedHierarchy]([id_NodelinkPublished] ASC);


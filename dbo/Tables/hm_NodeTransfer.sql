CREATE TABLE [dbo].[hm_NodeTransfer] (
    [id]             INT      IDENTITY (1, 1) NOT NULL,
    [idParent]       INT      NULL,
    [idOldParent]    INT      NULL,
    [idEmployee]     INT      NULL,
    [id_hm_nodelink] INT      NULL,
    [idStatus]       INT      NULL,
    [createDate]     DATETIME NULL,
    [idOwner]        INT      NULL,
    CONSTRAINT [PK_hm_nodelink_transfer] PRIMARY KEY CLUSTERED ([id] ASC)
);


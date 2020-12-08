CREATE TABLE [dbo].[hm_NodeTreePublished] (
    [id]                  INT            IDENTITY (1, 1) NOT NULL,
    [name]                NVARCHAR (100) NULL,
    [idOwner]             INT            NULL,
    [createDate]          DATETIME       NULL,
    [id_hm_NodeTree]      INT            NULL,
    [allowRepeatingItems] BIT            NULL,
    [id_source_tenant]    INT            NULL,
    [id_source]           INT            NULL,
    [id_change_set]       INT            NULL,
    CONSTRAINT [PK_hm_NodeTreePublished] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_hm_NodeTreePublished_hm_NodeTree] FOREIGN KEY ([id_hm_NodeTree]) REFERENCES [dbo].[hm_NodeTree] ([id]) ON DELETE CASCADE
);


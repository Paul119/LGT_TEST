CREATE TABLE [dbo].[hm_NodeType] (
    [id]         INT            IDENTITY (1, 1) NOT NULL,
    [name]       NVARCHAR (100) NULL,
    [idOwner]    INT            NULL,
    [createDate] DATETIME       NULL,
    CONSTRAINT [PK_hm_NodeType] PRIMARY KEY CLUSTERED ([id] ASC)
);


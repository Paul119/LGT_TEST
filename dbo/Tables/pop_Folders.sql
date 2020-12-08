CREATE TABLE [dbo].[pop_Folders] (
    [idFolder]         INT           IDENTITY (1, 1) NOT NULL,
    [idParentFolder]   INT           NULL,
    [nameFolder]       NVARCHAR (50) NULL,
    [idOwner]          INT           NULL,
    [createDate]       DATETIME      NULL,
    [idUpdateUser]     INT           NULL,
    [updateDate]       DATETIME      NULL,
    [id_source_tenant] INT           NULL,
    [id_source]        INT           NULL,
    [id_change_set]    INT           NULL,
    CONSTRAINT [PK_pop_PopulationFolder] PRIMARY KEY CLUSTERED ([idFolder] ASC),
    CONSTRAINT [FK_pop_PopulationFolder_pop_PopulationFolder] FOREIGN KEY ([idParentFolder]) REFERENCES [dbo].[pop_Folders] ([idFolder])
);


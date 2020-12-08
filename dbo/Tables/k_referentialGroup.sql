CREATE TABLE [dbo].[k_referentialGroup] (
    [id]           INT            IDENTITY (1, 1) NOT NULL,
    [name]         NVARCHAR (100) NOT NULL,
    [description]  NVARCHAR (MAX) NULL,
    [masterGridId] INT            NULL,
    [moduleId]     INT            NULL,
    [itemId]       INT            NULL,
    [createDate]   DATETIME       NULL,
    CONSTRAINT [PK_k_referentialGroup] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_referentialGroup_k_modules] FOREIGN KEY ([moduleId]) REFERENCES [dbo].[k_modules] ([id_module]),
    CONSTRAINT [FK_k_referentialGroup_k_referential_grids] FOREIGN KEY ([masterGridId]) REFERENCES [dbo].[k_referential_grids] ([id_grid])
);


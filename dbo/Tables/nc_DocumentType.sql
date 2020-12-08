CREATE TABLE [dbo].[nc_DocumentType] (
    [id]        INT           IDENTITY (1, 1) NOT NULL,
    [name]      NVARCHAR (50) NULL,
    [extension] NVARCHAR (50) NULL,
    CONSTRAINT [PK_nc_DocumentType] PRIMARY KEY CLUSTERED ([id] ASC)
);


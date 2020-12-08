CREATE TABLE [dbo].[k_object_relation_type] (
    [id]   INT           IDENTITY (1, 1) NOT NULL,
    [name] NVARCHAR (50) NULL,
    CONSTRAINT [PK_k_object_relation_type] PRIMARY KEY CLUSTERED ([id] ASC)
);


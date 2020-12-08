CREATE TABLE [dbo].[ads_gridRelationValue] (
    [id]             INT IDENTITY (1, 1) NOT NULL,
    [idGridRelation] INT NOT NULL,
    [baseItem]       INT NOT NULL,
    [relatedItem]    INT NOT NULL,
    CONSTRAINT [PK__ads_grid__3213E83F1940ECB7] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_ads_gridRelationValue_ads_gridRelation] FOREIGN KEY ([idGridRelation]) REFERENCES [dbo].[ads_gridRelation] ([id])
);


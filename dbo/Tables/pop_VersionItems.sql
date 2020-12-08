CREATE TABLE [dbo].[pop_VersionItems] (
    [idPopVersionItem] INT IDENTITY (1, 1) NOT NULL,
    [idPopVersion]     INT NULL,
    [idPop]            INT NULL,
    [idItem]           INT NULL,
    [itemType]         INT NULL,
    [activeVersion]    INT NULL,
    [applyToMajor]     BIT NULL,
    [applyToMinor]     BIT NULL,
    CONSTRAINT [PK_pop_VersionItems] PRIMARY KEY CLUSTERED ([idPopVersionItem] ASC),
    CONSTRAINT [FK_pop_VersionItems_pop_Population] FOREIGN KEY ([idPop]) REFERENCES [dbo].[pop_Population] ([idPop]),
    CONSTRAINT [FK_pop_VersionItems_pop_PopulationVersion] FOREIGN KEY ([idPopVersion]) REFERENCES [dbo].[pop_PopulationVersion] ([id])
);


CREATE TABLE [dbo].[pop_VersionContent] (
    [id]           INT IDENTITY (1, 1) NOT NULL,
    [idPopVersion] INT NULL,
    [idColl]       INT NULL,
    CONSTRAINT [PK_pop_VersionContent_1] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_pop_VersionContent_pop_PopulationVersion] FOREIGN KEY ([idPopVersion]) REFERENCES [dbo].[pop_PopulationVersion] ([id])
);


GO
CREATE NONCLUSTERED INDEX [ix_idPopVersion]
    ON [dbo].[pop_VersionContent]([idPopVersion] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_pop_VersionContent_idColl]
    ON [dbo].[pop_VersionContent]([idColl] ASC)
    INCLUDE([idPopVersion]);


CREATE TABLE [dbo].[pop_PopulationVersion] (
    [id]               INT      IDENTITY (1, 1) NOT NULL,
    [idPop]            INT      NULL,
    [versionMajor]     INT      NULL,
    [versionMinor]     INT      NULL,
    [changeType]       INT      NULL,
    [createDate]       DATETIME CONSTRAINT [DF_pop_PopulationVersion_createDate] DEFAULT (getutcdate()) NOT NULL,
    [id_source_tenant] INT      NULL,
    [id_source]        INT      NULL,
    [id_change_set]    INT      NULL,
    CONSTRAINT [PK_pop_PopulationVersion] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_pop_PopulationVersion_pop_ChangeType] FOREIGN KEY ([changeType]) REFERENCES [dbo].[pop_ChangeType] ([id]),
    CONSTRAINT [FK_pop_PopulationVersion_pop_Population] FOREIGN KEY ([idPop]) REFERENCES [dbo].[pop_Population] ([idPop])
);


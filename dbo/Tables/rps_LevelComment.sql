CREATE TABLE [dbo].[rps_LevelComment] (
    [idLevelComment]   INT           IDENTITY (1, 1) NOT NULL,
    [nameLevelComment] NVARCHAR (50) NULL,
    CONSTRAINT [PK_rps_LevelComment] PRIMARY KEY CLUSTERED ([idLevelComment] ASC)
);


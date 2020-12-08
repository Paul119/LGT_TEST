CREATE TABLE [dbo].[_tb_Point_Values] (
    [PointValuesId] INT IDENTITY (1, 1) NOT NULL,
    [Year]          INT NULL,
    [HFValue]       INT NULL,
    [PEValue]       INT NULL,
    CONSTRAINT [pk_tb_Point_Values_PointValuesId] PRIMARY KEY CLUSTERED ([PointValuesId] ASC)
);


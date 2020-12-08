CREATE TABLE [dbo].[_tb_Point_Values_xhisto_201909041312433978] (
    [id_xhisto]      INT      IDENTITY (1, 1) NOT NULL,
    [id_user_xhisto] INT      NOT NULL,
    [dt_xhisto]      DATETIME NOT NULL,
    [type_xhisto]    CHAR (3) NOT NULL,
    [PointValuesId]  INT      NULL,
    [Value]          INT      NULL,
    [Year]           INT      NULL,
    PRIMARY KEY CLUSTERED ([id_xhisto] ASC)
);


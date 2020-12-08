CREATE TABLE [dbo].[_tb_ref_year_xhisto_201909041334518519] (
    [id_xhisto]      INT      IDENTITY (1, 1) NOT NULL,
    [id_user_xhisto] INT      NOT NULL,
    [dt_xhisto]      DATETIME NOT NULL,
    [type_xhisto]    CHAR (3) NOT NULL,
    [EndDate]        DATE     NULL,
    [StartDate]      DATE     NULL,
    [Year]           INT      NULL,
    [YearId]         INT      NULL,
    PRIMARY KEY CLUSTERED ([id_xhisto] ASC)
);


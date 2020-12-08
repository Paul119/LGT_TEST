CREATE TABLE [dbo].[_tb_ref_year] (
    [YearId]    INT  IDENTITY (1, 1) NOT NULL,
    [Year]      INT  NULL,
    [StartDate] DATE NULL,
    [EndDate]   DATE NULL,
    CONSTRAINT [PK__tb_ref_year__YearId] PRIMARY KEY CLUSTERED ([YearId] ASC)
);


CREATE TABLE [dbo].[Dim_Performance_Rating] (
    [id_perf_rating]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_perf_rating]  INT             NULL,
    [code_perf_rating]       NVARCHAR (50)   NOT NULL,
    [short_name_perf_rating] NVARCHAR (100)  NULL,
    [long_name_perf_rating]  NVARCHAR (255)  NULL,
    [value1_perf_rating]     DECIMAL (18, 4) NULL,
    [value2_perf_rating]     DECIMAL (18, 4) NULL,
    [type_perf_rating]       NVARCHAR (50)   NULL,
    [sort_perf_rating]       INT             NULL,
    [id_version]             INT             NULL,
    CONSTRAINT [PK_Dim_Performance_Rating] PRIMARY KEY CLUSTERED ([id_perf_rating] ASC),
    CONSTRAINT [FK_Dim_Performance_Rating] FOREIGN KEY ([id_perf_rating]) REFERENCES [dbo].[Dim_Performance_Rating] ([id_perf_rating])
);


CREATE TABLE [dbo].[Dim_Geography] (
    [id_geography]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_geography]  INT             NULL,
    [code_geography]       NVARCHAR (50)   NOT NULL,
    [short_name_geography] NVARCHAR (100)  NULL,
    [long_name_geography]  NVARCHAR (255)  NULL,
    [value1_geography]     DECIMAL (18, 4) NULL,
    [value2_geography]     DECIMAL (18, 4) NULL,
    [type_geography]       NVARCHAR (50)   NULL,
    [sort_geography]       INT             NULL,
    [id_version]           INT             NULL,
    CONSTRAINT [PK_Dim_Geography] PRIMARY KEY CLUSTERED ([id_geography] ASC),
    CONSTRAINT [FK_Dim_Geography_Dim_Geography] FOREIGN KEY ([id_parent_geography]) REFERENCES [dbo].[Dim_Geography] ([id_geography])
);


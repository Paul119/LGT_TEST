CREATE TABLE [dbo].[Dim_Grade] (
    [id_grade]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_grade]  INT             NULL,
    [code_grade]       NVARCHAR (50)   NOT NULL,
    [short_name_grade] NVARCHAR (100)  NULL,
    [long_name_grade]  NVARCHAR (255)  NULL,
    [value1_grade]     DECIMAL (18, 4) NULL,
    [value2_grade]     DECIMAL (18, 4) NULL,
    [type_grade]       NVARCHAR (50)   NULL,
    [sort_grade]       INT             NULL,
    [id_version]       INT             NULL,
    CONSTRAINT [PK_Dim_Grade] PRIMARY KEY CLUSTERED ([id_grade] ASC),
    CONSTRAINT [FK_Dim_Grade_Dim_Grade] FOREIGN KEY ([id_parent_grade]) REFERENCES [dbo].[Dim_Grade] ([id_grade])
);


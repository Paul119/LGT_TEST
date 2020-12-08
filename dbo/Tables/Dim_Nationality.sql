CREATE TABLE [dbo].[Dim_Nationality] (
    [id_nationality]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_nationality]  INT             NULL,
    [code_nationality]       NVARCHAR (50)   NOT NULL,
    [short_name_nationality] NVARCHAR (100)  NULL,
    [long_name_nationality]  NVARCHAR (255)  NULL,
    [value1_nationality]     DECIMAL (18, 4) NULL,
    [value2_nationality]     DECIMAL (18, 4) NULL,
    [type_nationality]       NVARCHAR (50)   NULL,
    [sort_nationality]       INT             NULL,
    [id_version]             INT             NULL,
    CONSTRAINT [PK_Dim_Nationality] PRIMARY KEY CLUSTERED ([id_nationality] ASC),
    CONSTRAINT [FK_Dim_Nationality_Dim_Nationality] FOREIGN KEY ([id_parent_nationality]) REFERENCES [dbo].[Dim_Nationality] ([id_nationality])
);


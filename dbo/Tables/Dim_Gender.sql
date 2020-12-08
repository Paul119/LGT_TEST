CREATE TABLE [dbo].[Dim_Gender] (
    [id_gender]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_gender]  INT             NULL,
    [code_gender]       NVARCHAR (50)   NOT NULL,
    [short_name_gender] NVARCHAR (100)  NULL,
    [long_name_gender]  NVARCHAR (255)  NULL,
    [value1_gender]     DECIMAL (18, 4) NULL,
    [value2_gender]     DECIMAL (18, 4) NULL,
    [type_gender]       NVARCHAR (50)   NULL,
    [sort_gender]       INT             NULL,
    [id_version]        INT             NULL,
    CONSTRAINT [PK_Dim_Gender] PRIMARY KEY CLUSTERED ([id_gender] ASC),
    CONSTRAINT [FK_Dim_Gender_Dim_Gender] FOREIGN KEY ([id_parent_gender]) REFERENCES [dbo].[Dim_Gender] ([id_gender])
);


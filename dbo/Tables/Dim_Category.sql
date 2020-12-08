CREATE TABLE [dbo].[Dim_Category] (
    [id_category]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_category]  INT             NULL,
    [code_category]       NVARCHAR (50)   NOT NULL,
    [short_name_category] NVARCHAR (100)  NULL,
    [long_name_category]  NVARCHAR (255)  NULL,
    [value1_category]     DECIMAL (18, 4) NULL,
    [value2_category]     DECIMAL (18, 4) NULL,
    [type_category]       NVARCHAR (50)   NULL,
    [sort_category]       INT             NULL,
    [id_version]          INT             NULL,
    CONSTRAINT [PK_Dim_Category] PRIMARY KEY CLUSTERED ([id_category] ASC),
    CONSTRAINT [FK_Dim_Category_Dim_Category] FOREIGN KEY ([id_parent_category]) REFERENCES [dbo].[Dim_Category] ([id_category])
);


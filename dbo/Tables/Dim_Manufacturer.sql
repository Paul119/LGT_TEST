CREATE TABLE [dbo].[Dim_Manufacturer] (
    [id_manufacturer]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_manufacturer]  INT             NULL,
    [code_manufacturer]       NVARCHAR (50)   NOT NULL,
    [short_name_manufacturer] NVARCHAR (100)  NULL,
    [long_name_manufacturer]  NVARCHAR (255)  NULL,
    [value1_manufacturer]     DECIMAL (18, 4) NULL,
    [value2_manufacturer]     DECIMAL (18, 4) NULL,
    [type_manufacturer]       NVARCHAR (50)   NULL,
    [sort_manufacturer]       INT             NULL,
    [id_version]              INT             NULL,
    CONSTRAINT [PK_Dim_Manufacturer] PRIMARY KEY CLUSTERED ([id_manufacturer] ASC),
    CONSTRAINT [FK_Dim_Manufacturer_Dim_Manufacturer] FOREIGN KEY ([id_parent_manufacturer]) REFERENCES [dbo].[Dim_Manufacturer] ([id_manufacturer])
);


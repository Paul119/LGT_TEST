CREATE TABLE [dbo].[Dim_Product] (
    [id_product]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_product]  INT             NULL,
    [code_product]       NVARCHAR (50)   NOT NULL,
    [short_name_product] NVARCHAR (100)  NULL,
    [long_name_product]  NVARCHAR (255)  NULL,
    [value1_product]     DECIMAL (18, 4) NULL,
    [value2_product]     DECIMAL (18, 4) NULL,
    [type_product]       NVARCHAR (50)   NULL,
    [sort_product]       INT             NULL,
    [id_category]        INT             NULL,
    [id_family]          INT             NULL,
    [id_manufacturer]    INT             NULL,
    [id_version]         INT             NULL,
    CONSTRAINT [PK_Dim_Product] PRIMARY KEY CLUSTERED ([id_product] ASC),
    CONSTRAINT [FK_Dim_Product_Dim_Category] FOREIGN KEY ([id_category]) REFERENCES [dbo].[Dim_Category] ([id_category]),
    CONSTRAINT [FK_Dim_Product_Dim_Family] FOREIGN KEY ([id_family]) REFERENCES [dbo].[Dim_Family] ([id_family]),
    CONSTRAINT [FK_Dim_Product_Dim_Manufacturer] FOREIGN KEY ([id_manufacturer]) REFERENCES [dbo].[Dim_Manufacturer] ([id_manufacturer]),
    CONSTRAINT [FK_Dim_Product_Dim_Product] FOREIGN KEY ([id_parent_product]) REFERENCES [dbo].[Dim_Product] ([id_product])
);


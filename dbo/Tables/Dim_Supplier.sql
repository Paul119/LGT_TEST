CREATE TABLE [dbo].[Dim_Supplier] (
    [id_supplier]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_supplier]  INT             NULL,
    [code_supplier]       NVARCHAR (50)   NOT NULL,
    [short_name_supplier] NVARCHAR (100)  NULL,
    [long_name_supplier]  NVARCHAR (255)  NULL,
    [value1_supplier]     DECIMAL (18, 4) NULL,
    [value2_supplier]     DECIMAL (18, 4) NULL,
    [type_supplier]       NVARCHAR (50)   NULL,
    [sort_supplier]       INT             NULL,
    [id_version]          INT             NULL,
    CONSTRAINT [PK_Dim_Supplier] PRIMARY KEY CLUSTERED ([id_supplier] ASC),
    CONSTRAINT [FK_Dim_Supplier_Dim_Supplier] FOREIGN KEY ([id_parent_supplier]) REFERENCES [dbo].[Dim_Supplier] ([id_supplier])
);


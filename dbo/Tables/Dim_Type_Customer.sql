CREATE TABLE [dbo].[Dim_Type_Customer] (
    [id_type_customer]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_type_customer]  INT             NULL,
    [code_type_customer]       NVARCHAR (50)   NOT NULL,
    [short_name_type_customer] NVARCHAR (100)  NULL,
    [long_name_type_customer]  NVARCHAR (255)  NULL,
    [value1_type_customer]     DECIMAL (18, 4) NULL,
    [value2_type_customer]     DECIMAL (18, 4) NULL,
    [type_type_customer]       NVARCHAR (50)   NULL,
    [sort_type_customer]       INT             NULL,
    [id_version]               INT             NULL,
    CONSTRAINT [PK_Dim_Type_Customer] PRIMARY KEY CLUSTERED ([id_type_customer] ASC),
    CONSTRAINT [FK_Dim_Type_Customer_Dim_Type_Customer] FOREIGN KEY ([id_parent_type_customer]) REFERENCES [dbo].[Dim_Type_Customer] ([id_type_customer])
);


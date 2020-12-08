CREATE TABLE [dbo].[Dim_Category_Employee] (
    [id_category_employee]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_category_employee]  INT             NULL,
    [code_category_employee]       NVARCHAR (50)   NOT NULL,
    [short_name_category_employee] NVARCHAR (100)  NULL,
    [long_name_category_employee]  NVARCHAR (255)  NULL,
    [value1_category_employee]     DECIMAL (18, 4) NULL,
    [value2_category_employee]     DECIMAL (18, 4) NULL,
    [type_category_employee]       NVARCHAR (50)   NULL,
    [sort_category_employee]       INT             NULL,
    [id_version]                   INT             NULL,
    CONSTRAINT [PK_Dim_Category_Employee] PRIMARY KEY CLUSTERED ([id_category_employee] ASC),
    CONSTRAINT [FK_Dim_Category_Employee_Dim_Category_Employee] FOREIGN KEY ([id_parent_category_employee]) REFERENCES [dbo].[Dim_Category_Employee] ([id_category_employee])
);


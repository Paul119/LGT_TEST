CREATE TABLE [dbo].[Dim_Customer] (
    [id_customer]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_customer]  INT             NULL,
    [code_customer]       NVARCHAR (50)   NOT NULL,
    [short_name_customer] NVARCHAR (100)  NULL,
    [long_name_customer]  NVARCHAR (255)  NULL,
    [value1_customer]     DECIMAL (18, 4) NULL,
    [value2_customer]     DECIMAL (18, 4) NULL,
    [type_customer]       NVARCHAR (50)   NULL,
    [sort_customer]       INT             NULL,
    [id_version]          INT             NULL,
    [id_type_customer]    INT             NULL,
    CONSTRAINT [PK_Dim_Customer] PRIMARY KEY CLUSTERED ([id_customer] ASC),
    CONSTRAINT [FK_Dim_Customer_Dim_Customer] FOREIGN KEY ([id_parent_customer]) REFERENCES [dbo].[Dim_Customer] ([id_customer]),
    CONSTRAINT [FK_Dim_Customer_Dim_Type_Customer] FOREIGN KEY ([id_type_customer]) REFERENCES [dbo].[Dim_Type_Customer] ([id_type_customer])
);


CREATE TABLE [dbo].[Dim_Organization] (
    [id_organization]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_organization]  INT             NULL,
    [code_organization]       NVARCHAR (50)   NOT NULL,
    [short_name_organization] NVARCHAR (100)  NULL,
    [long_name_organization]  NVARCHAR (255)  NULL,
    [value1_organization]     DECIMAL (18, 4) NULL,
    [value2_organization]     DECIMAL (18, 4) NULL,
    [type_organization]       NVARCHAR (50)   NULL,
    [sort_organization]       INT             NULL,
    [id_version]              INT             NULL,
    [id_currency]             INT             NULL,
    CONSTRAINT [PK_Dim_Organization] PRIMARY KEY CLUSTERED ([id_organization] ASC),
    CONSTRAINT [FK_Dim_Organization_Dim_Organization] FOREIGN KEY ([id_parent_organization]) REFERENCES [dbo].[Dim_Organization] ([id_organization])
);


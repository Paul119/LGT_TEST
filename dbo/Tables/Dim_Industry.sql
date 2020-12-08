CREATE TABLE [dbo].[Dim_Industry] (
    [id_industry]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_industry]  INT             NULL,
    [code_industry]       NVARCHAR (50)   NOT NULL,
    [short_name_industry] NVARCHAR (100)  NULL,
    [long_name_industry]  NVARCHAR (255)  NULL,
    [value1_industry]     DECIMAL (18, 4) NULL,
    [value2_industry]     DECIMAL (18, 4) NULL,
    [type_industry]       NVARCHAR (50)   NULL,
    [sort_industry]       INT             NULL,
    [id_version]          INT             NULL,
    CONSTRAINT [PK_Dim_Industry] PRIMARY KEY CLUSTERED ([id_industry] ASC)
);


CREATE TABLE [dbo].[Dim_BusinessUnit] (
    [id_BusinessUnit]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_BusinessUnit]  INT             NULL,
    [code_BusinessUnit]       NVARCHAR (50)   NOT NULL,
    [short_name_BusinessUnit] NVARCHAR (100)  NULL,
    [long_name_BusinessUnit]  NVARCHAR (255)  NULL,
    [value1_BusinessUnit]     DECIMAL (18, 4) NULL,
    [value2_BusinessUnit]     DECIMAL (18, 4) NULL,
    [type_BusinessUnit]       NVARCHAR (50)   NULL,
    [sort_BusinessUnit]       INT             NULL,
    [id_version]              INT             NULL,
    CONSTRAINT [PK_Dim_BusinessUnit] PRIMARY KEY CLUSTERED ([id_BusinessUnit] ASC)
);


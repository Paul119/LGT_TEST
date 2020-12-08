CREATE TABLE [dbo].[Dim_Home_Country] (
    [id_Home_Country]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_Home_Country]  INT             NULL,
    [code_Home_Country]       NVARCHAR (50)   NOT NULL,
    [short_name_Home_Country] NVARCHAR (100)  NULL,
    [long_name_Home_Country]  NVARCHAR (255)  NULL,
    [value1_Home_Country]     DECIMAL (18, 4) NULL,
    [value2_Home_Country]     DECIMAL (18, 4) NULL,
    [type_Home_Country]       NVARCHAR (50)   NULL,
    [sort_Home_Country]       INT             NULL,
    [id_version]              INT             NULL,
    CONSTRAINT [PK_Dim_Home_Country] PRIMARY KEY CLUSTERED ([id_Home_Country] ASC)
);


CREATE TABLE [dbo].[Dim_Host_Country] (
    [id_Host_Country]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_Host_Country]  INT             NULL,
    [code_Host_Country]       NVARCHAR (50)   NOT NULL,
    [short_name_Host_Country] NVARCHAR (100)  NULL,
    [long_name_Host_Country]  NVARCHAR (255)  NULL,
    [value1_Host_Country]     DECIMAL (18, 4) NULL,
    [value2_Host_Country]     DECIMAL (18, 4) NULL,
    [type_Host_Country]       NVARCHAR (50)   NULL,
    [sort_Host_Country]       INT             NULL,
    [id_version]              INT             NULL,
    CONSTRAINT [PK_Dim_Host_Country] PRIMARY KEY CLUSTERED ([id_Host_Country] ASC)
);


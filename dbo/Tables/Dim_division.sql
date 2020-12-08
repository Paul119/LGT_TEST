CREATE TABLE [dbo].[Dim_division] (
    [id_division]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_division]  INT             NULL,
    [code_division]       NVARCHAR (50)   NOT NULL,
    [short_name_division] NVARCHAR (100)  NULL,
    [long_name_division]  NVARCHAR (255)  NULL,
    [value1_division]     DECIMAL (18, 4) NULL,
    [value2_division]     DECIMAL (18, 4) NULL,
    [type_division]       NVARCHAR (50)   NULL,
    [sort_division]       INT             NULL,
    [id_version]          INT             NULL,
    CONSTRAINT [PK_Dim_division] PRIMARY KEY CLUSTERED ([id_division] ASC)
);


CREATE TABLE [dbo].[Dim_Band] (
    [id_band]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_band]  INT             NULL,
    [code_band]       NVARCHAR (50)   NOT NULL,
    [short_name_band] NVARCHAR (100)  NULL,
    [long_name_band]  NVARCHAR (255)  NULL,
    [value1_band]     DECIMAL (18, 4) NULL,
    [value2_band]     DECIMAL (18, 4) NULL,
    [type_band]       NVARCHAR (50)   NULL,
    [sort_band]       INT             NULL,
    [id_version]      INT             NULL,
    CONSTRAINT [PK_Dim_Band] PRIMARY KEY CLUSTERED ([id_band] ASC)
);


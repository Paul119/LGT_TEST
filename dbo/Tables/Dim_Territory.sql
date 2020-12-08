CREATE TABLE [dbo].[Dim_Territory] (
    [id_territory]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_territory]  INT             NULL,
    [code_territory]       NVARCHAR (50)   NOT NULL,
    [short_name_territory] NVARCHAR (100)  NULL,
    [long_name_territory]  NVARCHAR (255)  NULL,
    [value1_territory]     DECIMAL (18, 4) NULL,
    [value2_territory]     DECIMAL (18, 4) NULL,
    [type_territory]       NVARCHAR (50)   NULL,
    [sort_territory]       INT             NULL,
    [id_version]           INT             NULL,
    CONSTRAINT [PK_Dim_Territory] PRIMARY KEY CLUSTERED ([id_territory] ASC),
    CONSTRAINT [FK_Dim_Territory_Dim_Territory] FOREIGN KEY ([id_parent_territory]) REFERENCES [dbo].[Dim_Territory] ([id_territory])
);


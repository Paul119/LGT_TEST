CREATE TABLE [dbo].[Dim_Family] (
    [id_family]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_family]  INT             NULL,
    [code_family]       NVARCHAR (50)   NOT NULL,
    [short_name_family] NVARCHAR (100)  NULL,
    [long_name_family]  NVARCHAR (255)  NULL,
    [value1_family]     DECIMAL (18, 4) NULL,
    [value2_family]     DECIMAL (18, 4) NULL,
    [type_family]       NVARCHAR (50)   NULL,
    [sort_family]       INT             NULL,
    [id_version]        INT             NULL,
    CONSTRAINT [PK_Dim_Family] PRIMARY KEY CLUSTERED ([id_family] ASC),
    CONSTRAINT [FK_Dim_Family_Dim_Family] FOREIGN KEY ([id_parent_family]) REFERENCES [dbo].[Dim_Family] ([id_family])
);


CREATE TABLE [dbo].[Dim_Structure] (
    [id_structure]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_structure]  INT             NULL,
    [code_structure]       NVARCHAR (50)   NOT NULL,
    [short_name_structure] NVARCHAR (100)  NULL,
    [long_name_structure]  NVARCHAR (255)  NULL,
    [value1_structure]     DECIMAL (18, 4) NULL,
    [value2_structure]     DECIMAL (18, 4) NULL,
    [type_structure]       NVARCHAR (50)   NULL,
    [sort_structure]       INT             NULL,
    [id_version]           INT             NULL,
    CONSTRAINT [PK_Dim_Structure] PRIMARY KEY CLUSTERED ([id_structure] ASC),
    CONSTRAINT [FK_Dim_Structure_Dim_Structure] FOREIGN KEY ([id_parent_structure]) REFERENCES [dbo].[Dim_Structure] ([id_structure])
);


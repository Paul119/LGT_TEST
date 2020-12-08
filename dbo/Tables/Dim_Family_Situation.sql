CREATE TABLE [dbo].[Dim_Family_Situation] (
    [id_family_situation]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_family_situation]  INT             NULL,
    [code_family_situation]       NVARCHAR (50)   NOT NULL,
    [short_name_family_situation] NVARCHAR (100)  NULL,
    [long_name_family_situation]  NVARCHAR (255)  NULL,
    [value1_family_situation]     DECIMAL (18, 4) NULL,
    [value2_family_situation]     DECIMAL (18, 4) NULL,
    [type_family_situation]       NVARCHAR (50)   NULL,
    [sort_family_situation]       INT             NULL,
    [id_version]                  INT             NULL,
    CONSTRAINT [PK_Dim_Family_Situation] PRIMARY KEY CLUSTERED ([id_family_situation] ASC),
    CONSTRAINT [FK_Dim_Family_Situation_Dim_Family_Situation] FOREIGN KEY ([id_parent_family_situation]) REFERENCES [dbo].[Dim_Family_Situation] ([id_family_situation])
);


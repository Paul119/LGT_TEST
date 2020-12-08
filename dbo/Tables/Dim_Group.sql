CREATE TABLE [dbo].[Dim_Group] (
    [id_group]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_group]  INT             NULL,
    [code_group]       NVARCHAR (50)   NOT NULL,
    [short_name_group] NVARCHAR (100)  NULL,
    [long_name_group]  NVARCHAR (255)  NULL,
    [value1_group]     DECIMAL (18, 4) NULL,
    [value2_group]     DECIMAL (18, 4) NULL,
    [type_group]       NVARCHAR (50)   NULL,
    [sort_group]       INT             NULL,
    [id_version]       INT             NULL,
    [id_currency]      INT             NULL,
    CONSTRAINT [PK_Dim_Group] PRIMARY KEY CLUSTERED ([id_group] ASC),
    CONSTRAINT [FK_Dim_Group_Dim_Group] FOREIGN KEY ([id_parent_group]) REFERENCES [dbo].[Dim_Group] ([id_group])
);


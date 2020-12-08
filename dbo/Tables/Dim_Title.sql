CREATE TABLE [dbo].[Dim_Title] (
    [id_title]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_title]  INT             NULL,
    [code_title]       NVARCHAR (50)   NOT NULL,
    [short_name_title] NVARCHAR (100)  NULL,
    [long_name_title]  NVARCHAR (255)  NULL,
    [value1_title]     DECIMAL (18, 4) NULL,
    [value2_title]     DECIMAL (18, 4) NULL,
    [type_title]       NVARCHAR (50)   NULL,
    [sort_title]       INT             NULL,
    [id_version]       INT             NULL,
    CONSTRAINT [PK_Dim_Title] PRIMARY KEY CLUSTERED ([id_title] ASC),
    CONSTRAINT [FK_Dim_Title_Dim_Title] FOREIGN KEY ([id_parent_title]) REFERENCES [dbo].[Dim_Title] ([id_title])
);


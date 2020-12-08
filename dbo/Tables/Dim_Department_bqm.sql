CREATE TABLE [dbo].[Dim_Department_bqm] (
    [id_department]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_department]  INT             NULL,
    [code_department]       NVARCHAR (50)   NOT NULL,
    [short_name_department] NVARCHAR (100)  NULL,
    [long_name_department]  NVARCHAR (255)  NULL,
    [value1_department]     DECIMAL (18, 4) NULL,
    [value2_department]     DECIMAL (18, 4) NULL,
    [type_department]       NVARCHAR (50)   NULL,
    [sort_department]       INT             NULL,
    [id_version]            INT             NULL,
    CONSTRAINT [PK_Dim_Department] PRIMARY KEY CLUSTERED ([id_department] ASC),
    CONSTRAINT [FK_Dim_Department_Dim_Department] FOREIGN KEY ([id_parent_department]) REFERENCES [dbo].[Dim_Department_bqm] ([id_department])
);


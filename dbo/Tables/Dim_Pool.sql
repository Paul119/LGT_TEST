CREATE TABLE [dbo].[Dim_Pool] (
    [id_pool]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_pool]  INT             NULL,
    [code_pool]       NVARCHAR (50)   NOT NULL,
    [short_name_pool] NVARCHAR (100)  NULL,
    [long_name_pool]  NVARCHAR (255)  NULL,
    [value1_pool]     DECIMAL (18, 4) NULL,
    [value2_pool]     DECIMAL (18, 4) NULL,
    [type_pool]       NVARCHAR (50)   NULL,
    [sort_pool]       INT             NULL,
    [id_version]      INT             NULL,
    CONSTRAINT [PK_Dim_Pool] PRIMARY KEY CLUSTERED ([id_pool] ASC),
    CONSTRAINT [FK_Dim_Pool_Dim_Pool] FOREIGN KEY ([id_parent_pool]) REFERENCES [dbo].[Dim_Pool] ([id_pool])
);


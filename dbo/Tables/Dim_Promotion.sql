CREATE TABLE [dbo].[Dim_Promotion] (
    [id_promotion]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_promotion]  INT             NULL,
    [code_promotion]       NVARCHAR (50)   NOT NULL,
    [short_name_promotion] NVARCHAR (100)  NULL,
    [long_name_promotion]  NVARCHAR (255)  NULL,
    [value1_promotion]     DECIMAL (18, 4) NULL,
    [value2_promotion]     DECIMAL (18, 4) NULL,
    [type_promotion]       NVARCHAR (50)   NULL,
    [sort_promotion]       INT             NULL,
    [id_version]           INT             NULL,
    CONSTRAINT [PK_Dim_Promotion] PRIMARY KEY CLUSTERED ([id_promotion] ASC),
    CONSTRAINT [FK_Dim_Promotion_Dim_Promotion] FOREIGN KEY ([id_parent_promotion]) REFERENCES [dbo].[Dim_Promotion] ([id_promotion])
);


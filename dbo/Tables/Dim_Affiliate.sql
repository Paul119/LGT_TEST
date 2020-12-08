CREATE TABLE [dbo].[Dim_Affiliate] (
    [id_affiliate]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_affiliate]  INT             NULL,
    [code_affiliate]       NVARCHAR (50)   NOT NULL,
    [short_name_affiliate] NVARCHAR (100)  NULL,
    [long_name_affiliate]  NVARCHAR (255)  NULL,
    [value1_affiliate]     DECIMAL (18, 4) NULL,
    [value2_affiliate]     DECIMAL (18, 4) NULL,
    [type_affiliate]       NVARCHAR (50)   NULL,
    [sort_affiliate]       INT             NULL,
    [id_version]           INT             NULL,
    CONSTRAINT [PK_Dim_Affiliate] PRIMARY KEY CLUSTERED ([id_affiliate] ASC),
    CONSTRAINT [FK_Dim_Affiliate_Dim_Affiliate] FOREIGN KEY ([id_parent_affiliate]) REFERENCES [dbo].[Dim_Affiliate] ([id_affiliate])
);


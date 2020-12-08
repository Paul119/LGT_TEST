CREATE TABLE [dbo].[Dim_Agreement] (
    [id_agreement]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_agreement]  INT             NULL,
    [code_agreement]       NVARCHAR (50)   NOT NULL,
    [short_name_agreement] NVARCHAR (100)  NULL,
    [long_name_agreement]  NVARCHAR (255)  NULL,
    [value1_agreement]     DECIMAL (18, 4) NULL,
    [value2_agreement]     DECIMAL (18, 4) NULL,
    [type_agreement]       NVARCHAR (50)   NULL,
    [sort_agreement]       INT             NULL,
    [id_version]           INT             NULL,
    [id_code_aggreement]   INT             NULL,
    CONSTRAINT [PK_Dim_Agreement] PRIMARY KEY CLUSTERED ([id_agreement] ASC),
    CONSTRAINT [FK_Dim_Agreement_Dim_Agreement] FOREIGN KEY ([id_parent_agreement]) REFERENCES [dbo].[Dim_Agreement] ([id_agreement])
);


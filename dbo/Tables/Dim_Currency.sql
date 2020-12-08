CREATE TABLE [dbo].[Dim_Currency] (
    [id_currency]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_currency]  INT             NULL,
    [code_currency]       NVARCHAR (50)   NOT NULL,
    [short_name_currency] NVARCHAR (100)  NULL,
    [long_name_currency]  NVARCHAR (255)  NULL,
    [value1_currency]     DECIMAL (18, 4) NULL,
    [value2_currency]     DECIMAL (18, 4) NULL,
    [type_currency]       NVARCHAR (50)   NULL,
    [sort_currency]       INT             NULL,
    [id_version]          INT             NULL,
    CONSTRAINT [PK_Dim_Currency] PRIMARY KEY CLUSTERED ([id_currency] ASC),
    CONSTRAINT [FK_Dim_Currency_Dim_Currency] FOREIGN KEY ([id_parent_currency]) REFERENCES [dbo].[Dim_Currency] ([id_currency])
);


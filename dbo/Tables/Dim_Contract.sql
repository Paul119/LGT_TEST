CREATE TABLE [dbo].[Dim_Contract] (
    [id_contract]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_contract]  INT             NULL,
    [code_contract]       NVARCHAR (50)   NOT NULL,
    [short_name_contract] NVARCHAR (100)  NULL,
    [long_name_contract]  NVARCHAR (255)  NULL,
    [value1_contract]     DECIMAL (18, 4) NULL,
    [value2_contract]     DECIMAL (18, 4) NULL,
    [type_contract]       NVARCHAR (50)   NULL,
    [sort_contract]       INT             NULL,
    [id_version]          INT             NULL,
    CONSTRAINT [PK_Dim_Contract] PRIMARY KEY CLUSTERED ([id_contract] ASC),
    CONSTRAINT [FK_Dim_Contract_Dim_Contract] FOREIGN KEY ([id_parent_contract]) REFERENCES [dbo].[Dim_Contract] ([id_contract])
);


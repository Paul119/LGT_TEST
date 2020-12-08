CREATE TABLE [dbo].[Dim_Benefit] (
    [id_benefit]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_benefit]  INT             NULL,
    [code_benefit]       NVARCHAR (50)   NOT NULL,
    [short_name_benefit] NVARCHAR (100)  NULL,
    [long_name_benefit]  NVARCHAR (255)  NULL,
    [value1_benefit]     DECIMAL (18, 4) NULL,
    [value2_benefit]     DECIMAL (18, 4) NULL,
    [type_benefit]       NVARCHAR (50)   NULL,
    [sort_benefit]       INT             NULL,
    [id_version]         INT             NULL,
    CONSTRAINT [PK_Dim_Benefit] PRIMARY KEY CLUSTERED ([id_benefit] ASC),
    CONSTRAINT [FK_Dim_Benefit_Dim_Benefit] FOREIGN KEY ([id_parent_benefit]) REFERENCES [dbo].[Dim_Benefit] ([id_benefit])
);


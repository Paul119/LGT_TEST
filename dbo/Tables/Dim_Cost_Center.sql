CREATE TABLE [dbo].[Dim_Cost_Center] (
    [id_cost_center]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_cost_center]  INT             NULL,
    [code_cost_center]       NVARCHAR (50)   NOT NULL,
    [short_name_cost_center] NVARCHAR (100)  NULL,
    [long_name_cost_center]  NVARCHAR (255)  NULL,
    [value1_cost_center]     DECIMAL (18, 4) NULL,
    [value2_cost_center]     DECIMAL (18, 4) NULL,
    [type_cost_center]       NVARCHAR (50)   NULL,
    [sort_cost_center]       INT             NULL,
    [id_version]             INT             NULL,
    CONSTRAINT [PK_Dim_Cost_Center] PRIMARY KEY CLUSTERED ([id_cost_center] ASC),
    CONSTRAINT [FK_Dim_Cost_Center_Dim_Cost_Center] FOREIGN KEY ([id_parent_cost_center]) REFERENCES [dbo].[Dim_Cost_Center] ([id_cost_center])
);


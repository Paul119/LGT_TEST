CREATE TABLE [dbo].[Dim_Status] (
    [id_status]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_status]  INT             NULL,
    [code_status]       NVARCHAR (50)   NOT NULL,
    [short_name_status] NVARCHAR (100)  NULL,
    [long_name_status]  NVARCHAR (255)  NULL,
    [value1_status]     DECIMAL (18, 4) NULL,
    [value2_status]     DECIMAL (18, 4) NULL,
    [type_status]       NVARCHAR (50)   NULL,
    [sort_status]       INT             NULL,
    [id_version]        INT             NULL,
    CONSTRAINT [PK_Dim_Status] PRIMARY KEY CLUSTERED ([id_status] ASC),
    CONSTRAINT [FK_Dim_Status_Dim_Status] FOREIGN KEY ([id_parent_status]) REFERENCES [dbo].[Dim_Status] ([id_status])
);


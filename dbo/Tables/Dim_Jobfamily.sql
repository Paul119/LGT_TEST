CREATE TABLE [dbo].[Dim_Jobfamily] (
    [id_Jobfamily]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_Jobfamily]  INT             NULL,
    [code_Jobfamily]       NVARCHAR (50)   NOT NULL,
    [short_name_Jobfamily] NVARCHAR (100)  NULL,
    [long_name_Jobfamily]  NVARCHAR (255)  NULL,
    [value1_Jobfamily]     DECIMAL (18, 4) NULL,
    [value2_Jobfamily]     DECIMAL (18, 4) NULL,
    [type_Jobfamily]       NVARCHAR (50)   NULL,
    [sort_Jobfamily]       INT             NULL,
    [id_version]           INT             NULL,
    CONSTRAINT [PK_Dim_Jobfamily] PRIMARY KEY CLUSTERED ([id_Jobfamily] ASC)
);


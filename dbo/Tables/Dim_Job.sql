CREATE TABLE [dbo].[Dim_Job] (
    [id_job]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_job]  INT             NULL,
    [code_job]       NVARCHAR (50)   NOT NULL,
    [short_name_job] NVARCHAR (100)  NULL,
    [long_name_job]  NVARCHAR (255)  NULL,
    [value1_job]     DECIMAL (18, 4) NULL,
    [value2_job]     DECIMAL (18, 4) NULL,
    [type_job]       NVARCHAR (50)   NULL,
    [sort_job]       INT             NULL,
    [id_version]     INT             NULL,
    [aggregated_job] NVARCHAR (100)  NULL,
    [risk_profile]   NVARCHAR (50)   NULL,
    CONSTRAINT [PK_Dim_Job] PRIMARY KEY CLUSTERED ([id_job] ASC),
    CONSTRAINT [FK_Dim_Job_Dim_Job] FOREIGN KEY ([id_parent_job]) REFERENCES [dbo].[Dim_Job] ([id_job])
);


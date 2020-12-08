CREATE TABLE [dbo].[Dim_Activity_Status] (
    [id_activity_status]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_activity_status]  INT             NULL,
    [code_activity_status]       NVARCHAR (50)   NOT NULL,
    [short_name_activity_status] NVARCHAR (100)  NULL,
    [long_name_activity_status]  NVARCHAR (255)  NULL,
    [value1_activity_status]     DECIMAL (18, 4) NULL,
    [value2_activity_status]     DECIMAL (18, 4) NULL,
    [type_activity_status]       NVARCHAR (50)   NULL,
    [sort_activity_status]       INT             NULL,
    [id_version]                 INT             NULL,
    CONSTRAINT [PK_Dim_Activity_Status] PRIMARY KEY CLUSTERED ([id_activity_status] ASC),
    CONSTRAINT [FK_Dim_Activity_Status_Dim_Activity_Status] FOREIGN KEY ([id_parent_activity_status]) REFERENCES [dbo].[Dim_Activity_Status] ([id_activity_status])
);


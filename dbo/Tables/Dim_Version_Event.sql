CREATE TABLE [dbo].[Dim_Version_Event] (
    [id_version_event]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_version_event]  INT             NULL,
    [code_version_event]       NVARCHAR (50)   NOT NULL,
    [short_name_version_event] NVARCHAR (100)  NULL,
    [long_name_version_event]  NVARCHAR (255)  NULL,
    [value1_version_event]     DECIMAL (18, 4) NULL,
    [value2_version_event]     DECIMAL (18, 4) NULL,
    [type_version_event]       NVARCHAR (50)   NULL,
    [sort_version_event]       INT             NULL,
    [id_version]               INT             NULL,
    CONSTRAINT [PK_Dim_Version_Event] PRIMARY KEY CLUSTERED ([id_version_event] ASC),
    CONSTRAINT [FK_Dim_Version_Event_Dim_Version_Event] FOREIGN KEY ([id_parent_version_event]) REFERENCES [dbo].[Dim_Version_Event] ([id_version_event])
);


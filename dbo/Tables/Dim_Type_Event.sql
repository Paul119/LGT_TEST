CREATE TABLE [dbo].[Dim_Type_Event] (
    [id_type_event]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_type_event]  INT             NULL,
    [code_type_event]       NVARCHAR (50)   NOT NULL,
    [short_name_type_event] NVARCHAR (100)  NULL,
    [long_name_type_event]  NVARCHAR (255)  NULL,
    [value1_type_event]     DECIMAL (18, 4) NULL,
    [value2_type_event]     DECIMAL (18, 4) NULL,
    [type_type_event]       NVARCHAR (50)   NULL,
    [sort_type_event]       INT             NULL,
    [id_version]            INT             NULL,
    CONSTRAINT [PK_Dim_Type_Event] PRIMARY KEY CLUSTERED ([id_type_event] ASC),
    CONSTRAINT [FK_Dim_Type_Event_Dim_Type_Event] FOREIGN KEY ([id_parent_type_event]) REFERENCES [dbo].[Dim_Type_Event] ([id_type_event])
);


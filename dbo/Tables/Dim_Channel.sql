CREATE TABLE [dbo].[Dim_Channel] (
    [id_channel]         INT             IDENTITY (1, 1) NOT NULL,
    [id_parent_channel]  INT             NULL,
    [code_channel]       NVARCHAR (50)   NOT NULL,
    [short_name_channel] NVARCHAR (100)  NULL,
    [long_name_channel]  NVARCHAR (255)  NULL,
    [value1_channel]     DECIMAL (18, 4) NULL,
    [value2_channel]     DECIMAL (18, 4) NULL,
    [type_channel]       NVARCHAR (50)   NULL,
    [sort_channel]       INT             NULL,
    [id_version]         INT             NULL,
    CONSTRAINT [PK_Dim_Channel] PRIMARY KEY CLUSTERED ([id_channel] ASC),
    CONSTRAINT [FK_Dim_Channel_Dim_Channel] FOREIGN KEY ([id_parent_channel]) REFERENCES [dbo].[Dim_Channel] ([id_channel])
);


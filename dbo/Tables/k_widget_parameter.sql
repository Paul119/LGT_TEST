CREATE TABLE [dbo].[k_widget_parameter] (
    [id_widget_parameter] INT            IDENTITY (1, 1) NOT NULL,
    [id_widget]           INT            NULL,
    [source_script]       NVARCHAR (255) NULL,
    [source_type]         VARCHAR (10)   NULL,
    [loading_trigger]     VARCHAR (25)   NULL,
    [pipe_mode]           VARCHAR (10)   NULL,
    [cache_value]         NVARCHAR (255) NULL,
    [caption]             NVARCHAR (100) NULL,
    [color]               NVARCHAR (10)  NULL,
    CONSTRAINT [PK_k_widget_parameter] PRIMARY KEY CLUSTERED ([id_widget_parameter] ASC),
    CONSTRAINT [FK_k_widget_parameter_k_widget] FOREIGN KEY ([id_widget]) REFERENCES [dbo].[k_widget] ([id_widget])
);


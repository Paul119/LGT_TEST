CREATE TABLE [dbo].[k_widget_type] (
    [id_widget_type]   INT           IDENTITY (1, 1) NOT NULL,
    [name_widget_type] NVARCHAR (20) NULL,
    CONSTRAINT [PK_k_widget_type] PRIMARY KEY CLUSTERED ([id_widget_type] ASC),
    CONSTRAINT [FK_k_widget_type_k_widget_type] FOREIGN KEY ([id_widget_type]) REFERENCES [dbo].[k_widget_type] ([id_widget_type])
);


CREATE TABLE [dbo].[k_widget_data_type] (
    [id_widget_data_type]   INT           IDENTITY (1, 1) NOT NULL,
    [name_widget_data_type] NVARCHAR (25) NOT NULL,
    CONSTRAINT [PK_k_widget_data_type] PRIMARY KEY CLUSTERED ([id_widget_data_type] ASC)
);


CREATE TABLE [dbo].[k_widget] (
    [id_widget]          INT            IDENTITY (1, 1) NOT NULL,
    [name_widget]        NVARCHAR (100) NULL,
    [id_widget_type]     INT            NULL,
    [id_data_widget]     INT            NULL,
    [is_percentage_used] BIT            NULL,
    [sibling_comparison] INT            NULL,
    [id_default_tree]    INT            NULL,
    CONSTRAINT [PK_k_widget] PRIMARY KEY CLUSTERED ([id_widget] ASC),
    CONSTRAINT [FK_k_widget_k_widget_data_type] FOREIGN KEY ([id_data_widget]) REFERENCES [dbo].[k_widget_data_type] ([id_widget_data_type]),
    CONSTRAINT [FK_k_widget_k_widget_type] FOREIGN KEY ([id_widget_type]) REFERENCES [dbo].[k_widget_type] ([id_widget_type])
);


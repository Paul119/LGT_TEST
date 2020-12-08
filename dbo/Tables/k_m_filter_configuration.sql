CREATE TABLE [dbo].[k_m_filter_configuration] (
    [id_filter_configuration]   INT            IDENTITY (1, 1) NOT NULL,
    [name_filter_configuration] NVARCHAR (100) NOT NULL,
    [id_type_plan]              INT            NOT NULL,
    [id_grid]                   INT            NULL,
    [id_join_type]              INT            DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_k_m_filter_configuration] PRIMARY KEY CLUSTERED ([id_filter_configuration] ASC),
    CONSTRAINT [FK_k_m_filter_configuration_k_m_filter_configuration_join_type] FOREIGN KEY ([id_join_type]) REFERENCES [dbo].[k_m_filter_configuration_join_type] ([id]),
    CONSTRAINT [FK_k_m_filter_configuration_k_m_type_plan] FOREIGN KEY ([id_type_plan]) REFERENCES [dbo].[k_m_type_plan] ([id_type_plan])
);


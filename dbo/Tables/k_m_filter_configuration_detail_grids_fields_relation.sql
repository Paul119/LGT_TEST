CREATE TABLE [dbo].[k_m_filter_configuration_detail_grids_fields_relation] (
    [id_filter_configuration_detail_grids_fields_relation] INT IDENTITY (1, 1) NOT NULL,
    [id_filter_configuration_detail]                       INT NOT NULL,
    [id_column]                                            INT NOT NULL,
    CONSTRAINT [PK_k_m_filter_configuration_detail_grids_fields_relation] PRIMARY KEY CLUSTERED ([id_filter_configuration_detail_grids_fields_relation] ASC),
    CONSTRAINT [FK_k_m_filter_configuration_detail_grids_fields_relation_k_m_filter_configuration_detail] FOREIGN KEY ([id_filter_configuration_detail]) REFERENCES [dbo].[k_m_filter_configuration_detail] ([id_filter_configuration_detail]),
    CONSTRAINT [FK_k_m_filter_configuration_detail_grids_fields_relation_k_referential_grids_fields] FOREIGN KEY ([id_column]) REFERENCES [dbo].[k_referential_grids_fields] ([id_column])
);


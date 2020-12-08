CREATE TABLE [dbo].[k_m_filter_configuration_detail] (
    [id_filter_configuration_detail] INT IDENTITY (1, 1) NOT NULL,
    [id_filter_configuration]        INT NOT NULL,
    [id_filter_type]                 INT NULL,
    [is_payee_configuration]         BIT NOT NULL,
    [is_indicator_configuration]     BIT NOT NULL,
    [is_field_configuration]         BIT NOT NULL,
    [is_filter_type_configuration]   BIT NOT NULL,
    CONSTRAINT [PK_k_m_filter_configuration_detail] PRIMARY KEY CLUSTERED ([id_filter_configuration_detail] ASC),
    CONSTRAINT [CK_k_m_filter_configuration_detail_payee_indicator_field_filter_type_configuration] CHECK ([is_payee_configuration]=(1) AND [is_indicator_configuration]=(0) AND [is_field_configuration]=(0) AND [is_filter_type_configuration]=(0) AND [id_filter_type] IS NULL OR [is_indicator_configuration]=(1) AND [is_payee_configuration]=(0) AND [is_field_configuration]=(0) AND [is_filter_type_configuration]=(0) AND [id_filter_type] IS NULL OR [is_indicator_configuration]=(0) AND [is_payee_configuration]=(0) AND [is_payee_configuration]=(0) AND [is_field_configuration]=(1) AND [is_filter_type_configuration]=(0) AND [id_filter_type] IS NULL OR [is_filter_type_configuration]=(1) AND [id_filter_type] IS NOT NULL AND [is_payee_configuration]=(0) AND [is_indicator_configuration]=(0) AND [is_field_configuration]=(0)),
    CONSTRAINT [FK_k_m_filter_configuration_detail_k_m_filter_configuration] FOREIGN KEY ([id_filter_configuration]) REFERENCES [dbo].[k_m_filter_configuration] ([id_filter_configuration]),
    CONSTRAINT [FK_k_m_filter_configuration_detail_k_m_filter_type] FOREIGN KEY ([id_filter_type]) REFERENCES [dbo].[k_m_filter_type] ([id_filter_type])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_UQ_k_m_filter_configuration_detail_id_filter_configuration_id_filter_type]
    ON [dbo].[k_m_filter_configuration_detail]([id_filter_configuration] ASC, [id_filter_type] ASC) WHERE ([is_filter_type_configuration]=(1));


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_UQ_k_m_filter_configuration_detail_id_filter_configuration_is_payee_configuration]
    ON [dbo].[k_m_filter_configuration_detail]([id_filter_configuration] ASC) WHERE ([is_payee_configuration]=(1));


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_UQ_k_m_filter_configuration_detail_id_filter_configuration_is_indicator_configuration]
    ON [dbo].[k_m_filter_configuration_detail]([id_filter_configuration] ASC) WHERE ([is_indicator_configuration]=(1));


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_UQ_k_m_filter_configuration_detail_id_filter_configuration_is_field_configuration]
    ON [dbo].[k_m_filter_configuration_detail]([id_filter_configuration] ASC) WHERE ([is_field_configuration]=(1));


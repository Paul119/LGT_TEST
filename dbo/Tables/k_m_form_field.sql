CREATE TABLE [dbo].[k_m_form_field] (
    [id_form_field]    INT IDENTITY (1, 1) NOT NULL,
    [id_form]          INT NULL,
    [id_plan]          INT NULL,
    [id_ind]           INT NULL,
    [id_field]         INT NULL,
    [id_source_tenant] INT NULL,
    [id_source]        INT NULL,
    [id_change_set]    INT NULL,
    CONSTRAINT [PK_k_m_form_field] PRIMARY KEY CLUSTERED ([id_form_field] ASC),
    CONSTRAINT [FK_k_m_form_field_k_m_fields] FOREIGN KEY ([id_field]) REFERENCES [dbo].[k_m_fields] ([id_field]),
    CONSTRAINT [FK_k_m_form_field_k_m_form] FOREIGN KEY ([id_form]) REFERENCES [dbo].[k_m_form] ([id_form]),
    CONSTRAINT [FK_k_m_form_field_k_m_indicators] FOREIGN KEY ([id_ind]) REFERENCES [dbo].[k_m_indicators] ([id_ind]),
    CONSTRAINT [FK_k_m_form_field_k_m_plans] FOREIGN KEY ([id_plan]) REFERENCES [dbo].[k_m_plans] ([id_plan])
);


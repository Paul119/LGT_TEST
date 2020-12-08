CREATE TABLE [dbo].[k_m_form] (
    [id_form]          INT            IDENTITY (1, 1) NOT NULL,
    [name_form]        NVARCHAR (100) NULL,
    [id_form_template] INT            NULL,
    [id_source_tenant] INT            NULL,
    [id_source]        INT            NULL,
    [id_change_set]    INT            NULL,
    CONSTRAINT [PK_k_m_form] PRIMARY KEY CLUSTERED ([id_form] ASC),
    CONSTRAINT [FK_k_m_form_k_referential_form_template] FOREIGN KEY ([id_form_template]) REFERENCES [dbo].[k_referential_form_template] ([form_template_id])
);


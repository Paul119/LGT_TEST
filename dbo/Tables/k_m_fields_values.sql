CREATE TABLE [dbo].[k_m_fields_values] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [id_field]         INT            NOT NULL,
    [label]            NVARCHAR (MAX) NULL,
    [value]            NVARCHAR (255) NULL,
    [culture]          INT            NOT NULL,
    [id_source_tenant] INT            NULL,
    [id_source]        INT            NULL,
    [id_change_set]    INT            NULL,
    [id_payee]         INT            NULL,
    [start_date]       DATETIME       NULL,
    [end_date]         DATETIME       NULL,
    CONSTRAINT [PK_k_m_fields_values] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_k_m_fields_values_k_cultures] FOREIGN KEY ([culture]) REFERENCES [dbo].[k_cultures] ([id]),
    CONSTRAINT [FK_k_m_fields_values_m_fields] FOREIGN KEY ([id_field]) REFERENCES [dbo].[k_m_fields] ([id_field]) ON DELETE CASCADE,
    CONSTRAINT [FK_k_m_fields_values_py_Payee] FOREIGN KEY ([id_payee]) REFERENCES [dbo].[py_Payee] ([idPayee])
);


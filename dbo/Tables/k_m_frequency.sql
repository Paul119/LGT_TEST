CREATE TABLE [dbo].[k_m_frequency] (
    [id_frequency]     INT            IDENTITY (1, 1) NOT NULL,
    [name_frequency]   NVARCHAR (50)  NOT NULL,
    [step_frequency]   INT            NULL,
    [sort]             INT            NULL,
    [olap_reference]   NVARCHAR (MAX) NULL,
    [is_kernel]        BIT            CONSTRAINT [DF_k_m_frequency_is_kernel] DEFAULT ((0)) NOT NULL,
    [id_source_tenant] INT            NULL,
    [id_source]        INT            NULL,
    [id_change_set]    INT            NULL,
    CONSTRAINT [PK_k_m_frequency] PRIMARY KEY CLUSTERED ([id_frequency] ASC)
);


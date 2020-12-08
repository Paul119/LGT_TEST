CREATE TABLE [dbo].[k_m_olap_references_detail] (
    [id_reference_detail]   INT            IDENTITY (1, 1) NOT NULL,
    [id_reference]          INT            NOT NULL,
    [name_reference_detail] NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_k_m_olap_references_detail] PRIMARY KEY CLUSTERED ([id_reference_detail] ASC),
    CONSTRAINT [FK_k_m_olap_references_detail_k_m_olap_references_detail] FOREIGN KEY ([id_reference]) REFERENCES [dbo].[k_m_olap_references] ([id_reference])
);


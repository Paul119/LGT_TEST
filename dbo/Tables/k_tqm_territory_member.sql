CREATE TABLE [dbo].[k_tqm_territory_member] (
    [id_territory_member] INT IDENTITY (1, 1) NOT NULL,
    [id_dimension]        INT NULL,
    [id_dimension_member] INT NULL,
    [id_territory]        INT NULL,
    CONSTRAINT [PK_k_tqm_territory_member] PRIMARY KEY CLUSTERED ([id_territory_member] ASC),
    CONSTRAINT [FK_k_tqm_territory_member_k_m_olap_references] FOREIGN KEY ([id_dimension]) REFERENCES [dbo].[k_m_olap_references] ([id_reference]),
    CONSTRAINT [FK_k_tqm_territory_member_k_tqm_territory] FOREIGN KEY ([id_territory]) REFERENCES [dbo].[k_tqm_territory] ([id_territory])
);


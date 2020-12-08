CREATE TABLE [dbo].[k_m_cube] (
    [id_cube]          INT            IDENTITY (1, 1) NOT NULL,
    [name_cube]        NVARCHAR (MAX) NOT NULL,
    [olap_cube_name]   NVARCHAR (MAX) NOT NULL,
    [id_source_tenant] INT            NULL,
    [id_source]        INT            NULL,
    [id_change_set]    INT            NULL,
    CONSTRAINT [PK_k_m_cube] PRIMARY KEY CLUSTERED ([id_cube] ASC)
);


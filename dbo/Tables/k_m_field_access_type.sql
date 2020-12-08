CREATE TABLE [dbo].[k_m_field_access_type] (
    [id_access_type]         INT            IDENTITY (-1, -1) NOT NULL,
    [name_field_access_type] NVARCHAR (255) NOT NULL,
    CONSTRAINT [PK_k_m_field_access_type] PRIMARY KEY CLUSTERED ([id_access_type] ASC)
);


CREATE TABLE [dbo].[k_m_indicators_types] (
    [id_type_ind]   INT            IDENTITY (1, 1) NOT NULL,
    [name_type_ind] NVARCHAR (255) NOT NULL,
    [sort]          INT            NULL,
    CONSTRAINT [PK_k_m_indicators_types] PRIMARY KEY CLUSTERED ([id_type_ind] ASC)
);


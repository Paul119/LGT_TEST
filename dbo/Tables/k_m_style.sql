CREATE TABLE [dbo].[k_m_style] (
    [id_style]         INT           IDENTITY (1, 1) NOT NULL,
    [name_style]       NVARCHAR (50) NOT NULL,
    [background_color] CHAR (6)      NOT NULL,
    CONSTRAINT [PK_k_m_style] PRIMARY KEY CLUSTERED ([id_style] ASC)
);


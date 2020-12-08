CREATE TABLE [dbo].[k_m_olap_timeframe] (
    [id_timeframe]   INT            IDENTITY (1, 1) NOT NULL,
    [name_timeframe] NVARCHAR (255) NULL,
    CONSTRAINT [PK_k_m_olap_timeframe] PRIMARY KEY CLUSTERED ([id_timeframe] ASC)
);


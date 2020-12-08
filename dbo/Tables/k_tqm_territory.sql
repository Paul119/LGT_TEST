CREATE TABLE [dbo].[k_tqm_territory] (
    [id_territory]          INT            IDENTITY (1, 1) NOT NULL,
    [code_territory]        NVARCHAR (200) NULL,
    [description_territory] NVARCHAR (MAX) NULL,
    [start_date]            DATETIME       NULL,
    [end_date]              DATETIME       NULL,
    CONSTRAINT [PK_k_tqm_territory] PRIMARY KEY CLUSTERED ([id_territory] ASC)
);


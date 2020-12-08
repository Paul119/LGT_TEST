CREATE TABLE [dbo].[_ref_Currency] (
    [CurrencyId]          INT           IDENTITY (1, 1) NOT NULL,
    [CurrencyCode]        NVARCHAR (3)  NOT NULL,
    [ISONumber]           NVARCHAR (3)  NULL,
    [CurrencyDescription] NVARCHAR (50) NULL,
    CONSTRAINT [pk_ref_Currency_CurrencyId] PRIMARY KEY CLUSTERED ([CurrencyId] ASC)
);


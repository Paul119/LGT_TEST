CREATE TABLE [dbo].[_tb_fx_rates_to_chf] (
    [fxratesId]    INT          IDENTITY (1, 1) NOT NULL,
    [year]         INT          NOT NULL,
    [CurrencyCode] NVARCHAR (3) NOT NULL,
    [Rate]         FLOAT (53)   NOT NULL,
    CONSTRAINT [pk_tb_fx_rates_to_chf_fxratesId] PRIMARY KEY CLUSTERED ([fxratesId] ASC),
    CONSTRAINT [U_tb_fx_rates_to_chf] UNIQUE NONCLUSTERED ([year] ASC, [CurrencyCode] ASC)
);


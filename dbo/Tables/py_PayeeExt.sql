CREATE TABLE [dbo].[py_PayeeExt] (
    [id_histo]                       INT             NOT NULL,
    [idPayee]                        INT             NOT NULL,
    [id_benefit_car]                 INT             NULL,
    [id_benefit_pension]             INT             NULL,
    [id_benefit_housing]             INT             NULL,
    [login]                          NVARCHAR (50)   NULL,
    [code_performance_rating]        NVARCHAR (50)   NULL,
    [code_jobfamily]                 NVARCHAR (50)   NULL,
    [code_host_country]              NVARCHAR (50)   NULL,
    [code_home_country]              NVARCHAR (50)   NULL,
    [code_division]                  NVARCHAR (50)   NULL,
    [code_businessunit]              NVARCHAR (50)   NULL,
    [code_band]                      NVARCHAR (50)   NULL,
    [FTE]                            DECIMAL (18, 2) NULL,
    [annual_fulltime_basesalary_usd] DECIMAL (18, 2) NULL,
    [annual_fulltime_basesalary_lc]  DECIMAL (18, 2) NULL,
    [effective_basesalary_lc]        DECIMAL (18, 2) NULL,
    [payment_periods]                DECIMAL (18, 2) NULL,
    [benefit_companycar]             DECIMAL (18, 2) NULL,
    [benefit_housingallowance]       DECIMAL (18, 2) NULL,
    [benefit_healthcare]             DECIMAL (18, 2) NULL,
    [wealth_pensionplan]             DECIMAL (18, 2) NULL,
    [code_potential_rating]          NVARCHAR (50)   NULL,
    [company_car]                    BIT             NULL,
    [company_laptop]                 BIT             NULL,
    [company_insurance]              BIT             NULL,
    [company_mobile]                 BIT             NULL,
    [region]                         NVARCHAR (200)  NULL,
    [area]                           NVARCHAR (200)  NULL,
    [years_in_company]               DECIMAL (18)    NULL,
    [years_in_job]                   DECIMAL (18)    NULL,
    CONSTRAINT [PK_k_collaborateurs_ext] PRIMARY KEY CLUSTERED ([id_histo] ASC, [idPayee] ASC),
    CONSTRAINT [FK_k_collaborateurs_ext_k_collaborateurs] FOREIGN KEY ([idPayee]) REFERENCES [dbo].[py_Payee] ([idPayee]),
    CONSTRAINT [FK_k_collaborateurs_ext_k_collaborateurs_histo] FOREIGN KEY ([id_histo]) REFERENCES [dbo].[py_PayeeHisto] ([id_histo])
);


GO
CREATE NONCLUSTERED INDEX [IX_k_collaborateurs_ext]
    ON [dbo].[py_PayeeExt]([idPayee] ASC, [id_histo] ASC);


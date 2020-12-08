CREATE TABLE [dbo].[py_Payee] (
    [idPayee]             INT             IDENTITY (1, 1) NOT NULL,
    [codePayee]           NVARCHAR (50)   NOT NULL,
    [is_active]           BIT             NULL,
    [id_sup]              INT             NULL,
    [ss_nb]               NVARCHAR (50)   NULL,
    [lastname]            NVARCHAR (255)  NOT NULL,
    [firstname]           NVARCHAR (255)  NOT NULL,
    [email]               NVARCHAR (255)  NOT NULL,
    [birth_date]          DATETIME        NULL,
    [home_phone]          NVARCHAR (50)   NULL,
    [mobile_phone]        NVARCHAR (50)   NULL,
    [address_street]      NVARCHAR (255)  NULL,
    [address_postal_code] NVARCHAR (255)  NULL,
    [address_city]        NVARCHAR (255)  NULL,
    [address_country]     NVARCHAR (255)  NULL,
    [family_situation]    NVARCHAR (255)  NULL,
    [children_nb]         INT             NULL,
    [image]               VARBINARY (MAX) NULL,
    [attachment]          NVARCHAR (MAX)  NULL,
    [id_sup2]             INT             NULL,
    CONSTRAINT [PK_k_collaborateurs] PRIMARY KEY CLUSTERED ([idPayee] ASC),
    CONSTRAINT [FK_k_collaborateurs_k_collaborateurs] FOREIGN KEY ([id_sup]) REFERENCES [dbo].[py_Payee] ([idPayee])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_k_collaborateurs]
    ON [dbo].[py_Payee]([codePayee] ASC);


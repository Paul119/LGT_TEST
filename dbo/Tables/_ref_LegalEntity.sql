CREATE TABLE [dbo].[_ref_LegalEntity] (
    [LegalEntityId]        INT            IDENTITY (1, 1) NOT NULL,
    [RegulatoryRegionCode] NVARCHAR (3)   NULL,
    [CompanyCode]          NVARCHAR (4)   NOT NULL,
    [CompanyDescription]   NVARCHAR (50)  NULL,
    [Adress]               NVARCHAR (255) NULL,
    [Phone]                NVARCHAR (50)  NULL,
    [Website]              NVARCHAR (50)  NULL,
    [Email]                NVARCHAR (50)  NULL,
    [Fax]                  NVARCHAR (50)  NULL,
    [EstablishmentID]      NVARCHAR (15)  NULL,
    [LocationCode]         NVARCHAR (15)  NULL,
    [Location]             NVARCHAR (50)  NULL,
    [nb_months]            INT            NULL,
    CONSTRAINT [pk_ref_LegalEntity_LegalEntityId] PRIMARY KEY CLUSTERED ([LegalEntityId] ASC)
);


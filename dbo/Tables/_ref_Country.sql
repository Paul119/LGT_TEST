CREATE TABLE [dbo].[_ref_Country] (
    [CountryId]         INT            IDENTITY (1, 1) NOT NULL,
    [CountryCode]       NVARCHAR (3)   NOT NULL,
    [CountryName]       NVARCHAR (50)  NULL,
    [SocialSecutiryPct] DECIMAL (4, 2) NULL,
    CONSTRAINT [pk_ref_Country_CountryId] PRIMARY KEY CLUSTERED ([CountryId] ASC)
);


CREATE TABLE [dbo].[k_cultures_parameters] (
    [id]                      INT           IDENTITY (1, 1) NOT NULL,
    [culture]                 NVARCHAR (50) NULL,
    [thousandSeparatorSymbol] CHAR (1)      NULL,
    [decimalSeparatorSymbol]  CHAR (1)      NULL,
    [datetimeFormat]          NVARCHAR (50) NULL,
    [dateFormat]              NVARCHAR (50) NULL,
    [userControlDateFormat]   NVARCHAR (50) CONSTRAINT [DF_k_cultures_parameters_userControlDateFormat] DEFAULT ('Do MMMM YYYY') NOT NULL,
    CONSTRAINT [PK_k_cultures_parameters] PRIMARY KEY CLUSTERED ([id] ASC)
);


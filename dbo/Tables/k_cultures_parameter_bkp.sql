CREATE TABLE [dbo].[k_cultures_parameter_bkp] (
    [id]                      INT           IDENTITY (1, 1) NOT NULL,
    [culture]                 NVARCHAR (50) NULL,
    [thousandSeparatorSymbol] CHAR (1)      NULL,
    [decimalSeparatorSymbol]  CHAR (1)      NULL,
    [datetimeFormat]          NVARCHAR (50) NULL,
    [dateFormat]              NVARCHAR (50) NULL,
    [userControlDateFormat]   NVARCHAR (50) NOT NULL
);


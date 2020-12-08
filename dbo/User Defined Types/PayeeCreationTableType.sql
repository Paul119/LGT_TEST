CREATE TYPE [dbo].[PayeeCreationTableType] AS TABLE (
    [codePayee] INT            NOT NULL,
    [email]     NVARCHAR (100) NOT NULL,
    [lastname]  NVARCHAR (50)  NOT NULL,
    [firstname] NVARCHAR (50)  NOT NULL,
    PRIMARY KEY CLUSTERED ([codePayee] ASC));


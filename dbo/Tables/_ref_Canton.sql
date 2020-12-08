CREATE TABLE [dbo].[_ref_Canton] (
    [CantonId]   INT            IDENTITY (1, 1) NOT NULL,
    [CantonCode] NVARCHAR (3)   NOT NULL,
    [CantonName] NVARCHAR (50)  NULL,
    [TaxRate]    DECIMAL (4, 2) NULL,
    CONSTRAINT [pk_ref_Canton_CantonId] PRIMARY KEY CLUSTERED ([CantonId] ASC)
);


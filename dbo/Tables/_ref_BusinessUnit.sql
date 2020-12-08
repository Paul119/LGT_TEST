CREATE TABLE [dbo].[_ref_BusinessUnit] (
    [BusinessUnitId]          INT           IDENTITY (1, 1) NOT NULL,
    [BusinessUnitCode]        NVARCHAR (5)  NOT NULL,
    [BusinessUnitDescription] NVARCHAR (50) NULL,
    CONSTRAINT [pk_ref_BusinessUnit_BusinessUnitId] PRIMARY KEY CLUSTERED ([BusinessUnitId] ASC)
);


CREATE TABLE [dbo].[_ref_Gender] (
    [GenderId]          INT           IDENTITY (1, 1) NOT NULL,
    [GenderCode]        NVARCHAR (5)  NOT NULL,
    [GenderDescription] NVARCHAR (50) NULL,
    CONSTRAINT [pk_ref_Gender_GenderId] PRIMARY KEY CLUSTERED ([GenderId] ASC)
);


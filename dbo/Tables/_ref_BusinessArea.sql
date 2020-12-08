CREATE TABLE [dbo].[_ref_BusinessArea] (
    [BusinessAreaId]          INT           IDENTITY (1, 1) NOT NULL,
    [BusinessAreaCode]        NVARCHAR (10) NOT NULL,
    [BusinessAreaDescription] NVARCHAR (50) NULL,
    CONSTRAINT [pk_ref_BusinessArea_BusinessAreaId] PRIMARY KEY CLUSTERED ([BusinessAreaId] ASC)
);


CREATE TABLE [dbo].[_ref_Academy] (
    [AcademyId]        INT           IDENTITY (1, 1) NOT NULL,
    [Academy_Name]     NVARCHAR (50) NOT NULL,
    [Academy_Duration] NVARCHAR (50) NULL,
    [Academy_Language] NVARCHAR (50) NULL,
    [Academy_Who]      NVARCHAR (50) NULL,
    CONSTRAINT [pk_ref_Academy_AcademyId] PRIMARY KEY CLUSTERED ([AcademyId] ASC)
);


CREATE TABLE [dbo].[_tb_employee_Title_20201020091417] (
    [employeeTitleId]  INT          IDENTITY (1, 1) NOT NULL,
    [IdPayee]          INT          NULL,
    [PersonnelNumber]  INT          NULL,
    [EffectiveDate]    DATE         NULL,
    [EndDate]          DATE         NULL,
    [TitleCode]        NVARCHAR (6) NULL,
    [id_user]          INT          NULL,
    [CreatedDate]      DATETIME     NULL,
    [ModificationDate] DATETIME     NULL,
    [ParentId]         INT          NULL
);


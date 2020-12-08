CREATE TABLE [dbo].[_ref_PayrollType] (
    [PayrollTypeId]          INT           IDENTITY (1, 1) NOT NULL,
    [PayrollTypeCode]        NVARCHAR (10) NULL,
    [PayrollTypeDescription] NVARCHAR (50) NULL,
    [RateCodeType]           NVARCHAR (10) NULL,
    [RateCodeClass]          NVARCHAR (6)  NULL,
    CONSTRAINT [pk_ref_PayrollType_PayrollTypeId] PRIMARY KEY CLUSTERED ([PayrollTypeId] ASC)
);


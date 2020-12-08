CREATE TABLE [dbo].[_ref_CostCenter] (
    [CostCenterId]          INT           IDENTITY (1, 1) NOT NULL,
    [CostCenterCode]        NVARCHAR (5)  NOT NULL,
    [CostCenterDescription] NVARCHAR (50) NULL,
    CONSTRAINT [pk_ref_CostCenter_CostCenterId] PRIMARY KEY CLUSTERED ([CostCenterId] ASC)
);


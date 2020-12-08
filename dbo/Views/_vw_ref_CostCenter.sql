
CREATE VIEW [dbo].[_vw_ref_CostCenter]
AS


SELECT [CostCenterId]
      ,[CostCenterCode]
      ,[CostCenterDescription]
	  ,[CostCenterCode]+' - '+[CostCenterDescription] as [CostCenterCodeandDescription]
  FROM [dbo].[_ref_CostCenter]
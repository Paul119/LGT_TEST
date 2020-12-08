
CREATE VIEW [dbo].[_vw_ref_Department]
AS

SELECT [DepartmentId]
      ,[DepartmentCode]
      ,[DepartmentShortCode]
      ,[DepartmentShortDescription]
	  ,[DepartmentShortCode]+' - '+[DepartmentShortDescription] as [DepartmentShortCodeandDescription]
  FROM [dbo].[_ref_Department]
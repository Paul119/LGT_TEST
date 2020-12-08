CREATE VIEW _vw_employee_fte
AS
SELECT 
pp.codePayee AS PersonnelNumber

	  ,CAST(fte.EffectiveDate AS DATE) AS EffectiveDate
	  ,CAST(fte.EndDate AS DATE) AS EndDate
	  ,fte.FTE
	  ,FTE.ParentId
	  
	   FROM _tb_employee_fte fte
INNER JOIN py_Payee pp
ON fte.idPayee = fte.IdPayee
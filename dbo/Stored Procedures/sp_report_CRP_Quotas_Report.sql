

CREATE     PROCEDURE [dbo].[sp_report_CRP_Quotas_Report]  
(@year INT, @group NVARCHAR(3))  
AS
BEGIN

	DROP TABLE IF EXISTS #calc

	DECLARE @date DATETIME = '12/31/'+CAST(@year-1 AS NVARCHAR(4))

	;
	WITH cte_comp
	AS
	(SELECT
			t.IdPayee
		   ,t.PersonnelNumber
		   ,CAST(SUM(t.PaidCHF) AS DECIMAL(18,2)) AS Total
		FROM (
			-- Salary and Bonus
			SELECT
				CASE
					WHEN Rate IS NULL THEN tec.PaidValue
					ELSE Rate * PaidValue
				END AS PaidCHF
			   ,tec.*
			FROM _tb_employee_compensation tec
			LEFT JOIN _tb_fx_rates_to_chf tfrtc
				ON tfrtc.CurrencyCode = tec.Currency
				AND YEAR(tec.AwardDate) = tfrtc.year
			WHERE 1 = 1
			--AND PayrollType = '000001'
			AND tec.PaidValue IS NOT NULL
			AND @date BETWEEN AwardDate AND EndDate
			AND tec.PayrollType NOT IN ('000008', '000009', '000010') -- Exclude HF Point, PE Point, LTIS

			UNION ALL

			-- HF Point
			SELECT
				tpv.HFValue * tec.TargetValue AS PaidCHF
			   ,tec.*
			FROM _tb_employee_compensation tec
			LEFT JOIN _tb_Point_Values tpv
				ON tpv.year = YEAR(tec.AwardDate)
			WHERE 1 = 1
			AND tec.TargetValue IS NOT NULL
			AND @date BETWEEN AwardDate AND EndDate
			AND tec.PayrollType = '000008' -- HF Point

			UNION ALL

			-- PE Point
			SELECT
				tpv.PEValue * tec.TargetValue AS PaidCHF
			   ,tec.*
			FROM _tb_employee_compensation tec
			LEFT JOIN _tb_Point_Values tpv
				ON tpv.year = YEAR(tec.AwardDate)
			WHERE 1 = 1
			AND tec.TargetValue IS NOT NULL
			AND @date BETWEEN AwardDate AND EndDate
			AND tec.PayrollType = '000009' -- HF Point 
		) t
		GROUP BY t.IdPayee
				,t.PersonnelNumber)


	

	SELECT
		CASE WHEN @group = 'All' THEN 'All' ELSE tqe.SEG END AS SEG
	   ,CASE
			WHEN tet.TitleCode = '000090' THEN 'Managing Partner'
			WHEN tet.TitleCode = '000140' OR
				tet.TitleCode = '000130' THEN 'Partner Principles'
			ELSE 'Regular Staff'
		END AS Title
	   ,COUNT(*) AS HC
	   ,CAST(SUM(Total) AS DECIMAL(18,2)) AS Total_Comp
	   ,CAST(SUM(Total) / COUNT(*) AS DECIMAL(18,2)) AS intersection
	   INTO #calc
	FROM _tb_quota_employee tqe
	LEFT JOIN _tb_employee_Title tet
		ON tqe.PersID = tet.PersonnelNumber
			AND @date BETWEEN tet.EffectiveDate AND tet.EndDate
	JOIN _ref_JobTitle rjt
		ON rjt.JobTitleCode = tet.TitleCode
	LEFT JOIN cte_comp
		ON tet.PersonnelNumber = cte_comp.PersonnelNumber
	WHERE (@group = 'All' OR @group = tqe.SEG)
	GROUP BY CASE WHEN @group = 'All' THEN 'All' ELSE tqe.SEG END
			,CASE
				 WHEN tet.TitleCode = '000090' THEN 'Managing Partner'
				 WHEN tet.TitleCode = '000140' OR
					 tet.TitleCode = '000130' THEN 'Partner Principles'
				 ELSE 'Regular Staff'
			 END

	ORDER BY 1, 2 DESC

	DECLARE @regular AS DECIMAL(18,2) = (SELECT c.intersection FROM #calc c WHERE c.Title = 'Regular Staff')

	SELECT c.SEG
		  ,c.Title
		  ,c.HC
		  ,c.Total_Comp
		  ,c.intersection
		  ,CAST(NULLIF(c.intersection/@regular,1) AS DECIMAL(18,2)) AS quota
		  FROM #calc c
	ORDER BY c.HC desc

	




END
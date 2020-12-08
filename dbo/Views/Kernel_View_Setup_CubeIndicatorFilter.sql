-- =============================================
-- Author		: Deniz Kocaboğa
-- Alter Date	: 29.05.2015
-- Description	: Task 1160
-- =============================================
CREATE VIEW [dbo].[Kernel_View_Setup_CubeIndicatorFilter]  
AS  
SELECT	F.id_ind,  
		F.id_reference,
		FV.id_olap_filter_value,  
		name_reference,  
		type_reference,  
		name_object_reference,
        F.id_filter
	FROM dbo.k_m_indicators_olap_filters F
	INNER JOIN dbo.k_m_indicators_olap_filters_values FV
		ON F.id_olap_filter = FV.id_olap_filter
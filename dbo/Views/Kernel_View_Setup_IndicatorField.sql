CREATE VIEW [dbo].[Kernel_View_Setup_IndicatorField]
AS
SELECT        dbo.k_m_indicators_fields.id_field, dbo.k_m_indicators.id_ind, dbo.k_m_indicators.name_ind AS indicator_name
FROM            dbo.k_m_indicators INNER JOIN
                         dbo.k_m_indicators_fields ON dbo.k_m_indicators.id_ind = dbo.k_m_indicators_fields.id_ind
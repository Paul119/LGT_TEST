CREATE VIEW [dbo].[Kernel_View_Payee_Culture] 
AS
SELECT     id, label, value, culture, sort
FROM         dbo.k_cultures
WHERE     (culture =
(SELECT     TOP (1) value_parameter
    FROM          dbo.k_parameters
    WHERE      (key_parameter = 'PRM_GlobalCulture')))
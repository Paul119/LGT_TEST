CREATE VIEW [dbo].[Kernel_View_Setup_UserControlAction]
AS
SELECT        dbo.act_UserControlAction.id AS controlAction_id, dbo.act_ActionType.name AS ActionTypeName, dbo.act_Action.name AS ActionName, 
                         dbo.k_m_fields.name_field AS FieldName
FROM            dbo.act_UserControlAction INNER JOIN
                         dbo.act_UserControl ON dbo.act_UserControlAction.idControl = dbo.act_UserControl.id AND 
                         dbo.act_UserControlAction.idControl = dbo.act_UserControl.id INNER JOIN
                         dbo.act_ActionType ON dbo.act_UserControlAction.idActionType = dbo.act_ActionType.id INNER JOIN
                         dbo.act_Action ON dbo.act_UserControlAction.idAction = dbo.act_Action.id INNER JOIN
                         dbo.k_m_fields ON PARSENAME(REPLACE(dbo.act_UserControl.controlKey, '_', '.'), 1) = dbo.k_m_fields.id_field
WHERE        (dbo.k_m_fields.id_field IN
                             (SELECT        PARSENAME(REPLACE(act_UserControl_1.controlKey, '_', '.'), 1) AS id_field
                               FROM            dbo.act_UserControl AS act_UserControl_1 CROSS JOIN
                                                         dbo.act_UserControlAction AS act_UserControlAction_1))
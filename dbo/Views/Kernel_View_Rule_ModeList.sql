CREATE VIEW [dbo].[Kernel_View_Rule_ModeList]
       AS     
       select 'GV_complete' AS name,'complete' AS value
       UNION ALL
       select 'GV_incremental' AS name,'incremental' AS value
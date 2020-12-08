


CREATE    PROCEDURE [dbo].[sp_audit_log]
(
	@Category [nvarchar](255),		--Events Hierarchy level 1
	@Process [nvarchar](255),		--Events Hierarchy level 2
	@SubProcess [nvarchar](255),	--Events (Names of the stored procedures)
	@StartDate [datetime],			--Start date to be used as a key (to know which records belong to each other)

	@EventText [nvarchar](1000),
	
	@AuditId [int],					--For ETL only
	@UserId [int],					--For application only
	
	@ErrorFlag [bit] = 0,				--If not provided it is not a technical error
	@ErrorText [nvarchar](MAX) = NULL,  --If not provided NULL in error text
	@ErrorLine [int] = NULL				--If not provided NULL in error line
)
AS
BEGIN 
SET NOCOUNT ON;
/*   
==========================================================================
Called by:		All stored procedures
Parameters:     
				  @Category		= Hierarchy of subprocesses level 1
				, @Process		= Hierarchy of subprocesses level 2
				, @SubProcess	= This whould be the stored procedured calling this procedure
				, @StartDate	= This is part of the key, meant to identified one single action in two rows (startevent and endevent for example)
				, @EventText	= This is the description of the event logged
				, @AuditId		= This is the Id of the ETL package (only used in the ETL)
				, @UserId		= This is the Id of the user executing the procedure (only used in the application)
				, @ErrorFlag	= This is either 0 or 1. 0 when the event is not an error but more a log of an action done (started, finished...)
				, @ErrorText	= This is the text of the error (got by the sql function error_text() in the catch part of a procedure
				, @ErrorLine	= This is the line of the error (got by the sql function error_line(à in the catch part of a procedure

Returns:        0
Description:    Used to insert in the tb_audit_log table. This table only gets inserts and deletes after a while; no updates
				The same table is used accross the application to get logs
==========================================================================
Date			Author			Change
---------------------------------------------
20/03/2017		D. RUIZ			Creation
==========================================================================
*/
	/*Default parameters:*/
	 --DECLARE 
		--@Category [nvarchar](255)	= 'Category',	
		--@Process [nvarchar](255)	= 'Process',		
		--@SubProcess [nvarchar](255) = 'SubProcess',	
		--@StartDate [datetime]		= GETDATE(),	

		--@EventText [nvarchar](1000) = 'EventText',
	
		--@AuditId [int]				= NULL,				
		--@UserId [int]				= -1,				
	
		--@ErrorFlag [bit]			= 1,
		--@ErrorText [nvarchar](MAX)	= 'ErrorText',
		--@ErrorLine [int]			= 39

		
	/*Insert the values in the log table:*/		
	INSERT INTO [dbo].[_tb_audit_log] ( Category, Process, SubProcess, StartDate, EventText, EventDate, AuditId, UserId, ErrorFlag, ErrorText, ErrorLine)
	VALUES (@Category, @Process, @SubProcess, @StartDate, @EventText, GETDATE(), @AuditId, @UserId, @ErrorFlag, @ErrorText, @ErrorLine)


	--SELECT * FROM 
	
	RETURN 0;--Returned by the procedure as ok

		
END --End procedure
CREATE PROC [dbo].[Kernel_SP_Data_GetForm](@IdForm int,@WhereClause Nvarchar(4000),@idTenant INT = NULL)                  
AS                  
BEGIN                  
DECLARE @NameTableView nvarchar(50);                  
DECLARE @SQL nvarchar(4000);                  
DECLARE @IdTable_View int;                  
DECLARE @RESULT NVARCHAR(4000)              
DECLARE @COLNAME NVARCHAR(255)              
DECLARE @COLCOUNT BIGINT              
DECLARE @TYPE NVARCHAR(20)        
DECLARE @PRIMARYCOLUMNNAME nvarchar(50)            
DECLARE @PRIMARYKEYNAME nvarchar(100)                  
DECLARE @GROUPNAME nvarchar(100)        
      
IF @WhereClause = ''      
BEGIN      
SET @WhereClause  = NULL;      
END      
         
 SELECT @IdTable_View = table_view_id                   
   FROM k_referential_form WITH (NOLOCK)                  
  WHERE form_id = @IdForm;                  
      
    
                  
 SELECT @NameTableView = NAME_TABLE_VIEW                   
   FROM K_REFERENTIAL_TABLES_VIEWS                   
  WHERE ID_TABLE_VIEW = @IdTable_View                  
              
 DECLARE CUSTLIST CURSOR FOR              
   SELECT NAME_FIELD,ROW_NUMBER() OVER (ORDER BY ORDER_FIELD) AS ORDROWS ,type_field         
     FROM K_REFERENTIAL_TABLES_VIEWS_FIELDS               
    WHERE ID_FIELD IN(SELECT table_view_field_id    
         FROM k_referential_form_field               
        WHERE FORM_ID = @IdForm)              
    ORDER BY ORDER_FIELD              
              
 OPEN CUSTLIST              
 FETCH NEXT FROM CUSTLIST               
 INTO @COLNAME,@COLCOUNT,@TYPE              
 WHILE @@FETCH_STATUS = 0              
 BEGIN              
               
 IF @COLCOUNT >1              
  BEGIN           
   IF @TYPE = 'datetime'        
    BEGIN        
    SET @RESULT = @RESULT + ', ' + +'SUBSTRING(convert(varchar(20),'+@COLNAME+', 101) '+'+'' '' + convert(varchar(20),'+@COLNAME+', 114),0,20) AS '  +@COLNAME;        
    END        
  ELSE        
    BEGIN        
    SET @RESULT = @RESULT + ', ' + +'['+@COLNAME+']';        
    END        
   END         
     ELSE              
      BEGIN               
    IF @TYPE = 'datetime'        
     BEGIN        
     SET @RESULT = @RESULT + ', ' + +'SUBSTRING(convert(varchar(20),'+@COLNAME+', 101) '+ '+'' '' + convert(varchar(20),'+@COLNAME+', 114),0,20) AS '  +@COLNAME;        
     END        
    ELSE        
     BEGIN        
   SET @RESULT =  '['+@COLNAME+']';              
     END        
  END       
                
   FETCH NEXT FROM CUSTLIST INTO @COLNAME,@COLCOUNT,@TYPE              
 END              
 CLOSE CUSTLIST              
 DEALLOCATE CUSTLIST              
     
        
        
  IF @WhereClause IS NOT NULL      
    BEGIN      
     SET @SQL = 'SELECT '+ @RESULT+' FROM ' + @NameTableView + ' WITH (NOLOCK) ' + @WhereClause ;      
    END       
  ELSE      
       BEGIN                 
        SET @SQL = 'SELECT '+ @RESULT+' FROM ' + @NameTableView + ' WITH (NOLOCK)';                  
       END      
        
    
      
  EXECUTE(@SQL);                  
                   
      
END
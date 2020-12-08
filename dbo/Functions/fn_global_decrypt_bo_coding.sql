CREATE FUNCTION [dbo].[fn_global_decrypt_bo_coding](@text NVARCHAR(MAX))  
RETURNS NVARCHAR(MAX)  
AS  
BEGIN  
/*    
==========================================================================  
Called by:  sp_global_refresh_population  
 
Parameter:      @text  
 
Returns:        NVARCHAR(MAX)  
 
Description:    Function decrypt Business Objects in populationTable to be read by SQL and added as a where clause  
SELECT [dbo].[fn_decrypt_bo_coding] ('{bo:76}=[''G_7489'']AND{bo:77}in([''Americas''],[''Asia Pacific''],[''EMEA''],[''Germany''],[''UK''])AND{bo:75}=[''General Employees'']')  
 
==========================================================================        
Date  Author      Change  
---------------------------------------------  
26/09/2017  D. RUIZ  Creation  
 
==========================================================================  
*/  
--SELECT @text  
DECLARE @pos INT  
DECLARE @pos2 int  
SELECT @pos=PATINDEX('%{%',@text)  
SELECT @pos2=PATINDEX('%}%',@text)  
--SELECT @pos, @pos2 -- position of the opening and closing parentasis  
 
DECLARE @id_bo INT  
DECLARE @substring nvarchar(255)  
DECLARE @field_name nvarchar(255)  
 
SELECT @text = REPLACE(@text, '[', ' ')  
SELECT @text = REPLACE(@text, ']', ' ')  
WHILE @pos > 0 and @pos2 > 0  
BEGIN  
   
   SELECT @substring = SUBSTRING(@text, @pos, @pos2 - @pos + 1) -- {bo: 1223}  
SELECT @id_bo = SUBSTRING(@substring, PATINDEX('%[0-9]%',@substring), LEN(@substring) - PATINDEX('%[0-9]%',@substring)) -- returns the id of the bo  
 
SELECT @field_name = value_field_preview FROM k_program_cond_fields WHERE id_field = @id_bo  
 
SELECT @text = REPLACE(@text, @substring, ' ' + @field_name + ' ')  
 
SELECT @pos=PATINDEX('%{%',@text)  
SELECT @pos2=PATINDEX('%}%',@text)  
END  
 
RETURN @text  
 
END
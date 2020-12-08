

CREATE FUNCTION [dbo].[fn_Round_Salary_Month]
(
	  @salary DECIMAL, @month DECIMAL
) RETURNS INT
AS
	BEGIN
			--DECLARE  @q int = CEILING(@salary / @month)
			--DECLARE @result INT = @q*@month

			DECLARE @result INT

		    SELECT @result = (CEILING(@salary/@month)+ CASE WHEN CEILING(@salary/@month)%5 = 0 THEN 0 ELSE 5 - CEILING(@salary/@month)%5 END)*@month

			RETURN @result

	END
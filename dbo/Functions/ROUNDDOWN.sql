CREATE Function [dbo].[ROUNDDOWN](@Val Decimal(32,16), @Digits Int)
Returns Decimal(32,16)
AS
Begin
 declare @result decimal(32,16)
 if @Digits >= 0
  set @result = FLOOR(@Val * POWER(10.0, @Digits)) / POWER(10.0, @Digits)
 else
     set @result = @Val

 return @result
End
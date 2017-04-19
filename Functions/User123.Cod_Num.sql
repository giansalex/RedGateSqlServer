SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [User123].[Cod_Num](@RucE nvarchar(11))
returns nvarchar(7) AS
begin 
      declare @c nvarchar(7), @n int
      select @c = count(Cd_Num) from Numeracion where RucE=@RucE
      if @c=0
	set @c='N000001'
      else
	begin
	select @c=max(Cd_Num) from Numeracion where RucE=@RucE
	set @c= right(@c,5)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = 'N'+right('000000'+ltrim(str(@n)), 6)
	end
       return @c

end






GO

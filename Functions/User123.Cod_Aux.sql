SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [User123].[Cod_Aux](@RucE nvarchar(11))
returns nvarchar(7) AS
begin 
      declare @c nvarchar(7), @n int
      select @c = count(Cd_Aux) from Auxiliar where RucE=@RucE and left(Cd_Aux,1)='A'
      if @c=0
	set @c='AUX0001'
      else
	begin
	select @c=max(Cd_Aux) from Auxiliar where RucE=@RucE and left(Cd_Aux,1)='A'
	set @c= right(@c,4)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = 'AUX'+right('0000'+ltrim(str(@n)), 4)
	end
       return @c

end









GO

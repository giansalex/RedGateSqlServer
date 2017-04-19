SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [User123].[Cod_Vta](@RucE nvarchar(11))
returns nvarchar(10) AS
begin 
      declare @c nvarchar(10), @n int
      select @c = count(Cd_Vta) from Venta where RucE=@RucE
      if @c=0
	set @c='VT00000001'
      else
	begin
	select @c=max(Cd_Vta) from Venta where RucE=@RucE
	set @c= right(@c,8)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = 'VT'+right('00000000'+ltrim(str(@n)), 8)
	end
       return @c

end




GO

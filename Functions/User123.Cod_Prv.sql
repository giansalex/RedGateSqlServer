SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [User123].[Cod_Prv](@RucE nvarchar(11))
returns nvarchar(7) AS
begin 
      declare @c nvarchar(7), @n int
      select @c = count(Cd_Aux) from Proveedor where RucE=@RucE
      if @c=0
	set @c='PRV0001'
      else
	begin
	select @c=max(Cd_Aux) from Proveedor where RucE=@RucE
	set @c= right(@c,4)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = 'PRV'+right('0000'+ltrim(str(@n)), 4)
	end
       return @c
end





GO

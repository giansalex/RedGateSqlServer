SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cod_Prod2](@RucE nvarchar(11))
returns nvarchar(7) AS
begin 
      declare @c nvarchar(7), @n int
      select @n = count(Cd_Prod) from Producto2 where RucE=@RucE
      if @n=0
	set @c='PD00001'
      else
	begin
	select @c=max(Cd_Prod) from Producto2 where RucE=@RucE
	set @c= right(@c,5)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = 'PD'+right('0000'+ltrim(str(@n)), 5)
	end
       return @c
end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cd_Inv](@RucE nvarchar(11))
returns char(12) AS
begin 
      declare @c char(12), @n int
      select @n = count(*) from Inventario where RucE=@RucE
      if @n=0
	set @c='INV000000001'
      else
	begin
	select @c=max(Cd_Inv) from Inventario where RucE=@RucE
	set @c= right(@c,9)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = 'INV'+right('00000000'+ltrim(str(@n)), 9)
	end
       return @c
end
GO

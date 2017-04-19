SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [User123].[Cod_Cot](@RucE nvarchar(11))
returns char(10) AS
begin 
      declare @c char(10), @n int
      select @c = count(Cd_Cot) from Cotizacion where RucE=@RucE
      if @c=0
	set @c='CT00000001'
      else
	begin
	select @c=max(Cd_Cot) from Cotizacion where RucE=@RucE
	set @c= right(@c,8)  --> solo es necesario si lleva una letra adelante
	set @n =convert(int, @c)+1
	set @c = 'CT'+right('00000000'+ltrim(str(@n)), 8 )
	end
       return @c
end

GO

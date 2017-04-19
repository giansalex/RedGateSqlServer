SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [dbo].[Cd_Liq](@RucE nvarchar(11))
returns char(10) AS
begin 
	declare @c char(10), @n int,  @prefijo char(2)
	select @c =  count(Cd_Liq) from Liquidacion where RucE=@RucE
	set @prefijo = 'LF'  	
	if @c=0
		set @c='LF00000001'
      	else
	begin
		select @c=max(Cd_Liq) from Liquidacion where RucE=@RucE
		set @c= right(@c,8)  --> solo es necesario si lleva una letra adelante
		set @n =convert(int, @c)+1
		set @c = @prefijo+right('0000000'+ltrim(str(@n)), 8)
	end
       return @c
end
GO

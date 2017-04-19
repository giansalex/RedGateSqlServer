SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cod_Clt2](@RucE nvarchar(11))
returns char(10) AS
begin 
	declare @c char(10), @n int,  @prefijo char(3)
	select @c =  count(Cd_Clt) from Cliente2 where RucE=@RucE
	set @prefijo = 'CLT'  	
	if @c=0
		set @c='CLT0000001'
      	else
	begin
		select @c=max(Cd_Clt) from Cliente2 where RucE=@RucE
		set @c= right(@c,7)  --> solo es necesario si lleva una letra adelante
		set @n =convert(int, @c)+1
		set @c = 'CLT'+right('0000000'+ltrim(str(@n)), 7)
	end
       return @c
end

GO

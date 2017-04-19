SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Cd_OF](@RucE nvarchar(11))
returns char(10) AS
begin 
	declare @c char(10), @n int,  @prefijo char(2)
	select @c =  count(Cd_OF) from ordfabricacion where RucE=@RucE
	set @prefijo = 'OF'  	
	if @c=0
		set @c='OF00000001'
      	else
	begin
		select @c=max(Cd_OF) from ordfabricacion where RucE=@RucE
		set @c= right(@c,8)  --> solo es necesario si lleva una letra adelante
		set @n =convert(int, @c)+1
		set @c = 'OF'+right('00000000'+ltrim(str(@n)), 8)
	end
       return @c
end
GO

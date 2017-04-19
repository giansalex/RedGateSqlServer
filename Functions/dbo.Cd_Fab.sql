SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [dbo].[Cd_Fab](@RucE nvarchar(11))
returns char(10) AS
begin 
	declare @c char(10), @n int,  @prefijo char(2)
	select @c =  count(Cd_Fab) from fabfabricacion where RucE=@RucE
	set @prefijo = 'FAB'  	
	if @c=0
		set @c='FAB00000001'
      	else
	begin
		select @c=max(Cd_Fab) from fabfabricacion where RucE=@RucE
		set @c= right(@c,7)  --> solo es necesario si lleva una letra adelante
		set @n =convert(int, @c)+1
		set @c = 'FAB'+right('0000000'+ltrim(str(@n)), 7)
	end
       return @c
end
GO

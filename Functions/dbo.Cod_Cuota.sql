SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[Cod_Cuota](@RucE nvarchar(11))
returns int AS
begin 
	declare @c int, @n int
	select @c = count(Cd_Cuo) from Cuota where RucE = @RucE
	
	if @c=0
		set @c=1
	else
	begin
		select @c=max(Cd_Cuo) from Cuota where RucE = @RucE
		--set @c= right(@c,3)  --> solo es necesario si lleva una letra adelante
		set @n = @c + 1
		--set @c = right('000'+ltrim(str(@n)), 3 )
	end
    return @c
end







GO

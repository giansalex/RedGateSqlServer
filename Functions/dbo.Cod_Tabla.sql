SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[Cod_Tabla]()
returns char(4) 
as
begin
	declare @c char(4), @n int
	select @c = count(Cd_Tab) from Tabla where LEFT(Cd_Tab,2) = 'MN'

	if @c = 0
		set @c = 'MN01'
	else
	begin
		select @c = count(Cd_Tab) from Tabla where LEFT(Cd_Tab,2) = 'MN'
		set @n = convert(int,@c) + 1

		set @c = 'MN' + right('000' + ltrim(str(@n)),2)
	end
	return @c
end

--MP : 20/07/2012 <Modificacion del procedimiento almacenado>
/*
declare @aux nvarchar(4)
exec @aux = Cod_Tabla
print @aux
*/

GO

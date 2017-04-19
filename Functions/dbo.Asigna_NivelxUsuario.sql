SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[Asigna_NivelxUsuario](@NomUsu nvarchar(10))
returns nvarchar(100) 
AS
begin
	
	declare @nivel nvarchar(100), @n int
	select @nivel = Nivel, @n =(
	case 
	when LEN(Nivel) = null then 2
	when LEN(Nivel) = 2 then 4
	when LEN(Nivel) = 4 then LEN(Nivel) + 3
	when LEN(Nivel) = 7 then LEN(Nivel) + 4
	when LEN(Nivel) > 7 then LEN(Nivel) + 2
	--when LEN(Nivel) > 11 then LEN(Nivel) + 2
	--when 7 then 11
	end )
	from Usuario
	where NomUsu = @NomUsu

	declare @aux nvarchar(100)
	select @aux = max(nivel) from Usuario 
	where LEFT(Nivel, LEN(@nivel)) = ''+@nivel+'' and LEN(Nivel) = @n
	--print @nivel--PRUEBA
	--print @aux--PRUEBA

	declare @nuevoNivel int
	if(@n=2 OR @n=4)
	begin
		
		set @nuevoNivel = isnull(convert(int, RIGHT(@aux,2)),0)
		set @nuevoNivel = + @nuevoNivel + 1
		if(@nuevoNivel > 0 and @nuevoNivel < 10)
			set @nivel = '' + @nivel + '0' + convert(nvarchar(4),@nuevoNivel)
		else if(@nuevoNivel > 9 and @nuevoNivel < 100)
			set @nivel = '' + @nivel + '' + convert(nvarchar(4),@nuevoNivel)
		
	end
	else if(@n=7)
	begin

		set @nuevoNivel = isnull(convert(int, RIGHT(@aux,3)),0)
		set @nuevoNivel = + @nuevoNivel + 1
		if(@nuevoNivel > 0 and @nuevoNivel < 10)
			set @nivel = '' + @nivel + '00' + convert(nvarchar(4),@nuevoNivel)
		else if(@nuevoNivel > 9 and @nuevoNivel < 100)
			set @nivel = '' + @nivel + '0' + convert(nvarchar(4),@nuevoNivel)
		else if(@nuevoNivel > 99 and @nuevoNivel < 1000)
			set @nivel = '' + @nivel + '' + convert(nvarchar(4),@nuevoNivel)
		
	end
	else if (@n=11)
	begin

		set @nuevoNivel = isnull(convert(int, RIGHT(@aux,4),0),0)
		set @nuevoNivel = + @nuevoNivel + 1
		if(@nuevoNivel > 0 and @nuevoNivel < 10)
			set @nivel = '' + @nivel + '000' + convert(nvarchar(4),@nuevoNivel)
		else if(@nuevoNivel > 9 and @nuevoNivel < 100)
			set @nivel = '' + @nivel + '00' + convert(nvarchar(4),@nuevoNivel)
		else if(@nuevoNivel > 99 and @nuevoNivel < 1000)
			set @nivel = '' + @nivel + '0' + convert(nvarchar(4),@nuevoNivel)
		else
			set @nivel = '' + @nivel + '' + convert(nvarchar(4),@nuevoNivel)
			
	end
	else if (@n>11)
	begin

		set @nuevoNivel = isnull(convert(int, RIGHT(@aux,2),0),0)
		set @nuevoNivel = + @nuevoNivel + 1
		if(@nuevoNivel > 0 and @nuevoNivel < 10)
			set @nivel = '' + @nivel + '0' + convert(nvarchar(4),@nuevoNivel)
		else if(@nuevoNivel > 9 and @nuevoNivel < 100)
			set @nivel = '' + @nivel + '' + convert(nvarchar(4),@nuevoNivel)
			
	end

	--print @nivel

	return @nivel
end

--MP : 2011/06/01 : <Modificaciones del procedimiento almacenado>
GO

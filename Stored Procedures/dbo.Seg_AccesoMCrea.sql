SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_AccesoMCrea]
@Cd_GA int,
@Cadena nvarchar(4000),
@msj varchar(100) output
as

Declare @letra nvarchar(1)
Declare @valor nvarchar(10)
Declare @i int
Set @letra = ''
Set @valor = ''
Set @i = 1 

while(@i <= len(@Cadena))
begin
	Set @letra = Substring(@Cadena,@i,@i)
	Set @valor = @valor + @letra
	if(@letra = ',')
	begin
		Set @valor = left(@valor,len(@valor)-1)
		print @valor

		if exists (select * from AccesoM where Cd_GA=@Cd_GA and Cd_MN=@valor)
		begin
			set @msj = 'Acceso ya existe'
			return
		end
		else
		begin
			insert into AccesoM(Cd_GA,Cd_MN,Estado)
				     values(@Cd_GA,@valor,1)
		
			if @@rowcount <= 0
			begin
		        	set @msj = 'Acceso no pudo ser registrado'
				return
			end
			
		end
		
		Set @valor = ''
	end
	Set @i = @i + 1
end

-- Leyenda --
-------------

-- DI : 25/09/2009 Creacion del procedimiento almacenado

GO

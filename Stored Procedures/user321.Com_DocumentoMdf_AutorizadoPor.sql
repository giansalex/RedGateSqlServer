SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [user321].[Com_DocumentoMdf_AutorizadoPor]
@RucE nvarchar(11),
@Cd_Doc char(10),
@AutorizadoPor varchar(100),
@TipoDoc int,
@msj varchar(100) output
as
-----------------------------------------------------------------------------------------------------
declare @Cadena nvarchar(200)
declare @Tabla nvarchar(20)
declare @Campo nvarchar(10)
-----------------------------------------------------------------------------------------------------

if(@TipoDoc = 0)
begin
	set @Tabla = 'OrdCompra'
	set @Campo = 'Cd_OC'
end
else if(@TipoDoc = 1)
begin
	set @Tabla = 'OrdPedido'
	set @Campo = 'Cd_OP'
end
else if(@TipoDoc = 2)
begin
	set @Tabla = 'SolicitudCom'
	set @Campo = 'Cd_SCo'
end
else if(@TipoDoc = 3)
begin
	set @Tabla = 'SolicitudReq'
	set @Campo = 'Cd_SR'
end
-----------------------------------------------------------------------------------------------------
declare @cont int
set @Cadena = 'select @contador = count(*) from '+@Tabla+' where '+@Campo +' = '''+@Cd_Doc+''' and RucE = '''+@RucE+''''
exec sp_executesql @Cadena, N'@contador int output', @cont output

if (@cont=0)
begin
	set @msj = 'No existe la solicitud'
end
else
begin
	declare @Auts nvarchar(50)
	if(@TipoDoc = 0)
	set @Cadena = 'select @auto = AutdoPorN1 from '+@Tabla+'  where '+@Campo+' = '''+@Cd_Doc+''' and RucE = '''+@RucE+''''
	else
	set @Cadena = 'select @auto = AutorizadoPor from '+@Tabla+'  where '+@Campo+' = '''+@Cd_Doc+''' and RucE = '''+@RucE+''''

	exec sp_executesql @Cadena, N'@auto nvarchar(100) output', @Auts output

	if(len(@Auts)>0)	set @AutorizadoPor = @Auts + ', ' +@AutorizadoPor

	if(@TipoDoc = 0)
	set @Cadena = 'update '+@Tabla+' set AutdoPorN1 = '''+@AutorizadoPor+''' where '+@Campo+' = '''+@Cd_Doc+''' and RucE = '''+@RucE+''''
	else
	set @Cadena = 'update '+@Tabla+' set AutorizadoPor = '''+@AutorizadoPor+''' where '+@Campo+' = '''+@Cd_Doc+''' and RucE = '''+@RucE+''''

	exec(@Cadena)
end

-- MM : <Creacion del procedimiento almacenado>
GO

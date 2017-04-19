SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Cfg_ConsultaEstadoAutDocumento]
@RucE nvarchar(11),
@TipoDoc int,
@Cd_Doc char(10),
@msj varchar(100) output,
@resul int output
/*
	@resul -> 0 = ERROR
	@resul -> 1 = MENSAJE ALERTA
	@resul -> 2 = MENSAJE CONFIRMACION
	@resul -> 3 = FALTA AUTORIZAR
*/
as
--------------------------------------------------------------
declare @Tabla nvarchar(50)
declare @Campo nvarchar(20)
declare @Cadena nvarchar(4000)
declare @estAutDoc bit
declare @tipoAut int
declare @cont int
--------------------------------------------------------------
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
else if(@TipoDoc = 4)
begin
	set @Tabla = 'OrdFabricacion'
	set @Campo = 'Cd_OF'
end
else if(@TipoDoc = 5)
begin
	set @Tabla = 'Cotizacion'
	set @Campo = 'Cd_Cot'
end
----------------------------------------------------------------------------------------------------------------------------
set @Cadena = 'select @contador = count(*) from '+@Tabla+' where RucE = '''+@RucE+''' and '+@Campo+' = '''+@Cd_Doc+''''
exec sp_executesql @Cadena, N'@contador bit output', @cont output
if(@cont=0)
begin
	set @msj = 'No existe el documento'
	set @resul = 0
	return
end
----------------------------------------------------------------------------------------------------------------------------
set @Cadena = 'select @tipo = isnull(TipAut,0) from '+@Tabla+' where RucE = '''+@RucE+''' and '+@Campo+' = '''+@Cd_Doc+''''
exec sp_executesql @Cadena, N'@tipo int output', @tipoAut output
if(@tipoAut=0)
begin
	set @msj = 'Este documento no tiene una configuracion de autorizacion'
	set @resul = 1	
end
else
begin
	set @Cadena = 'select @estadoAut = isnull(IB_Aut,0) from '+@Tabla+' where RucE = '''+@RucE+''' and '+@Campo+' = '''+@Cd_Doc+''''
	exec sp_executesql @Cadena, N'@estadoAut bit output', @estAutDoc output
	
	if(@estAutDoc=1)
	begin
		set @msj = 'Este documento esta autorizado'
		set @resul = 2
	end
	else
		set @resul = 3
end

-- MM : 2011-03-10    : <Creacion del procedimiento almacenado>
/*
  declare @msj varchar(100)
  declare @res int 
  exec Cfg_ConsultaEstadoAutDocumento '11111111111', 3, 'SR00000014', @msj out, @res out
  print @msj
  print @res
*/
GO

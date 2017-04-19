SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Cfg_EliminarAutorizaciones2]
@RucE nvarchar(11),
@Cd_Doc char(10),
@TipoDoc int,
@msj varchar(100) output
as
------------------------------------------------------------------------------------------------------------------------
declare @Cadena nvarchar (200)
declare @Tabla varchar(10)
declare @Tabla2 varchar(15)
declare @Campo varchar(10)
------------------------------------------------------------------------------------------------------------------------
if(@TipoDoc = 0)
begin
	set @Tabla = 'AutOC'
	set @Campo = 'Cd_OC'
	set @Tabla2 = 'OrdCompra'
end
else if(@TipoDoc = 1)
begin
	set @Tabla = 'AutOP'
	set @Campo = 'Cd_OP'
	set @Tabla2 = 'OrdPedido'
end
else if(@TipoDoc = 2)
begin
	set @Tabla = 'AutSC'
	set @Campo = 'Cd_SCo'
	set @Tabla2 = 'SolicitudCom'
end
else if(@TipoDoc = 3)
begin
	set @Tabla = 'AutSR'
	set @Campo = 'Cd_SR'
	set @Tabla2 = 'SolicitudReq'
end
else if(@TipoDoc = 4)
begin
	set @Tabla = 'AutOF'
	set @Campo = 'Cd_OF'
	set @Tabla2 = 'OrdFabricacion'
end
else if(@TipoDoc = 5)
begin
	set @Tabla = 'AutCot'
	set @Campo = 'Cd_Cot'
	set @Tabla2 = 'Cotizacion'
end
------------------------------------------------------------------------------------------------------------------------
set @Cadena = 'delete from '+@Tabla+' where RucE ='''+@RucE+''' and '+@Campo+' = '''+@Cd_Doc+'''' 
exec(@Cadena)	

set @Cadena = 'update '+@Tabla2 + ' set IB_Aut = 0, AutorizadoPor = '''' where RucE = '''+@RucE +''' and '+@Campo+' = '''+@Cd_Doc+''''

exec(@Cadena)
if(@@rowcount<=0)
	set @msj = 'No se pudo modificar el estado de autorizacion del documento'


--LEYENDA--
-- MM : (11/02/11) <CREACION DEL SP>
-- MM : (07/06/11) <MODIFICACION DEL SP> : SE AGREGO LA ELIMINACION A COTIZACION
GO

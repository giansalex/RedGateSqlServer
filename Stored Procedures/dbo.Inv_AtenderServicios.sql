SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_AtenderServicios]
@RucE varchar(11),
@Cd_Doc char(10),
@TipoDoc int,
@CdServicios varchar(1000),
@msj varchar(100) output
as
declare @sql nvarchar(500)
declare @tabla varchar(50)
if(@TipoDoc = 0) -- SOLICITUD DE REQUERIMIENTOS
begin
	set @tabla = 'SolicitudReqDet'
end
else if(@TipoDoc = 1) -- SOLICITUD DE COMPRA
begin
	set @tabla = 'SolicitudComDet'
end
else if(@TipoDoc = 2) -- ORDEN DE COMPRA
begin
	set @tabla = 'OrdCompraDet'
end

--ACTUALIZACION
set @sql = 'update ' + @tabla + ' set IB_AtSrv = 1 where RucE =  ''' + @RucE+ ''' and Cd_Srv in (' + @CdServicios + ')'
exec sp_executesql @sql

--	LEYENDA
/*	MM : <03/08/11 : Creacion del SP>
	
*/
GO

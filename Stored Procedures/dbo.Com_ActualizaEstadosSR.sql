SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ActualizaEstadosSR]
@RucE varchar(11),
@Cd_SR char(10),
@msj varchar(100) output
as
--VALIDACION DEL DOCUMENTO
if not exists (select * from SolicitudReq where RucE = @RucE and Cd_SR = @Cd_SR)
begin
	set @msj = 'No existe la solicitud de requerimientos con codigo : ' + @Cd_SR
	return
end
--VARIABLES
declare @estPrd char(2), @estSrv char(2)

--OBTENCION DEL NUEVO ESTADO DE PRODUCTOS/SERVICIOS
set @estPrd = dbo.Com_ObtenerEstadoSR_Prod(@RucE,@Cd_SR)
set @estSrv = dbo.Com_ObtenerEstadoSR_Serv(@RucE,@Cd_SR)

--ACTUALIZACION DE ESTADOS
update SolicitudReq set Id_EstSR = @estPrd, Id_EstSRS = @estSrv
where RucE = @RucE and Cd_SR = @Cd_SR

if(@@rowcount = 0) set @msj = 'Error a modificar el estado de la SR'

--	LEYENDA
/*	MM : <26/07/11 : Creacion del SP>
	
*/
GO

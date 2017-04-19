SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ActualizaEstadosSC]
@RucE varchar(11),
@Cd_SCo char(10),
@msj varchar(100) output
as
--VALIDACION DEL DOCUMENTO
if not exists (select * from SolicitudCom where RucE = @RucE and Cd_SCo = @Cd_SCo)
begin
	set @msj = 'No existe la solicitud de compra con codigo : ' + @Cd_SCo
	return
end
--VARIABLES
declare @estPrd char(2), @estSrv char(2)

--OBTENCION DEL NUEVO ESTADO DE PRODUCTOS/SERVICIOS
set @estPrd = dbo.Com_ObtenerEstadoSC_Prod(@RucE,@Cd_SCo)
set @estSrv = dbo.Com_ObtenerEstadoSC_Serv(@RucE,@Cd_SCo)

--ACTUALIZACION DE ESTADOS
update SolicitudCom set Id_EstSC = @estPrd, Id_EstSCS = @estSrv
where RucE = @RucE and Cd_SCo = @Cd_SCo

if(@@rowcount = 0) set @msj = 'Error a modificar el estado de la SC'

--	LEYENDA
/*	MM : <26/07/11 : Creacion del SP>
	
*/
-- PRUEBAS
-- exec Com_ActualizaEstadosSC '11111111111','SC00000184',null
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudReq_ActualizaEstado]
@RucE varchar(11),
@Cd_SR char(10),
@msj varchar(100) output
as
--ESTADO PRODUCTO
select Cd_Prod, isnull(Cant,0) as Cant, ID_UMP, Cd_Srv, isnull(IB_AtSrv,0) as IB_AtSrv
from SolicitudReqDet where RucE = '11111111111' and Cd_SR = @Cd_SR
union all
select Cd_Prod, isnull(-Cant,0) as Cant, ID_UMP, Cd_Srv, isnull(IB_AtSrv,0) as IB_AtSrv
from SolicitudComDet where RucE = '11111111111' and Cd_SR = @Cd_SR
union all
select Cd_Prod, isnull(-Cant,0) as Cant, ID_UMP, null as Cd_Srv, 0 as IB_AtSrv
from Inventario where RucE = '11111111111' and Cd_SR = @Cd_SR
--ESTADO SERVICIO

--	LEYENDA
/*	MM : <08/08/11 : Creacion del SP>
	
*/
GO

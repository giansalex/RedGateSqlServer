SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Com_VerificaPendientes_SolicitudReq]
@RucE nvarchar(11),
@Cd_SR char(10),
@msj varchar(100) output
as
--Calcula pendientes:
declare @pend decimal(13,6), @cd char(10)
select @cd = Cd_SCo from SolicitudCom where RucE = @RucE and Cd_SR = @Cd_SR
select @pend = sum(t.pendiente) from (select Cant-ABS(isnull((select sum(Cant) from SolicitudComDet i where i.RucE = c.RucE and i.Cd_SC = @cd and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0) ) as pendiente 
from SolicitudReqDet c where c.RucE = @RucE and c.Cd_SR = @Cd_SR and c.Cd_Prod is not null) t
print @pend

--Calcula el total de productos de la SR:
declare @totalcant decimal(13,6) 
select @totalcant = sum(Cant) from SolicitudReqDet c where c.RucE = @RucE and c.Cd_SR = @Cd_SR
print @totalcant

--Verifico:
if(@pend = @totalcant)
begin
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,@Cd_SR,null,null,null,null,null,1,@msj output
end
else
if(@pend > 0)
begin
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,@Cd_SR,null,null,null,null,null,2,@msj output
end
else
begin
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,@Cd_SR,null,null,null,null,null,3,@msj output
end
-- LEYENDA
-- CAM <04/02/2011><Creacion del SP>
-- CAM <15/02/2011><Modificacion del SP>
--	<Se cambio la invocacion de Inv_Inventario_EstadoUpd_1 a Inv_Inventario_EstadoUpd_2>
-- CAM <28/02/2011><Modificacion del SP>
--	<Se cambio la invocacion de Inv_Inventario_EstadoUpd_2 a Inv_Inventario_EstadoUpd_3>



GO

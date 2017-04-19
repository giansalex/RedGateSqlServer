SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Com_VerificaPendientes_SolicitudCom]
@RucE nvarchar(11),
@Cd_SCo char(10),
@msj varchar(100) output
as
--Calcula pendientes:
declare @pend decimal(13,6), @cd char(10)
select @cd = Cd_OC from OrdCompra where RucE = @RucE and Cd_SCo = @Cd_SCo
select @pend = sum(t.pendiente) from (select Cant-ABS(isnull((select sum(Cant) from OrdCompraDet i where i.RucE = c.RucE and i.Cd_OC = @cd and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0) ) as pendiente 
from SolicitudComDet c where c.RucE = @RucE and c.Cd_SC = @Cd_SCo and c.Cd_Prod is not null) t

--Calcula el total de productos de la SC:
declare @totalcant decimal(13,6) 
select @totalcant = sum(Cant) from SolicitudComDet c where c.RucE = @RucE and c.Cd_SC = @Cd_SCo
print @totalcant


--Verifico:
if(@pend = @totalcant)
begin
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,null,null,@Cd_SCo,null,null,null,7,@msj output
end
else
if(@pend > 0)
begin
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,null,null,@Cd_SCo,null,null,null,8,@msj output
end
else
begin
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,null,null,@Cd_SCo,null,null,null,9,@msj output
end
-- LEYENDA
-- CAM <04/02/2011><Creacion del SP>
-- CAM <28/02/2011><Modificacion del SP><cambio de Inv_Inventario_EstadoUpd_2 a Inv_Inventario_EstadoUpd_3>

--exec Com_VerificaPendientes_SolicitudCom '11111111111','OC00000032',''
GO

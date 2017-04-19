SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Inv_VerificaPendientes_OrdCompra]
@RucE nvarchar(11),
@Cd_OC char(10),
@msj varchar(100) output
as
declare @pend decimal(13,6) 
select @pend = sum(t.pendiente) from (select Cant-ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_OC = c.Cd_OC and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0) ) as pendiente 
from OrdCompraDet c where c.RucE = @RucE and c.Cd_OC = @Cd_OC and c.Cd_Prod is not null) t

declare @totalcant decimal(13,6) 
select @totalcant = sum(Cant) from OrdCompraDet c where c.RucE = @RucE and c.Cd_OC = @Cd_OC
print @totalcant

if(@pend = @totalcant)
begin
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,1,@msj output
end
else
if(@pend > 0)
begin
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,2,@msj output
end
else
begin
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,3,@msj output
end
-- LEYENDA
-- CAM <27/01/2011><Creacion del SP>
-- CAM 04/02/2011 - Cambio de Inv_Inventario_EstadoUpd a Inv_Inventario_EstadoUpd_1 que tiene GR
-- CAM 15/02/2011 - CAmbio de la invocacion de Inv_Inventario_EstadoUpd_1 a Inv_Inventario_EstadoUpd_2
-- CAM 15/02/2011 - CAmbio de la invocacion de Inv_Inventario_EstadoUpd_2 a Inv_Inventario_EstadoUpd_3

GO

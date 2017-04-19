SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Com_VerificaPendientes_OrdCompra]
@RucE nvarchar(11),
@Cd_OC char(10),
@msj varchar(100) output
as
--Calcula pendientes:
declare @pend decimal(13,6), @cd char(10)
select @cd = Cd_Com from Compra where RucE = @RucE and Cd_OC = @Cd_OC
print @cd
select @pend = sum(t.pendiente) from (select Cant-ABS(isnull((select sum(Cant) from CompraDet i where i.RucE = c.RucE and i.Cd_Com = @cd and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0) ) as pendiente 
from OrdCompraDet c where c.RucE = @RucE and c.Cd_OC = @Cd_OC and c.Cd_Prod is not null) t
print @pend

--Calcula el total de productos de la SC:
declare @totalcant decimal(13,6) 
select @totalcant = sum(Cant) from OrdCompraDet c where c.RucE = @RucE and c.Cd_OC = @Cd_OC
print @totalcant

--Verifico:
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
-- CAM <16/02/2011><Creacion del SP>
-- CAM <28/02/2011><Actualizacion del SP Inv_Inventario_EstadoUpd_2 al Inv_Inventario_EstadoUpd_3>

-- exec Com_VerificaPendientes_OrdCompra '11111111111','OC00000091',''

GO

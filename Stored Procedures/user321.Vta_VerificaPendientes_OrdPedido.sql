SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Vta_VerificaPendientes_OrdPedido]
@RucE nvarchar(11),
@Cd_OP nvarchar(10),
@msj varchar(100) output
as
--Calcula pendientes:
declare @pend decimal(13,6), @cd char(10)
select @cd = Cd_Vta from Venta where RucE = @RucE and Cd_OP = @Cd_OP
print @cd
select @pend = sum(t.pendiente) from (select Cant-ABS(isnull((select sum(Cant) from VentaDet i where i.RucE = c.RucE and i.Cd_Vta = @cd and i.Cd_Prod=c.Cd_Prod and i.Nro_RegVdt = c.Item),0) ) as pendiente 
from OrdPedidoDet c where c.RucE = @RucE and c.Cd_OP = @Cd_OP and c.Cd_Prod is not null) t
print @pend

--Calcula el total de productos de la SC:
declare @totalcant decimal(13,6) 
select @totalcant = sum(Cant) from OrdPedidoDet c where c.RucE = @RucE and c.Cd_OP = @Cd_OP
print @totalcant

--Verifico:
if(@pend = @totalcant)
begin
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,@Cd_OP,null,null,null,null,null,null,1,@msj output
end
else
if(@pend > 0)
begin
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,@Cd_OP,null,null,null,null,null,null,2,@msj output
end
else
begin
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,@Cd_OP,null,null,null,null,null,null,3,@msj output
end
-- LEYENDA
-- CAM <16/02/2011><Creacion del SP>
-- CAM <28/02/2011><Modificacion del SP> <Inv_Inventario_EstadoUpd_2 a Inv_Inventario_EstadoUpd_3>

-- exec Com_VerificaPendientes_OrdCompra '11111111111','OC00000091',''





GO

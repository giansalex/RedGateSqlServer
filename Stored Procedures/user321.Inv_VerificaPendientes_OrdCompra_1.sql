SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Inv_VerificaPendientes_OrdCompra_1]
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

declare @Id_EstOC char(2)
select @Id_EstOC = Id_EstOC from OrdCompra oc where oc.RucE = @RucE and oc.Cd_OC = @Cd_OC

if(@pend = @totalcant)
begin
	if(@Id_EstOC = '02' or @Id_EstOC = '03')
		exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,1,@msj output
	if(@Id_EstOC = '05' or @Id_EstOC = '06')
		exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,4,@msj output
		
end
else
if(@pend > 0)
begin
	if(@Id_EstOC = '01' or @Id_EstOC = '03')
		exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,2,@msj output
	if(@Id_EstOC = '04' or @Id_EstOC = '06')
		exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,5,@msj output
end
else
if(@pend = 0)
begin
	if(@Id_EstOC = '01' or @Id_EstOC = '02')
		exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,3,@msj output
	if(@Id_EstOC = '04' or @Id_EstOC = '05')
		exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,@Cd_OC,null,null,null,null,null,null,null,6,@msj output

end
-- LEYENDA
-- CAM <13/07/2011><Creacion del SP>
GO

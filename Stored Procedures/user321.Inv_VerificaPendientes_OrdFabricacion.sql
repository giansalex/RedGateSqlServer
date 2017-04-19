SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Inv_VerificaPendientes_OrdFabricacion]
@RucE nvarchar(11),
@Cd_OF  char(10),
@msj varchar(100) output
as
-- Calculo los pendientes de la OF
---------------------------------------------------------------------------
declare @pend_form decimal(13,6) 
select @pend_form = sum(t.pendiente) from (select Cant-ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_OF = c.Cd_OF and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0) ) as pendiente 
from FrmlaOF c where c.RucE = @RucE and c.Cd_OF = @Cd_OF and c.Cd_Prod is not null) t
--print @pend_form

declare @pend_env decimal(13,6) 
select @pend_env = sum(t.pendiente) from (select Cant-ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_OF = c.Cd_OF and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0) ) as pendiente 
from EnvEmbOF c where c.RucE = @RucE and c.Cd_OF = @Cd_OF and c.Cd_Prod is not null) t
--print @pend_env

declare @pend_total decimal(13,6)
set @pend_total = @pend_form + @pend_env
--print @pend_total
---------------------------------------------------------------------------
declare @cant_form decimal(13,6) 
select @cant_form = sum(Cant) from FrmlaOF c where c.RucE = @RucE and c.Cd_OF = @Cd_OF
--print @cant_form

declare @cant_env decimal(13,6) 
select @cant_env = sum(Cant) from EnvEmbOF c where c.RucE = @RucE and c.Cd_OF = @Cd_OF
--print @cant_env

declare @cant_total decimal(13,6) 
set @cant_total = @cant_form + @cant_env
--print @cant_total
---------------------------------------------------------------------------

if(@pend_total = @cant_total)
begin
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,null,null,null,null,@Cd_OF,null,1,@msj output
end
else if(@pend_total = 0)
begin
  exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,null,null,null,null,@Cd_OF,null,2,@msj output
end
--else
--begin
  --exec Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,null,null,null,null,@Cd_OF,null,3,@msj output
--end
-- LEYENDA
-- CAM <28/02/2011><Creacion del SP>

-- PRUEBAS
-- exec Inv_VerificaPendientes_OrdFabricacion '11111111111','OF00000006',''


GO

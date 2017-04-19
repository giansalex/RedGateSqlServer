SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Inv_VerificaPendientes_OrdFabricacion_1]
@RucE nvarchar(11),
@Cd_OF  char(10),
@msj varchar(100) output
as
-- Calculo los pendientes de la OF
---------------------------------------------------------------------------
declare @pend_form decimal(13,6) 
select @pend_form = sum(t.pendiente) from (select (c.Cant * op.Cant)-ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_OF = c.Cd_OF and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0) ) as pendiente 
from FrmlaOF c left join OrdFabricacion op on op.RucE = c.RucE and op.Cd_OF = c.Cd_OF
where c.RucE = @RucE and c.Cd_OF = @Cd_OF and c.Cd_Prod is not null) t
--print @pend_form

declare @pend_env decimal(13,6) 
select @pend_env = sum(t.pendiente) from (select (c.Cant * op.Cant)-ABS(isnull((select sum(Cant_Ing) from Inventario i where i.RucE = c.RucE and i.Cd_OF = c.Cd_OF and i.Cd_Prod=c.Cd_Prod and i.Item = c.Item),0) ) as pendiente 
from EnvEmbOF c left join OrdFabricacion op on op.RucE = c.RucE and op.Cd_OF = c.Cd_OF
where c.RucE = @RucE and c.Cd_OF = @Cd_OF and c.Cd_Prod is not null) t
if (@pend_env is null) set @pend_env = 0
--print @pend_env

declare @pend_total decimal(13,6)
set @pend_total = @pend_form + @pend_env
--print @pend_total
---------------------------------------------------------------------------
declare @cant_form decimal(13,6) 
select @cant_form = sum(c.Cant * op.Cant) from FrmlaOF c left join OrdFabricacion op on op.RucE = c.RucE and op.Cd_OF = c.Cd_OF
where c.RucE = @RucE and c.Cd_OF = @Cd_OF
--print @cant_form

declare @cant_env decimal(13,6) 
select @cant_env = sum(c.Cant * op.Cant) from EnvEmbOF c left join OrdFabricacion op on op.RucE = c.RucE and op.Cd_OF = c.Cd_OF
where c.RucE = @RucE and c.Cd_OF = @Cd_OF
if (@cant_env is null) set @cant_env = 0
--print @cant_env

declare @cant_total decimal(13,6) 
set @cant_total = @cant_form + @cant_env
--print @cant_total
---------------------------------------------------------------------------

if(@pend_total = @cant_total)
begin
  exec dbo.Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,null,null,null,null,@Cd_OF,null,1,@msj output
end
else if(@pend_total = 0)
begin
  exec dbo.Inv_Inventario_EstadoUpd_3 @RucE,null,null,null,null,null,null,null,null,@Cd_OF,null,2,@msj output
end

-- LEYENDA
-- CAM <28/02/2011><Creacion del SP>

-- PRUEBAS
-- exec Inv_VerificaPendientes_OrdFabricacion_1 '11111111111','OF00000053',''

GO

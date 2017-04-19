SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioValida]
@RucE nvarchar(11),
@CadenaCd_Prod  varchar(1000),
@FecMov datetime,
@msj varchar(100) output
as

declare @sql nvarchar(400)
declare @n int

set @sql = 'select @n = count(*) from Inventario  where RucE = '''+@RucE+''' and Cd_Prod in ('+@CadenaCd_Prod+') and FecMov > convert(datetime, '''+convert(varchar,@FecMov)+''')'

exec sp_executesql @sql,N'@n int output',@n output
if(@n >0)
begin
	set @msj  ='Existen registros posteriores , demandara recalcular los costos desea continuar'
	set @sql = 'select distinct RegCtb, FecMov from Inventario where RucE = '''+@RucE+''' and Cd_Prod in ('+@CadenaCd_Prod+') and FecMov > convert(datetime,'''+convert(varchar,@FecMov)+''')'
	exec (@sql)
end
print @sql
-- Leyenda --
-- PP : 2010-08-06 17:01:03.237	: <Creacion del procedimiento almacenado>
/*
declare @a nvarchar(100)
exec Inv_InventarioValida '20504743561','''PD01116'',''PD01117'',''PD01118'',''PD01119'',''PD01120'',''PD01121'',''PD01123'',''PD01124'',''PD01129'',''PD01156'',''PD01155'',''PD01154''','01/01/2000',@a output
print @a
*/
GO

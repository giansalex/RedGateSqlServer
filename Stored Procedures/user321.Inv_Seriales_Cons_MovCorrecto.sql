SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Inv_Seriales_Cons_MovCorrecto]
@RucE nvarchar(11),
@ListaSeriales nvarchar(4000)
--@ListaSeriales varchar(8000)
as
declare @consulta nvarchar(4000)
--declare @consulta varchar(8000)
set @consulta = 'select sm.cd_prod, sm.serial, sm.cd_inv, inv.IC_ES, inv.FecMov from serialmov sm 
join inventario inv on inv.RucE = sm.RucE and sm.cd_inv = inv.cd_inv
where sm.RucE = '''+@RucE+''' and sm.cd_prod+''-''+serial in ('+@ListaSeriales+')
and sm.cd_inv = (
select top 1 i.cd_inv from inventario i
join serialmov smv on smv.RucE = i.RucE and smv.cd_inv = i.cd_inv
where i.RucE = sm.RucE and smv.Cd_Prod = sm.cd_prod and Serial = sm.serial
order by FecMov desc)
order by inv.cd_inv'

print @consulta
exec sp_executesql @consulta
GO

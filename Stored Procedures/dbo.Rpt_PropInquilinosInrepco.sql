SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_PropInquilinosInrepco]
@RucEdi nvarchar(11),
@EjerEdi nvarchar(4),
@Cd_vta nvarchar(4000)

as
--set @RucEdi= '20518936973'
--exec Rpt_PropInquilinosInrepco '20518936973','2011','''VT00000001'',''VT00000002'''
--set @EjerEdi= '2011'
--set @Cd_vta = 'VT00000001'
Declare @Sql nvarchar(4000)
set @Sql = '
select
v.RucE,
v.Cd_Vta,
case when isnull(cl.CA01,'''')<>'''' then (select top 1 mg.Descrip from MantenimientoGN mg where mg.RucE = '''+@RucEdi+''' and mg.Codigo = cl.CA01) else '''' end as Propietario,
case when isnull(cl.CA02,'''')<>'''' then (select top 1 mg.Descrip from MantenimientoGN mg where mg.RucE = '''+@RucEdi+''' and mg.Codigo = cl.CA02) else '''' end as Inquilino
from venta v
left join Cliente2 cl on v.RucE = cl.RucE and v.Cd_clt = cl.Cd_Clt

where v.RucE = '''+@RucEdi+''' and v.Eje = '''+@EjerEdi+''' and v.cd_Vta in ('+@Cd_Vta+')'

print @Sql
exec sp_executesql @Sql
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[Rpt_SeriesXGuiaRemision]
@RucE nvarchar(11),
@Cd_GR nvarchar(4000)

as
--set @Cd_GR  = '''GR00000286'',''GR00000288'''
--set @RucE = '11111111111'
declare @SqlSerie nvarchar(4000)
set @SqlSerie = '
select gt.Cd_GR,gt.Cd_Prod,gt.Item,sm.Serial,inv.Cd_MIS,mto.Descrip as Nom_MIS,inv.Cd_Alm, alm.Nombre as NomAlmacen
from  GuiaRemisionDet gt 
left join SerialMov sm on sm.RucE = gt.RucE and sm.Cd_Prod = gt.Cd_Prod
left join Inventario inv on inv.RucE = gt.RucE and inv.Cd_Inv = sm.Cd_Inv and inv.Cd_GR = gt.Cd_GR 
left join Producto2 p on p.RucE = gt.RucE and p.Cd_Prod = gt.Cd_Prod
left join MtvoIngsal mto on mto.RucE = inv.RucE  and mto.Cd_MIS = inv.Cd_MIS
left join Almacen alm on alm.RucE = gt.RucE and alm.Cd_Alm = inv.Cd_Alm
where gt.RucE = '''+@RucE+''' and inv.Cd_GR in ('+@Cd_GR+')'
print @SqlSerie
exec (@SqlSerie)
--Create
--<JA: 04/05/2012>
--exec Rpt_SeriesXGuiaRemision '11111111111','''GR00000286'',''GR00000288'''

--select * from inventario where RucE = '11111111111' and Ejer = '2012' and cd_gr = 'GR00000286'
--select * from almacen

GO

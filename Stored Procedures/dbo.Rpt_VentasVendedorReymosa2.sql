SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--declare
CREATE procedure [dbo].[Rpt_VentasVendedorReymosa2]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Vdr nvarchar(10),
@Cd_Clt nvarchar(10),
@FecIni datetime,
@FecFin datetime,
@Ib_Incluir bit,
@Cd_Mda nvarchar(10),
@ColOrder nvarchar(2),
@TipOrder nvarchar(4),
@IC_InPrdSrv nchar(1)

as

--exec Rpt_VentasVendedorReymosa2 '20102028687','2012','','','01/12/2012','31/12/2012',0,'02','5','asc'
--set @RucE = '20102028687'
--set @Ejer = '2012'
--set @Cd_Vdr = ''
--set @Cd_Clt = 'CLT0000034'
--set @FecIni = '01/12/2012'
--set @FecFin = '31/12/2012'
--set @Ib_Incluir = 1
--set @Cd_Mda = '02'
--set @ColOrder = '3'
--set @TipOrder = 'asc'



select e.*,'DEL '+Convert(nvarchar,@FecIni,103)+ ' AL '+Convert(nvarchar,@FecFin,103) as FecCons from empresa e where e.Ruc=@RucE

declare @Sql varchar(8000)
set @Sql=
'
select 
Max(td.NCorto) as Cd_TD
,v.NroSre
,v.NroDoc
,v.FecMov
,v.FecCbr
,sum(case when isnull(v.IB_Anulado,0)=1 then 0.0 else case when v.Cd_Mda = ''01'' then vd.IMP else vd.IMP*v.CamMda end end ) as IMP_MN
,sum(case when isnull(v.IB_Anulado,0)=1 then 0.0 else case when v.Cd_Mda = ''02'' then vd.IMP else vd.IMP/v.CamMda end end ) as IMP_ME

,sum(case when isnull(v.IB_Anulado,0)=1 then 0.0 else case when v.Cd_Mda = ''01'' then vd.IGV else vd.IGV*v.CamMda end end ) as IGV_MN
,sum(case when isnull(v.IB_Anulado,0)=1 then 0.0 else case when v.Cd_Mda = ''02'' then vd.IGV else vd.IGV/v.CamMda end end ) as IGV_ME

,sum(case when isnull(v.IB_Anulado,0)=1 then 0.0 else case when v.Cd_Mda = ''01'' then vd.Total else vd.Total*v.CamMda end end ) as Total_MN
,sum(case when isnull(v.IB_Anulado,0)=1 then 0.0 else case when v.Cd_Mda = ''02'' then vd.Total else vd.Total/v.CamMda end end ) as Total_ME

, 0.00 as Saldo
, 0.00 as Porc
, 0.00 as Comision
,isnull(vdr.NDoc,'''') as Cd_Vdr
,case when isnull(v.Cd_Vdr,'''') <> '''' then isnull(vdr.RSocial,isnull(vdr.ApPat,'''')+'' ''+isnull(vdr.ApMat,'''')+'' ''+isnull(vdr.Nom,'''')) end as Vendedor
,isnull(v.Cd_Clt,'''') as Cd_Clt
,case when isnull(v.Cd_Clt,'''') <> '''' then isnull(clt.RSocial,isnull(clt.ApPat,'''')+'' ''+isnull(clt.ApMat,'''')+'' ''+isnull(clt.Nom,'''')) end + case when isnull(v.IB_Anulado,0)=1 then '' (ANULADO)'' else '''' end as Cliente 
,v.CamMda
from Venta v
inner join VentaDet vd on vd.RucE = v.RucE and vd.Cd_Vta = v.Cd_Vta
left join Vendedor2 vdr on vdr.RucE = v.RucE and vdr.Cd_Vdr = v.Cd_Vdr
left join Cliente2 clt on clt.RucE = v.RucE and clt.Cd_Clt = v.Cd_Clt 
left join TipDoc td on td.Cd_TD=v.Cd_TD
where
v.RucE = '''+@RucE+''' and v.Eje = '''+@Ejer+''' and v.FecMov between '''+Convert(nvarchar,@FecIni)+''' and '''+Convert(nvarchar,@FecFin)+'''
and isnull(case when '''+Convert(nvarchar,@Ib_Incluir)+''' = 1 then '''' else v.Cd_Mda end,'''') = isnull(case when '''+Convert(nvarchar,@Ib_Incluir)+''' = 1 then '''' else '''+@Cd_Mda+''' end,'''')
and case when isnull('''+@Cd_Vdr+''','''') <> '''' then isnull(v.Cd_Vdr,'''') else '''' end = isnull('''+@Cd_Vdr+''','''') 
and case '''+@IC_InPrdSrv+''' when ''A'' then '''' when ''P'' then ISNULL(vd.Cd_Srv,'''') when ''S'' then ISNULL(vd.Cd_Prod,'''') end = ''''
and case when isnull('''+@Cd_Clt+''','''') <> '''' then isnull(v.Cd_Clt,'''') else '''' end = isnull('''+@Cd_Clt+''','''') 
'
declare @Sql2 varchar(8000)
set @Sql2=
'

group by 
v.Cd_TD
,v.NroSre
,v.NroDoc
,v.FecMov
,v.FecCbr
,isnull(vdr.NDoc,'''')
,case when isnull(v.Cd_Vdr,'''') <> '''' then isnull(vdr.RSocial,isnull(vdr.ApPat,'''')+'' ''+isnull(vdr.ApMat,'''')+'' ''+isnull(vdr.Nom,'''')) end
,isnull(v.Cd_Clt,'''')
,case when isnull(v.Cd_Clt,'''') <> '''' then isnull(clt.RSocial,isnull(clt.ApPat,'''')+'' ''+isnull(clt.ApMat,'''')+'' ''+isnull(clt.Nom,'''')) end + case when isnull(v.IB_Anulado,0)=1 then '' (ANULADO)'' else '''' end
,v.CamMda
order by 
'+@ColOrder + ' ' +@TipOrder

print @Sql+@Sql2
exec (@Sql+@Sql2)

--<JA: Creado><18/01/2013>
GO

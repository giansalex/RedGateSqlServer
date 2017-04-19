SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--declare 
CREATE procedure [dbo].[Rpt_VentasXClienteXMes2]
@RucE nvarchar(11)
,@Ejer nvarchar(4)
,@FecIni datetime
,@FecFin datetime
,@Cd_Clt nvarchar(11)
, @ColOrder nvarchar(2)
,@TipOrder nvarchar(4)
,@Cd_Mda nvarchar(2)

,@Cd_Vdr nvarchar(10)
,@Ib_Incluir bit
--set @RucE = '20102028687'
--set @Ejer = '2012'
--set @FecIni = '01/09/2012'
--set @FecFin = '30/10/2012'

as

--Rpt_VentasXClienteXMes2 '20102028687','2012','01/01/2012','31/12/2012','','7','asc','02','', 0
select *,'DEL '+Convert(nvarchar,@FecIni,103)+ ' AL '+Convert(nvarchar,@FecFin,103) as FecCons,@Cd_Mda as MdaCons from Empresa Where Ruc = @RucE

declare @Sql varchar(8000)
set @Sql = '

select 
isnull(v.Cd_Clt,'''') as Cd_Clt
,c.NDoc
,isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) as Cliente
--,vdr.Cd_Vdr
--,isnull(vdr.RSocial,isnull(vdr.ApPat,'''')+'' ''+isnull(vdr.ApMat,'''')+'' ''+isnull(vdr.Nom,'''')) as Vendedor
,sum(case v.Prdo when ''01'' then case when v.cd_td = ''07'' then (-1)*isnull(v.BIM_Neto,0) else  case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.BIM_Neto,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(v.BIM_Neto,0) else isnull(v.BIM_Neto,0)/isnull(v.CamMda,0.00)end end  end else 0 end) as BIM_Enero
,sum(case v.Prdo when ''02'' then case when v.cd_td = ''07'' then (-1)*isnull(v.BIM_Neto,0) else case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.BIM_Neto,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(v.BIM_Neto,0) else isnull(v.BIM_Neto,0)/isnull(v.CamMda,0.00)end end end else 0 end) as BIM_Febrero
,sum(case v.Prdo when ''03'' then case when v.cd_td = ''07'' then (-1)*isnull(v.BIM_Neto,0) else  case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.BIM_Neto,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(v.BIM_Neto,0) else isnull(v.BIM_Neto,0)/isnull(v.CamMda,0.00)end end end else 0 end) as BIM_Marzo
,sum(case v.Prdo when ''04'' then case when v.cd_td = ''07'' then (-1)*isnull(v.BIM_Neto,0) else  case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.BIM_Neto,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(v.BIM_Neto,0) else isnull(v.BIM_Neto,0)/isnull(v.CamMda,0.00)end end end else 0 end) as BIM_Abril
,sum(case v.Prdo when ''05'' then case when v.cd_td = ''07'' then (-1)*isnull(v.BIM_Neto,0) else  case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.BIM_Neto,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(v.BIM_Neto,0) else isnull(v.BIM_Neto,0)/isnull(v.CamMda,0.00)end end end else 0 end) as BIM_Mayo
,sum(case v.Prdo when ''06'' then case when v.cd_td = ''07'' then (-1)*isnull(v.BIM_Neto,0) else  case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.BIM_Neto,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(v.BIM_Neto,0) else isnull(v.BIM_Neto,0)/isnull(v.CamMda,0.00)end end end else 0 end) as BIM_Junio
,sum(case v.Prdo when ''07'' then case when v.cd_td = ''07'' then (-1)*isnull(v.BIM_Neto,0) else  case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.BIM_Neto,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(v.BIM_Neto,0) else isnull(v.BIM_Neto,0)/isnull(v.CamMda,0.00)end end end else 0 end) as BIM_Julio
,sum(case v.Prdo when ''08'' then case when v.cd_td = ''07'' then (-1)*isnull(v.BIM_Neto,0) else  case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.BIM_Neto,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(v.BIM_Neto,0) else isnull(v.BIM_Neto,0)/isnull(v.CamMda,0.00)end end end else 0 end) as BIM_Agosto
,sum(case v.Prdo when ''09'' then case when v.cd_td = ''07'' then (-1)*isnull(v.BIM_Neto,0) else  case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.BIM_Neto,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(v.BIM_Neto,0) else isnull(v.BIM_Neto,0)/isnull(v.CamMda,0.00)end end end else 0 end) as BIM_Septiembre
,sum(case v.Prdo when ''10'' then case when v.cd_td = ''07'' then (-1)*isnull(v.BIM_Neto,0) else  case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.BIM_Neto,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(v.BIM_Neto,0) else isnull(v.BIM_Neto,0)/isnull(v.CamMda,0.00)end end end else 0 end) as BIM_Octubre
,sum(case v.Prdo when ''11'' then case when v.cd_td = ''07'' then (-1)*isnull(v.BIM_Neto,0) else  case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.BIM_Neto,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(v.BIM_Neto,0) else isnull(v.BIM_Neto,0)/isnull(v.CamMda,0.00)end end end else 0 end) as BIM_Noviembre
,sum(case v.Prdo when ''12'' then case when v.cd_td = ''07'' then (-1)*isnull(v.BIM_Neto,0) else  case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.BIM_Neto,0) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(v.BIM_Neto,0) else isnull(v.BIM_Neto,0)/isnull(v.CamMda,0.00)end end end else 0 end) as BIM_Diciembre


'
declare @Sql0_1 nvarchar(4000)
set @Sql0_1 = 
'
,sum(case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(v.BIM_Neto,0) else case when '''+@Cd_Mda+''' = ''01''	then isnull(v.CamMda,0.00)*isnull(v.BIM_Neto,0) else isnull(v.BIM_Neto,0)/isnull(v.CamMda,0.00)end end) as Total
'
declare @Sql1 nvarchar(4000)
set @Sql1 = ' 
from 
Venta v
left join Cliente2 c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt
left join Vendedor2 vdr on vdr.RucE = v.RucE and vdr.Cd_Vdr = v.Cd_Vdr
where v.rucE = '''+@RucE+''' and v.FecMov between '''+Convert(nvarchar,@FecIni)+''' and '''+convert(nvarchar,@FecFin)+'''
and isnull(case when '+convert(nvarchar,@Ib_Incluir)+' = 1 then '''' else v.Cd_Mda end,'''') = isnull(case when '+convert(nvarchar,@Ib_Incluir)+' = 1 then '''' else '''+@Cd_Mda+''' end,'''')
and case when isnull('''+convert(nvarchar,@Cd_Clt)+''','''') = '''' then '''' else c.Cd_Clt end = isnull('''+convert(nvarchar,@Cd_Clt)+''','''') 
and case when isnull('''+convert(nvarchar,@Cd_Vdr)+''','''') = '''' then '''' else vdr.Cd_Vdr end = isnull('''+convert(nvarchar,@Cd_Vdr)+''','''') 
and isnull(IB_Anulado,0)<>1
group by isnull(v.Cd_Clt,''''),isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,''''))
--,isnull(vdr.RSocial,isnull(vdr.ApPat,'''')+'' ''+isnull(vdr.ApMat,'''')+'' ''+isnull(vdr.Nom,''''))
--,vdr.Cd_Vdr
,c.NDoc
order by 
'

print(@Sql)
print(@Sql0_1)
print(@Sql1 +@ColOrder+ ' ' + @TipOrder)
exec(@Sql+@Sql0_1+ @Sql1 +@ColOrder+ ' ' + @TipOrder)

--<Creado: JA: 18/01/2013>
GO

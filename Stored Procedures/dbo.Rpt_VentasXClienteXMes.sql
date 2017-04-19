SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--declare 
CREATE procedure [dbo].[Rpt_VentasXClienteXMes]
@RucE nvarchar(11),@Ejer nvarchar(4),@FecIni datetime,@FecFin datetime,@Cd_Clt nvarchar(11), @ColOrder nvarchar(2),@TipOrder nvarchar(4),@Cd_Mda nvarchar(2)--,@Cd_Vdr nvarchar(10)
--set @RucE = '20102028687'
--set @Ejer = '2012'
--set @FecIni = '01/09/2012'
--set @FecFin = '30/10/2012'
as
--[Rpt_VentasXClienteXMes] '20102028687','2012','01/09/2012','30/09/2012','','3','asc','02'
select *,'DEL '+Convert(nvarchar,@FecIni,103)+ ' AL '+Convert(nvarchar,@FecFin,103) as FecCons,@Cd_Mda as MdaCons from Empresa Where Ruc = @RucE

declare @Sql varchar(8000)
set @Sql = '
select 
isnull(v.Cd_Clt,'''') as Cd_Clt
,c.NDoc
,isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) as Cliente
--,isnull(vdr.RSocial,isnull(vdr.ApPat,'''')+'' ''+isnull(vdr.ApMat,'''')+'' ''+isnull(vdr.Nom,'''')) as Vendedor
/*BIM**/
,sum(case v.Prdo when ''01'' then isnull(v.BIM_Neto,0) else 0 end) as BIM_Enero
,sum(case v.Prdo when ''02'' then isnull(v.BIM_Neto,0) else 0 end) as BIM_Febrero
,sum(case v.Prdo when ''03'' then isnull(v.BIM_Neto,0) else 0 end) as BIM_Marzo
,sum(case v.Prdo when ''04'' then isnull(v.BIM_Neto,0) else 0 end) as BIM_Abril
,sum(case v.Prdo when ''05'' then isnull(v.BIM_Neto,0) else 0 end) as BIM_Mayo
,sum(case v.Prdo when ''06'' then isnull(v.BIM_Neto,0) else 0 end) as BIM_Junio
,sum(case v.Prdo when ''07'' then isnull(v.BIM_Neto,0) else 0 end) as BIM_Julio
,sum(case v.Prdo when ''08'' then isnull(v.BIM_Neto,0) else 0 end) as BIM_Agosto
,sum(case v.Prdo when ''09'' then isnull(v.BIM_Neto,0) else 0 end) as BIM_Septiembre
,sum(case v.Prdo when ''10'' then isnull(v.BIM_Neto,0) else 0 end) as BIM_Octubre
,sum(case v.Prdo when ''11'' then isnull(v.BIM_Neto,0) else 0 end) as BIM_Noviembre
,sum(case v.Prdo when ''12'' then isnull(v.BIM_Neto,0) else 0 end) as BIM_Diciembre


from 
Venta v
--left join VentaDet vd on vd.RucE = v.RucE and vd.Cd_Vta = v.Cd_Vta
left join Cliente2 c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt
where v.rucE = '''+@RucE+''' and v.FecMov between '''+Convert(nvarchar,@FecIni)+''' and '''+convert(nvarchar,@FecFin)+'''
and v.Cd_Mda = '''+@Cd_Mda+'''
and case when isnull('''+@Cd_Clt+''','''') = '''' then '''' else c.Cd_Clt end = isnull('''+@Cd_Clt+''','''') 
and isnull(IB_Anulado,0)<>1
group by isnull(v.Cd_Clt,''''),isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,''''))
--,isnull(vdr.RSocial,isnull(vdr.ApPat,'''')+'' ''+isnull(vdr.ApMat,'''')+'' ''+isnull(vdr.Nom,''''))
,c.NDoc
order by 
'+@ColOrder+ ' ' + @TipOrder


exec(@Sql)
print(@Sql)
--<Creado: JA: 20/12/2012>
GO

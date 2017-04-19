SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  Procedure [dbo].[Rpt_VentasXMesEnCant2]
--Declare
@RucE nvarchar(11),
@Ejer nvarchar(4),
@FecIni datetime,
@FecFin datetime,
@ColOrder nvarchar(2),
@TipOrder nvarchar(4),
@IC_InPrdSrv nchar(1),
@Cd_CL nvarchar(10),
@Cd_Prod nvarchar(10)

as
--set @RucE = '20102028687'
--set @Ejer = '2012'
--set @FecIni = '01/01/2013'
--set @FecFin = '31/01/2013'
--set @ColOrder = '2'
--set @TipOrder = 'asc'
--set @IC_InPrdSrv = 'P'
--set @Cd_CL = ''
--set @Cd_Prod = ''
--exec [Rpt_VentasXMesEnCant2] '20102028687','2012','24/10/2012','25/10/2012','2','asc','P','',''
select e.*,'DEL '+Convert(nvarchar,@FecIni,103)+ ' AL '+Convert(nvarchar,@FecFin,103) as FecCons from empresa e where e.Ruc=@RucE

	
declare @Sql varchar(8000)
set @Sql = '
select
isnull(vd.Cd_Prod,isnull(vd.Cd_Srv,'''')) as CodPrdSrv

,isnull(p.CodCo1_,isnull(s.CodCo,'''')) as CodCoPrdSrv
,isnull(p.Nombre1,isnull(s.Nombre,'''')) as NomPrdSrv
,isnull(p.Cd_CL,''--'') as Cd_CL
,isnull(cl.Nombre,''--Sin Nom. Clase--'') as NomCL

,sum(case v.Prdo when ''01'' then case when v.cd_td = ''07'' then (-1)*vd.cant else vd.cant end else 0 end) as CantEnero
,sum(case v.Prdo when ''02'' then case when v.cd_td = ''07'' then (-1)*vd.cant else vd.cant end else 0 end) as CantFebrero
,sum(case v.Prdo when ''03'' then case when v.cd_td = ''07'' then (-1)*vd.cant else vd.cant end else 0 end) as CantMarzo
,sum(case v.Prdo when ''04'' then case when v.cd_td = ''07'' then (-1)*vd.cant else vd.cant end else 0 end) as CantAbril
,sum(case v.Prdo when ''05'' then case when v.cd_td = ''07'' then (-1)*vd.cant else vd.cant end else 0 end) as CantMayo
,sum(case v.Prdo when ''06'' then case when v.cd_td = ''07'' then (-1)*vd.cant else vd.cant end else 0 end) as CantJunio
,sum(case v.Prdo when ''07'' then case when v.cd_td = ''07'' then (-1)*vd.cant else vd.cant end else 0 end) as CantJulio
,sum(case v.Prdo when ''08'' then case when v.cd_td = ''07'' then (-1)*vd.cant else vd.cant end else 0 end) as CantAgosto
,sum(case v.Prdo when ''09'' then case when v.cd_td = ''07'' then (-1)*vd.cant else vd.cant end else 0 end) as CantSeptiembre
,sum(case v.Prdo when ''10'' then case when v.cd_td = ''07'' then (-1)*vd.cant else vd.cant end else 0 end) as CantOctubre
,sum(case v.Prdo when ''11'' then case when v.cd_td = ''07'' then (-1)*vd.cant else vd.cant end else 0 end) as CantNoviembre
,sum(case v.Prdo when ''12'' then case when v.cd_td = ''07'' then (-1)*vd.cant else vd.cant end else 0 end) as CantDiciembre
,sum(case when v.cd_td = ''07'' then (-1)*vd.cant else vd.cant end) as Total

from
Venta v
Inner join VentaDet vd on vd.RucE = v.RucE and vd.Cd_Vta = v.Cd_Vta
left join Producto2 p on p.RucE = v.RucE and p.Cd_Prod = vd.Cd_Prod
left join Servicio2 s on s.RucE = v.RucE and s.Cd_Srv = vd.Cd_Srv
left join Clase cl on cl.RucE = p.RucE and cl.Cd_CL = p.Cd_CL
where v.RucE = '''+@RucE+''' and v.Eje = '''+@Ejer+''' and v.Fecmov between '''+convert(nvarchar,@FecIni)+''' and '''+convert(nvarchar,@FecFin)+'''
and case '''+@IC_InPrdSrv+''' when ''A'' then '''' when ''P'' then ISNULL(vd.Cd_Srv,'''') when ''S'' then ISNULL(vd.Cd_Prod,'''') end = ''''
and case when isnull('''+@Cd_Prod+''','''') <> '''' then isnull(p.Cd_Prod,'''') else '''' end = isnull('''+@Cd_Prod+''','''') 
and case when isnull('''+@Cd_CL+''','''') <> '''' then isnull(cl.Cd_CL,'''') else '''' end = isnull('''+@Cd_CL+''','''') 
and isnull(v.Ib_Anulado,0)<>1
group by v.Prdo,isnull(vd.Cd_Prod,isnull(vd.Cd_Srv,'''')),isnull(p.CodCo1_,isnull(s.CodCo,'''')),isnull(p.Nombre1,isnull(s.Nombre,''''))
,isnull(p.Cd_CL,''--'')
,isnull(cl.Nombre,''--Sin Nom. Clase--'')
order by '+@ColOrder + ' '+ @TipOrder

--print (@Sql)
exec (@Sql)

--<Creado: JA><18/01/2013>
--<Modificado: RG><26/02/2013>

GO

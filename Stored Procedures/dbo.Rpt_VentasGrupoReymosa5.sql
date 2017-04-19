SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE procedure [dbo].[Rpt_VentasGrupoReymosa5]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Vdr nvarchar(10),
@Cd_Clt nvarchar(10),
@FecIni datetime,
@FecFin datetime,
@Ib_Incluir bit,
@Cd_Mda nvarchar(2),
@IC_InPrdSrv nchar(1),
@ColOrder nvarchar(2),
@TipOrder nvarchar(4),
@Cd_CL nvarchar(10),
@Cd_ProdSrv char(10)


 

as

--Rpt_VentasGrupoReymosa5 '20102028687','2012'   ,''    ,''  ,'01/12/2012','31/12/2012'     ,0       ,'02'        ,'P'        ,'5'       ,'desc'       ,''       , '' 
--Rpt_VentasGrupoReymosa5 RUC__EMPRESA, _EJER, CD_VDR, CD_CLT,   FEC_INI,    FEC_FIN,   IB_INCLUIR,  CD_MDA,   IC_InPrdSrv,  ColOrder,   TipOrder,   Cd_Clase, Cd_Prd
--set @RucE = '20102028687'
--set @Ejer = '2012'
--set @Cd_Vdr = ''
--set @Cd_Clt = ''
--set @FecIni = '01/09/2012'
--set @FecFin = '30/09/2012'
--set @Ib_Incluir = 1
--set @Cd_Mda = '03'
--set @IC_InPrdSrv = 'A'
--set @ColOrder = '3'
--set @TipOrder = 'asc'




select e.*,'DEL '+Convert(nvarchar,@FecIni,103)+ ' AL '+Convert(nvarchar,@FecFin,103) as FecCons from empresa e where e.Ruc=@RucE

declare @Sql varchar(8000)
set @Sql = 
'
Select 
/**Venta**/

v.RucE,
v.Eje,
v.Cd_Vta,
v.FecMov,
v.Cd_Td,
v.NroSre,
v.NroDoc,
v.FecCbr as FecCbr,
v.FecReg as FecReg,
v.Obs,
v.Prdo,


/**GuiaxVenta**/
gv.Cd_GR,
g.NroSre as NroSreGR,
g.NroGR,
/**VentaDet**/
vd.CU,
isnull(vd.Cd_Prod,isnull(vd.Cd_Srv,'''')) as Cd_PrdSrv

,case when v.cd_td = ''07'' then (-1*vd.IMP) else case when isnull(v.IB_Anulado,0)=1 then 0.0 else  case when isnull(vd.IGV,0) = 0 then case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(vd.IMP,0.00) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(vd.IMP,0.00) else isnull(vd.IMP,0.00)/isnull(v.CamMda,0.00)end end else 0.00 end end end as INF_Det --inafecto que no tiene igv, precio sin igv, MONTO SIN IGV
,case when v.cd_td = ''07'' then (-1*vd.Valor)else case when isnull(v.IB_Anulado,0)=1 then 0.0 else case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(vd.Valor,0.00) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(vd.Valor,0.00) else isnull(vd.Valor,0.00)/isnull(v.CamMda,0.00)end end end end as Valor_Det  --valor por unidad sin igv
,case when v.cd_td = ''07'' then (-1*vd.DsctoI) else case when isnull(v.IB_Anulado,0)=1 then 0.0 else case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(vd.DsctoI,0.00) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(vd.DsctoI,0.00) else isnull(vd.DsctoI,0.00)/isnull(v.CamMda,0.00)end end end end as DsctoI_Det
,case when v.cd_td = ''07'' then (-1*vd.IMP) else  case when isnull(v.IB_Anulado,0)=1 then 0.0 else  case when isnull(vd.IGV,0) <> 0 then case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(vd.IMP,0.00) else  case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(vd.IMP,0.00) else isnull(vd.IMP,0.00)/isnull(v.CamMda,0.00)end end else 0.00 end end  end as BIM_Det --total sin igv
,case when v.cd_td = ''07'' then (-1*vd.IMP)/vd.Cant else(case when isnull(v.IB_Anulado,0)=1 then 0.0 else case when isnull(vd.IGV,0) <> 0 then case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(vd.IMP,0.00) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(vd.IMP,0.00) else isnull(vd.IMP,0.00)/isnull(v.CamMda,0.00)end end else 0.00 end end)/vd.Cant end as PrecioU -- precio unitario
,case when v.cd_td = ''07'' then (-1*vd.IGV) else case when isnull(v.IB_Anulado,0)=1 then 0.0 else case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(vd.IGV,0.00) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(vd.IGV,0.00) else isnull(vd.IGV,0.00)/isnull(v.CamMda,0.00)end end end end as IGV_Det 
,case when v.cd_td = ''07'' then (-1*vd.Total) else case when isnull(v.IB_Anulado,0)=1 then 0.0 else case when '''+@Cd_Mda+''' = v.Cd_Mda then isnull(vd.Total,0.00) else case when '''+@Cd_Mda+''' = ''01'' then isnull(v.CamMda,0.00)*isnull(vd.Total,0.00) else isnull(vd.Total,0.00)/isnull(v.CamMda,0.00)end end end end as Total_Det  

'
declare @Sql0 varchar(8000)
Set @Sql0 = '
,case when isnull(vd.Cd_Prod,'''')<>'''' then p.Nombre1 when isnull(vd.Cd_Srv,'''')<>'''' then s.Nombre end as NomPrdSrv
,case when isnull(vd.Cd_Prod,'''')<>'''' then p.CodCo1_ when isnull(vd.Cd_Srv,'''')<>'''' then s.CodCo end as CodCoPrdSrv
,case when isnull(vd.Cd_Prod,'''')<>'''' then p.Descrip when isnull(vd.Cd_Srv,'''')<>'''' then s.Descrip end as DescripPrdSrv
,isnull(p.Cd_CL,''--'') as Cd_CL
,isnull(cl.Nombre,''--Sin Nom. Clase--'') as NomCL
,isnull(vdr.NDoc,'''') as Cd_Vdr
,case when isnull(v.Cd_Vdr,'''') <> '''' then isnull(vdr.RSocial,isnull(vdr.ApPat,'''')+'' ''+isnull(vdr.ApMat,'''')+'' ''+isnull(vdr.Nom,'''')) end as Vendedor
,isnull(v.Cd_Clt,'''') as Cd_Clt
,case when isnull(v.Cd_Clt,'''') <> '''' then isnull(clt.RSocial,isnull(clt.ApPat,'''')+'' ''+isnull(clt.ApMat,'''')+'' ''+isnull(clt.Nom,'''')) end +case when isnull(v.IB_Anulado,0)=1 then '' (ANULADO)'' else '''' end as Cliente
,case when isnull(v.IB_Anulado,0) = 1 then 0.0 else case when v.cd_td = ''07'' then -vd.cant  else isnull(vd.Cant,0) end end as Cant
,v.Cd_Mda,v.CamMda
,case when isnull(v.IB_Anulado,0)=1 then 0.0 else case when  v.Cd_Mda = ''01'' then  isnull(vd.Total,0.00)*isnull(v.CamMda,0.00) else isnull(vd.Total,0.00) end end as Total_MN
,case when isnull(v.IB_Anulado,0)=1 then 0.0 else case when  v.Cd_Mda = ''02'' then isnull(vd.Total,0.00)/isnull(v.CamMda,0.00) else isnull(vd.Total,0.00) end end as Total_ME,
v.CA01,v.CA02,v.CA03,v.CA04,v.CA05


'

declare @Sql2 varchar(8000)
set @Sql2 = '
,um.Nombre as NomUM
,um.NCorto as NCortoUM
,vdr.CA01 as CA01VDR
,vdr.CA02 as CA02VDR
,vdr.CA03 as CA03VDR
,vdr.CA04 as CA04VDR
,vdr.CA05 as CA05VDR
,vdr.CA06 as CA06VDR
,vdr.CA07 as CA07VDR
,vdr.CA08 as CA08VDR
,vdr.CA09 as CA09VDR
,vdr.CA10 as CA10VDR
,v.cd_fpc
,fpc.Nombre as Forma_Pago	
from Venta v
left join GuiaxVenta gv on gv.RucE = v.RucE and gv.Cd_Vta = v.Cd_Vta
left join GuiaRemision g on g.RucE = v.RucE and g.Cd_GR = gv.Cd_GR
inner join VentaDet vd on vd.RucE = v.RucE and vd.Cd_Vta = v.Cd_Vta
left join Producto2 p on p.RucE = v.RucE and p.Cd_Prod = vd.Cd_Prod
left join Servicio2 s on s.RucE = v.RucE and s.Cd_Srv = vd.Cd_Srv
left join Vendedor2 vdr on vdr.RucE = v.RucE and vdr.Cd_Vdr = v.Cd_Vdr
left join Cliente2 clt on clt.RucE = v.RucE and clt.Cd_Clt = v.Cd_Clt 
left join Prod_UM pum on pum.RucE = v.RucE and pum.Cd_Prod = vd.Cd_Prod and pum.ID_UMP = vd.ID_UMP
left join UnidadMedida um on um.Cd_UM = pum.Cd_UM
left join Clase cl on cl.RucE = v.RucE and cl.Cd_CL = p.Cd_CL
left join FormaPc fpc on fpc.Cd_FPC = v.Cd_FPC
'

declare @Sql3 varchar(8000)
set @Sql3 = '

where 
v.RucE = '''+@RucE+''' and v.Eje = '''+@Ejer+''' and v.FecMov between '''+convert(nvarchar,@FecIni)+''' and '''+convert(nvarchar,@FecFin)+'''
and isnull(case when '''+Convert(nvarchar,@Ib_Incluir)+''' = 1 then '''' else v.Cd_Mda end,'''') = isnull(case when '''+Convert(nvarchar,@Ib_Incluir)+''' = 1 then '''' else '''+@Cd_Mda+''' end,'''')
and case '''+@IC_InPrdSrv+''' when ''A'' then '''' when ''P'' then ISNULL(vd.Cd_Srv,'''') when ''S'' then ISNULL(vd.Cd_Prod,'''') end = ''''
and case when isnull('''+@Cd_Cl+''','''') <> '''' then isnull(p.Cd_CL,'''') else '''' end = isnull('''+@Cd_CL+''','''') 
and case when isnull('''+@Cd_Vdr+''','''') <> '''' then isnull(v.Cd_Vdr,'''') else '''' end = isnull('''+@Cd_Vdr+''','''') 
and case when isnull('''+@Cd_Clt+''','''') <> '''' then isnull(v.Cd_Clt,'''') else '''' end = isnull('''+@Cd_Clt+''','''') 
and case when isnull('''+@Cd_ProdSrv+''','''') <> '''' then isnull( case len('''+@Cd_ProdSrv+''') when 10 then vd.Cd_Srv when 7 then vd.Cd_prod end  ,'''') else '''' end = isnull('''+@Cd_ProdSrv+''','''') 
' +case when @ColOrder <> '' then ' order by '+@ColOrder+' '+@TipOrder else '' end

print @Sql
print @Sql0
print @Sql2
print @Sql3




exec(@Sql + @Sql0+ @Sql2 + @Sql3)

--<RAFAEL: Creado> <11/02/2013>
GO

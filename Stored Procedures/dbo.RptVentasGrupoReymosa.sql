SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create PROCEDURE [dbo].[RptVentasGrupoReymosa]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Vdr nvarchar(7),
@FecIni datetime,
@FecFin datetime,
@Ib_Incluir bit,
@cod_mda nvarchar(10)
AS
BEGIN
select *from empresa where empresa.Ruc=@RucE

Select 
/**Venta**/
v.RucE,v.Cd_Vta,v.FecMov,v.Cd_Td,v.NroSre,v.NroDoc,v.IGV as 'IVG_Venta',v.INF_Neto as 'Inf_neto_Venta',v.BIM_Neto as 'BIM_NetoVenta',
v.Total as 'Total_Venta',convert(varchar,v.FecCbr,103)as 'fecha_Cobro' ,convert(varchar,v.FecReg,103) as 'fecha_registro',v.Eje,v.Obs,v.Prdo,v.FecMov as 'Fecha_movimiento_Venta',
v.CamMda,
/**GuiaxVenta**/
gv.Cd_GR,g.NroSre as 'NroSerieGuiaRemision',g.NroGR,
/**VentaDet**/
clt.Ndoc,clt.ApPat,clt.ApMat,
vd.IGV,vd.IMP,vd.Total,vd.CU,
isnull(vd.Cd_Prod,isnull(vd.Cd_Srv,'')) as Cd_PrdSrv
,case when isnull(vd.IGV,0.00)=0 then  isnull(vd.IMP,0.00) else 0.00 end as 'Imp_INFDetalle'
,case when isnull(vd.IGV,0.0)=0  then isnull(vd.Total,0.00) else 0.00  end as 'Total_INF' 
,case when isnull(vd.Cd_Prod,'')<>'' then p.Nombre1 when isnull(vd.Cd_Srv,'')<>'' then s.Nombre end as NomPrdSrv
,case when isnull(vd.Cd_Prod,'')<>'' then p.CodCo1_ when isnull(vd.Cd_Srv,'')<>'' then s.CodCo end as CodCoPrdSrv
,case when isnull(vd.Cd_Prod,'')<>'' then p.Descrip when isnull(vd.Cd_Srv,'')<>'' then s.Descrip end as DescripPrdSrv
,isnull(v.Cd_Vdr,'') as Cd_Vdr
,case when isnull(v.Cd_Vdr,'') <> '' then isnull(vdr.RSocial,isnull(vdr.ApPat,'')+' '+isnull(vdr.ApMat,'')+' '+isnull(vdr.Nom,'')) end as Vendedor
,isnull(v.Cd_Clt,'') as Cd_Clt
,case when isnull(v.Cd_Clt,'') <> '' then isnull(clt.RSocial,isnull(clt.ApPat,'')+' '+isnull(clt.ApMat,'')+' '+isnull(clt.Nom,'')) end as Cliente
,vd.Cant
from Venta v
left join GuiaxVenta gv on gv.RucE = v.RucE and gv.Cd_Vta = v.Cd_Vta
left join GuiaRemision g on g.RucE = v.RucE and g.Cd_GR = gv.Cd_GR
inner join VentaDet vd on vd.RucE = v.RucE and vd.Cd_Vta = v.Cd_Vta
left join Producto2 p on p.RucE = v.RucE and p.Cd_Prod = vd.Cd_Prod
left join Servicio2 s on s.RucE = v.RucE and s.Cd_Srv = vd.Cd_Srv
left join Vendedor2 vdr on vdr.RucE = v.RucE and vdr.Cd_Vdr = v.Cd_Vdr
left join Cliente2 clt on clt.RucE = v.RucE and clt.Cd_Clt = v.Cd_Clt
where 
v.RucE = @RucE and v.Eje = @Ejer and v.FecMov between @FecIni and @FecFin--and v.Cd_Vta = 'VT00001202'
and case when isnull(@Cd_Vdr,'') <> '' then isnull(v.Cd_Vdr,'') else '' end = isnull(@Cd_Vdr,'') and v.Cd_Mda=@cod_mda
END
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_TotalVentaXPeriodo]
@RucE nvarchar(11),@Ejer nvarchar(4),@FecIni datetime,@FecFin datetime,@Cd_Prod nvarchar(7),@msj varchar(100) output
--set @RucE = '11111111111'
--set @Ejer = '2012'
--set @Prdo = ''
--set @Cd_Prod = ''
as
if not exists(select top 1 * from Venta where RucE = @RucE and Eje = @Ejer and Fecmov between @FecIni and @FecFin + ' 23:59:29')
set @msj='No existen ventas'
else
begin
	select e.RSocial,@Ejer as Ejer,'DEL '+Convert(nvarchar,@FecIni,103)+' AL '+Convert(nvarchar,@FecFin,103) as Fecha, @RucE as RucE 
	from Empresa e where Ruc = @RucE
	
	select 
	v.Cd_TD,
	v.NroSre,
	td.NCorto as NCortoTD,
	v.NroDoc,
	vd.RucE
	,vd.Cd_Vta
	,vd.Cant
	,vd.Valor
	,vd.DsctoP	
	,vd.DsctoI
	,vd.IMP
	,case v.Cd_Mda when '01' then vd.IGV
					when '02' then (vd.IGV*v.CamMda) end as IGV
	,case v.Cd_Mda when '02' then vd.IGV 
					when '01' then (vd.IGV/v.CamMda) end as IGV_ME
					
	,case v.Cd_Mda when '01' then (vd.Total - vd.IGV)
					when '02' then ((vd.Total-vd.IGV)*v.CamMda) end as BIM
	,case v.Cd_Mda when '02' then (vd.Total - vd.IGV)
					when '01' then ((vd.Total - vd.IGV)/v.CamMda) end as BIM_ME
	
	,vd.Total
	,vd.DsctoP
	,vd.UsuCrea
	,vd.Cd_CC
	,vd.Cd_SC
	,vd.Cd_SS
	,vd.Cd_Prod
	,vd.Cd_Srv
	,vd.Cd_Alm
	,v.Cd_Vdr
	,case when isnull(vdr.RSocial,'') <>'' then vdr.RSocial else vdr.ApPat+' '+vdr.ApMat+' '+vdr.Nom end as Vendedor
	,case when isnull(clt.RSocial,'') <>'' then clt.RSocial else clt.ApPat+' '+clt.ApMat+' '+clt.Nom end as Cliente
	,clt.NDoc as NroDocCliente
	,v.CamMda
	,v.FecED as FecEmi
	,v.FecMov,case when v.Cd_Mda = '01'then 'S/.' else 'US$' end as Moneda
	,case v.Cd_Mda when '01' then vd.Total 
					when '02' then (vd.Total*v.CamMda) end as TotalDet
	,case v.Cd_Mda when '02' then vd.Total 
					when '01' then (vd.Total/v.CamMda) end as TotalDetME
					
	,isnull(p.CodCo1_,isnull(s.CodCo,p.Cd_Prod)) as CodCom1
	,p.CodCo2_ as CodCom2
	,p.CodCo2_ as CodCom3
	,isnull(s.Nombre,'') as NomSrv
	,isnull(p.Nombre1,'') as Nombre1
	,p.Nombre2
	,DATENAME(month, v.FecMov) as Mes
	,isnull(vd.Cd_Prod,isnull(vd.Cd_Srv,'')) as CodInt
	,isnull(p.Nombre1,isnull(s.Nombre,'')) as NomPrdSrv
	,v.RegCtb
	--,case v.Cd_Mda when '01' then vd.CU*vd.Cant end as CostoTotal--agregado si es que se friega xD
					
	--,case v.Cd_Mda when '02' then vd.CU_ME*vd.Cant end as CostoTotalDolares
	,vd.Costo as CostoTotal
	,vd.Costo_ME as CostoTotalDolares
	 from VentaDet vd
	inner join Venta v on v.RucE = vd.RucE and v.Cd_Vta = vd.cd_Vta
    left join Producto2 p on p.RucE = vd.RucE and p.Cd_Prod = vd.Cd_Prod
    left join Servicio2 s on s.RucE = vd.RucE and s.Cd_Srv = vd.Cd_Srv
	Left Join Prod_UM ump on ump.RucE=vd.RucE and ump.ID_UMP = vd.ID_UMP and  ump.Cd_Prod = p.Cd_Prod
	Left Join UnidadMedida um on um.Cd_UM = ump.Cd_UM
	left join Vendedor2 vdr on vdr.RucE = vd.RucE and vdr.Cd_Vdr = v.Cd_Vdr
	left join Cliente2 clt on clt.RucE = vd.RucE and clt.Cd_Clt = v.Cd_Clt
	left join TipDoc td on td.Cd_TD = v.Cd_TD
	Where v.RucE = @RucE /*and v.Eje=@Ejer*/ and v.FecMov between @FecIni and @FecFin + ' 23:59:29' 
	and case when isnull(@Cd_Prod,'')<> '' then vd.Cd_Prod else '' end = isnull(@Cd_Prod,'')
	and isnull(v.Ib_Anulado,0)<>1
	order BY NomPrdSrv,NomSrv,Nombre1
end

print @msj
--Creado x JA <07/08/2012>
--Prueba exec Rpt_TotalVentaXPeriodo '20538349730','2012','01/10/2012','31/10/2012','',null
--select*from VentaDet v where v.RucE = '20538349730' and Cd_Vta = 'VT00000396'












GO

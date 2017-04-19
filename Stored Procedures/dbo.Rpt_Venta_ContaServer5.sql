SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  Procedure [dbo].[Rpt_Venta_ContaServer5]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Vta varchar(4000),
@msj varchar(100) output
as
begin
declare @SqlCab1 varchar(8000)
declare @SqlCab2 varchar(8000)
declare @SqlDet1 varchar(8000)
declare @SqlDet2 varchar(8000)
		------------------------------------------------
		-- VENTA
		------------------------------------------------
		if(@RucE = '20503060621')
set @SqlCab1 = 
'
		select 
			e.Ruc as RucE, e.RSocial, e.Direccion as DirEmp, e.Telef as TelefEmp,
			vta.Cd_Vta,vta.Eje,vta.Prdo,vta.RegCtb,
			convert(varchar,vta.FecMov,103) as FecMov,
			vta.Cd_MIS as Cd_FPC --modificare para codigo MIS
			,fpc.Nombre as NombreFPC,fpc.NCorto as NCortoFPC,
			/****************VENTA*********************/
			--Convert(nvarchar,vta.FecCbr,103) as FecCbr,
			vta.FecCbr,
			/******TIPO DE DOCUMENTO*******/
			vta.Cd_TD,td.Descrip as DescripTD,td.NCorto as NCortoTD,
			/*****VENTA*****/
			vta.NroDoc,Convert(varchar,FecED,103) as FecED,
			Convert(varchar,FecVD,103) as FecVD,
			/******AREA*******/
			vta.Cd_Area,a.Descrip as DescripAR,a.NCorto as NCortoAR,
			/******VENTA*****/
			vta.Cd_MR,vta.Obs,vta.Valor,
			case(IsNull(vta.TotDsctoP,0)) when 0 then vta.TotDsctoI else vta.TotDsctoP end as DsctoT,
			vta.ValorNeto,			
			case(IsNull(vta.DsctoFnz_I,0)) when 0 then vta.DsctoFnz_P else DsctoFnz_I end as DsctoFnz,
			BaseSinDsctoF,vta.Cd_IAV_DF,isnull(vta.INF_Neto,0) as INF_Neto ,isnull(vta.EXO_Neto,0) as EXO_Neto ,isnull(vta.EXPO_Neto,0) as EXPO_Neto,
			isnull(isnull(vta.BIM_Neto, vta.INF_Neto), 0) as BIM_Neto,isnull(vta.IGV,0) as IGV,isnull(vta.Total,0) as Total,vta.Percep,
			vta.Cd_Mda,mda.Nombre as NombreMDA,mda.Simbolo as SimboloMDA,
			vta.CamMda,vta.FecReg,vta.FecMdf,vta.UsuCrea,
			vta.UsuModf,vta.IB_Anulado,vta.IB_Cbdo,vta.DR_CdVta,
			vta.DR_FecED,vta.DR_CdTD,vta.DR_NSre,vta.DR_NDoc,
			vta.CA01,vta.CA02,vta.CA03,vta.CA04,vta.CA05,
			vta.CA06,vta.CA07,vta.CA08,vta.CA09,vta.CA10,
			isnull(vta.CA11,'''') As CA11,vta.CA12,vta.CA13,vta.CA14,vta.CA15,
			/******ORDEN DE PEDIDO*******/
			vta.Cd_OP,vta.NroOP,vta.NroSre,
			/*****CLIENTE2*******/
			vta.Cd_Clt,clt.NDoc as NDocCLI,tdi.Cd_TDI,tdi.Descrip as DescripCLI,
			case(isnull(len(clt.RSocial),0))
			when 0 then isnull(clt.ApPat,'''')+'' ''+isnull(clt.ApMat,'''')+'' ''+isnull(clt.Nom,'''')
			else clt.RSocial end as NomCLI,clt.CodPost,
			udep.Nombre+''-''+upr.Nombre+''-''+ud.Nombre as UbigeoCLI,
			clt.Direc as DirecCLI,clt.Telf1 as Telf1CLI,clt.Telf2 as Telf2CLI,clt.Fax,clt.Correo as CorreoCLI,
			/***VENDEDOR2***/
			case(isnull(len(vd.RSocial),0))
			when 0 then isnull(vd.Nom,'''')+'' ''+isnull(vd.ApPat,'''')
			else vd.RSocial end as NomVdr
			,vd.Ubigeo as UbigeoVDR,vd.Direc as DirecVDR,vd.Telf1 as Telf1VDR,vd.Telf2 as Telf2VDR,vd.Correo as CorreoVDR,vd.Cargo,
			/*****GUIA X VENTA*******/
			gr.NroSre +''-'' + gr.NroGR  as Cd_GR,gr.NroGR,
			/****CAMPOS ADICIONALES CLIENTE****/
			clt.CA01 as CA01cli,clt.CA02 as CA02cli,clt.CA03 as CA03cli,
			clt.CA04 as CA04cli,clt.CA05 as CA05cli,clt.CA06 as CA06cli,
			clt.CA07 as CA07cli,clt.CA08 as CA08cli,clt.CA09 as CA09cli,clt.CA10 as CA10cli
			/****DireccionEntregaOP****/
			,op.DirecEnt as DirecEntOP
			/**Centro Costos**/
			,vta.Cd_CC, vta.Cd_SC, vta.Cd_SS,ss.Descrip,
			/**Datos Transportista**/
			case when isnull(tr.RSocial,'''') = '''' then tr.Nom + '' '' + tr.ApPat + '' '' + tr.ApMat else tr.RSocial end as NomTransp,
			isnull(tr.NroPlaca,'''') as NroPlaca,
			isnull(tr.Direc,'''')as DirecTrans,
			isnull(tr.NDoc,'''') as NdocTrans
			,vta.CA16,vta.CA17,vta.CA18,vta.CA19,vta.CA20,
			vta.CA21,vta.CA22,vta.CA23,vta.CA24,vta.CA25
			,(select udep.Nombre+''-''+upr.Nombre+''-''+ud.Nombre from Empresa e 
			left join UDist ud on ud.Cd_UDt = e.Ubigeo
			left join UProv upr on upr.Cd_UPv = LEFT(ud.Cd_UDt,4)
			left join UDepa udep on udep.Cd_UDp = LEFT(ud.Cd_UDt,2)
			where e.Ruc = '''+@RucE+''') as UbigeoEmpresa,vd.Cd_Vdr 
			,vta.FecMov as FechaMovimiento
			,tdR.NCorto as DR_NCortoTD
			,op.UsuCrea as UsuOP
			,isnull(left(vd.Nom,1)+''.''+left(vd.ApPat,1)+''.''+left(vd.ApMat,1)+''.'',isnull(vd.RSocial,'''')) as IniVdr
			,vd.CA01 as CA01VDR
			,vd.CA02 as CA02VDR
			,vd.CA03 as CA03VDR
			'
		else
set @SqlCab1 = 
'
		select 
			e.Ruc as RucE, e.RSocial, e.Direccion as DirEmp, e.Telef as TelefEmp,
			vta.Cd_Vta,vta.Eje,vta.Prdo,vta.RegCtb,
			convert(varchar,vta.FecMov,103) as FecMov,
			vta.Cd_MIS as Cd_FPC --modificare para codigo MIS
			,fpc.Nombre as NombreFPC,fpc.NCorto as NCortoFPC,
			--Convert(nvarchar,vta.FecCbr,103) as FecCbr,
			vta.FecCbr,
			vta.Cd_TD,td.Descrip as DescripTD,td.NCorto as NCortoTD,
			vta.NroDoc,Convert(varchar,FecED,103) as FecED,
			Convert(varchar,FecVD,103) as FecVD,
			/*********VENTA************/
			vta.Cd_MR,vta.Obs,vta.Valor,
			case(IsNull(vta.TotDsctoP,0)) when 0 then vta.TotDsctoI else vta.TotDsctoP end as DsctoT,
			vta.ValorNeto,			
			case(IsNull(vta.DsctoFnz_I,0)) when 0 then vta.DsctoFnz_P else DsctoFnz_I end as DsctoFnz,
			BaseSinDsctoF,vta.Cd_IAV_DF,isnull(vta.INF_Neto,0) as INF_Neto ,isnull(vta.EXO_Neto,0) as EXO_Neto ,isnull(vta.EXPO_Neto,0) as EXPO_Neto,
			
			isnull(vta.BIM_Neto,0) as BIM_Neto,isnull(vta.IGV,0) as IGV,isnull(vta.Total,0) as Total,vta.Percep,
			/******MONEDA*******/
			vta.Cd_Mda,mda.Nombre as NombreMDA,mda.Simbolo as SimboloMDA,
			/*****************VENTA*******************/
			vta.CamMda,vta.FecReg,vta.FecMdf,vta.UsuCrea,
			vta.UsuModf,vta.IB_Anulado,vta.IB_Cbdo,vta.DR_CdVta,
			vta.DR_FecED,vta.DR_CdTD,vta.DR_NSre,vta.DR_NDoc,
			vta.CA01,vta.CA02,vta.CA03,vta.CA04,vta.CA05,
			vta.CA06,vta.CA07,vta.CA08,vta.CA09,vta.CA10,
			isnull(vta.CA11,'''') As CA11,vta.CA12,vta.CA13,vta.CA14,vta.CA15,
			/*****************ORDEN DE PEDIDO********************/
			vta.Cd_OP,vta.NroOP,vta.NroSre,
			/*****************CLIENTE2********************/
			vta.Cd_Clt,clt.NDoc as NDocCLI,tdi.Cd_TDI,tdi.Descrip as DescripCLI,
			case(isnull(len(clt.RSocial),0))
			when 0 then isnull(clt.ApPat,'''')+'' ''+isnull(clt.ApMat,'''')+'' ''+isnull(clt.Nom,'''')
			else clt.RSocial end as NomCLI,clt.CodPost,
			udep.Nombre+''-''+upr.Nombre+''-''+ud.Nombre as UbigeoCLI,
			clt.Direc as DirecCLI,clt.Telf1 as Telf1CLI,clt.Telf2 as Telf2CLI,clt.Fax,clt.Correo as CorreoCLI,
			/****VENDEDOR2***/
			case(isnull(len(vd.RSocial),0))
			when 0 then isnull(vd.Nom,'''')+'' ''+isnull(vd.ApPat,'''')
			else vd.RSocial end as NomVdr
			,vd.Ubigeo as UbigeoVDR,vd.Direc as DirecVDR,vd.Telf1 as Telf1VDR,vd.Telf2 as Telf2VDR,vd.Correo as CorreoVDR,vd.Cargo,
			/****GUIA X VENTA*******/
			gr.NroSre +''-'' + gr.NroGR  as Cd_GR,gr.NroGR,
			/***CAMPOS ADICIONALES CLIENTE******/
			clt.CA01 as CA01cli,clt.CA02 as CA02cli,clt.CA03 as CA03cli,
			clt.CA04 as CA04cli,clt.CA05 as CA05cli,clt.CA06 as CA06cli,
			clt.CA07 as CA07cli,clt.CA08 as CA08cli,clt.CA09 as CA09cli,clt.CA10 as CA10cli
			/******DireccionEntregaOP*****/
			,op.DirecEnt as DirecEntOP
			/**Centro Costos**/
			,vta.Cd_CC, vta.Cd_SC, vta.Cd_SS,ss.Descrip,
			/**Datos Transportista**/
			case when isnull(tr.RSocial,'''') = '''' then tr.Nom + '' '' + tr.ApPat + '' '' + tr.ApMat else tr.RSocial end as NomTransp,
			isnull(tr.NroPlaca,'''') as NroPlaca,
			isnull(tr.Direc,'''')as DirecTrans,
			isnull(tr.NDoc,'''') as NdocTrans
			,vta.CA16,vta.CA17,vta.CA18,vta.CA19,vta.CA20,
			vta.CA21,vta.CA22,vta.CA23,vta.CA24,vta.CA25
			,(select udep.Nombre+''-''+upr.Nombre+''-''+ud.Nombre from Empresa e 
			left join UDist ud on ud.Cd_UDt = e.Ubigeo
			left join UProv upr on upr.Cd_UPv = LEFT(ud.Cd_UDt,4)
			left join UDepa udep on udep.Cd_UDp = LEFT(ud.Cd_UDt,2)
			where e.Ruc = '''+@RucE+''') as UbigeoEmpresa,vd.Cd_Vdr 
			,vta.FecMov as FechaMovimiento
			,tdR.NCorto as DR_NCortoTD
			,op.UsuCrea as UsuOP
			,isnull(left(vd.Nom,1)+''.''+left(vd.ApPat,1)+''.''+left(vd.ApMat,1)+''.'',isnull(vd.RSocial,'''')) as IniVdr
			,vd.CA01 as CA01VDR
			,vd.CA02 as CA02VDR
			,vd.CA03 as CA03VDR
			'
declare @SqlDirecEnt varchar(4000)
set @SqlDirecEnt ='
			
		,(select top 1 d.Direc from DirecEnt d left join Venta v on d.RucE = v.RucE and d.Cd_Clt = v.Cd_Clt where v.RucE = '''+@RucE+''' and Cd_Vta in('

set	@SqlCab2 = '
		from Venta vta
			left join Empresa e on e.Ruc= vta.RucE
			left join FormaPC fpc on fpc.Cd_FPC = vta.Cd_FPC
			left join Area a on a.Cd_Area = vta.Cd_Vta and a.RucE= vta.RucE
			left join TipDoc td on td.Cd_TD = vta.Cd_TD
			left join Moneda mda on mda.Cd_Mda = vta.Cd_Mda
			left join OrdPedido op on op.Cd_OP = vta.Cd_OP and op.RucE = vta.RucE
			left join Cliente2 clt on clt.Cd_Clt = vta.Cd_Clt and clt.RucE= vta.RucE
			left join TipDocIdn tdi on tdi.Cd_TDI = clt.Cd_TDI
			left join Vendedor2 vd on vd.Cd_Vdr = vta.Cd_Vdr and vd.RucE=vta.RucE
			Left Join GuiaXVenta gv on gv.RucE = vta.RucE and gv.Cd_Vta = vta.Cd_Vta
			left join CCSubSub ss on vta.Cd_CC = ss.Cd_CC and ss.Cd_SC = vta.Cd_SC and ss.Cd_SS = vta.Cd_SS and ss.RucE = vta.RucE
			left join GuiaRemision gr on vta.RucE = gr.RucE and gv.Cd_GR = gr.Cd_GR
			left join Transportista tr on gr.Cd_Tra = tr.Cd_Tra and vta.RucE = tr.RucE
			left join UDist ud on ud.Cd_UDt = clt.Ubigeo
			left join UProv upr on upr.Cd_UPv = LEFT(ud.Cd_UDt,4)
			left join UDepa udep on udep.Cd_UDp = LEFT(ud.Cd_UDt,2)
			left join DirecEnt de on de.RucE = vta.RucE  and de.Cd_Clt = vta.Cd_Clt
			left join TipDoc tdR on tdR.Cd_TD = vta.DR_CdTD
		Where isnull(de.Item,'''')= case when isnull(de.Item,'''')<>'''' then 1 else '''' end and vta.RucE='''+@RucE+''' and vta.Cd_Vta in('
		print (@SqlCab1)
		--exec Rpt_Venta_ContaServer5 '20503060621','2012','''VT00000995''',null
exec (@SqlCab1+@SqlDirecEnt+ @Cd_Vta+'))as DirecEnt' + @SqlCab2 + @Cd_Vta+')'	)	


	------------------------------------------------
	--DETALLE DE LA VENTA
	------------------------------------------------
		/*Declare @RucE nvarchar(11)
		set @RucE='11111111111'
		Declare @Cd_Vta nvarchar(10)
		set @Cd_Vta = 'VT00000400'*/
set @SqlDet1 =
' 
		select 
			det.RucE,det.Cd_Vta,det.Nro_RegVdt,det.Cant,det.Valor,
			case(IsNull(det.DsctoP,0)) when 0 then det.DsctoI else det.DsctoP end as Dscto,det.IMP,det.IGV,det.Total,
			det.CA01 as DCA01,det.CA02 as DCA02,det.CA03 as DCA03,det.CA04 as DCA04,det.CA05 as DCA05,
			det.CA06 as DCA06,det.CA07 as DCA07,det.CA08 as DCA08,det.CA09 as DCA09,det.CA10 as DCA10,
			det.FecReg,det.FecMdf,det.UsuCrea,det.UsuModf,
			/*********************************************************************************************/
			case(IsNull(det.Cd_Prod,''0'')) when ''0'' then det.Cd_Srv else det.Cd_Prod end as Cd_PrSrv,
			case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.CodCo else pr.CodCo1_ end as CodCoPrSrv,
			case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.Nombre else pr.Nombre1 end as NomPrSrv,
			case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.Descrip else pr.Descrip end as DescripPrSrv,
			case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.NCorto else pr.NCorto end as NCortoPrSrv,
			case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.CA01 else pr.CA01 end as CA01PrSrv,
			case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.CA02 else pr.CA02 end as CA02PrSrv,
			case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.CA03 else pr.CA03 end as CA03PrSrv,
			case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.CA04 else pr.CA04 end as CA04PrSrv,
			case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.CA05 else pr.CA05 end as CA05PrSrv,
			case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.CA06 else pr.CA06 end as CA06PrSrv,
			case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.CA07 else pr.CA07 end as CA07PrSrv,
			case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.CA08 else pr.CA08 end as CA08PrSrv,
			case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.CA09 else pr.CA09 end as CA09PrSrv,
			case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.CA10 else pr.CA10 end as CA10PrSrv,
			/*********************************************************************************************/
			det.Descrip as DescripDET,
			/*************UNIDAD DE MEDIDA X PROD********************************************************************************/
			det.ID_UMP,ump.DescripAlt,ump.Factor,ump.PesoKg,
			/*********************************************************************************************/
			ump.Cd_UM,um.Nombre as NombreUM,um.NCorto as NCortoUM,
			/*************DETALLE********************************************************************************/
			det.PU,det.Obs as ObsDET,
			/*************ALMACEN********************************************************************************/
			det.Cd_Alm,alm.Codigo,alm.Nombre as NombreALM,alm.NCorto as NCortoALM,alm.Ubigeo as UbigeoALM,alm.Direccion as DireccionALM,alm.Encargado,
			alm.Telef as TelefALM,alm.Capacidad,alm.Obs as ObsALM,
			alm.CA01 as ACA01,alm.CA02 as ACA02,alm.CA03 as ACA03,alm.CA04 as ACA04,alm.CA05 as ACA05,
			/*************INDICADOR AFECTO VTA*******************************************************************************/
			det.Cd_IAV,iav.Descrip as DescripIAV,iav.NomCorto as NomCortoIAV,
			/*************MARCA********************************************************************************/
			mca.Cd_Mca,mca.Nombre as NomMca,mca.Descrip,mca.NCorto as NomCortoMca,
			/*************CLASE********************************************************************************/
			cl.Cd_CL,cl.Nombre as NomClase,cl.NCorto as NomCortoClase
			/*********************************************************************************************/
			,case(det.IGV)When 0 then 0 else det.IMP end as AFECTO,
			case(det.IGV)When 0 then det.IMP else 0 end as INAFECTO
			/*************************Centro de costos*****************************************/
			,det.Cd_CC,det.Cd_SC,det.Cd_SS,ss.Descrip as DescripSS
'

set @SqlDet2 = 
'
		from VentaDet det
			Left Join Producto2 pr on pr.Cd_Prod = det.Cd_Prod and pr.RucE = det.RucE
			Left Join Marca mca on mca.RucE=pr.RucE and mca.Cd_Mca = pr.Cd_Mca
			Left Join Clase cl on cl.RucE=pr.RucE and cl.Cd_CL=pr.Cd_CL
			Left Join Servicio2 srv on srv.Cd_Srv = det.Cd_Srv and srv.RucE= det.RucE
			Left Join Prod_UM ump on ump.RucE=det.RucE and ump.ID_UMP = det.ID_UMP and  ump.Cd_Prod = pr.Cd_Prod --and ump.Cd_UM = um.ID_UMP
			Left Join UnidadMedida um on um.Cd_UM = ump.Cd_UM
			Left Join Almacen alm on alm.Cd_Alm = det.Cd_Alm and alm.RucE = det.RucE
			Left Join IndicadorAfectoVta iav on iav.Cd_IAV = det.Cd_IAV
			Left join CCSubSub ss on det.Cd_CC = ss.Cd_CC and ss.Cd_SC = det.Cd_SC and ss.Cd_SS = det.Cd_SS and ss.RucE = det.RucE
		Where det.RucE='''+@RucE+''' and det.Cd_Vta in ('

declare @SqlDetOrder varchar(200)
set @SqlDetOrder = ''
if(@RucE = '20546110720')
begin
set @SqlDetOrder = 
'
Order by 
case(IsNull(det.Cd_Prod,''0'')) when ''0'' then srv.Nombre else pr.Nombre1 end,
ump.DescripAlt,
det.PU
'
end
exec (@SqlDet1 + @SqlDet2 +@Cd_Vta+') '+@SqlDetOrder)


print(@SqlCab1 +@SqlDirecEnt+ @Cd_Vta+'))as DirecEnt' + @SqlCab2 + @Cd_Vta+')'	)
print(@SqlDet1 + @SqlDet2 + @Cd_Vta+')'+@SqlDetOrder)
end

print @msj

-- Leyenda --
-- J : 2010-11-10 	: <Creacion del procedimiento almacenado>
-- JA : 2011-02-23 	: <Modificacion del procedimiento almacenado> : Se agrego el campo Cd_GR
-- JA : 2001-03-15	: <Modificacion del procedimiento almacenado> : Se agrego los campos: Afecto - Inafecto //en el detalle de la factura
-- JA : 2001-03-28	: <Modificacion del procedimiento almacenado> : Se agrego el campo DireccionEntregadeOP a la cabecera
-- JA : 2011/08/20  : <Modificacion del SP> : Agrege datos del transportista, dividi la cabecera en dos cadenas.
--exec Rpt_Venta_ContaServer '111111111111','2011','VT00000798',null
--select * from venta where ruce='11111111111' and CD_Vta = 'VT00000400'
--select * from ventaDet where ruce='11111111111' and Cd_Vta = 'VT00000400'

--

--select *from venta where ruce = '20100876788' and eje = '2011' and cd_vta = 'VT00000010'

--select * from Venta where RucE = '20514402346' and Cd_Vta = 'VT00000001'







GO

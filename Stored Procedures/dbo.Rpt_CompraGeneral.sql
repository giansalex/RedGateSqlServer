SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CompraGeneral]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Com nvarchar(4000)
as
--set @RucE = '11111111111'
--set @Ejer = '2012'
--set @Cd_Com = 'CM00000543'


		select 
			e.Ruc as RucE, e.RSocial, e.Direccion as DirEmp, e.Telef as TelefEmp,
			c.Cd_Com,c.Ejer,c.Prdo,c.RegCtb,
			convert(varchar,c.FecMov,103) as FecMov,
			c.Cd_MIS as MIS
			,fpc.Nombre as NombreFPC,fpc.NCorto as NCortoFPC,
			c.NroSre, c.Cd_TD,td.Descrip as DescripTD,td.NCorto as NCortoTD,
			c.NroDoc,Convert(varchar,FecED,103) as FecED,
			Convert(varchar,FecVD,103) as FecVD,
			c.Cd_MR,c.Obs,
			c.Cd_Mda,mda.Nombre as NombreMDA,mda.Simbolo as SimboloMDA,
			/*****************Compra*******************/
			c.CamMda,c.FecReg,c.FecMdf,c.UsuCrea,
			c.DR_FecED,c.DR_CdTD,c.DR_NSre,c.DR_NDoc,c.DR_CdCom,c.DR_FecDet,c.DR_NroDet,
			
			isnull(c.BIM_S,0) as BIM_S,
			isnull(c.IGV_S,0) as IGV_S,
			isnull(c.BIM_E,0) as BIM_E,
			isnull(c.IGV_E,0) as IGV_E,
			isnull(c.BIM_C,0) as BIM_C,
			isnull(c.IGV_C,0) as IGV_C,
			isnull(c.IMP_N,0) as IMP_N,
			isnull(c.IMP_O,0) as IMP_O,
			isnull(c.Total,0) as Total,	
			c.CA01,c.CA02,c.CA03,c.CA04,c.CA05,
			c.CA06,c.CA07,c.CA08,c.CA09,c.CA10,
			isnull(c.CA11,'') As CA11,c.CA12,c.CA13,c.CA14,c.CA15,
			

			/*****************Proveedor********************/
			c.Cd_Prv,prv.NDoc as NDocPrv,
			case(isnull(len(prv.RSocial),0))
			when 0 then isnull(prv.ApPat,'')+' '+isnull(prv.ApMat,'')+' '+isnull(prv.Nom,'')
			else prv.RSocial end as NomPRV,prv.CodPost,
			udep.Nombre+'-'+upr.Nombre+'-'+ud.Nombre as UbigeoPrv,
			prv.Direc as DirecPRV,prv.Telf1 as Telf1PRV,prv.Telf2 as Telf2PRV,prv.Fax,prv.Correo as CorreoPRV,
			
			/******************CAMPOS ADICIONALES CLIENTE****************/
			prv.CA01 as CA01prv,prv.CA02 as CA02prv,prv.CA03 as CA03prv,
			prv.CA04 as CA04prv,prv.CA05 as CA05prv,prv.CA06 as CA06prv,
			prv.CA07 as CA07prv,prv.CA08 as CA08prv,prv.CA09 as CA09prv,prv.CA10 as CA10prv
			,c.Cd_CC, c.Cd_SC, c.Cd_SS,ss.Descrip
			
		from Compra c
			left join Empresa e on e.Ruc= c.RucE
			left join FormaPC fpc on fpc.Cd_FPC = c.Cd_FPC
			left join TipDoc td on td.Cd_TD = c.Cd_TD
			left join Moneda mda on mda.Cd_Mda = c.Cd_Mda
			left join Proveedor2 prv on prv.Cd_Prv = c.Cd_Prv and prv.RucE= c.RucE
			left join OrdCompra oc on oc.Cd_OC = c.Cd_OC and oc.RucE = c.RucE			
			left join CCSubSub ss on c.Cd_CC = ss.Cd_CC and ss.Cd_SC = c.Cd_SC and ss.Cd_SS = c.Cd_SS and ss.RucE = c.RucE
			left join UDist ud on ud.Cd_UDt = prv.Ubigeo
			left join UProv upr on upr.Cd_UPv = LEFT(ud.Cd_UDt,4)
			left join UDepa udep on udep.Cd_UDp = LEFT(ud.Cd_UDt,2)
		
where c.RucE = @RucE and c.Ejer = @Ejer and c.Cd_Com = @Cd_Com


select 
c.RucE,cd.Cd_Com,cd.Item,isnull(cd.Descrip,'') as DescripDet,
case(IsNull(cd.Cd_Prod,'')) when '' then cd.Cd_Srv else cd.Cd_Prod end as Cd_PrSrv,
case(IsNull(cd.Cd_Prod,'')) when '' then srv.CodCo else pr.CodCo1_ end as CodCoPrSrv,
case(IsNull(cd.Cd_Prod,'')) when '' then srv.Nombre else pr.Nombre1 end as NomPrSrv,
case(IsNull(cd.Cd_Prod,'')) when '' then srv.Descrip else pr.Descrip end as DescripPrSrv,
case(IsNull(cd.Cd_Prod,'')) when '' then srv.NCorto else pr.NCorto end as NCortoPrSrv,
case(IsNull(cd.Cd_Prod,'')) when '' then srv.CA01 else pr.CA01 end as CA01PrSrv,
case(IsNull(cd.Cd_Prod,'')) when '' then srv.CA02 else pr.CA02 end as CA02PrSrv,
case(IsNull(cd.Cd_Prod,'')) when '' then srv.CA03 else pr.CA03 end as CA03PrSrv,
case(IsNull(cd.Cd_Prod,'')) when '' then srv.CA04 else pr.CA04 end as CA04PrSrv,
case(IsNull(cd.Cd_Prod,'')) when '' then srv.CA05 else pr.CA05 end as CA05PrSrv,
case(IsNull(cd.Cd_Prod,'')) when '' then srv.CA06 else pr.CA06 end as CA06PrSrv,
case(IsNull(cd.Cd_Prod,'')) when '' then srv.CA07 else pr.CA07 end as CA07PrSrv,
case(IsNull(cd.Cd_Prod,'')) when '' then srv.CA08 else pr.CA08 end as CA08PrSrv,
case(IsNull(cd.Cd_Prod,'')) when '' then srv.CA09 else pr.CA09 end as CA09PrSrv,
case(IsNull(cd.Cd_Prod,'')) when '' then srv.CA10 else pr.CA10 end as CA10PrSrv,
cd.ID_UMP,ump.DescripAlt,ump.Factor,ump.PesoKg,
ump.Cd_UM,um.Nombre as NombreUM,um.NCorto as NCortoUM,
isnull(cd.Cant,0) as Cant,
isnull(cd.Valor,0) as Valor,
isnull(cd.DsctoP,0) as DsctoP,
isnull(cd.DsctoI,0) as DsctoI,
isnull(cd.IMP,0) as IMP,
isnull(cd.IGV,0) as IGV,
isnull(cd.PU,0) as PU,
isnull(cd.Total,0) as Total,
cd.Obs as ObsDET,
cd.Cd_Alm,alm.Codigo,alm.Nombre as NombreALM,alm.NCorto as NCortoALM,alm.Ubigeo as UbigeoALM,alm.Direccion as DireccionALM,alm.Encargado,
alm.Telef as TelefALM,alm.Capacidad,alm.Obs as ObsALM,
alm.CA01 as ACA01,alm.CA02 as ACA02,alm.CA03 as ACA03,alm.CA04 as ACA04,alm.CA05 as ACA05,
case(cd.IGV)When 0 then 0 else cd.IMP end as AFECTO,
case(cd.IGV)When 0 then cd.IMP else 0 end as INAFECTO,
cd.Cd_CC,cd.Cd_SC,cd.Cd_SS

from CompraDet cd
left join Compra c on c.RucE = cd.RucE and c.Cd_Com = cd.Cd_Com
left join Producto2 pr on c.RucE = pr.RucE and cd.Cd_Prod = pr.Cd_Prod
left join Servicio2 srv on c.RucE = srv.RucE and cd.Cd_Srv = srv.Cd_Srv
Left Join Prod_UM ump on ump.RucE=cd.RucE and ump.ID_UMP = cd.ID_UMP and  ump.Cd_Prod = pr.Cd_Prod
Left Join UnidadMedida um on um.Cd_UM = ump.Cd_UM
Left Join Almacen alm on alm.Cd_Alm = cd.Cd_Alm and alm.RucE = cd.RucE

where c.RucE = @RucE and c.Ejer = @Ejer and c.Cd_Com = @Cd_Com

/*Creado <JA> : 06/02/2012*/
--exec Rpt_CompraGeneral '11111111111','2012','CM00000543'
GO

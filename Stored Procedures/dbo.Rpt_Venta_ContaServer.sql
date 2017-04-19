SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_Venta_ContaServer]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as
begin

		------------------------------------------------
		-- VENTA
		------------------------------------------------

		select 
			e.Ruc as RucE, e.RSocial, e.Direccion as DirEmp, e.Telef as TelefEmp,
			vta.Cd_Vta,vta.Eje,vta.Prdo,vta.RegCtb,
			convert(varchar,vta.FecMov,103) as FecMov,
			/*************************************/
			vta.Cd_FPC,fpc.Nombre as NombreFPC,fpc.NCorto as NCortoFPC,
			/*************************************/
			vta.FecCbr,
			/*************************************/
			vta.Cd_TD,td.Descrip as DescripTD,td.NCorto as NCortoTD,
			/*************************************/
			vta.NroDoc,Convert(varchar,FecED,103) as FecED,
			Convert(varchar,FecVD,103) as FecVD,
			/*************************************/
			vta.Cd_Area,a.Descrip as DescripAR,a.NCorto as NCortoAR,
			/*************************************/
			vta.Cd_MR,vta.Obs,vta.Valor,
			case(IsNull(vta.TotDsctoP,0)) when 0 then vta.TotDsctoI else vta.TotDsctoP end as DsctoT,
			vta.ValorNeto,			
			case(IsNull(vta.DsctoFnz_I,0)) when 0 then vta.DsctoFnz_P else DsctoFnz_I end as DsctoFnz,
			BaseSinDsctoF,vta.Cd_IAV_DF,vta.INF_Neto,vta.EXO_Neto,vta.EXPO_Neto,
			vta.BIM_Neto,vta.IGV,vta.Total,vta.Percep,
			/*************************************/
			vta.Cd_Mda,mda.Nombre as NombreMDA,mda.Simbolo as SimboloMDA,
			/*************************************/
			vta.CamMda,vta.FecReg,vta.FecMdf,vta.UsuCrea,
			vta.UsuModf,vta.IB_Anulado,vta.IB_Cbdo,vta.DR_CdVta,
			vta.DR_FecED,vta.DR_CdTD,vta.DR_NSre,vta.DR_NDoc,
			vta.CA01,vta.CA02,vta.CA03,vta.CA04,vta.CA05,
			vta.CA06,vta.CA07,vta.CA08,vta.CA09,vta.CA10,
			vta.CA11,vta.CA12,vta.CA13,vta.CA14,vta.CA15,
			/*************************************/
			vta.Cd_OP,vta.NroOP,vta.NroSre,
			/*************************************/
			vta.Cd_Clt,clt.NDoc as NDocCLI,tdi.Cd_TDI,tdi.Descrip as DescripCLI,
			case(isnull(len(clt.RSocial),0))
			when 0 then clt.ApPat+' '+clt.ApMat+' '+clt.Nom
			else clt.RSocial end as NomCLI,clt.CodPost,clt.Ubigeo as UbigeoCLI,clt.Direc as DirecCLI,clt.Telf1 as Telf1CLI,clt.Telf2 as Telf2CLI,clt.Fax,clt.Correo as CorreoCLI,
			/*************************************/
			case(isnull(len(vd.RSocial),0))
			when 0 then vd.ApPat+' '+vd.ApMat+' '+vd.Nom
			else vd.RSocial end as NomVdr
			,vd.Ubigeo as UbigeoVDR,vd.Direc as DirecVDR,vd.Telf1 as Telf1VDR,vd.Telf2 as Telf2VDR,vd.Correo as CorreoVDR,vd.Cargo
			/*************************************/
		from Venta vta
			left join Empresa e on e.Ruc= vta.RucE
			left join FormaPC fpc on fpc.Cd_FPC = vta.Cd_FPC
			left join Area a on a.Cd_Area = vta.Cd_Vta and a.RucE= vta.RucE
			left join TipDoc td on td.Cd_TD = vta.Cd_TD
			left join Moneda mda on mda.Cd_Mda = vta.Cd_Mda
			--left join OrdPedido on op.Cd_OP = vta.Cd_OP and op.NroOP = vta.NroOP
			left join Cliente2 clt on clt.Cd_Clt = vta.Cd_Clt and clt.RucE= vta.RucE--and clt.Cd_TDI = tdi.Cd_TDI
			left join TipDocIdn tdi on tdi.Cd_TDI = clt.Cd_TDI
			left join Vendedor2 vd on vd.Cd_Vdr = vta.Cd_Vdr and vd.RucE=vta.RucE
		Where vta.RucE=@RucE and /*vta.Eje=@Ejer and*/ vta.Cd_Vta = @Cd_Vta

	------------------------------------------------
	--DETALLE DE LA VENTA
	------------------------------------------------
		/*Declare @RucE nvarchar(11)
		set @RucE='11111111111'
		Declare @Cd_Vta nvarchar(10)
		set @Cd_Vta = 'VT00000400'*/

		select 
			det.RucE,det.Cd_Vta,det.Nro_RegVdt,det.Cant,det.Valor,
			case(IsNull(det.DsctoP,0)) when 0 then det.DsctoI else det.DsctoP end as Dscto,det.IMP,det.IGV,det.Total,
			det.CA01 as DCA01,det.CA02 as DCA02,det.CA03 as DCA03,det.CA04 as DCA04,det.CA05 as DCA05,
			det.CA06 as DCA06,det.CA07 as DCA07,det.CA08 as DCA08,det.CA09 as DCA09,det.CA10 as DCA10,
			det.FecReg,det.FecMdf,det.UsuCrea,det.UsuModf,
			/*********************************************************************************************/
			case(IsNull(det.Cd_Prod,'0')) when '0' then det.Cd_Srv else det.Cd_Prod end as Cd_PrSrv,
			case(IsNull(det.Cd_Prod,'0')) when '0' then srv.CodCo else pr.CodCo1_ end as CodCoPrSrv,
			case(IsNull(det.Cd_Prod,'0')) when '0' then srv.Nombre else pr.Nombre1 end as NomPrSrv,
			case(IsNull(det.Cd_Prod,'0')) when '0' then srv.Descrip else pr.Descrip end as DescripPrSrv,
			case(IsNull(det.Cd_Prod,'0')) when '0' then srv.NCorto else pr.NCorto end as NCortoPrSrv,
			case(IsNull(det.Cd_Prod,'0')) when '0' then srv.CA01 else pr.CA01 end as CA01PrSrv,
			case(IsNull(det.Cd_Prod,'0')) when '0' then srv.CA02 else pr.CA02 end as CA02PrSrv,
			case(IsNull(det.Cd_Prod,'0')) when '0' then srv.CA03 else pr.CA03 end as CA03PrSrv,
			case(IsNull(det.Cd_Prod,'0')) when '0' then srv.CA04 else pr.CA04 end as CA04PrSrv,
			case(IsNull(det.Cd_Prod,'0')) when '0' then srv.CA05 else pr.CA05 end as CA05PrSrv,
			case(IsNull(det.Cd_Prod,'0')) when '0' then srv.CA06 else pr.CA06 end as CA06PrSrv,
			case(IsNull(det.Cd_Prod,'0')) when '0' then srv.CA07 else pr.CA07 end as CA07PrSrv,
			case(IsNull(det.Cd_Prod,'0')) when '0' then srv.CA08 else pr.CA08 end as CA08PrSrv,
			case(IsNull(det.Cd_Prod,'0')) when '0' then srv.CA09 else pr.CA09 end as CA09PrSrv,
			case(IsNull(det.Cd_Prod,'0')) when '0' then srv.CA10 else pr.CA10 end as CA10PrSrv,
			/*********************************************************************************************/
			det.Descrip as DescripDET,
			/*********************************************************************************************/
			det.ID_UMP,ump.DescripAlt,ump.Factor,ump.PesoKg,
			/*********************************************************************************************/
			ump.Cd_UM,um.Nombre as NombreUM,um.NCorto as NCortoUM,
			/*********************************************************************************************/
			det.PU,det.Obs as ObsDET,
			/*********************************************************************************************/
			det.Cd_Alm,alm.Codigo,alm.Nombre as NombreALM,alm.NCorto as NCortoALM,alm.Ubigeo as UbigeoALM,alm.Direccion as DireccionALM,alm.Encargado,
			alm.Telef as TelefALM,alm.Capacidad,alm.Obs as ObsALM,
			alm.CA01 as ACA01,alm.CA02 as ACA02,alm.CA03 as ACA03,alm.CA04 as ACA04,alm.CA05 as ACA05,
			/*********************************************************************************************/
			det.Cd_IAV,iav.Descrip as DescripIAV,iav.NomCorto as NomCortoIAV
		from VentaDet det
			Left Join Producto2 pr on pr.Cd_Prod = det.Cd_Prod and pr.RucE = det.RucE
			Left Join Servicio2 srv on srv.Cd_Srv = det.Cd_Srv and srv.RucE= det.RucE
			Left Join Prod_UM ump on ump.RucE=det.RucE and ump.ID_UMP = det.ID_UMP and  ump.Cd_Prod = pr.Cd_Prod --and ump.Cd_UM = um.ID_UMP
			Left Join UnidadMedida um on um.Cd_UM = ump.Cd_UM
			Left Join Almacen alm on alm.Cd_Alm = det.Cd_Alm and alm.RucE = det.RucE
			Left Join IndicadorAfectoVta iav on iav.Cd_IAV = det.Cd_IAV
		Where det.RucE=@RucE and det.Cd_Vta = @Cd_Vta

end
print @msj
-- Leyenda --
-- J : 2010-11-10 	: <Creacion del procedimiento almacenado>
--exec Rpt_Venta_ContaServer '111111111111','2010','VT00000400',null
--select * from venta where ruce='11111111111' and CD_Vta = 'VT00000400'
--select * from ventaDet where ruce='11111111111' and Cd_Vta = 'VT00000400'
GO

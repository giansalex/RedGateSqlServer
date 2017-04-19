SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Venta_CampoAdd5]--Procedimiento almacenado para todas las ventas con Campos Adicionales
@RucE nvarchar(11),
@Eje nvarchar(4),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as 
begin
declare @direcAR nvarchar(100)
set @direcAR = ''

	/*================================================================================================*/
	/*DIRECCION DE AREA*/
	/*================================================================================================*/
	if(@RucE = '20518906390')
	begin
	declare @area varchar(6)
	set @area = (select Cd_Area from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
		if(@area = '010101') --LIMA
			set @direcAR = ''   --'CAL. LOS METALES N° 120 URB. IND. BOCANEGRA - LIMA'
		else if(@area = '010102') --CHICLAYO
			set @direcAR = 'CAL. VICTOR RAUL HAYA DE LA TORRE N° 2770 P.J. LA VICTORIA - CHICLAYO'
		else if(@area = '010103') --TRUJILLO
			set @direcAR = ' - TRUJILLO'
		else if(@area = '010104') --AREQUIPA
			set @direcAR = 'AV. INDUSTRIAL N° 302 APIMA - AREQUIPA'
		else if(@area = '010105') --HUARAZ
			set @direcAR = 'AV. ML. NORE RIO QUILLAY N° 777 URB. NICRUPAMPA - HUARAZ'
		else if(@area = '010106') --ICA
			set @direcAR = 'PARCELA N° 13 - ICA'
		else if(@area = '010107') --HUANCAYO
			set @direcAR = 'AV. 9 DE DICIEMBRE N° 599 CHILCA SECTOR 8 - HUANCAYO'
		else if(@area = '010108') --SAN MARTIN
			set @direcAR = 'MARGINAL NORTE N° 365 - SAN MARTIN'
		else if(@area = '010109') --CUSCO
			set @direcAR = 'URB. PARQUE INDUSTRIAL WANCHAQ, CALLE. LAS AMERICAS MZ. D LOTE 11'
		else set @direcAR = 'En esta Area no se definio direccion'
	end		
	/*================================================================================================*/
	/*REPORTE VENTA*/
	/*================================================================================================*/
	select 
	       ------------------------------------------------------------------------------------------------------
	       --Datos empresa--
	       ve.RucE,em.RSocial,em.Direccion,
	       --Datos Cliente--
		
	       cl.Cd_Clt,cl.Cd_TDI,ti.Descrip as DescripTDI,cl.NDoc as NDocCli,
	       case(isnull(len(cl.RSocial),0))
		             when 0 then cl.ApPat+' '+cl.ApMat+' '+cl.Nom
		 	     else cl.RSocial end as RSocialCli,
                    cl.Direc as DirecCli,cl.Telf1 as TelfCli1,cl.Telf2 as Telf1Cli2,
		--Datos Vendedor--		
	       vnd.Cd_Vdr,vnd.Cd_TDI,ti.Descrip as DescripTDI,vnd.NDoc as NDocVnd,
	       case(isnull(len(vnd.RSocial),0))
			     when 0 then vnd.ApPat+' '+vnd.ApMat+' '+vnd.Nom
			     else vnd.RSocial end as RSocialVnd,
               vnd.Direc as DirecVnd,vnd.Telf1 as TelfVnd,vnd.Telf2 as Telf1Cli1,
	       --Datos venta--
	       ve.Cd_Vta,convert(char,ve.FecMov,103) as FecMov,convert(char,ve.FecCbr,103) as FecCbr,
		--ve.Cd_Sr,
		ve.NroSre,/*nu.NroAutSunat,*/convert(char,ve.FecED,103) as FecED,
		convert(char,ve.FecVD,103) as FecVD,ve.Cd_MR,ve.Obs,
		--ve.INF,ve.EXO,ve.BIM,
		--ve.BIM+ve.INF+ve.EXO as BIM_Vta,ve.IGV as IGV_Vta,ve.Total as Total_Vta,
		ve.CamMda,ve.FecMov as FecMov,ve.UsuCrea,
	       --Datos Tipo Documento--
	       ve.Cd_TD,td.Descrip as DescripTD,ve.NroDoc,
	       --Datos Area--
	       ve.Cd_Area,ar.NCorto as NCortoArea,
	       --Datos Monedas--
               ve.Cd_Mda,mo.Simbolo,mo.Nombre as NomMoneda,
	       --Datos Campo Venta--
	       @direcAR as DirecAr,
	       --Datos Campos Adicionales--
	       ve.CA01,ve.CA02,ve.CA03,ve.CA04,ve.CA05,ve.CA06,ve.CA07,ve.CA08,
	       ve.CA09,ve.CA10,ve.CA11,ve.CA12,ve.CA13,ve.CA14,ve.CA15,
	       ve.DR_CdVTa,ve.DR_FecED,ve.Cd_TD,ve.DR_NSre,ve.DR_NDoc,ve.Cd_OP,ve.NroOP,
	       ve.Valor,ve.TotDsctoP,ve.TotDsctoI,ve.ValorNeto,ve.INF_EXO,ve.DsctoFnzInf_P,
 	       ve.DsctoFnzInf_I,ve.INF_Neto,ve.EXO_Neto,ve.BIM,ve.DsctoFnzAf_P,ve.DsctoFnzAf_I,
	       ve.BIM_Neto,ve.IGV,ve.Total,ve.CamMda

	from Venta ve
	left join Empresa em on ve.RucE=em.Ruc		
	--left join Serie se on ve.RucE=se.RucE and ve.Cd_Sr=se.Cd_Sr
	--left join Auxiliar ca on ve.RucE=ca.RucE and ve.Cd_Cte=ca.Cd_Aux
	--left join Auxiliar va on ve.RucE=va.RucE and ve.Cd_Vdr=va.Cd_Aux and va.Cd_TDI=ti.Cd_TDI
	left join Cliente2 cl on cl.RucE = ve.RucE and cl.Cd_Clt=ve.Cd_Clt --and cl.Cd_TDI = ti.Cd_TDI
	left join TipDocIdn ti on ti.Cd_TDI=cl.Cd_TDI	
	left join Vendedor2 vnd on vnd.RucE = ve.RucE and vnd.Cd_Vdr = ve.Cd_Vdr and vnd.Cd_TDI = ti.Cd_TDI
	left join TipDoc td on ve.Cd_TD=td.Cd_TD
	left join Area ar on ve.RucE=ar.RucE and ve.Cd_Area=ar.Cd_Area
	left join Moneda mo on ve.Cd_Mda=mo.Cd_Mda	
	--left join Numeracion nu on nu.RucE=se.RucE and nu.Cd_Sr=se.Cd_Sr and nu.Desde<=convert(int,ve.NroDoc) and Hasta>=convert(int,ve.NroDoc)
	where ve.RucE=@RucE and ve.Cd_Vta=@Cd_Vta and ve.IB_Anulado=0
	/*================================================================================================*/
	/*REPORTE DETALLE VENTA*/
	/*================================================================================================*/	
	select 
	       --Datos Producto2--
               de.Cd_Prod, 
		pr.Nombre1 as NomPro,
		pr.Descrip,pr.NCorto,
		pr.CodCo1_,pr.CodCo2_,
		pr.CodCo3_,pr.Cd_Mca,
	       --Datos Campos Informativos del producto--
	       pr.CA01 as CP1,pr.CA02 as CP2,
	       pr.CA03 as CP3,pr.CA04 as CP4,
	       pr.CA05 as CP5,pr.CA06 as CP6,
	       pr.CA07 as CP7,pr.CA08 as CP8,
	       pr.CA09 as CP9,pr.CA10 as CP10,
	       --Datos Servicio2--
	       de.Cd_Srv,se.CodCo,se.Nombre,se.Descrip,se.NCorto,
	       --Datos Campos Informativos del producto--
	       pr.CA01 as CS1,pr.CA02 as CS2,pr.CA03 as CS3,pr.CA04 as CS4,pr.CA05 as CS5,pr.CA06 as CS6,
	       pr.CA07 as CS7,pr.CA08 as CS8,pr.CA09 as CS9,pr.CA10 as CS10,
	       --Datos Detalle Venta--
	       de.Cant,de.Valor,de.DsctoI,DsctoP,de.IMP,de.IGV,de.Total,
	       --Datos Campos Informativos de Detalle Venta--
	       de.CA01,de.CA02,de.CA03,de.CA04,de.CA05,de.CA06,de.CA07,de.CA08,de.CA09,de.CA10,
	       --Datos Unidad Medida--
	       de.Id_UMP,de.PU,de.Cd_Alm,de.Obs,
	       --Datos Servicio--
	       se.Cd_GS, gr.Descrip as NomGS,
	       Nro_RegVdt as NroPro --INFORMACION ADICIONADA
               -------------------------------------------------------------------------------------------------------	       
	from 
	       VentaDet de,
	       Producto2 pr,
	       Prod_UM um,
               Servicio2 se,
               GrupoSrv gr
	where de.RucE=@RucE and de.Cd_Vta=@Cd_Vta and 
	      de.RucE=pr.RucE and de.Cd_Prod=pr.Cd_Prod and
	      de.RucE=se.RucE and de.Cd_Srv=se.Cd_Srv and
	      --pr.RucE=se.RucE and pr.Cd_Prod=se.Cd_Srv and
	      se.RucE=gr.RucE and se.Cd_GS=gr.Cd_GS and
	      de.Id_UMP=um.Id_UMP      
	
end
print @msj
-- Leyenda --
-------------
-- Di 08/10/2009 Modificacion : Se agrego una seleccion de los campos adicionales del servicio
			      --Se agrego el campo Nro_RegVdt en la seleccion detalle (Ref 2do Select) 
-- Je 13/10/2009 Modificacion : Se agrego el campo CodCo
			      --Modificado--
-- Je 22/09/2010 <Modif:
-- 			RA01,MG05 ; se adaptaron tablas como producto2, servicio2 para los reportes
--			a su vez auxiliares
GO

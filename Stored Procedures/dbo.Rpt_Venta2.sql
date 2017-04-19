SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Venta2]
@RucE nvarchar(11),
@Eje nvarchar(4),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as 
begin
declare @CampoInsp nvarchar(10),@direcAR nvarchar(100)
set @direcAR = ''
set @CampoInsp = (select Valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='01')
	
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
	       ca.Cd_Clt/*ca.Cd_Aux*/,ca.Cd_TDI,ti.Descrip as DescripTDI,ca.NDoc as NDocCli,
	       /*case(isnull(len(ca.RSocial),0))
		             when 0 then ca.ApPat+' '+ca.ApMat+' '+ca.Nom
		 	     else ca.RSocial end as RSocialCli,*/
		case(isnull(len(ca.RSocial),0)) 
		when 0 then isnull(nullif(ca.ApPat +' '+ca.ApMat+' '+ca.Nom,''),'------- SIN NOMBRE ------')
		else ca.RSocial end as RSocialCli,
                    ca.Direc as DirecCli,ca.Telf1 as Telf1Cli,ca.Telf2 as Telf1Cli1,
	       --Datos venta--
	       ve.Cd_Vta,convert(char,ve.FecMov,103) as FecMov,convert(char,ve.FecCbr,103) as FecCbr,ve.Cd_Sr,se.NroSerie,nu.NroAutSunat,convert(char,ve.FecED,103) as FecED,convert(char,ve.FecVD,103) as FecVD,ve.Cd_MR,ve.Obs,ve.INF,ve.EXO,ve.BIM,ve.BIM+ve.INF+ve.EXO as BIM_Vta,ve.IGV as IGV_Vta,ve.Total as Total_Vta,ve.CamMda,ve.FecMov as FecMov,ve.UsuCrea,
	       --Datos Vendedor--
	       /*ve.Cd_Vdr,case(isnull(len(va.RSocial),0))
	    		     when 0 then va.ApPat+' '+va.ApMat+' '+va.Nom
	    		     else va.RSocial end as NomCompVdr,*/
		case(isnull(len(va.RSocial),0)) 
		when 0 then isnull(nullif(va.ApPat +' '+va.ApMat+' '+va.Nom,''),'------- SIN NOMBRE ------')
		else va.RSocial end as NomCompVdr,
	       --Datos Tipo Documento--
	       ve.Cd_TD,td.Descrip as DescripTD,ve.NroDoc,
	       --Datos Area--
	       ve.Cd_Area,ar.NCorto as NCortoArea,
	       --Datos Monedas--
                    ve.Cd_Mda,mo.Simbolo,mo.Nombre as NomMoneda,
	       --Datos Campo Venta--
	       @CampoInsp as 'Inspeccion',
	       @direcAR as DirecAr
	from Venta ve
	left join Empresa em on ve.RucE=em.Ruc
	--left join Auxiliar ca on ve.RucE=ca.RucE and ve.Cd_Cte=ca.Cd_Aux
	left join Cliente2 ca on ve.RucE=ca.RucE and ve.Cd_Clt=ca.Cd_Clt
	left join TipDocIdn ti on ca.Cd_TDI=ti.Cd_TDI
	left join Serie se on ve.RucE=se.RucE and ve.Cd_Sr=se.Cd_Sr
	--left join Auxiliar va on ve.RucE=va.RucE and ve.Cd_Vdr=va.Cd_Aux and va.Cd_TDI=ti.Cd_TDI
	left join Vendedor2 va on ve.RucE=va.RucE and ve.Cd_Vdr=va.Cd_Vdr and va.Cd_TDI=ti.Cd_TDI
	left join TipDoc td on ve.Cd_TD=td.Cd_TD
	left join Area ar on ve.RucE=ar.RucE and ve.Cd_Area=ar.Cd_Area
	left join Moneda mo on ve.Cd_Mda=mo.Cd_Mda
	
	left join Numeracion nu on nu.RucE=se.RucE and nu.Cd_Sr=se.Cd_Sr and nu.Desde<=convert(int,ve.NroDoc) and Hasta>=convert(int,ve.NroDoc)

	--left join Numeracion nu on nu.RucE=ve.RucE and nu.Cd_Num=ve.Cd_Num

	where ve.RucE=@RucE /*and Eje=@Eje */and ve.Cd_Vta=@Cd_Vta and ve.IB_Anulado=0
	
	/*================================================================================================*/
	/*REPORTE DETALLE VENTA*/
	/*================================================================================================*/
	--select * from Producto2
	select 
	       --Datos Producto--
               de.Cd_Prod, pr.Nombre1 as NomPro,
	       --Datos Detalle Venta--
	       de.Cant,de.Valor,de.DsctoI,de.IMP,de.IGV,de.Total,
	       --Datos Unidad Medida--
	       de.ID_UMP,um.NCorto as NCortoUM,
	       --Datos Servicio--
	       se.Cd_GS, gr.Descrip as NomGS
               -------------------------------------------------------------------------------------------------------	       
	from VentaDet de, Producto2 pr, UnidadMedida um, Servicio2 se, GrupoSrv gr
	where de.RucE=@RucE and de.Cd_Vta=@Cd_Vta and 
	      de.RucE=pr.RucE and de.Cd_Prod=pr.Cd_Prod/*de.Cd_Pro=pr.Cd_Pro*/ and
	      pr.RucE=se.RucE and pr.Cd_Prod=se.Cd_Srv/*pr.Cd_Pro=se.Cd_Srv*/ and
	      se.RucE=gr.RucE and se.Cd_GS=gr.Cd_GS and
	      de.ID_UMP=um.Cd_UM/*de.Cd_UM=um.Cd_UM*/      

	/*================================================================================================*/
	/*REPORTE CAMPO VENTA*/
	/*================================================================================================*/	
	select v.RucE, v.Cd_Vta,v.Cd_Cp,c.Nombre as NomCP, c.NCorto as NCortoCP,c.Cd_TC,v.Valor
	from CampoV v, Campo c, CampoT t
	where v.RucE=@RucE and v.Cd_Vta=@Cd_Vta and v.RucE=c.RucE and v.Cd_Cp=c.Cd_Cp and c.Cd_TC=t.Cd_TC
	/*================================================================================================*/
	/*CAMPO_VALOR*/
	/*================================================================================================*/	
	Select 	v.Cd_Vta,(c.Nombre+' : '+v.Valor) as Valor_Campo
	from 	CampoV v, Campo c, CampoT t
	where 	v.RucE=@RucE and v.Cd_Vta=@Cd_Vta and
		v.RucE=c.RucE and v.Cd_Cp=c.Cd_Cp and 
		c.Cd_TC=t.Cd_TC
	order by 
		v.Cd_Vta
	
end
print @msj

--exec dbo.Rpt_Venta2 '11111111111', '2010', 'VT00000021', null
--MP: MAR 21-09-2010 Modf: Se quito las referencias a la tabla Auxiliar y se enlazo con Cliente2, Proveedor2, Servicio2 y Producto2
--CM: RA01
GO

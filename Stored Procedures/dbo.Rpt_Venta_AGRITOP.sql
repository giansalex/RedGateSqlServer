SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Venta_AGRITOP]
--//CAMBIAR LA FECHA DE REGISTRO POR FECHA DE MOVIMIENTO
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
			set @direcAR = ''   --'CAL. LOS METALES NÃ‚Â° 120 URB. IND. BOCANEGRA - LIMA'
		else if(@area = '010102') --CHICLAYO
			set @direcAR = 'CAL. VICTOR RAUL HAYA DE LA TORRE NÃ‚Â° 2770 P.J. LA VICTORIA - CHICLAYO'
		else if(@area = '010103') --TRUJILLO
			set @direcAR = ' - TRUJILLO'
		else if(@area = '010104') --AREQUIPA
			set @direcAR = 'AV. INDUSTRIAL NÃ‚Â° 302 APIMA - AREQUIPA'
		else if(@area = '010105') --HUARAZ
			set @direcAR = 'AV. ML. NORE RIO QUILLAY NÃ‚Â° 777 URB. NICRUPAMPA - HUARAZ'
		else if(@area = '010106') --ICA
			set @direcAR = 'PARCELA NÃ‚Â° 13 - ICA'
		else if(@area = '010107') --HUANCAYO
			set @direcAR = 'AV. 9 DE DICIEMBRE NÃ‚Â° 599 CHILCA SECTOR 8 - HUANCAYO'
		else if(@area = '010108') --SAN MARTIN
			set @direcAR = 'MARGINAL NORTE NÃ‚Â° 365 - SAN MARTIN'
		else if(@area = '010109') --CUSCO
			set @direcAR = 'URB. PARQUE INDUSTRIAL WANCHAQ, CALLE. LAS AMERICAS MZ. D LOTE 11'
		else set @direcAR = 'En esta Area no se definio direccion'
	end		


	/*================================================================================================*/
	/*REPORTE VENTA*/
	/*================================================================================================*/
	--Pto 11
	select
	-- Datos empresa --
	v.RucE, em.RSocial, em.Direccion,
	-- Datos Cliente --
	cl.Cd_Clt as Cd_Aux, cl.Cd_TDI, ti.Descrip as DescripTDI,cl.NDoc as NDocCli,
	case(isnull(len(cl.RSocial),0)) 
		when 0 then cl.ApPat + ' ' +cl.ApMat + ' ' + cl.Nom 
		else cl.RSocial end as RSocialCli,
		cl.Direc as DirecCli,cl.Telf1 as Telf1Cli,cl.Telf2 as Telf1Cli1,
	-- Datos Venta --
	v.Cd_Vta, convert(char,v.FecMov,103) as FecMov,Convert(char,v.FecCbr,103) as FecCbr, ' ' as Cd_Sr/*v.Cd_Sr*/,v.NroSre as NroSerie/*se.NroSerie*/, ' ' as NroAutSunat, /*nu.NroAutSunat,*/convert(char,v.FecED,103) as FecED,convert(char,v.FecVD,103) as FecVD,
	v.Cd_MR,v.Obs, v.INF_Neto as INF, v.EXO_Neto as EXO, v.BIM_Neto as BIM,v.BIM_Neto + v.INF_Neto + v.EXO_Neto as BIM_Vta,v.IGV as IGV_Vta,v.Total as Total_Vta,v.CamMda,v.FecMov as FecMov,v.UsuCrea,
	-- Datos Vendedor --
	v.Cd_Vdr, case(isnull(len(v2.RSocial),0))
		when 0 then v2.ApPat + ' ' +v2.ApMat + ' ' +v2.Nom
		else v2.RSocial end as NomCompVdr,
	-- Datos Tipo Documento --
	v.Cd_TD,td.Descrip as DescripTD,v.NroDoc,
	-- Datos Monedas --
	v.Cd_Mda,mo.Simbolo,mo.Nombre as NomMoneda
	from Venta v 
	left join Empresa em on v.RucE=em.Ruc
	left join Cliente2 cl on cl.RucE=v.RucE and v.Cd_Clt=cl.Cd_Clt
	left join TipDocIdn ti on cl.Cd_TDI=ti.Cd_TDI
	left join TipDoc td on v.Cd_TD=td.Cd_TD
	--left join Serie se on v.RucE=se.RucE and v.Cd_Sr=se.Cd_sr
	-- join Numeracion nu on nu.RucE=se.RucE and nu.Cd_Sr=se.Cd_Sr and nu.Desde<=Convert(int,v.NroDoc) and Hasta>=Convert(int,v.NroDoc)
	left join Vendedor2 v2 on v2.RucE=v.RucE and v.Cd_Vdr=v2.Cd_Vdr and v2.Cd_TDI=ti.Cd_TDI
	left join Moneda mo on v.Cd_Mda=mo.Cd_Mda
	
	where v.RucE=@RucE /*and Eje=@Eje */and v.Cd_Vta=@Cd_Vta and v.IB_Anulado=0
	
	/*select 
	       ------------------------------------------------------------------------------------------------------
	       --Datos empresa--
	       ve.RucE,em.RSocial,em.Direccion,
	       --Datos Cliente--
	       ca.Cd_Aux,ca.Cd_TDI,ti.Descrip as DescripTDI,ca.NDoc as NDocCli,
	       case(isnull(len(ca.RSocial),0))
		             when 0 then ca.ApPat+' '+ca.ApMat+' '+ca.Nom
		 	     else ca.RSocial end as RSocialCli,
                    ca.Direc as DirecCli,ca.Telf1 as Telf1Cli,ca.Telf2 as Telf1Cli1,
	       --Datos venta--
	       ve.Cd_Vta,convert(char,ve.FecMov,103) as FecMov,convert(char,ve.FecCbr,103) as FecCbr,ve.Cd_Sr,se.NroSerie,nu.NroAutSunat,convert(char,ve.FecED,103) as FecED,convert(char,ve.FecVD,103) as FecVD,ve.Cd_MR,ve.Obs,ve.INF,ve.EXO,ve.BIM,ve.BIM+ve.INF+ve.EXO as BIM_Vta,ve.IGV as IGV_Vta,ve.Total as Total_Vta,ve.CamMda,ve.FecMov as FecMov,ve.UsuCrea,
	       --Datos Vendedor--
	       ve.Cd_Vdr,case(isnull(len(va.RSocial),0))
	    		     when 0 then va.ApPat+' '+va.ApMat+' '+va.Nom
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
	left join Auxiliar ca on ve.RucE=ca.RucE and ve.Cd_Cte=ca.Cd_Aux
	left join TipDocIdn ti on ca.Cd_TDI=ti.Cd_TDI
	left join Serie se on ve.RucE=se.RucE and ve.Cd_Sr=se.Cd_Sr
	left join Auxiliar va on ve.RucE=va.RucE and ve.Cd_Vdr=va.Cd_Aux and va.Cd_TDI=ti.Cd_TDI
	left join TipDoc td on ve.Cd_TD=td.Cd_TD
	left join Area ar on ve.RucE=ar.RucE and ve.Cd_Area=ar.Cd_Area
	left join Moneda mo on ve.Cd_Mda=mo.Cd_Mda
	
	left join Numeracion nu on nu.RucE=se.RucE and nu.Cd_Sr=se.Cd_Sr and nu.Desde<=convert(int,ve.NroDoc) and Hasta>=convert(int,ve.NroDoc)

	--left join Numeracion nu on nu.RucE=ve.RucE and nu.Cd_Num=ve.Cd_Num

	where ve.RucE=@RucE and Eje=@Ejeand ve.Cd_Vta=@Cd_Vta and ve.IB_Anulado=0*/

	/*================================================================================================*/
	/*REPORTE DETALLE VENTA*/
	/*================================================================================================*/
		select
		--Datos Producto--
	       case(isnull(len(de.Cd_Prod),0)) when 0 then de.Cd_Srv else de.Cd_Prod end as Cd_Pro,
	       case(isnull(len(de.Cd_Prod),0)) when 0 then sr.Nombre else pr.Nombre1 end as NomPro,
	       de.Cant,de.Valor,de.DsctoI,de.IMP,de.IGV,de.Total, de.ID_UMP as Cd_UM, um.DescripAlt as NCortoUM,
	       sr.Cd_GS, gr.Descrip as NomGS
	       from VentaDet de
	       left join Producto2 pr on de.RucE=pr.RucE and de.Cd_Prod=pr.Cd_Prod
	       left join Servicio2 sr on sr.RucE=de.RucE and sr.Cd_Srv=de.Cd_Srv
	       left join Prod_UM um on um.RucE=de.RucE and um.Cd_Prod=de.Cd_Prod and um.ID_UMP=de.ID_UMP
	       left join GrupoSrv gr on gr.RucE=sr.RucE and sr.Cd_GS=gr.Cd_GS
	       where de.RucE=@RucE and de.Cd_Vta=@Cd_Vta
	/*select 
	       --Datos Producto--
               de.Cd_Pro as Cd_Pro, pr.Nombre as NomPro,
	       --Datos Detalle Venta--
	       de.Cant,de.Valor,de.DsctoI,de.IMP,de.IGV,de.Total,
	       --Datos Unidad Medida--
	       de.Cd_UM as Cd_UM,um.NCorto as NCortoUM,
	       --Datos Servicio--
	       se.Cd_GS, gr.Descrip as NomGS
               -------------------------------------------------------------------------------------------------------	       
	from VentaDet de, Producto pr, UnidadMedida um, Servicio se, GrupoSrv gr
	where de.RucE=@RucE and de.Cd_Vta=@Cd_Vta and 
	      de.RucE=pr.RucE and de.Cd_Pro=pr.Cd_Pro and
	      pr.RucE=se.RucE and pr.Cd_Pro=se.Cd_Srv and
	      se.RucE=gr.RucE and se.Cd_GS=gr.Cd_GS and
	      de.Cd_UM=um.Cd_UM      
	*/
	/*================================================================================================*/
	/*REPORTE CAMPO VENTA*/
	/*================================================================================================*/
	
	select v.RucE, v.Cd_Vta,v.Cd_Cp,c.Nombre as NomCP, c.NCorto as NCortoCP,c.Cd_TC,v.Valor
	from CampoV v, Campo c, CampoT t
	where v.RucE=@RucE and v.Cd_Vta=@Cd_Vta and v.RucE=c.RucE and v.Cd_Cp=c.Cd_Cp and c.Cd_TC=t.Cd_TC

	/*================================================================================================*/
	/*REPORTE CAMPOS ADICIONALES*/
	/*================================================================================================*/

Declare @v1 nvarchar(100),@v2 nvarchar(100),@v3 nvarchar(100)
	Declare @v4 nvarchar(100),@v5 nvarchar(100),@v6 nvarchar(100)
	Declare @v7 nvarchar(100),@v8 nvarchar(100),@v9 nvarchar(100)
	Declare @v10 nvarchar(100),@v11 nvarchar(100),@v12 nvarchar(100)

	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='01') Set @v1=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='01') else    Set @v1= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='02') Set @v2=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='02') else    Set @v2= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='03') Set @v3=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='03') else    Set @v3= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='04') Set @v4=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='04') else    Set @v4= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='05') Set @v5=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='05') else    Set @v5= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='06') Set @v6=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='06') else    Set @v6= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='07') Set @v7=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='07') else    Set @v7= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='08') Set @v8=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='08') else    Set @v8= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='09') Set @v9=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='09') else    Set @v9= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='10') Set @v10=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='10') else    Set @v10= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='11') Set @v11=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='11') else    Set @v11= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='12') Set @v12=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='12') else    Set @v12= '  '

	Select @v1 as V1, @v2 as V2, @v3 as V3, @v4 as V4, @v5 as V5, @v6 as V6, @v7 as V7, @v8 as V8,@v9 as V9,@v10 as V10,@v11 as V11,@v12 as V12
end
print @msj
-- Leyenda -- 
-- exec dbo.Rpt_Venta_AGRITOP '11111111111','2010','VT00000326',null
-- JJ: 2010-08-20:  Modificacion del SP Se Modificio Consulta Buscar Pto 11


GO

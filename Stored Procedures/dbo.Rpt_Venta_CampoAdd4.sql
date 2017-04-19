SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Venta_CampoAdd4]
---Procedimiento almacenado para todas las ventas con Campos Adicionales
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

	where ve.RucE=@RucE /*and Eje=@Eje */and ve.Cd_Vta=@Cd_Vta and ve.IB_Anulado=0

	/*================================================================================================*/
	/*REPORTE DETALLE VENTA*/
	/*================================================================================================*/
	
	select 
	       --Datos Producto--
               de.Cd_Vta,de.Cd_Pro, pr.Nombre as NomPro,pr.CodCo,
	       --Datos Detalle Venta--
	       de.Cant,de.Valor,de.DsctoI,de.IMP,de.IGV,de.Total,
	       --Datos Unidad Medida--
	       de.Cd_UM,um.NCorto as NCortoUM,
	       --Datos Servicio--
	       se.Cd_GS, gr.Descrip as NomGS,
	       --INFORMACION ADICIONADA
	       Nro_RegVdt as NroPro, 
	       --CAMPOS INFORMATIVOS
	       de.CA01,de.CA02,de.CA03,de.CA04,de.CA05,de.CA06,de.CA07,de.CA08,de.CA09,de.CA10
               -------------------------------------------------------------------------------------------------------	       
	from VentaDet de, Producto pr, UnidadMedida um, Servicio se, GrupoSrv gr
	where de.RucE=@RucE and de.Cd_Vta=@Cd_Vta and 
	      de.RucE=pr.RucE and de.Cd_Pro=pr.Cd_Pro and
	      pr.RucE=se.RucE and pr.Cd_Pro=se.Cd_Srv and
	      se.RucE=gr.RucE and se.Cd_GS=gr.Cd_GS and
	      de.Cd_UM=um.Cd_UM      

	/*================================================================================================*/
	/*REPORTE CAMPO VENTA*/
	/*================================================================================================*/
	
	select v.RucE, v.Cd_Vta,v.Cd_Cp,c.Nombre as NomCP, c.NCorto as NCortoCP,c.Cd_TC,v.Valor
	from CampoV v, Campo c, CampoT t
	where v.RucE=@RucE and v.Cd_Vta=@Cd_Vta and v.RucE=c.RucE and v.Cd_Cp=c.Cd_Cp and c.Cd_TC=t.Cd_TC

	/*================================================================================================*/
	/*REPORTE CAMPOS ADICIONALES*/
	/*================================================================================================*/

	--TREINTA (30) CAMPOS ADICIONALES PARA TODAS LAS EMPRESAS CON CAMPOS ADICIONALES
	Declare @v1 nvarchar(100),@v2 nvarchar(100),@v3 nvarchar(100)
	Declare @v4 nvarchar(100),@v5 nvarchar(100),@v6 nvarchar(100)
	Declare @v7 nvarchar(100),@v8 nvarchar(100),@v9 nvarchar(100)
	Declare @v10 nvarchar(100),@v11 nvarchar(100),@v12 nvarchar(100)
	Declare @v13 nvarchar(100),@v14 nvarchar(100),@v15 nvarchar(100)
	Declare @v16 nvarchar(100),@v17 nvarchar(100),@v18 nvarchar(100)
	Declare @v19 nvarchar(100),@v20 nvarchar(100),@v21 nvarchar(100)
	Declare @v22 nvarchar(100),@v23 nvarchar(100),@v24 nvarchar(100)
	Declare @v25 nvarchar(100),@v26 nvarchar(100),@v27 nvarchar(100)
	Declare @v28 nvarchar(100),@v29 nvarchar(100),@v30 nvarchar(100)
			
	--TREINTA (30) CAMPOS DE UNIDADES PARA TODAS LAS EMPRESAS CON CAMPOS ADICIONALES
	Declare @nc1 nvarchar(100),@nc2 nvarchar(100),@nc3 nvarchar(100)
	Declare @nc4 nvarchar(100),@nc5 nvarchar(100),@nc6 nvarchar(100)
	Declare @nc7 nvarchar(100),@nc8 nvarchar(100),@nc9 nvarchar(100)
	Declare @nc10 nvarchar(100),@nc11 nvarchar(100),@nc12 nvarchar(100)
	Declare @nc13 nvarchar(100),@nc14 nvarchar(100),@nc15 nvarchar(100)
	Declare @nc16 nvarchar(100),@nc17 nvarchar(100),@nc18 nvarchar(100)
	Declare @nc19 nvarchar(100),@nc20 nvarchar(100),@nc21 nvarchar(100)
	Declare @nc22 nvarchar(100),@nc23 nvarchar(100),@nc24 nvarchar(100)
	Declare @nc25 nvarchar(100),@nc26 nvarchar(100),@nc27 nvarchar(100)
	Declare @nc28 nvarchar(100),@nc29 nvarchar(100),@nc30 nvarchar(100)

	-----------------------------
	/*CAMPOS INFORMATIVOS*/
	-----------------------------
	/*Declare @CA01 varchar(50),@CA02 varchar(50),@CA03 varchar(50)
	Declare @CA04 varchar(50),@CA05 varchar(50),@CA06 varchar(50)
	Declare @CA07 varchar(50),@CA08 varchar(50),@CA09 varchar(50)
	Declare @CA10 varchar(50)*/

	----@@@@@@@@@@@@@@@@@@-----
	Declare @CA01 varchar(50),@CA06 varchar(50)
	SET @CA01=(select CA01 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta)
	SET @CA06=(select CA06 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta)
	if(@CA01='' or @CA01 is null)
	set @msj = 'El campo'+@CA01+'es obligatorio'
	if(@CA06 = '' or @CA06 is null)
	set @msj = 'El campo'+@CA06+'es obligatorio'
	------------------------------
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='01') Set @v1=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='01') else    Set @v1= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='02') Set @v2=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='02') else    Set @v2= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='03') Set @v3=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='03') else    Set @v3= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='04') Set @v4=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='04') else    Set @v4= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='05') Set @v5=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='05') else    Set @v5= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='06') Set @v6=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='06') else    Set @v6= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='07') Set @v7=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='07') else    Set @v7= '  '	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='08') Set @v8=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='08') else    Set @v8= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='09') Set @v9=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='09') else    Set @v9= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='10') Set @v10=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='10')else   Set @v10= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='11') Set @v11=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='11')else   Set @v11= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='12') Set @v12=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='12')else   Set @v12= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='13') Set @v13=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='13')else   Set @v13= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='14') Set @v14=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='14')else   Set @v14= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='15') Set @v15=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='15')else   Set @v15= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='16') Set @v16=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='16')else   Set @v16= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='17') Set @v17=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='17')else   Set @v17= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='18') Set @v18=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='18')else   Set @v18= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='19') Set @v19=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='19')else   Set @v19= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='20') Set @v20=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='20')else   Set @v20= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='21') Set @v21=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='21')else   Set @v21= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='22') Set @v22=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='22')else   Set @v22= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='23') Set @v23=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='23')else   Set @v23= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='24') Set @v24=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='24')else   Set @v24= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='25') Set @v25=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='25')else   Set @v25= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='26') Set @v26=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='26')else   Set @v26= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='27') Set @v27=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='27')else   Set @v27= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='28') Set @v28=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='27')else   Set @v28= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='29') Set @v29=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='27')else   Set @v29= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='30') Set @v30=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='27')else   Set @v30= '  '


	/*----*/
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='01') 
		Set @nc1=' ' 
	else 
		Set @nc1=(select Nombre from Campo where RucE=@RucE and Cd_Cp='01')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='02')
		Set @nc2=' ' 
	else 
		Set @nc2=(select Nombre from Campo where RucE=@RucE and Cd_Cp='02')
 	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='03')
		Set @nc3=' ' 
	else 
		Set @nc3=(select Nombre from Campo where RucE=@RucE and Cd_Cp='03')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='04')
		Set @nc4=' ' 
	else 
		Set @nc4=(select Nombre from Campo where RucE=@RucE and Cd_Cp='04')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='05')
		Set @nc5=' ' 
	else 
		Set @nc5=(select Nombre from Campo where RucE=@RucE and Cd_Cp='05')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='06')
		Set @nc6=' ' 
	else 
		Set @nc6=(select Nombre from Campo where RucE=@RucE and Cd_Cp='06')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='07')
		Set @nc7=' ' 
	else 
		Set @nc7=(select Nombre from Campo where RucE=@RucE and Cd_Cp='07')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='08')
		Set @nc8=' ' 
	else 
		Set @nc8=(select Nombre from Campo where RucE=@RucE and Cd_Cp='08')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='09')
		Set @nc9=' ' 
	else 
		Set @nc9=(select Nombre from Campo where RucE=@RucE and Cd_Cp='09')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='10')
		Set @nc10=' ' 
	else 
		Set @nc10=(select Nombre from Campo where RucE=@RucE and Cd_Cp='10')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='11')
		Set @nc11=' ' 
	else 
		Set @nc11=(select Nombre from Campo where RucE=@RucE and Cd_Cp='11')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='12')
		Set @nc12=' ' 
	else 
		Set @nc12=(select Nombre from Campo where RucE=@RucE and Cd_Cp='12')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='13')
		Set @nc13=' ' 
	else 
		Set @nc13=(select Nombre from Campo where RucE=@RucE and Cd_Cp='13')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='14')
		Set @nc14=' ' 
	else 
		Set @nc14=(select Nombre from Campo where RucE=@RucE and Cd_Cp='14')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='15')
		Set @nc15=' ' 
	else 
		Set @nc15=(select Nombre from Campo where RucE=@RucE and Cd_Cp='15')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='16')
		Set @nc16=' ' 
	else 
		Set @nc16=(select Nombre from Campo where RucE=@RucE and Cd_Cp='16')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='17')
		Set @nc17=' ' 
	else 
		Set @nc17=(select Nombre from Campo where RucE=@RucE and Cd_Cp='17')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='18')
		Set @nc18=' ' 
	else 
		Set @nc18=(select Nombre from Campo where RucE=@RucE and Cd_Cp='18')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='19')
		Set @nc19=' ' 
	else 
		Set @nc19=(select Nombre from Campo where RucE=@RucE and Cd_Cp='19')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='20')
		Set @nc20=' ' 
	else 
		Set @nc20=(select Nombre from Campo where RucE=@RucE and Cd_Cp='20')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='21')
		Set @nc21=' ' 
	else 
		Set @nc21=(select Nombre from Campo where RucE=@RucE and Cd_Cp='21')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='22')
		Set @nc22=' ' 
	else 
		Set @nc22=(select Nombre from Campo where RucE=@RucE and Cd_Cp='22')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='23')
		Set @nc23=' ' 
	else 
		Set @nc23=(select Nombre from Campo where RucE=@RucE and Cd_Cp='23')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='24')
		Set @nc24=' ' 
	else 
		Set @nc24=(select Nombre from Campo where RucE=@RucE and Cd_Cp='24')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='25')
		Set @nc25=' ' 
	else 
		Set @nc25=(select Nombre from Campo where RucE=@RucE and Cd_Cp='25')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='26')
		Set @nc26=' ' 
	else 
		Set @nc26=(select Nombre from Campo where RucE=@RucE and Cd_Cp='26')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='27')
		Set @nc27=' ' 
	else 
		Set @nc27=(select Nombre from Campo where RucE=@RucE and Cd_Cp='27')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='28')
		Set @nc28=' ' 
	else 
		Set @nc28=(select Nombre from Campo where RucE=@RucE and Cd_Cp='28')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='29')
		Set @nc29=' ' 
	else 
		Set @nc29=(select Nombre from Campo where RucE=@RucE and Cd_Cp='29')
	if not exists(select*from Campo where RucE=@RucE and Cd_Cp='30')
		Set @nc30=' ' 
	else 
		Set @nc30=(select Nombre from Campo where RucE=@RucE and Cd_Cp='30')

	/*if not exists(select CA01 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta) 
		Set @CA01=' ' 
	else 
		Set @CA01=(select CA01 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta)
	if not exists(select CA02 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta) 
		Set @CA02=' ' 
	else 
		Set @CA02=(select CA02 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta)
	if not exists(select CA03 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta) 
		Set @CA03=' ' 
	else 
		Set @CA03=(select CA03 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta)
	if not exists(select CA04 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta) 
		Set @CA04=' ' 
	else 
		Set @CA04=(select CA04 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta)
	if not exists(select CA05 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta) 
		Set @CA05=' ' 
	else 
		Set @CA05=(select CA05 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta)
	if not exists(select CA06 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta) 
		Set @CA06=' ' 
	else 
		Set @CA06=(select CA06 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta)
	if not exists(select CA06 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta) 
		Set @CA07=' ' 
	else 
		Set @CA07=(select CA07 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta)
	if not exists(select CA08 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta) 
		Set @CA08=' ' 
	else 
		Set @CA08=(select CA08 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta)
	if not exists(select CA09 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta) 
		Set @CA09=' ' 
	else 
		Set @CA09=(select CA09 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta)
	if not exists(select CA10 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta) 
		Set @CA10=' ' 
	else 
		Set @CA10=(select CA10 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta)*/

	Select 	@v1 as V1,@v2 as V2,@v3 as V3, @v4 as V4, @v5 as V5, @v6 as V6, @v7 as V7, @v8 as V8,@v9 as V9,@v10 as V10,@v11 as V11,@v12 as V12,@v13 as V13,
		@v14 as V14,@v15 as V15,@v16 as V16,@v17 as V17,@v18 as V18,@v19 as V19,@v20 as V20,@v21 as V21,@v22 as V22,@v23 as V23,@v24 as V24,@v25 as V25,
		@v26 as V26,@v27 as V27,@v28 as V28,@v29 as V29,@v30 as V30
	
	Select	@nc1 as N1,@nc2 as N2,@nc3 as N3,@nc4 as N4,@nc5 as N5,@nc6 as N6,@nc7 as N7,@nc8 as N8,@nc9 as N9,@nc10 as N10,@nc11 as N11,@nc12 as N12,@nc13 as N13,@nc14 as N14,@nc15 as N15,
		@nc16 as N16,@nc17 as N17,@nc18 as N18,@nc19 as N19,@nc20 as N20,@nc21 as N21,@nc22 as N22,@nc23 as N23,@nc24 as N24,@nc25 as N25,@nc26 as N26,@nc27 as N27,@nc28 as N28,@nc29 as N29,
		@nc30 as N30


	--select Cd_Vta,Cd_Pro,CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10 from VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta
	/*Select @CA01 as C1,@CA02 as C2,@CA03 as C3,@CA04 as C4,@CA05 as C5,@CA06 as C6,@CA07 as C7,@CA08 as C8,
		@CA09 as C9,@CA10 as C10*/
	
end
print @msj

------CODIGO DE MODIFICACION--------
--CM=MG01
GO

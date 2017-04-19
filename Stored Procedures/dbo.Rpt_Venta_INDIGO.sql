SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Venta_INDIGO]/*PROCEDIMIENTO ALMACENADO PARA CAMPOS INFORMATIVOS*/
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
	       ve.Cd_Vta,convert(char,ve.FecMov,103) as FecMov,convert(char,ve.FecCbr,103) as FecCbr,' ' as Cd_Sr,ve.NroSre as NroSerie,' ' as NroAutSunat,/*ve.Cd_Sr,se.NroSerie,nu.NroAutSunat,*/convert(char,ve.FecED,103) as FecED,convert(char,ve.FecVD,103) as FecVD,ve.Cd_MR,ve.Obs,ve.INF_Neto as INF,ve.EXO_Neto as EXO,ve.BIM_Neto as BIM,ve.BIM_Neto+ve.INF_Neto+ve.EXO_Neto as BIM_Vta/*ve.INF,ve.EXO,ve.BIM,ve.BIM+ve.INF+ve.EXO as BIM_Vta*/,ve.IGV as IGV_Vta,ve.Total as Total_Vta,ve.CamMda,ve.FecMov as FecMov,ve.UsuCrea,
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
	--left join Auxiliar ca on ve.RucE=ca.RucE and ve.Cd_Cte=ca.Cd_Aux
	left join Cliente2 ca on ca.RucE=ve.RucE and ve.Cd_Clt=ca.Cd_Clt
	left join TipDocIdn ti on ca.Cd_TDI=ti.Cd_TDI
	--left join Serie se on ve.RucE=se.RucE and ve.Cd_Sr=se.Cd_Sr
	--left join Auxiliar va on ve.RucE=va.RucE and ve.Cd_Vdr=va.Cd_Aux and va.Cd_TDI=ti.Cd_TDI
	left join Vendedor2 va on va.RucE=va.RucE and ve.Cd_Vdr=va.Cd_Vdr and va.Cd_TDI=ti.Cd_TDI
	left join TipDoc td on ve.Cd_TD=td.Cd_TD
	left join Area ar on ve.RucE=ar.RucE and ve.Cd_Area=ar.Cd_Area
	left join Moneda mo on ve.Cd_Mda=mo.Cd_Mda
	--left join Numeracion nu on nu.RucE=se.RucE and nu.Cd_Sr=se.Cd_Sr and nu.Desde<=convert(int,ve.NroDoc) and Hasta>=convert(int,ve.NroDoc)
	--left join Numeracion nu on nu.RucE=ve.RucE and nu.Cd_Num=ve.Cd_Num
	where ve.RucE=@RucE /*and Eje=@Eje */and ve.Cd_Vta=@Cd_Vta and ve.IB_Anulado=0
	
	/*================================================================================================*/
	/*REPORTE DETALLE VENTA*/
	/*================================================================================================*/
	
	select 
	       --Datos Producto--
               de.Cd_Prod as Cd_Pro, pr.Nombre1 as NomPro,pr.CodCo1_ as CodCo,
	       --Datos Detalle Venta--
	       de.Cant,de.Valor,de.DsctoI,de.IMP,de.IGV,de.Total,
	       --Datos Unidad Medida--
	       de.ID_UMP as Cd_UM,um.DescripAlt as NCortoUM,
	       --Datos Servicio--
	       se.Cd_GS, gr.Descrip as NomGS,
	       Nro_RegVdt as NroPro --INFORMACION ADICIONADA
               -------------------------------------------------------------------------------------------------------	       
	from VentaDet de, Producto2 pr, Prod_UM um, Servicio2 se, GrupoSrv gr
	where de.RucE=@RucE and de.Cd_Vta=@Cd_Vta and 
	      de.RucE=pr.RucE and de.Cd_Prod=pr.Cd_Prod and
	      de.RucE=se.RucE and de.Cd_Srv=se.Cd_Srv and
	      se.RucE=gr.RucE and se.Cd_GS=gr.Cd_GS and
	      de.ID_UMP=um.ID_UMP and um.RucE=de.RucE and de.Cd_Prod=um.Cd_Prod  
	/*================================================================================================*/
	/*REPORTE CAMPO VENTA*/
	/*================================================================================================*/
	select v.RucE, v.Cd_Vta,v.Cd_Cp,c.Nombre as NomCP, c.NCorto as NCortoCP,c.Cd_TC,v.Valor
	from CampoV v, Campo c, CampoT t
	where v.RucE=@RucE and v.Cd_Vta=@Cd_Vta and v.RucE=c.RucE and v.Cd_Cp=c.Cd_Cp and c.Cd_TC=t.Cd_TC
	/*================================================================================================*/
	/*REPORTE CAMPOS ADICIONALES*/
	/*================================================================================================*/
	--CAMP ADICIONAL
	Declare @v1 nvarchar(100),@v2 nvarchar(100),@v3 nvarchar(100)
	Declare @v4 nvarchar(100),@v5 nvarchar(100),@v6 nvarchar(100)
	Declare @v7 nvarchar(100),@v8 nvarchar(100),@v9 nvarchar(100)
	Declare @v10 nvarchar(100),@v11 nvarchar(100),@v12 nvarchar(100)
	Declare @v13 nvarchar(100),@v14 nvarchar(100),@v15 nvarchar(100)
	Declare @v16 nvarchar(100),@v17 nvarchar(100),@v18 nvarchar(100)
	Declare @v19 nvarchar(100),@v20 nvarchar(100)
	--CAMP ADICIONAL
	Declare @nc1 nvarchar(100),@nc2 nvarchar(100),@nc3 nvarchar(100)
	Declare @nc4 nvarchar(100),@nc5 nvarchar(100),@nc6 nvarchar(100)
	Declare @nc7 nvarchar(100),@nc8 nvarchar(100),@nc9 nvarchar(100)
	Declare @nc10 nvarchar(100),@nc11 nvarchar(100),@nc12 nvarchar(100)
	Declare @nc13 nvarchar(100),@nc14 nvarchar(100),@nc15 nvarchar(100)
	Declare @nc16 nvarchar(100),@nc17 nvarchar(100),@nc18 nvarchar(100)
	Declare @nc19 nvarchar(100),@nc20 nvarchar(100)
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='01') Set @v1=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='01') else    Set @v1= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='02') Set @v2=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='02') else    Set @v2= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='03') Set @v3=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='03') else    Set @v3= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='04') Set @v4=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='04') else    Set @v4= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='05') Set @v5=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='05') else    Set @v5= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='06') Set @v6=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='06') else    Set @v6= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='07') Set @v7=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='07') else    Set @v7= '  '	
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='08') Set @v8=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='08') else    Set @v8= '  '
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

	Select 	@v1 as V1,
		case(isnull(len(@v1),0)) 
		when 0 
		then '' 
		else 
		@v1 end as V1,		
		
		@v2 as V2,
		case(isnull(len(@v1),0)) 
		when 0 
		then '' 
		else 
		@v2 end as V2,	
		
		@v3 as V3,
		case(isnull(len(@v3),0)) 
		when 0 
		then '' 
		else 
		@v3 
		end as V3,
		
		@v4 as V4,
		case(isnull(len(@v4),0)) 
		when 0 
		then '' 
		else 
		@v4 end as V4,		
		
		@v5 as V5,
		case(isnull(len(@v5),0)) 
		when 0 
		then 0 
		else 
		convert(varchar(50),convert(decimal(6,2),@v5)) 
		end as V5,
		
		@v6 as V6,
		case(isnull(len(@v6),0)) 
		when 0 
		then 0 
		else 
		convert(varchar(50),convert(decimal(6,2),@v6)) 
		end as V6,
		
		@v7 as V7,
		case(isnull(len(@v7),0)) 
		when 0 
		then '' 
		else 
		@v7 end as V7,
		
		@v8 as V8,
		case(isnull(len(@v8),0)) 
		when 0 
		then '' 
		else 
		@v8 end as V8,
		
		@v9 as V9,
		case(isnull(len(@v9),0)) 
		when 0 
		then '' 
		else 
		@v9 end as V9,
		
		@v10 as V10,
		case(isnull(len(@v10),0)) 
		when 0 
		then '' 
		else 
		@v10 end as V10,
		
		@v11 as V11,
		case(isnull(len(@v11),0)) 
		when 0 
		then '' 
		else 
		@v11 end as V11,
		
		@v12 as V12,
		case(isnull(len(@v12),0)) 
		when 0 
		then '' 
		else 
		@v12 end as V12,
		
		@v13 as V13,
		case(isnull(len(@v13),0)) 
		when 0 
		then '' 
		else 
		@v13 end as V13,
		
		@v14 as V14,
		case(isnull(len(@v14),0)) 
		when 0 
		then '' 
		else 
		@v14 end as V14,
		
		@v15 as V15,
		case(isnull(len(@v15),0)) 
		when 0 
		then '' 
		else 
		@v15 end as V15,
		
		@v16 as V16,
		case(isnull(len(@v16),0)) 
		when 0 
		then '' 
		else 
		@v16 end as V16,
		
		@v17 as V17,
		case(isnull(len(@v17),0)) 
		when 0 
		then '' 
		else 
		@v17 end as V17,
		
		@v18 as V18,
		case(isnull(len(@v18),0)) 
		when 0 
		then '' 
		else 
		@v18 end as V18,
		
		@v19 as V19,
		case(isnull(len(@v19),0)) 
		when 0 
		then '' 
		else 
		@v19 end as V19,
		
		@v20 as V20,
		case(isnull(len(@v20),0)) 
		when 0 
		then '' 
		else 
		@v20 end as V20

	--((convert(varchar(50),convert(decimal(6,2),@v5))*convert(varchar(50),convert(decimal(6,2),@v6)))/100) as CampOpe,(((convert(varchar(50),convert(decimal(6,2),@v5))*convert(varchar(50),convert(decimal(6,2),@v6)))/100)*0.19) as CampOpeIGV
	
	Select	@nc1 as N1,@nc2 as N2,@nc3 as N3,@nc4 as N4,@nc5 as N5,@nc6 as N6,@nc7 as N7,@nc8 as N8,@nc9 as N9,@nc10 as N10,@nc11 as N11,@nc12 as N12,@nc13 as N13,@nc14 as N14,@nc15 as N15,
		@nc16 as N16,@nc17 as N17,@nc18 as N18,@nc19 as N19,@nc20 as N20
	/* ----------- CAMPOS ADICIONALES DEL SERVICIO --------------*/
	/*if (select isnull(len(CA01+CA02+CA03+CA04+CA05+CA06+CA07+CA08+CA09+CA10),0) from VentaDet Where RucE=@RucE and Cd_Vta=@Cd_Vta Group by CA01,CA02,CA03,CA04,CA05,CA06,CA07,CA08,CA09,CA10) = 0
		Select  Cd_Vta,Nro_RegVdt,Cd_Pro,'- Sin detalle -' as Campo From VentaDet Where RucE=@RucE and Cd_Vta=@Cd_Vta 
	else*/(	
	/*------------------CAMPO INFORMATIVO 01------------------*/
	Select  Cd_Vta,Nro_RegVdt as NroPro,Cd_Prod,
	case(isnull(len(CA01),0)) 
	when 0 
	then ' ' 
	else '  -'+CA01 
	end as Campo
	From VentaDet 
	Where RucE=@RucE and Cd_Vta=@Cd_Vta 
	Group by Cd_Vta,Nro_RegVdt,Cd_Prod,CA01
	--Having CA01 <> ' ' 
	--Union All 
	Union
	/*------------------CAMPO INFORMATIVO 02------------------*/
	Select  Cd_Vta,Nro_RegVdt as NroPro,Cd_Prod,
	case(isnull(len(CA02),0)) 
	when 0 
	then ' ' 
	else '  -'+CA02 
	end as Campo
	From VentaDet 
	Where RucE=@RucE and Cd_Vta=@Cd_Vta 
	Group by Cd_Vta,Nro_RegVdt,Cd_Prod,CA02
	--Having CA02 <> ' '
	--Union All
	Union
	/*------------------CAMPO INFORMATIVO 03------------------*/
	Select  Cd_Vta,Nro_RegVdt as NroPro,Cd_Prod,
	case(isnull(len(CA03),0)) 
	when 0 
	then ' ' 
	else '  -'+CA03
	end as Campo
	From VentaDet 
	Where RucE=@RucE and Cd_Vta=@Cd_Vta
	Group by Cd_Vta,Nro_RegVdt,Cd_Prod,CA03
	--Having CA03 <> ' '
	--Union All
	Union
	/*------------------CAMPO INFORMATIVO 04------------------*/
	Select  Cd_Vta,Nro_RegVdt as NroPro,Cd_Prod,
	case(isnull(len(CA04),0)) 
	when 0 
	then ' ' 
	else '  -'+CA04
	end as Campo
	From VentaDet 
	Where RucE=@RucE and Cd_Vta=@Cd_Vta
	Group by Cd_Vta,Nro_RegVdt,Cd_Prod,CA04
	--Having CA04 <> ' '
	--Union All
	Union
	/*------------------CAMPO INFORMATIVO 05------------------*/
	Select  Cd_Vta,Nro_RegVdt as NroPro,Cd_Prod,
	case(isnull(len(CA05),0)) 
	when 0 
	then ' ' 
	else '  -'+CA05
	end as Campo
	From VentaDet 
	Where RucE=@RucE and Cd_Vta=@Cd_Vta
	Group by Cd_Vta,Nro_RegVdt,Cd_Prod,CA05
	--Having CA05 <> ' ' 
	--Union All
	Union
	/*------------------CAMPO INFORMATIVO 06------------------*/
	Select  Cd_Vta,Nro_RegVdt as NroPro,Cd_Prod,
	case(isnull(len(CA06),0)) 
	when 0 
	then ' '
	else '  -'+CA06
	end as Campo
	From VentaDet 
	Where RucE=@RucE and Cd_Vta=@Cd_Vta 
	Group by Cd_Vta,Nro_RegVdt,Cd_Prod,CA06
	--Having CA06 <> ' '
	--Union All
	Union
	/*------------------CAMPO INFORMATIVO 07------------------*/
	Select  Cd_Vta,Nro_RegVdt as NroPro,Cd_Prod,
	case(isnull(len(CA07),0)) 
	when 0 
	then ' '
	else '  -'+CA07
	end as Campo
	From VentaDet 
	Where RucE=@RucE and Cd_Vta=@Cd_Vta
	Group by Cd_Vta,Nro_RegVdt,Cd_Prod,CA07
	--Having CA07 <> ' '
	--Union All
	Union
	/*------------------CAMPO INFORMATIVO 08------------------*/
	Select  Cd_Vta,Nro_RegVdt as NroPro,Cd_Prod,
	case(isnull(len(CA08),0)) 
	when 0 
	then ' ' 
	else '  -'+CA08
	end as Campo
	From VentaDet 
	Where RucE=@RucE and Cd_Vta=@Cd_Vta
	Group by Cd_Vta,Nro_RegVdt,Cd_Prod,CA08
	--Having CA08 <> ' '
	--Union All
	Union
	/*------------------CAMPO INFORMATIVO 09------------------*/
	Select  Cd_Vta,Nro_RegVdt as NroPro,Cd_Prod,
	case(isnull(len(CA09),0)) 
	when 0 
	then ' ' 
	else '  -'+CA09
	end as Campo
	From VentaDet 
	Where RucE=@RucE and Cd_Vta=@Cd_Vta
	Group by Cd_Vta,Nro_RegVdt,Cd_Prod,CA09
	--Having CA09 <> ' '
	--Union All
	Union
	/*------------------CAMPO INFORMATIVO 10------------------*/
	Select  Cd_Vta,Nro_RegVdt as NroPro,Cd_Prod,
	case(isnull(len(CA10),0)) 
	when 0 
	then ' ' 
	else '  -'+CA10
	end as Campo
	From VentaDet 
	Where RucE=@RucE and Cd_Vta=@Cd_Vta
	Group by Cd_Vta,Nro_RegVdt,Cd_Prod,CA10
	--Having CA10 <> ' '
	)
	Order by 2,3
end
print @msj
-- Leyenda --
-------------
-- Je 09/11/2009 CREADO 
-- JJ: 2010-08-23:  Modificacion del SP Se Modificio Consulta RA01




GO

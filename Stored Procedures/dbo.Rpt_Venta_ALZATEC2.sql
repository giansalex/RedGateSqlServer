SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Venta_ALZATEC2]
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
	       ve.Cd_Vta,convert(char,ve.FecMov,103) as FecMov,convert(char,ve.FecCbr,103) as FecCbr,' ' as Cd_Sr, ve.NroSre as NroSerie, ' ' as NroAutSunat,/*ve.Cd_Sr,se.NroSerie,nu.NroAutSunat,*/convert(char,ve.FecED,103) as FecED,convert(char,ve.FecVD,103) as FecVD,ve.Cd_MR,ve.Obs, ve.INF_Neto as INF, ve.EXO_Neto as EXO, ve.BIM_Neto as BIM, ve.BIM_Neto + ve.INF_Neto + ve.EXO_Neto as BIM_Vta,/*ve.INF,ve.EXO,ve.BIM,ve.BIM+ve.INF+ve.EXO as BIM_Vta,*/ve.IGV as IGV_Vta,ve.Total as Total_Vta,ve.CamMda,ve.FecMov as FecMov,ve.UsuCrea,
	       --Datos Vendedor--
	       ve.Cd_Vdr,case(isnull(len(va.RSocial),0))
	    		     when 0 then va.ApPat+' '+va.ApMat+' '+va.Nom
	    		     else va.RSocial end as NomCompVdr,
	       --Datos Tipo Documento--
	       ve.Cd_TD,td.Descrip as DescripTD,ve.NroDoc,
	       --Datos Area--
	       ve.Cd_Area,ar.NCorto as NCortoArea,
	       --Datos Monedas--
                    ve.Cd_Mda,mo.Simbolo,mo.Nombre as NomMoneda--,
	       --Datos Campo Venta--
	       --@CampoInsp as 'Inspeccion',
	      -- @direcAR as DirecAr
	from Venta ve
	left join Empresa em on ve.RucE=em.Ruc
	--left join Auxiliar ca on ve.RucE=ca.RucE and ve.Cd_Cte=ca.Cd_Aux
	left join Cliente2 ca on ca.RucE=ve.RucE and ve.Cd_Clt=ca.Cd_Clt
	left join TipDocIdn ti on ca.Cd_TDI=ti.Cd_TDI
	--left join Serie se on ve.RucE=se.RucE and ve.Cd_Sr=se.Cd_Sr
	--left join Auxiliar va on ve.RucE=va.RucE and ve.Cd_Vdr=va.Cd_Aux and va.Cd_TDI=ti.Cd_TDI
	left join Vendedor2 va on va.RucE=ve.RucE and ve.Cd_Vdr=va.Cd_Vdr and va.Cd_TDI=ti.Cd_TDI
	left join TipDoc td on ve.Cd_TD=td.Cd_TD
	left join Area ar on ve.RucE=ar.RucE and ve.Cd_Area=ar.Cd_Area
	left join Moneda mo on ve.Cd_Mda=mo.Cd_Mda
	--left join Numeracion nu on nu.RucE=se.RucE and nu.Cd_Sr=se.Cd_Sr and nu.Desde<=convert(int,ve.NroDoc) and Hasta>=convert(int,ve.NroDoc)
	where ve.RucE=@RucE /*and Eje=@Eje */and ve.Cd_Vta=@Cd_Vta and ve.IB_Anulado=0
	/*================================================================================================*/
	/*REPORTE DETALLE VENTA*/
	/*================================================================================================*/
	select 
	       --Datos Producto--
               de.RucE,de.Cd_Vta,de.Cd_Prod, pr.Nombre1 as NomPro,pr.CodCo1_ as CodCo,
	       --Datos Detalle Venta--
	       de.Cant,de.Valor,de.DsctoI,de.IMP,de.IGV,de.Total,
	       --Datos Unidad Medida--
	       de.ID_UMP as Cd_UM,um.DescripAlt as NCortoUM,
	       --Datos Servicio--
	       se.Cd_GS, gr.Descrip as NomGS,
	       --INFORMACION ADICIONADA
	       Nro_RegVdt as NroPro, 
	       --CAMPOS INFORMATIVOS
			/*CAMPO INFORMATIVO 1*/
				case(isnull(len(de.CA01),0)) 
				when 0 
				then '' 
				else Convert(varchar(50),Convert(datetime,left(de.CA01,10),103),103) end as CA01,
			/*CAMPO INFORMATIVO 02*/
				case(isnull(len(de.CA02),0)) 
				when 0 
				then '' 
				else Convert(varchar(50),Convert(datetime,left(de.CA02,10),103),103) end as CA02,
			/*CAMPO INFORMATIVO 03*/
				case(isnull(len(de.CA03),0)) 
				when 0 
				then 0 
				else Convert(varchar(50),Convert(int,de.CA03)) end as CA03,
			/*CAMPO INFORMATIVO 04*/
				case(isnull(len(de.CA04),0)) 
				when 0 
				then 0 
				else Convert(varchar(50),Convert(real,de.CA04)) end as CA04,
			/*CAMPO INFORMATIVO 05*/
				case(isnull(len(de.CA05),0)) 
				when 0 
				then '' 
				else Convert(varchar(50),Convert(int,de.CA05)) end as CA05,
			/*CAMPO INFORMATIVO 06*/
				case(isnull(len(de.CA06),0)) 
				when 0 
				then 0 
				else Convert(varchar(50),Convert(int,de.CA06)) end as CA06,
			/*CAMPO INFORMATIVO 07*/
				case(isnull(len(de.CA07),0)) 
				when 0 
				then '' 
				else de.CA07 end as CA07,
			/*CAMPO INFORMATIVO 08*/
				case(isnull(len(de.CA08),0)) 
				when 0 
				then '' 
				else de.CA08 end as CA08,
			/*CAMPO INFORMATIVO 09*/
				case(isnull(len(de.CA09),0)) 
				when 0 
				then '' 
				else de.CA09 end as CA09,
			/*CAMPO INFORMATIVO 10*/
				case(isnull(len(de.CA10),0)) 
				when 0 
				then 0 
				else Convert(varchar(50),Convert(real,de.CA10)) end as CA10

	from VentaDet de, Producto2 pr, Prod_UM um, Servicio2 se, GrupoSrv gr
	where de.RucE=@RucE and de.Cd_Vta=@Cd_Vta and 
	      de.RucE=pr.RucE and de.Cd_Prod=pr.Cd_Prod and
	      de.RucE=se.RucE and de.Cd_Srv=se.Cd_Srv and
	      se.RucE=gr.RucE and se.Cd_GS=gr.Cd_GS and
	      um.RucE=de.RucE and de.ID_UMP=um.ID_UMP and um.Cd_Prod=de.Cd_Prod

	select 	case(isnull(len(CA02),0))
	when 0
	then ''
	else
	datediff(day,Convert(varchar(50),
	Convert(datetime,left(CA01,10),103),103),
	Convert(varchar(50),Convert(datetime,left(CA02,10),103),103))
	-Convert(varchar(50),Convert(int,CA03))-1
	end as Dif_Total_Dias	
	from ventadet 
	where RucE=@RucE and Cd_Vta=@Cd_Vta

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
	Declare @v10 nvarchar(100)
			
	--TREINTA (30) CAMPOS DE UNIDADES PARA TODAS LAS EMPRESAS CON CAMPOS ADICIONALES
	Declare @nc1 nvarchar(100),@nc2 nvarchar(100),@nc3 nvarchar(100)
	Declare @nc4 nvarchar(100),@nc5 nvarchar(100),@nc6 nvarchar(100)
	Declare @nc7 nvarchar(100),@nc8 nvarchar(100),@nc9 nvarchar(100)
	Declare @nc10 nvarchar(100)
			

	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='01') Set @v1=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='01') else    Set @v1= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='02') Set @v2=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='02') else    Set @v2= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='03') Set @v3=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='03') else    Set @v3= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='04') Set @v4=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='04') else    Set @v4= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='05') Set @v5=(select valor/*Convert(nvarchar(100),Convert(decimal(9,9),valor))*/ from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='05') else    Set @v5= '0'
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='06') Set @v6=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='06') else    Set @v6= '  '
	
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='07') Set @v7=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='07') else    Set @v7= '  '	
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='08') Set @v8=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='08') else    Set @v8= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='09') Set @v9=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='09') else    Set @v9= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='10') Set @v10=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='10')else   Set @v10= '  '
					
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

	Select 	@v1 as V1,@v2 as V2,@v3 as V3,@v4 as V4,
		case(isnull(len(@v5),0))
		when 0 
		then '0' 
		else convert(varchar(50),convert(decimal(15,2),@v5)) 
		end as V5,
		@v6 as V6,
		@v7 as V7, @v8 as V8,@v9 as V9,@v10 as V10
	
	Select	@nc1 as N1,@nc2 as N2,@nc3 as N3,@nc4 as N4,@nc5 as N5,
		@nc6 as N6,@nc7 as N7,@nc8 as N8,@nc9 as N9,@nc10 as N10
	
end
print @msj
print @msj
-- Leyenda -- 
-- JJ: 2010-08-23:  Modificacion del SP Se Modificio Consulta


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Venta_OSIRIS]
@RucE nvarchar(11),
@Eje nvarchar(4),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as 
Begin
	/*================================================================================================*/
	/*REPORTE VENTA*/
	/*================================================================================================*/
	select 
		
	       --Datos empresa--
	       ve.RucE,em.RSocial,em.Direccion,dist.Nombre,
	       --Datos Cliente--
	       ca.Cd_Aux,ca.Cd_TDI,ti.Descrip as DescripTDI,ti.NCorto,ca.NDoc as NDocCli,
	       case(isnull(len(ca.RSocial),0))
		             when 0 then ca.ApPat+' '+ca.ApMat+' '+ca.Nom
		 	     else ca.RSocial end as RSocialCli,
                    ca.Direc as DirecCli,ca.Telf1 as Telf1Cli,ca.Telf2 as Telf1Cli1,
	       --Datos venta--
	       ve.Cd_Vta,convert(char,ve.FecMov,103) as FecMov,convert(char,ve.FecCbr,103) as FecCbr,' ' as Cd_Sr,ve.NroSre as NroSerie,' ' as NroAutSunat,/*ve.Cd_Sr,se.NroSerie,nu.NroAutSunat,*/convert(char,ve.FecED,103) as FecED,convert(char,ve.FecVD,103) as FecVD,ve.Cd_MR,ve.Obs,ve.INF_Neto as INF,ve.EXO_Neto as EXO,
		
		Sum(det.Cant*det.Valor)/(1.00+User321.DameIGVImp(convert(varchar,ve.FecMov,103))) as BIM,


		Sum(det.Cant*det.Valor)/(1.00+User321.DameIGVImp(convert(varchar,ve.FecMov,103))) as BIM_Vta,--ve.BIM+ve.INF+ve.EXO as BIM_Vta,
		(Sum(det.Cant*det.Valor)/(1.00+User321.DameIGVImp(convert(varchar,ve.FecMov,103))))*(User321.DameIGVImp(convert(varchar,ve.FecMov,103))) as IGV_Vta,--ve.IGV as IGV_Vta,
		Sum(det.Cant*(det.Valor-det.Valor*(User321.DameIGVImp(convert(varchar,ve.FecMov,103)))))+(Sum(det.Cant*det.Valor)*(User321.DameIGVImp(convert(varchar,ve.FecMov,103)))) as Total_Vta,

		ve.CamMda,
		ve.FecMov as FecMov,
		ve.UsuCrea,
		ve.DR_CdTD,ve.DR_NSre,ve.DR_NDoc,
	       --Datos Vendedor--
	       ve.Cd_Vdr,case(isnull(len(va.RSocial),0))
	    		     when 0 then va.ApPat+' '+va.ApMat+' '+va.Nom
	    		     else va.RSocial end as NomCompVdr,
	       --Datos Tipo Documento--
	       ve.Cd_TD,td.Descrip as DescripTD,ve.NroDoc,
	       --Datos Area--
	       ve.Cd_Area,ar.NCorto as NCortoArea,
	       --Datos Monedas--
                    ve.Cd_Mda,mo.Simbolo,mo.Nombre as NomMoneda
	from Venta ve
	left join Empresa em on ve.RucE=em.Ruc
	--left join Auxiliar ca on ve.RucE=ca.RucE and ve.Cd_Cte=ca.Cd_Aux
	left join Cliente2 ca on ca.RucE=ve.RucE and ve.Cd_Clt=ca.Cd_Clt
	left join UDist dist on ca.Ubigeo=dist.Cd_UDt
	left join TipDocIdn ti on ca.Cd_TDI=ti.Cd_TDI
	--left join Serie se on ve.RucE=se.RucE and ve.Cd_Sr=se.Cd_Sr
	--left join Auxiliar va on ve.RucE=va.RucE and ve.Cd_Vdr=va.Cd_Aux and va.Cd_TDI=ti.Cd_TDI
	left join Vendedor2 va on ve.RucE=va.RucE and ve.Cd_Vdr=va.Cd_Vdr and va.Cd_TDI=ti.Cd_TDI
	left join TipDoc td on ve.Cd_TD=td.Cd_TD
	left join Area ar on ve.RucE=ar.RucE and ve.Cd_Area=ar.Cd_Area
	left join Moneda mo on ve.Cd_Mda=mo.Cd_Mda
	--left join Numeracion nu on nu.RucE=se.RucE and nu.Cd_Sr=se.Cd_Sr and nu.Desde<=convert(int,ve.NroDoc) and Hasta>=convert(int,ve.NroDoc)
	left join VentaDet det on det.RucE=ve.RucE and det.Cd_Vta=ve.Cd_Vta
	--left join Numeracion nu on nu.RucE=ve.RucE and nu.Cd_Num=ve.Cd_Num
	--where ve.RucE=@RucE /*and Eje=@Eje */and ve.Cd_Vta=@Cd_Vta and ve.IB_Anulado=0	
	Group by ve.RucE,em.RSocial,em.Direccion,ca.Cd_Aux,ca.Cd_TDI,ti.Descrip,ti.NCorto,ca.NDoc,ca.ApPat,
		ca.ApMat,ca.Nom,ca.RSocial,ca.RSocial,ca.Direc,ca.Telf1,ca.Telf2,ve.Cd_Vta,ve.FecMov,ve.FecCbr,ve.NroSre,/*ve.Cd_Sr,se.NroSerie,nu.NroAutSunat,*/ve.FecED,ve.FecVD,ve.Cd_MR,ve.Obs,ve.INF_Neto,ve.EXO_Neto,ve.BIM_Neto,ve.IGV,
		ve.Total,ve.CamMda,ve.FecMov,ve.UsuCrea,ve.DR_CdTD,ve.DR_NSre,ve.DR_NDoc,ve.Cd_Vdr,va.ApPat,va.ApMat,va.Nom,va.RSocial,ve.Cd_TD,td.Descrip,ve.NroDoc,ve.Cd_Area,ar.NCorto,ve.Cd_Mda,mo.Simbolo,mo.Nombre,dist.Nombre
	/*================================================================================================*/
	/*REPORTE DETALLE VENTA*/
	/*================================================================================================*/
			select 
			       --Datos Producto--
		               de.RucE,de.Cd_Prod as Cd_Pro, pr.Nombre1 as NomPro,pr.CodCo1_ as CodCo,de.Cd_Vta,pr.Descrip as DescripPro,
			       --Datos Detalle Venta--
			    de.Cant,Valor as Valor,de.DsctoI,de.IMP,de.IGV,de.Cant*de.Valor as Total,--de.Total,
			       --Datos Unidad Medida--
			       de.ID_UMP as Cd_UM,um.DescripAlt as NCortoUM,
			       --Datos Servicio--select* from producto2
			       se.Cd_GS, gr.Descrip as NomGS,Nro_RegVdt as NroPro,/*pr.IB_IncIGV,*/
				de.CA01,de.CA02,de.CA03,de.CA04,de.CA05,de.CA06,de.CA07,de.CA08,de.CA09,de.CA10,
				case(de.IGV)When 0 then 0 else de.IMP end as AFECTO,
				case(de.IGV)When 0 then de.IMP else 0 end as INAFECTO
		            -------------------------------------------------------------------------------------------------------	       
			from VentaDet de, Producto2 pr, Prod_UM um, Servicio2 se, GrupoSrv gr
				where de.RucE=@RucE and de.Cd_Vta=@Cd_Vta and 
				de.RucE=pr.RucE and de.Cd_Prod=pr.Cd_Prod and
				de.RucE=se.RucE and de.Cd_Srv=se.Cd_Srv and
				se.RucE=gr.RucE and se.Cd_GS=gr.Cd_GS and
				um.RucE=de.RucE and de.Cd_Prod=um.Cd_Prod and um.ID_UMP=de.ID_UMP

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
			
	--TREINTA (30) CAMPOS DE UNIDADES PARA TODAS LAS EMPRESAS CON CAMPOS ADICIONALES
	Declare @nc1 nvarchar(100),@nc2 nvarchar(100),@nc3 nvarchar(100)
	Declare @nc4 nvarchar(100),@nc5 nvarchar(100),@nc6 nvarchar(100)

	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='01') Set @v1=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='01') else    Set @v1= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='02') Set @v2=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='02') else    Set @v2= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='03') Set @v3=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='03') else    Set @v3= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='04') Set @v4=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='04') else    Set @v4= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='05') Set @v5=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='05') else    Set @v5= '  '
	if exists(select*from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='06') Set @v6=(select valor from CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta and Cd_Cp='06') else    Set @v6= '  '
						
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

	Select 	@v1 as V1,@v2 as V2,@v3 as V3,@v4 as V4,@v5 as V5,
		@v6 as V6
	
	Select	@nc1 as N1,@nc2 as N2,@nc3 as N3,@nc4 as N4,@nc5 as N5,
		@nc6 as N6

	
declare @valor varchar(50),@mensaje varchar(50)
	if(@RucE='20101949461')
	begin
		
		--set @Cd_Vta = 'VT00000724'
		--declare @RucE nvarchar(11),@Cd_Vta nvarchar(10),
		set @valor = (select valor from CampoV where Ruce='20101949461' and Cd_Cp='04' and Cd_Vta=@Cd_Vta) 
		if (@valor is null)
			begin
				set @valor = '1'
			end
		if (@valor='1')
			begin
				set @mensaje = 
				(select 'PERIODO : '+
				Upper(convert(varchar,Datename(Month,convert(datetime,valor))))+' ' 
				+ Convert(varchar ,year(convert(datetime,valor))) from CampoV 
				where Ruce='20101949461' and Cd_Cp='02' and Cd_Vta=@Cd_Vta)
			end
		else if (@valor='2')
			begin
				set @mensaje = 	
				(select 'PERIODO : '+
				Upper(convert(varchar,Datename(Month,convert(datetime,valor)))) 
				from CampoV where Ruce='20101949461' and Cd_Cp='02' and Cd_Vta=@Cd_Vta)+' - '+
				(select 
				Upper(convert(varchar,Datename(Month,convert(datetime,valor))))+' ' 
				+ Upper(Convert(varchar ,year(convert(datetime,valor)))) from CampoV 
				where Ruce='20101949461' and Cd_Cp='03' and Cd_Vta=@Cd_Vta) 
			end
		if (@valor='3')
			begin
				set @mensaje = 	
				(select 'PERIODO : '+  
				Upper(convert(varchar,convert(datetime,valor), 103)) 
				from CampoV where Ruce='20101949461' and Cd_Cp='02' and Cd_Vta=@Cd_Vta)+' - '+
				(select  
				Upper(convert(varchar,convert(datetime,valor), 103)) from CampoV 
				where Ruce='20101949461' and Cd_Cp='03' and Cd_Vta=@Cd_Vta) 
			end
		print @mensaje
		select @valor as Valor, @mensaje as Mensaje
	end	
	
	
	
End
Print @Msj
---
--J : 14-04-2010 <CreaciÃƒÂ³n del Procedimiento Almacenado>
-- JJ: 2010-08-26:  Modificacion del SP Se Modificio Consulta


GO

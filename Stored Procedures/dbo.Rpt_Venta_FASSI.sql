SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Venta_FASSI]
@RucE nvarchar(11),
@Eje nvarchar(4),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as 
begin
	/*================================================================================================*/
	/*REPORTE VENTA*/
	/*================================================================================================*/
	select 
	       ------------------------------------------------------------------------------------------------------
	       --Datos empresa--
	       ve.RucE,em.RSocial,em.Direccion,
	       --Datos Cliente--
	       ve.Cd_Clt as Cd_Aux, cl.Cd_TDI, ti.Descrip as DescripTDI,cl.NDoc as NDocCli,
	       case(isnull(len(cl.RSocial),0))
		             when 0 then cl.ApPat+' '+cl.ApMat+' '+cl.Nom
		 	     else cl.RSocial end as RSocialCli,
                    cl.Direc as DirecCli,cl.Telf1 as Telf1Cli,cl.Telf2 as Telf1Cli1,
	       --Datos venta--
		/*ve.Cd_Sr,se.NroSerie,nu.NroAutSunat,*/
	       	ve.Cd_Vta,convert(char,ve.FecMov,103) as FecMov,convert(char,ve.FecCbr,103) as FecCbr,
		' ' as Cd_Sr,
		ve.NroSre as NroSerie,
		' ' as NroAutSunat,
		convert(char,ve.FecED,103) as FecED,
		convert(char,ve.FecVD,105) as FecVD,
		ve.Cd_MR,
		ve.Obs,
		Case(IB_Anulado)  when 0 then ( case(ve.Cd_Mda) when '02' then ve.BIM_Neto/**ve.CamMda*/ else ve.BIM_Neto end) else '0.00' end as BIM,
	 	Case(IB_Anulado)  when 0 then ( case(ve.Cd_Mda) when '02' then ve.EXO_Neto/**ve.CamMda*/ else ve.EXO_Neto end) else '0.00' end as EXO,
	 	Case(IB_Anulado)  when 0 then ( case(ve.Cd_Mda) when '02' then ve.INF_Neto/**ve.CamMda*/ else ve.INF_Neto end) else '0.00' end as INF,				
		Case(IB_Anulado)  when 0 then ( case(ve.Cd_Mda) when '02' then (BIM_Neto+EXO_Neto+INF_Neto)/**ve.CamMda*/ else BIM_Neto+EXO_Neto+INF_Neto end) else '0.00' end as BIM_Vta,		
	 	Case(IB_Anulado)  when 0 then ( case(ve.Cd_Mda) when '02' then ve.IGV/**ve.CamMda*/ else ve.IGV end) else '0.00' end as IGV_Vta,	
		Case(IB_Anulado)  when 0 then ( case(ve.Cd_Mda) when '02' then ve.Total/**ve.CamMda*/ else ve.Total end) else '0.00' end as Total_Vta, 
		Case(IB_Anulado)  when 0 then ( case(ve.Cd_Mda) when '02' then ve.CamMda else '0.000' end) else '0.000' end as CamMda ,
		
		--Case(IB_Anulado)  when 0 then ( case(ve.Cd_Mda) when '02' then vdet.IMP/**ve.CamMda*/ else vdet.IMP end) else '0.00' end as IMP, 
		--Case(IB_Anulado)  when 0 then ( case(ve.Cd_Mda) when '02' then vdet.IGV/**ve.CamMda*/ else vdet.IGV end) else '0.00' end as IGV, 
 		--Case(IB_Anulado)  when 0 then ( case(ve.Cd_Mda) when '02' then vdet.Valor/**ve.CamMda*/ else vdet.Valor end) else '0.00' end as Valor, 
		--Case(IB_Anulado)  when 0 then ( case(ve.Cd_Mda) when '02' then vdet.Total/**ve.CamMda*/ else vdet.Total end) else '0.00' end as Total, 
		
		--Case(IB_Anulado)  when 0 then ( case(ve.Cd_Mda) when '02' )
		--Case(IB_Anulado)  when 0 then case(vdet.Cant) when 0 then '0.00' else case(ve.Cd_Mda) when '02' then (vdet.IMP/vdet.Cant) else (vdet.IMP/vdet.Cant) end end else '0.00' end as PUnit,
	 	'0.00' as PUnit,
		Case(IB_Anulado)  when 0 then '' else 'ANULADO' end as Letra,
		ve.DsctoFnz_I as DsctoFnzI,
		ve.FecMov as FecMov,ve.UsuCrea,
		--ve.IB_Anulado,
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
		--------------
		ve.IB_Anulado,
		cl.CA01,cl.CA02,cl.CA03,cl.CA04,cl.CA05,
		day(ve.FecMov) as dd,
		datename(month,ve.FecMov) as mm,
		year(ve.FecMov)as aaaa		

	from Venta ve
	--Datos empresa--
	left join Empresa em on ve.RucE=em.Ruc
	--Datos Cliente--
	left join Cliente2 cl on cl.RucE=ve.RucE and cl.Cd_Clt=ve.Cd_Clt
	left join TipDocIdn ti on cl.Cd_TDI=ti.Cd_TDI
	--Datos venta--



	left join TipDoc td on ve.Cd_TD=td.Cd_TD
	--left join Auxiliar ca on ve.RucE=ca.RucE and ve.Cd_Cte=ca.Cd_Aux
	
	--left join Serie se on ve.RucE=se.RucE and ve.Cd_Sr=se.Cd_Sr
	--left join Auxiliar va on ve.RucE=va.RucE and ve.Cd_Vdr=va.Cd_Aux and va.Cd_TDI=ti.Cd_TDI
	left join Vendedor2 va on ve.RucE=va.RucE and ve.Cd_Vdr=va.Cd_Vdr and va.Cd_TDI=ti.Cd_TDI
	left join Area ar on ve.RucE=ar.RucE and ve.Cd_Area=ar.Cd_Area
	left join Moneda mo on ve.Cd_Mda=mo.Cd_Mda
--select * from Numeracion
	--left join Numeracion nu on nu.RucE=se.RucE and nu.Cd_Sr=se.Cd_Sr and nu.Desde<=convert(int,ve.NroDoc) and Hasta>=convert(int,ve.NroDoc)
	--left join VentaDet vdet on vdet.RucE=ve.RucE and vdet.Cd_Vta = ve.Cd_Vta
	where ve.RucE=@RucE /*and Eje=@Eje */and ve.Cd_Vta=@Cd_Vta --and ve.IB_Anulado=0
	/*================================================================================================*/
	/*REPORTE DETALLE VENTA*/
	/*================================================================================================*/
	select 
	       --Datos Producto--
               de.RucE,de.Cd_Vta,de.Cd_Prod as Cd_Pro, pr.Nombre1 as NomPro,pr.CodCo1_ as CodCo,
	       --Datos Detalle Venta--
	       de.Cant,de.Valor,de.DsctoI,de.IMP,de.IGV,de.Total,(de.IMP/de.Cant) as PrecioUnit,
	       --Datos Unidad Medida--
	       de.ID_UMP as Cd_UM,um.DescripAlt as NCortoUM,
	       --Datos Servicio--
	       se.Cd_GS, gr.Descrip as NomGS,
	       --INFORMACION ADICIONADA
	       Nro_RegVdt as NroPro, 
	       --CAMPOS INFORMATIVOS
		de.CA01,de.CA02,de.CA03,de.CA04,de.CA05,de.CA06,de.CA07,de.CA08,de.CA09,de.CA10
	from VentaDet de, Producto2 pr, Prod_UM um, Servicio2 se, GrupoSrv gr
	where de.RucE=@RucE and de.Cd_Vta=@Cd_Vta and 
	      de.RucE=pr.RucE and de.Cd_Prod=pr.Cd_Prod and
	      pr.RucE=se.RucE and de.Cd_Srv=se.Cd_Srv and
	      se.RucE=gr.RucE and se.Cd_GS=gr.Cd_GS and
	      de.ID_UMP=um.ID_UMP and um.RucE=de.RucE and
	      um.RucE=de.RucE and de.ID_UMP=um.ID_UMP and um.Cd_Prod=de.Cd_Prod     

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
	
end
print @msj
--exec dbo.Rpt_Venta_FASSI '11111111111','2010','VT00000292',null
-- JJ: 2010-08-23:  Modificacion del SP Se Modificio Consulta RA01

GO

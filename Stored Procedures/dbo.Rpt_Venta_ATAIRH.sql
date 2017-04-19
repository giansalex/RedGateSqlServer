SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Venta_ATAIRH]
---Procedimiento almacenado para todas las ventas con Campos Adicionales
@RucE nvarchar(11),
@Eje nvarchar(4),
@Cd_Vta nvarchar(10),
@Cd_Vou int,
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
               de.Cd_Pro, pr.Nombre as NomPro,
	       --Datos Detalle Venta--
	       de.Cant,de.Valor,de.DsctoI,de.IMP,de.IGV,de.Total,
	       --Datos Unidad Medida--
	       de.Cd_UM,um.NCorto as NCortoUM,
	       --Datos Servicio--
	       se.Cd_GS, gr.Descrip as NomGS
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
	
	select v.RucE, v.Cd_Vta,v.Cd_Cp,c.Nombre as NomCP, c.NCorto as NCortoCP,c.Cd_TC,v.Valor,vou.Cd_Vou as Cod_Voucher
	from CampoV v, Campo c, CampoT t,Voucher vou
	where v.RucE=@RucE and v.Cd_Vta=@Cd_Vta and v.RucE=c.RucE and vou.RucE=v.RucE and c.RucE=vou.RucE and v.Cd_Cp=c.Cd_Cp and c.Cd_TC=t.Cd_TC
	
	/*================================================================================================*/
	/*CAMPOS VOUCHER */
	/*================================================================================================*/

	select RucE,Cd_Vou,Ejer,Prdo from Voucher where RucE=@RucE and Cd_Vou=@Cd_Vou

	/*================================================================================================*/
	/*REPORTE CAMPOS ADICIONALES*/
	/*================================================================================================*/

	--VEINTE (20) CAMPOS ADICIONALES PARA TODAS LAS EMPRESAS CON CAMPOS ADICIONALES
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



	Select @v1 as V1, @v2 as V2, @v3 as V3, @v4 as V4, @v5 as V5, @v6 as V6, @v7 as V7, @v8 as V8,@v9 as V9,@v10 as V10,@v11 as V11,@v12 as V12,@v13 as V13,
		@v14 as V14,@v15 as V15,@v16 as V16,@v17 as V17,@v18 as V18,@v19 as V19,@v20 as V20,@v21 as V21,@v22 as V22,@v23 as V23,@v24 as V24,@v25 as V25,
		@v26 as V26,@v27 as V27,@v28 as V28,@v29 as V29,@v30 as V30
end
print @msj


--J:CREADO -> 16/09/2009 SE AGREGO EL CAMPO CD_VOUCHER
--
GO

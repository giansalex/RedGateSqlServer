SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_VentaCedive]
@RucE nvarchar(11),
@Eje nvarchar(4),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as
if not exists(select * from Venta where RucE=@RucE and Eje=@Eje and Cd_Vta=@Cd_Vta)
	set @msj = 'Venta no existe'
else
begin
	/*================================================================================================*/
	/*REPORTE VENTA*/
	/*================================================================================================*/
	select 
	-- Datos Empresa --
	ve.RucE, em.RSocial, em.Direccion,
	-- Datos Cliente --
	cl.Cd_Clt as Cd_Aux, cl.Cd_TDI, ti.Descrip as DescripTDI, cl.NDoc as NDocCli, cl.RSocial as RSocialCli, cl.ApPat +' '+cl.ApMat+' '+cl.Nom as NomCompCte, cl.Direc as DirecCli, cl.Telf1 as Telf1Cli, cl.Telf2 as Telf1Cli,
	-- Datos Venta --
	ve.Cd_Vta,ve.FecMov,ve.FecCbr,' ' as Cd_Sr, ve.NroSre as NroSerie, ve.FecED,ve.FecVD,ve.Cd_MR,ve.Obs,ve.BIM_Neto as BIM_Vta, ve.IGV as IGV_Vta, ve.Total as Total_Vta, ve.CamMda,ve.FecReg,ve.UsuCrea,
	-- Datos Vendedor --
	ve.Cd_Vdr+' - '+vd.ApPat+' '+vd.ApMat+' '+vd.Nom as NomCompVdr,
	-- Datos Tipo Documento --
	ve.Cd_TD, td.Descrip as DescripTD, ve.NroDoc,
	-- Datos Area --
	ve.Cd_Area, ar.NCorto as NCortoArea,
	-- Datos Monedas --
	ve.Cd_Mda, mo.Simbolo,
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Datos Producto --
	de.Cd_Prod as Cd_Pro, pr.Nombre1 as NomPro,
	-- Datos Detalle Venta --
	de.Cant,de.Valor,de.DsctoI, de.IMP,de.IGV,de.Total,
	-- Datos Unida Medida --
	de.ID_UMP as Cd_UM, um.DescripAlt as NCortoUM
	from 	venta ve, Empresa em, Cliente2 cl, TipDocIdn ti, Vendedor2 vd,TipDoc td,Area ar,Moneda mo,VentaDet de, Producto2 pr, Prod_UM um
	where 	ve.RucE=em.Ruc and
		ve.RucE=cl.RucE and ve.Cd_Clt=cl.Cd_Clt and
		cl.Cd_TDI=ti.Cd_TDI and
		vd.RucE=ve.RucE and vd.Cd_Vdr=ve.Cd_Vdr and
		td.Cd_TD=ve.Cd_TD and ve.Cd_Area=ar.Cd_Area and ve.Cd_Mda=mo.Cd_Mda and
		ve.RucE=de.RucE and ve.Cd_Vta=de.Cd_Vta and
		de.RucE=pr.RucE and de.Cd_Prod=pr.Cd_Prod and
		um.RucE=de.RucE and um.ID_UMP=de.ID_UMP and um.Cd_Prod=de.Cd_Prod and
		ve.RucE=@RucE and ve.Eje=@Eje and ve.Cd_Vta=@Cd_Vta and ve.IB_Anulado=0	


	/*select 
	------------------------------------------------------------------------------------------------------
	--Datos empresa--
	ve.RucE,em.RSocial,em.Direccion,
	--Datos Cliente--
	cl.Cd_Aux,ca.Cd_TDI,ti.Descrip as DescripTDI,ca.NDoc as NDocCli,ca.RSocial as RSocialCli,ca.ApPat+' '+ca.ApMat+' '+ca.Nom as NomCompCte,ca.Direc as DirecCli,ca.Telf1 as Telf1Cli,ca.Telf2 as Telf1Cli,
	--Datos venta--
	ve.Cd_Vta,ve.FecMov,ve.FecCbr,ve.Cd_Sr,se.NroSerie,ve.FecED,ve.FecVD,ve.Cd_MR,ve.Obs,ve.BIM as BIM_Vta,ve.IGV as IGV_Vta,ve.Total as Total_Vta,ve.CamMda,ve.FecReg,ve.UsuCrea,
	--Datos Vendedor--
	ve.Cd_Vdr+' - '+va.ApPat+' '+va.ApMat+' '+va.Nom as NomCompVdr,
	--Datos Tipo Documento--
	ve.Cd_TD,td.Descrip as DescripTD,ve.NroDoc,
	--Datos Area--
	ve.Cd_Area,ar.NCorto as NCortoArea,
	--Datos Monedas--
	ve.Cd_Mda,mo.Simbolo,
	-------------------------------------------------------------------------------------------------------
	--Datos Producto--
	de.Cd_Pro, pr.Nombre as NomPro,
	--Datos Detalle Venta--
	de.Cant,de.Valor,de.DsctoI,de.IMP,de.IGV,de.Total,
	--Datos Unidad Medida--
	de.Cd_UM,um.NCorto as NCortoUM
	-------------------------------------------------------------------------------------------------------	       
	from Venta ve, Empresa em, Cliente cl, Auxiliar ca, TipDocIdn ti, Serie se, Vendedor vd, Auxiliar va, TipDoc td, Area ar, Moneda mo, VentaDet de, Producto pr, UnidadMedida um
	where ve.RucE=@RucE and ve.Eje=@Eje and ve.Cd_Vta=@Cd_Vta and 
	      ve.RucE=em.Ruc and 
	      ve.RucE=cl.RucE and cl.RucE=ca.RucE and ve.Cd_Cte=cl.Cd_Aux and cl.Cd_Aux=ca.Cd_Aux and
	      ca.Cd_TDI=ti.Cd_TDI and
	      ve.RucE=vd.RucE and vd.RucE=va.RucE and ve.Cd_Vdr=vd.Cd_Aux and vd.Cd_Aux=va.Cd_Aux and
	      ve.RucE=se.RucE and ve.Cd_Sr=se.Cd_Sr and
	      ve.Cd_TD=td.Cd_TD and ve.Cd_Area=ar.Cd_Area and ve.Cd_Mda=mo.Cd_Mda and
	      ve.RucE=de.RucE and ve.Cd_Vta=de.Cd_Vta and 
	      de.RucE=pr.RucE and de.Cd_Pro=pr.Cd_Pro and
	      de.Cd_UM=um.Cd_UM and ve.IB_Anulado=0*/
	
	/*================================================================================================*/
	/*REPORTE CAMPO VENTA*/
	/*================================================================================================*/
		
	select v.RucE, v.Cd_Vta,v.Cd_Cp,c.Nombre as NomCP, c.NCorto as NCortoCP,c.Cd_TC,v.Valor
	from CampoV v, Campo c, CampoT t
	where v.RucE=@RucE and v.Cd_Vta=@Cd_Vta and v.RucE=c.RucE and v.Cd_Cp=c.Cd_Cp and c.Cd_TC=t.Cd_TC
	
	/*================================================================================================*/
end
print @msj
-- Leyenda --
-- JJ: 2010-09-27:  Modificacion del SP Se Modificio Consulta RA01
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Com_SolicitudComResp_ConsProvXProd]

@RucE nvarchar(11),
@Cd_SC char(10),
@msj varchar(100) output

AS


--*************** PROVEEDORES **************
Select 
	s.Cd_SCoEnv,
	s.Cd_Prv,
	p.NDoc,isnull(p.RSocial,isnull(p.ApPat,'')+' '+isnull(p.ApMat,'')+' '+isnull(p.Nom,'')) As Proveedor
From 
	SCxProv s
	Inner Join Proveedor2 p On p.RucE=s.RucE and p.Cd_Prv=s.Cd_Prv
Where 
	s.RucE=@RucE
	and s.Cd_SCo=@Cd_SC
	
--*************** PRODUCTOS **************
	
Select 
	sc.Cd_SC,
	sc.Item,
	isnull(sc.Cd_Prod,'') As Cd_Prod,
	isnull(pr.Nombre1,'') As NomProd,
	isnull(sc.Cd_Srv,'') As Cd_Srv,
	isnull(sr.Nombre,'') As NomSrv,
	sc.ID_UMP,
	pu.DescripAlt,
	um.NCorto,
	sc.Cant As CantSol
From 
	SolicitudComDet sc
	Left Join Producto2 pr On pr.RucE=sc.RucE and pr.Cd_Prod=sc.Cd_Prod
	Left Join Servicio2 sr On sr.RucE=sc.RucE and sr.Cd_Srv=sc.Cd_Srv
	Left Join Prod_UM pu On pu.RucE=sc.RucE and pu.Cd_Prod=sc.Cd_Prod and pu.ID_UMP=sc.ID_UMP
	Inner Join UnidadMedida um On um.Cd_UM=pu.Cd_UM
Where
	sc.RucE=@RucE
	and sc.Cd_SC=@Cd_SC
	
	
--*************** DATOS RELACIONADOS **************


Select 
	d.Cd_SCoEnv,d.Cd_Prov,d.Item,d.Cd_Prod,d.Cd_Srv,
	d.Cant,d.Cd_Mda,
	d.Precio,
	Case When d.Cd_Mda='01' Then d.Precio Else Convert(decimal(13,2),d.Precio*t.TCVta) End As PrecioS,
	Case When d.Cd_Mda='01' Then Convert(decimal(13,2),d.Precio/t.TCVta) Else d.Precio End As PrecioD,
	d.Total,
	Case When d.Cd_Mda='01' Then d.Total Else Convert(decimal(13,2),d.Total*t.TCVta) End As TotalS,
	Case When d.Cd_Mda='01' Then Convert(decimal(13,2),d.Total/t.TCVta) Else d.Total End As TotalD,
	d.Obs,d.IB_Acp,
	Convert(varchar,s.FecEnt,103) As FecEnt,
	s.Cd_FPC,
	f.Nombre + Case When isnull(s.DiasPago,0)=0 Then '' Else ' a '+Convert(varchar,s.DiasPago)+' días' End As NomFPC,
	s.DiasPago,
	d.Descrip As DescrpAlt
	
From SCxProv s
	Left Join SCxProvDet d On d.RucE=s.RucE and d.Cd_SCoEnv=s.Cd_SCoEnv
	Left Join TipCam t On Convert(varchar,t.FecTC,103)=Convert(varchar,s.FecResp,103)
	Left Join FormaPC f On f.Cd_FPC=s.Cd_FPC
Where
	s.RucE=@RucE
	and s.Cd_SCo=@Cd_SC
	
-- Leyenda --
-- DI <04/06/12 : Creacion del SP>

GO

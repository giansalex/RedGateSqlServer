SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Doc_ContratoCons2]

@RucE nvarchar(11),
@FecDesde datetime,
@FecHasta datetime,
@msj varchar(100) output

AS

Select 
	o.RucE,
	'Eliminar' As Elim,
	'Editar' As Edit,
	o.Cd_Ctt,
	
	Case When isnull(o.Cd_Clt,'')<>'' Then o.Cd_Clt Else 
		Case When isnull(o.Cd_Prv,'')<>'' Then o.Cd_Prv Else
			Case When isnull(o.Cd_Vdr,'')<>'' Then o.Cd_Vdr Else '' End End End As Cd_Aux,

	Case When isnull(o.Cd_Clt,'')<>'' Then c.NDoc Else 
		Case When isnull(o.Cd_Prv,'')<>'' Then p.NDoc Else
			Case When isnull(o.Cd_Vdr,'')<>'' Then v.NDoc Else '' End End End As NDocAux,
			
	Case When isnull(o.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) Else 
		Case When isnull(o.Cd_Prv,'')<>'' Then isnull(p.RSocial,isnull(p.ApPat,'')+' '+isnull(p.ApMat,'')+' '+isnull(p.Nom,'')) Else
			Case When isnull(o.Cd_Vdr,'')<>'' Then isnull(v.RSocial,isnull(v.ApPat,'')+' '+isnull(v.ApMat,'')+' '+isnull(v.Nom,'')) Else '' End End End As NomAux,
	
	Convert(varchar,o.FecIni,103) As FecIni,
	Convert(varchar,o.FecFin,103) As FecFin,
	o.Descrip,
	o.Obs,
	
	Convert(varchar,o.FecReg,103) As FecReg,
	Convert(varchar,o.FecMdf,103) As FecMdf,
	o.UsuCrea,
	o.UsuMdf,
	o.Estado
	
From 
	Contrato o
	Left Join Cliente2 c On c.RucE=o.RucE and c.Cd_Clt=o.Cd_Clt
	Left Join Proveedor2 p On p.RucE=o.RucE and p.Cd_Prv=o.Cd_Prv
	Left Join Vendedor2 v On v.RucE=o.RucE and v.Cd_Vdr=o.Cd_Vdr
Where 
	o.RucE=@RucE and Convert(varchar,o.FecReg,103)>=Convert(varchar,@FecDesde,103) and Convert(varchar,o.FecReg,103)<=Convert(varchar,@FecHasta,103)

-- Leyenda 
-- DI : 25/10/2011 <Creacion del procedimiento almacenado>
	
GO

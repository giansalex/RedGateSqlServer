SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Doc_ContratoCons]

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
	o.Cd_Clt,c.NDoc As NDocClt,isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) As NomClt,
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
Where 
	o.RucE=@RucE and Convert(varchar,o.FecReg,103)>=Convert(varchar,@FecDesde,103) and Convert(varchar,o.FecReg,103)<=Convert(varchar,@FecHasta,103)

-- Leyenda 
-- DI : 25/10/2011 <Creacion del procedimiento almacenado>
	
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_ProveedorListado]
@RucE nvarchar(11)
as
/*SELECT     dbo.Proveedor.RucE, dbo.Proveedor.Cd_Aux, dbo.Proveedor.Cta, dbo.Auxiliar.Cd_TDI, dbo.Auxiliar.NDoc, dbo.Auxiliar.RSocial, dbo.Auxiliar.ApPat, 
                      dbo.Auxiliar.ApMat, dbo.Auxiliar.Nom, dbo.Auxiliar.Direc, dbo.Auxiliar.Telf2, dbo.Auxiliar.Telf1, dbo.Auxiliar.Correo, dbo.Auxiliar.PWeb, 
                      dbo.TipDocIdn.Descrip, dbo.TipDocIdn.NCorto, dbo.Empresa.RSocial AS NombreEmp, dbo.Empresa.Ruc
FROM         dbo.Auxiliar INNER JOIN
                      dbo.Proveedor ON dbo.Auxiliar.RucE = dbo.Proveedor.RucE AND dbo.Auxiliar.Cd_Aux = dbo.Proveedor.Cd_Aux INNER JOIN
                      dbo.TipDocIdn ON dbo.Auxiliar.Cd_TDI = dbo.TipDocIdn.Cd_TDI INNER JOIN
                      dbo.Empresa ON dbo.Auxiliar.RucE = dbo.Empresa.Ruc
WHERE  Auxiliar.RucE=@RucE*/
select 	p.RucE, p.Cd_Prv as Cd_Aux, p.CtaCtb as Cta, p.Cd_TDI, p.NDoc, p.RSocial, p.ApPat,
	p.ApMat, p.Nom, p.Direc, p.Telf2, p.Telf1, p.Correo, p.PWeb, t.Descrip, t.NCorto,
	e.RSocial as NombreEmp, e.Ruc
from 	proveedor2 p inner join TipDocIdn t on p.Cd_TDI=t.Cd_TDI
	inner join Empresa e on e.Ruc=p.RucE
where 	p.RucE=@RucE

-- Leyenda --
--JJ: 2010-09-19	: Modificacion del procedimiento	RA01ç
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_ClienteListado]
@RucE nvarchar(11)
as
--Codigo Anterior:
/*SELECT     dbo.Cliente.RucE, dbo.Cliente.Cd_Aux, dbo.Cliente.Cta, dbo.Auxiliar.Cd_TDI, dbo.Auxiliar.NDoc, dbo.Auxiliar.RSocial, dbo.Auxiliar.ApPat, 
                      dbo.Auxiliar.ApMat, dbo.Auxiliar.Nom, dbo.Auxiliar.Direc, dbo.Auxiliar.Telf2, dbo.Auxiliar.Telf1, dbo.Auxiliar.Correo, dbo.Auxiliar.PWeb, 
                      dbo.TipDocIdn.Descrip, dbo.TipDocIdn.NCorto, dbo.Empresa.RSocial AS NombreEmp, dbo.Empresa.Ruc
FROM         dbo.Auxiliar INNER JOIN
                      dbo.Cliente ON dbo.Auxiliar.RucE = dbo.Cliente.RucE AND dbo.Auxiliar.Cd_Aux = dbo.Cliente.Cd_Aux INNER JOIN
                      dbo.TipDocIdn ON dbo.Auxiliar.Cd_TDI = dbo.TipDocIdn.Cd_TDI INNER JOIN
                      dbo.Empresa ON dbo.Auxiliar.RucE = dbo.Empresa.Ruc
WHERE  Auxiliar.RucE=@RucE*/

SELECT     c.RucE, c.Cd_Clt, c.CtaCtb, c.Cd_TDI, c.NDoc, c.RSocial, c.ApPat, 
                      c.ApMat, c.Nom, c.Direc, c.Telf2, c.Telf1, c.Correo, c.PWeb, 
                      TipDocIdn.Descrip, TipDocIdn.NCorto, Empresa.RSocial AS NombreEmp, dbo.Empresa.Ruc
FROM         Cliente2 c
		INNER JOIN TipDocIdn ON c.Cd_TDI = TipDocIdn.Cd_TDI 
		INNER JOIN Empresa ON c.RucE = Empresa.Ruc
WHERE  c.RucE=@RucE

/*
exec sp_help Rpt_ClienteListado
exec Rpt_ClienteListado '11111111111'
select * from Cliente2
*/

--Leyenda
--CAM 17/09/2010 > Modificado 	Eliminacion de la Tabla Auxiliar y Cliente.
--				Agregue la tabla Cliente2
--				Los nombres de las columnas las deje iguales, solo cambie de donde se obtiene la info.
GO

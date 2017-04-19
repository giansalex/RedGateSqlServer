SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[Rpt_VendedorListado]
@RucE nvarchar(11)
as
SELECT     dbo.Vendedor.RucE, dbo.Vendedor.Cd_Aux, dbo.Vendedor.Cta, dbo.Auxiliar.Cd_TDI, dbo.Auxiliar.NDoc, dbo.Auxiliar.RSocial, dbo.Auxiliar.ApPat, 
                      dbo.Auxiliar.ApMat, dbo.Auxiliar.Nom, dbo.Auxiliar.Direc, dbo.Auxiliar.Telf2, dbo.Auxiliar.Telf1, dbo.Auxiliar.Correo, dbo.Auxiliar.PWeb, 
                      dbo.TipDocIdn.Descrip, dbo.TipDocIdn.NCorto, dbo.Empresa.RSocial AS NombreEmp, dbo.Empresa.Ruc
FROM         dbo.Auxiliar INNER JOIN
                      dbo.Vendedor ON dbo.Auxiliar.RucE = dbo.Vendedor.RucE AND dbo.Auxiliar.Cd_Aux = dbo.Vendedor.Cd_Aux INNER JOIN
                      dbo.TipDocIdn ON dbo.Auxiliar.Cd_TDI = dbo.TipDocIdn.Cd_TDI INNER JOIN
                      dbo.Empresa ON dbo.Auxiliar.RucE = dbo.Empresa.Ruc
WHERE  Auxiliar.RucE=@RucE
------CODIGO DE MODIFICACION--------
--CM=MG01
GO

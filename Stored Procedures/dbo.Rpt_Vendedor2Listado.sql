SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Vendedor2Listado]
@RucE nvarchar(11)
as
SELECT     dbo.Vendedor2.RucE, dbo.Vendedor2.Cd_Vdr, /*dbo.Vendedor.Cta,*/ dbo.Vendedor2.Cd_TDI, dbo.Vendedor2.NDoc, dbo.Vendedor2.RSocial, dbo.Vendedor2.ApPat, 
                      dbo.Vendedor2.ApMat, dbo.Vendedor2.Nom, dbo.Vendedor2.Direc, dbo.Vendedor2.Telf2, dbo.Vendedor2.Telf1, dbo.Vendedor2.Correo, /*dbo.Auxiliar.PWeb, */
                      dbo.TipDocIdn.Descrip, dbo.TipDocIdn.NCorto, dbo.Empresa.RSocial AS NombreEmp, dbo.Empresa.Ruc
FROM         dbo.Vendedor2
                      --dbo.Vendedor ON dbo.Auxiliar.RucE = dbo.Vendedor.RucE AND dbo.Auxiliar.Cd_Aux = dbo.Vendedor.Cd_Aux INNER JOIN
                      INNER JOIN dbo.TipDocIdn ON dbo.Vendedor2.Cd_TDI = dbo.TipDocIdn.Cd_TDI
		      INNER JOIN dbo.Empresa ON dbo.Vendedor2.RucE = dbo.Empresa.Ruc
WHERE  Vendedor2.RucE=@RucE

------CODIGO DE MODIFICACION--------
--MG04

------Leyenda------
--FL : 20/09/2010 <Se creo nuevo procedimiento para la tabla vendedor2>
GO

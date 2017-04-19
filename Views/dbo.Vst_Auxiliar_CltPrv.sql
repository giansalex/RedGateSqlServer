SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Vst_Auxiliar_CltPrv]
AS
SELECT     RucE, Cd_Clt as Cd_Aux, Cd_TDI, NDoc, RSocial, ApPat, ApMat, Nom, CtaCtb, Estado
FROM         dbo.Cliente2

union

SELECT     RucE, Cd_Prv as Cd_Aux, Cd_TDI, NDoc, RSocial, ApPat, ApMat, Nom, CtaCtb, Estado
FROM         dbo.Proveedor2

--order by 1,2

--PV: 22/10/2010  --Creada: Temporalmenente para aprobechar los sp de Auxiliar


GO

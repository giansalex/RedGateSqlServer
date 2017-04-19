SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Doc_VentaLtr]

AS

SELECT     
	v.RucE, 
	v.Eje AS Ejer, 
	v.RegCtb, 
	v.Cd_Clt, 
	CASE WHEN isnull(v.DR_CdTD, '') = '' THEN v.Cd_TD ELSE v.DR_CdTD END AS DR_CdTD, 
	CASE WHEN isnull(v.DR_NSre, '') = '' THEN v.NroSre ELSE v.DR_NSre END AS DR_NSre, 
	CASE WHEN isnull(v.DR_NDoc, '') = '' THEN v.NroDoc ELSE v.DR_NDoc END AS DR_NDoc, 
	v.Cd_Vta,
	'' AS Cd_Vou, 
	'' AS Cd_Ltr, 
	v.Cd_TD, 
	t.NCorto AS NomTD, 
	v.NroSre, 
	v.NroDoc, 
	o.Cd_Mda, 
	m.Simbolo AS NomMda, 
	v.CamMda, 
	0-CASE WHEN o.Cd_Mda = '01' THEN o.Total ELSE CONVERT(decimal(13, 2), o.Total * isnull(v.CamMda, 0)) END AS SaldoS, 
    0-CASE WHEN o.Cd_Mda = '02' THEN o.Total ELSE CASE WHEN isnull(v.CamMda, 0) = 0 THEN 0.00 ELSE CONVERT(decimal(13, 2), o.Total / v.CamMda) END END AS SaldoD
FROM         
	dbo.Venta AS v 
	LEFT OUTER JOIN dbo.Moneda AS m ON m.Cd_Mda = v.Cd_Mda 
	LEFT OUTER JOIN dbo.TipDoc AS t ON t.Cd_TD = v.Cd_TD 
	INNER JOIN dbo.CanjeDet AS o ON o.RucE = v.RucE AND o.Cd_Vta = v.Cd_Vta AND o.Cd_TD = v.Cd_TD AND o.NroSre = v.NroSre AND o.NroDoc = v.NroDoc
	INNER JOIN dbo.Canje As c On c.RucE=o.RucE and c.Cd_Cnj=o.Cd_Cnj and isnull(c.IB_Anulado,0)=0
WHERE     
	(ISNULL(v.IB_Anulado, 0) = 0) 
	AND (ISNULL(v.IB_Anulado, 0) = 0)
-- Leyenda --
-- DI : 20/12/2012 <Creacion de la Vista>

GO

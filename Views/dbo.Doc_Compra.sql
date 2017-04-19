SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Doc_Compra]

AS

SELECT     
	c.RucE, 
	c.Ejer, 
	c.RegCtb, 
	c.Cd_Prv, 
	CASE WHEN isnull(c.DR_CdTD, '') = '' THEN c.Cd_TD ELSE c.DR_CdTD END AS DR_CdTD, 
	CASE WHEN isnull(c.DR_NSre, '') = '' THEN c.NroSre ELSE c.DR_NSre END AS DR_NSre, 
	CASE WHEN isnull(c.DR_NDoc, '') = '' THEN c.NroDoc ELSE c.DR_NDoc END AS DR_NDoc, 
	c.Cd_Com, 
	'' AS Cd_Vou, 
	'' AS Cd_Ltr, 
	c.Cd_TD, 
	t.NCorto AS NomTD, 
	c.NroSre, 
	c.NroDoc, 
	c.Cd_Mda, 
	m.Simbolo AS NomMda, 
	c.CamMda, 
	CASE WHEN isnull(o.RegCtb, '') <> '' THEN (o.MtoH - o.MtoD) ELSE CASE WHEN c.Cd_Mda = '01' THEN c.Total ELSE CONVERT(decimal(13, 2), c.Total * isnull(c.CamMda, 0)) END END AS SaldoS, 
	CASE WHEN isnull(o.RegCtb, '') <> '' THEN (o.MtoH_ME - o.MtoD_ME) ELSE CASE WHEN c.Cd_Mda = '02' THEN c.Total ELSE CASE WHEN isnull(c.CamMda, 0) = 0 THEN 0.00 ELSE CONVERT(decimal(13, 2), c.Total / c.CamMda) END END END AS SaldoD
FROM         
	dbo.Compra AS c LEFT OUTER JOIN
    dbo.Moneda AS m ON m.Cd_Mda = c.Cd_Mda LEFT OUTER JOIN
    dbo.TipDoc AS t ON t.Cd_TD = c.Cd_TD LEFT OUTER JOIN
    dbo.Voucher AS o ON o.RucE = c.RucE AND o.RegCtb = c.RegCtb AND o.Cd_Prv = c.Cd_Prv AND o.Cd_TD = c.Cd_TD AND o.NroSre = c.NroSre AND o.NroDoc = c.NroDoc
WHERE     
	(ISNULL(c.IB_Anulado, 0) = 0)
GO

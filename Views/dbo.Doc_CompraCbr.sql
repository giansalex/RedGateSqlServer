SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Doc_CompraCbr]

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
    ISNULL(SUM(o.MtoH - o.MtoD), 0.00) AS SaldoS, 
    ISNULL(SUM(o.MtoH_ME - o.MtoD_ME), 0.00) AS SaldoD
FROM         
	dbo.Compra AS c LEFT OUTER JOIN
    dbo.Moneda AS m ON m.Cd_Mda = c.Cd_Mda LEFT OUTER JOIN
    dbo.TipDoc AS t ON t.Cd_TD = c.Cd_TD INNER JOIN
    dbo.Voucher AS o ON o.RucE = c.RucE AND o.Cd_Prv = c.Cd_Prv AND o.Cd_TD = c.Cd_TD AND o.NroSre = c.NroSre AND o.NroDoc = c.NroDoc
WHERE     
	(ISNULL(c.IB_Anulado, 0) = 0) AND 
	(SUBSTRING(o.RegCtb, 1, 1) <> 'L') AND 
	(CASE WHEN o.Cd_Fte = 'LD' THEN 0 ELSE ISNULL(o.IB_EsProv, 0) END = 0)
GROUP BY 
	c.RucE, c.Ejer, c.RegCtb, c.Cd_Prv, 
	CASE WHEN isnull(c.DR_CdTD, '') = '' THEN c.Cd_TD ELSE c.DR_CdTD END, 
	CASE WHEN isnull(c.DR_NSre, '')  = '' THEN c.NroSre ELSE c.DR_NSre END, 
	CASE WHEN isnull(c.DR_NDoc, '') = '' THEN c.NroDoc ELSE c.DR_NDoc END, 
	c.Cd_Com, c.Cd_TD, t.NCorto, c.NroSre, c.NroDoc, c.Cd_Mda, m.Simbolo, c.CamMda
GO

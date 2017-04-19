SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Doc_VouCom]

AS

SELECT     
	v.RucE, 
	v.Ejer, 
	v.RegCtb, 
	v.Cd_Prv, 
	CASE WHEN isnull(v.DR_CdTD, '') = '' THEN v.Cd_TD ELSE v.DR_CdTD END AS DR_CdTD, 
	CASE WHEN isnull(v.DR_NSre, '') = '' THEN v.NroSre ELSE v.DR_NSre END AS DR_NSre, 
	CASE WHEN isnull(v.DR_NDoc, '') = '' THEN v.NroDoc ELSE v.DR_NDoc END AS DR_NDoc, 
	'' AS Cd_Com, 
	v.Cd_Vou, 
	'' AS Cd_Ltr, 
	v.Cd_TD, 
	t.NCorto AS NomTD, 
	v.NroSre, 
	v.NroDoc, 
	v.Cd_MdRg AS Cd_Mda, 
	m.Simbolo AS NomMda, 
	v.CamMda, 
	SUM(v.MtoH - v.MtoD) AS SaldoS, 
	SUM(v.MtoH_ME - v.MtoD_ME) AS SaldoD
FROM         
	dbo.Voucher AS v LEFT OUTER JOIN
    dbo.Moneda AS m ON m.Cd_Mda = v.Cd_MdRg LEFT OUTER JOIN
    dbo.TipDoc AS t ON t.Cd_TD = v.Cd_TD LEFT OUTER JOIN
    dbo.Doc_Compra AS o ON o.RucE = v.RucE AND o.Cd_Prv = v.Cd_Prv AND o.Cd_TD = v.Cd_TD AND o.NroSre = v.NroSre AND o.NroDoc = v.NroDoc
WHERE   
	(ISNULL(v.IB_Anulado, 0) = 0) AND 
	(SUBSTRING(v.RegCtb, 1, 2) IN ('CT')) AND 
	(v.Cd_Fte IN ('RC', 'LD')) AND 
	(v.Cd_TD NOT IN ('39')) AND (ISNULL(o.Cd_Com, N'') = '')
GROUP BY 
	v.RucE, v.Ejer, v.RegCtb, v.Cd_Prv, 
	CASE WHEN isnull(v.DR_CdTD, '') = '' THEN v.Cd_TD ELSE v.DR_CdTD END, 
	CASE WHEN isnull(v.DR_NSre, '') = '' THEN v.NroSre ELSE v.DR_NSre END, 
	CASE WHEN isnull(v.DR_NDoc, '') = '' THEN v.NroDoc ELSE v.DR_NDoc END, 
	v.Cd_Vou, v.Cd_TD, t.NCorto, v.NroSre, 
    v.NroDoc, v.Cd_MdRg, m.Simbolo, v.CamMda
    
GO

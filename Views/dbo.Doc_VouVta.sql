SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Doc_VouVta]

AS

SELECT     
	v.RucE, 
	v.Ejer, 
	v.RegCtb, 
	v.Cd_Clt, 
	CASE WHEN isnull(v.DR_CdTD, '') = '' THEN v.Cd_TD ELSE v.DR_CdTD END AS DR_CdTD, 
	CASE WHEN isnull(v.DR_NSre, '') = '' THEN v.NroSre ELSE v.DR_NSre END AS DR_NSre, 
	CASE WHEN isnull(v.DR_NDoc, '') = '' THEN v.NroDoc ELSE v.DR_NDoc END AS DR_NDoc, 
	'' As Cd_Vta,
	v.Cd_Vou, 
	'' AS Cd_Ltr, 
	v.Cd_TD, 
	t.NCorto AS NomTD, 
	v.NroSre, 
	v.NroDoc, 
	v.Cd_MdRg AS Cd_Mda, 
	m.Simbolo AS NomMda,
	v.CamMda, 
	Sum(v.MtoD-v.MtoH) As SaldoS,
	Sum(v.MtoD_ME-v.MtoH_ME) As SaldoD
FROM         
	dbo.Voucher AS v 
	LEFT OUTER JOIN dbo.Moneda AS m ON m.Cd_Mda = v.Cd_MdRg 
	LEFT OUTER JOIN dbo.TipDoc AS t ON t.Cd_TD = v.Cd_TD
	LEFT OUTER JOIN dbo.Doc_Venta As o On o.RucE=v.RucE and o.Cd_Clt=v.Cd_Clt and o.Cd_TD=v.Cd_TD and o.NroSre=v.NroSre and o.NroDoc=v.NroDoc
WHERE     
	ISNULL(v.IB_Anulado, 0) = 0 
	AND SubString(v.RegCtb,1,2) IN ('CT')
	AND v.Cd_Fte in ('RV','LD')
	AND v.Cd_TD not in ('39')
	AND ISNULL(o.Cd_Vta,'') = '' --> Esto indica que no esta en venta
	
GROUP BY
	v.RucE, 
	v.Ejer, 
	v.RegCtb, 
	v.Cd_Clt, 
	CASE WHEN isnull(v.DR_CdTD, '') = '' THEN v.Cd_TD ELSE v.DR_CdTD END, 
	CASE WHEN isnull(v.DR_NSre, '') = '' THEN v.NroSre ELSE v.DR_NSre END, 
	CASE WHEN isnull(v.DR_NDoc, '') = '' THEN v.NroDoc ELSE v.DR_NDoc END, 
	v.Cd_Vou, 
	v.Cd_TD, 
	t.NCorto, 
	v.NroSre, 
	v.NroDoc, 
	v.Cd_MdRg, 
	m.Simbolo,
	v.CamMda

-- Leyenda --
-- DI : <Creacion de la Vista>

GO

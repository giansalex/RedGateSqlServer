SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create VIEW [dbo].[Inv_LoteSalidaAyudaCons]
AS
SELECT     l.RucE, l.Cd_Lote, l.NroLote, ISNULL(CASE (isnull(len(p.RSocial), 0)) WHEN 0 THEN p.ApPat + ' ' + p.ApMat + ' ' + p.Nom ELSE p.RSocial END, 'Sin Proveedor') 
                      AS LoteProveedor, pl.Cd_Prod, SUM(pl.Cant) AS Stock
FROM         dbo.ProductoxLote AS pl LEFT OUTER JOIN
                      dbo.Lote AS l ON l.RucE = pl.RucE AND l.Cd_Lote = pl.Cd_Lote LEFT OUTER JOIN
                      dbo.Proveedor2 AS p ON p.RucE = l.RucE AND p.Cd_Prv = l.Cd_Prov
GROUP BY l.RucE, l.Cd_Lote, l.NroLote, pl.Cd_Prod, p.RSocial, p.ApPat, p.ApMat, p.Nom

GO

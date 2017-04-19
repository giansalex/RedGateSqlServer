SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Vst_AlmacenStockRcb] as
SELECT iv.RucE, iv.Cd_Prod, iv.Cd_Alm, SUM(iv.Cant) AS StockRcb
FROM dbo.Inventario iv, OrdCompra oc
where iv.Cd_OC is not null and iv.RucE = oc.RucE and iv.Cd_OC = oc.Cd_OC and id_EstOC not in ('06','07') and IC_ES='E'
GROUP BY iv.RucE, iv.Cd_Prod, iv.Cd_Alm 
--ORDER BY iv.RucE, iv.Cd_Prod, iv.Cd_Alm
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[Vst_AlmacenStockEnt] as
SELECT iv.RucE, iv.Cd_Prod, iv.Cd_Alm, abs(SUM(iv.Cant)) AS StockEnt
FROM dbo.Inventario iv, OrdPedido oc
where iv.Cd_OP is not null and iv.RucE = oc.RucE and iv.Cd_OP = oc.Cd_OP and id_EstOP not in ('06') and IC_ES='S'
GROUP BY iv.RucE, iv.Cd_Prod, iv.Cd_Alm 
--ORDER BY iv.RucE, iv.Cd_Prod, iv.Cd_Alm
-- PP  : 2011-02-18	: <Arregle

GO

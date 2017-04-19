SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Vst_AlmacenStockAct]
AS
--SELECT     RucE, Cd_Prod, Cd_Alm, SUM(Cant) AS CantAlm
--FROM         dbo.Inventario
--GROUP BY RucE, Cd_Prod, Cd_Alm
select p.*, s.CantAlm  from (select p.RucE, p.Cd_Prod, a.Cd_Alm from producto2 as p, Almacen as a where p.RucE = a.RucE) as p left join
(select RucE, Cd_Prod, Cd_Alm, SUM(Cant) as CantAlm from Inventario group by RucE, Cd_Prod, Cd_Alm) as  s on s.RucE = p.RucE and s.Cd_Prod = p.Cd_Prod and s.Cd_Alm = p.Cd_Alm
--Order by 1,2,3
--PP 19-02-2011 Corregila  cagada de  jujo!
GO

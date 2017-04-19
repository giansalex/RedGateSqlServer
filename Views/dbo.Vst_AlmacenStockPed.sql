SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Vst_AlmacenStockPed] as
select RucE, Cd_Prod, Cd_Alm, sum(Cant) as StockPed from OrdPedidoDet group by RucE, Cd_Prod, Cd_Alm
GO

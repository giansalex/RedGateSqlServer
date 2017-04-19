SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Vst_AlmacenStockOrd] as
select RucE, Cd_Prod, Cd_Alm, sum(Cant) as StockOrd from OrdCompraDet group by RucE, Cd_Prod, Cd_Alm
GO

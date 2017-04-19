SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioCons_StockxAlm_Tot]
@RucE nvarchar(11),
@Cd_Prod char(7),
@msj varchar(100) output
as

if not exists (select top 1 * from inventario where RucE=@RucE)
		set @msj = 'No se encontro Cliente'
else
begin
	select 	'Totales    --------------------------------------------------------- ' as Mensaje, sum(StockActual) as StockActual, Sum(StockOrd) as StockOrd, sum(StockRcb) as StockRcb,
	sum(StockPed) as StockPed, sum(StockEnt) as StockEnt from Vst_AlmacenStockGen where RucE=@RucE and Cd_Prod=@Cd_Prod
end
-- Leyenda --
-- JJ : 2010-08-03 	: <Creacion del procedimiento almacenado>
-- JJ : 2010-08-04 	: <Modificacion del procedimiento almacenado>
GO

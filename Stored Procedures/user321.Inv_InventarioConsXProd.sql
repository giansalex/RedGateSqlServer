SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Inv_InventarioConsXProd]
@RucE nvarchar (11),
@Cd_Prod char(7),
@StockSol int output,
@StockCot int output,
@msj varchar(100) output
as
--para sacar StockSolicitado y Cotizado
if not exists (select top 1 * from Inventario where RucE=@RucE)
	set @msj = 'No se encontro Cliente'
set @StockSol=(select case when Sum(cant) is not null then Sum(cant) else (isnull(Sum(cant),'0')) end as StockSol from SolicitudComDet where RucE=@RucE and Cd_Prod=@Cd_Prod)
set @StockCot=(select case when Sum(cant) is not null then Sum(cant) else (isnull(sum(cant),'0')) end as StockCot from CotizacionDet where RucE=@RucE and Cd_Prod=@Cd_Prod)


print @StockSol
print @StockCot
-- Leyenda --
-- JJ : 2010-08-04 	: <Creacion del procedimiento almacenado>
-- JJ : 2010-08-04 	: <Modificacion del procedimiento almacenado>

GO

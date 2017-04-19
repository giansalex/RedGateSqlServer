SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_StockProdAlert]
(
@RucE char(11),
@msj varchar(100) output
)
AS
BEGIN
	SET NOCOUNT ON;
	
	select i.Cd_Alm + '-' + a.Nombre as Cd_Alm, i.Cd_Prod, p.CodCo1_, p.Nombre1, 
	Sum(isnull(i.Cant,0)) as StockActual, 
	isnull(p.StockMin,0.00) as StockMin,
	isnull(p.StockMax,0.00) as StockMax,
	p.StockAlerta
	from inventario i 
	left join producto2 p on i.Cd_Prod = p.Cd_Prod and i.RucE=p.RucE
	left join Almacen a on i.RucE = a.RucE and i.Cd_Alm = a.Cd_Alm
	where i.RucE = @RucE
	Group By i.Cd_Prod, i.Cd_Alm + '-' + a.Nombre, p.CodCo1_, p.Nombre1, p.StockAlerta, p.StockMin,p.StockMax
	having Sum(i.Cant)<=p.StockAlerta
	order by i.Cd_Prod
	set @msj=''
END

--leyenda
-- no se quien loc creo
-- CAM 11/10/2012 Mdf agregue columna stock maximo y isnull
GO

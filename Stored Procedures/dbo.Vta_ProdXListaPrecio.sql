SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Proc [dbo].[Vta_ProdXListaPrecio](
	@RucE nvarchar(11),
	@Cd_LP char(10)
)
As

Declare @TempProd Table(
	Sel bit,
	Cd_Prod char(7),
	NomProd varchar(100),
	Clase varchar(50),
	SClase varchar(50),
	SSClase varchar(50),
	StockActual numeric(38,3),
	StockOrden numeric(38,3),
	StockRecibido numeric(38,3),
	StockPedido numeric(38,3),
	StockEntregado numeric(38,3),
	CodComer varchar(20),
	StockSolicitado numeric(18,3),
	StockCotizado numeric(18,3),
	Cd_CC nvarchar(8),
	Cd_SC nvarchar(8),
	Cd_SS nvarchar(8)
)

Declare @msj varchar(100)
Insert Into @TempProd exec Inv_Producto2Cons_paCot1 @RucE, @msj Output
/*Select * From ListaPrecioDet Where RucE = @RucE And Cd_LP = @Cd_LP*/
Select	
		x.Sel,
		x.Cd_Prod,
		x.NomProd,
		x.Clase,
		x.SClase,
		x.SSClase,
		x.StockActual,
		x.StockOrden,
		x.CodComer,
		x.StockSolicitado,
		x.StockCotizado,
		x.Cd_CC,
		x.Cd_SC,
		x.Cd_SS 
From 
		@TempProd As x
Left Join
		ListaPrecioDet As det
On
		x.Cd_Prod = det.Cd_Prod
Where 
		det.RucE = @RucE And det.Cd_LP = @Cd_LP 
Group By
		x.Sel,
		x.Cd_Prod,
		x.NomProd,
		x.Clase,
		x.SClase,
		x.SSClase,
		x.StockActual,
		x.StockOrden,
		x.CodComer,
		x.StockSolicitado,
		x.StockCotizado,
		x.Cd_CC,
		x.Cd_SC,
		x.Cd_SS 

		
		
GO

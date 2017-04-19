SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Vta_ListaPrecio_ConsXLP] 
	@RucE NVARCHAR(11),
	@Cd_Prod CHAR(7),
	@Cd_Area NVARCHAR(6),
	@Cd_Clt char(10),
	@Cd_Vdr char(7)
As
SELECT DISTINCT    ListaPrecio.*
FROM         ListaPrecio LEFT JOIN
                      ListaPrecio_Area ON ListaPrecio.RucE = ListaPrecio_Area.RucE AND ListaPrecio.Cd_LP = ListaPrecio_Area.Cd_LP LEFT JOIN
                      ListaPrecio_Cliente ON ListaPrecio.RucE = ListaPrecio_Cliente.RucE AND ListaPrecio.Cd_LP = ListaPrecio_Cliente.Cd_LP LEFT JOIN
                      ListaPrecio_Vendedores ON ListaPrecio.RucE = ListaPrecio_Vendedores.RucE AND ListaPrecio.Cd_LP = ListaPrecio_Vendedores.Cd_LP LEFT JOIN
                      ListaPrecioDet ON ListaPrecio.RucE = ListaPrecioDet.RucE AND ListaPrecio.Cd_LP = ListaPrecioDet.Cd_LP
WHERE
			ListaPrecio.RucE = @RucE And
			(ListaPrecioDet.Cd_Prod = @Cd_Prod Or @Cd_Prod Is Null) And
			(ListaPrecio_Area.Cd_Area = @Cd_Area Or @Cd_Area Is Null) And
			(ListaPrecio_Cliente.Cd_Clt = @Cd_Clt Or @Cd_Clt Is Null) And
			(ListaPrecio_Vendedores.Cd_Vdr = @Cd_Vdr Or @Cd_Vdr Is Null)
GO

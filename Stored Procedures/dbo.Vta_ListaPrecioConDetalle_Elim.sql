SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create Proc [dbo].[Vta_ListaPrecioConDetalle_Elim](
@RucE nvarchar(11),
@Cd_LP char(10)
)
As
Delete From ListaPrecioDet Where RucE = @RucE And Cd_LP = @Cd_LP
Delete From ListaPrecio_Area Where RucE = @RucE And Cd_LP = @Cd_LP
Delete From ListaPrecio_Autorizados Where RucE = @RucE And Cd_LP = @Cd_LP
Delete From ListaPrecio_Cliente Where RucE = @RucE And Cd_LP = @Cd_LP
Delete From ListaPrecio_Vendedores Where RucE = @RucE And Cd_LP = @Cd_LP
Delete From ListaPrecio Where RucE = @RucE And Cd_LP = @Cd_LP

GO

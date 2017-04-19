SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2ConsAyuda]
@RucE nvarchar(11),
@TipProd int = null,
@msj varchar(100) output
as
begin

	if(@TipProd=0)
		select Cd_Prod,CodCo1_, CodCo2_, CodCo3_,Nombre1 from Producto2 where Estado=1 and  RucE = @RucE and IB_PT=1
	else if (@TipProd=1)
		select Cd_Prod,CodCo1_, CodCo2_, CodCo3_,Nombre1 from Producto2 where Estado=1 and  RucE = @RucE and IB_MP=1
	else
		select Cd_Prod,CodCo1_, CodCo2_, CodCo3_,Nombre1 from Producto2 where Estado=1 and  RucE = @RucE
	print @msj

end
-- Leyenda --
-- PP : 2010-02-23 : <Creacion del procedimiento almacenado>

GO

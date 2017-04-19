SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ProdProvPrecioElim]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Cd_Prv char(7),
@ID_UMP int,
@ID_PrecPrv int,
@msj varchar(100) output
as
if not exists (select * from ProdProvPrecio where  RucE = @RucE and Cd_Prod=@Cd_Prod and Cd_Prv=@Cd_Prv and ID_UMP=@ID_UMP and ID_PrecPrv=@ID_PrecPrv)
	set @msj = 'Producto no existe'
else
begin
	delete from ProdProvPrecio where RucE=@RucE and Cd_Prod=@Cd_Prod and Cd_Prv=@Cd_Prv and ID_UMP=@ID_UMP and ID_PrecPrv=@ID_PrecPrv
	if @@rowcount <= 0
	set @msj = 'El Producto no pudo ser eliminado'	
end
-- Leyenda --
-- FL : 2010-08-20 : <Creacion del procedimiento almacenado>


GO

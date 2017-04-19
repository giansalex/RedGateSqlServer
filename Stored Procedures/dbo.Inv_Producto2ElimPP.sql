SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2ElimPP]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Cd_Prv char(7),
@ID_UMP int,
@msj varchar(100) output
as
if not exists (select * from ProdProv where  RucE = @RucE and Cd_Prod=@Cd_Prod and Cd_Prv=@Cd_Prv and ID_UMP=@ID_UMP)
	set @msj = 'Producto no existe'
else
begin
	delete from ProdProvPrecio where RucE=@RucE and Cd_Prod=@Cd_Prod and Cd_Prv=@Cd_Prv and ID_UMP=@ID_UMP
	delete from ProdProv where RucE = @RucE and Cd_Prod=@Cd_Prod and Cd_Prv=@Cd_Prv and ID_UMP=@ID_UMP

	if @@rowcount <= 0
	set @msj = 'El Producto no pudo ser eliminado'	
end
-- Leyenda --
-- FL : 2010-08-17 : <Creacion del procedimiento almacenado>
-- FL : 2010-08-18 : <Modificacion del procedimiento almacenado>
GO

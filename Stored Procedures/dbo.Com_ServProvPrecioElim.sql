SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ServProvPrecioElim]
@RucE nvarchar(11),
@ID_PrecSP int,
@msj varchar(100) output
as
if not exists (select * from ServProvPrecio where RucE=@RucE and ID_PrecSP=@ID_PrecSP)
	set @msj = 'Servicio no existe'
else
begin
	delete from ServProvPrecio where RucE=@RucE and ID_PrecSP=@ID_PrecSP
	
	if @@rowcount <= 0
	set @msj = 'Precio no pudo ser eliminado'	
end
print @msj
-- Leyenda --
-- FL : 2010-08-26 : <Creacion del procedimiento almacenado>

GO

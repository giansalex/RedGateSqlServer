SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioSrvElim]
@ID_PrSv int,
@RucE nvarchar(11),
@msj varchar(100) output
as
if not exists (select * from PrecioSrv where RucE=@RucE and ID_PrSv = @ID_PrSv)
	set @msj = 'Precio de Servicio no existe'
else
begin
	delete from PrecioSrv where RucE=@RucE and ID_PrSv = @ID_PrSv
	if @@rowcount <= 0
	set @msj = 'Precio de Servicio no pudo ser eliminado'	
end
print @msj
-- Leyenda --
-- J : 2010-03-19 : <Creacion del procedimiento almacenado>
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Servicio2ElimSP]
@RucE nvarchar(11),
@Cd_Prv char(7),
@Cd_Srv char(7),
@msj varchar(100) output
as
if not exists (select * from ServProv where RucE = @RucE and Cd_Prv=@Cd_Prv and Cd_Srv=@Cd_Srv)
	set @msj = 'Servicio no existe'
else
begin
	delete from ServProvPrecio where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_Srv=@Cd_Srv
	delete from ServProv where RucE=@RucE and Cd_Prv=@Cd_Prv and Cd_Srv=@Cd_Srv

	if @@rowcount <= 0
	set @msj = 'El Servicio no pudo ser eliminado'	
end
-- Leyenda --
-- FL : 2011-02-08 : <Creacion del procedimiento almacenado>


GO

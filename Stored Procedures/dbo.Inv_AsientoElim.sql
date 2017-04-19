SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_AsientoElim] --<Procedimiento que elimina los asientos>
@RucE nvarchar(11),
@Cd_MIS char(3),
@Item int,
@msj varchar(100) output
as
set @msj = 'Asiento no puede eliminarce, debe de actualizar el sistema'
/*if not exists(select * from Asiento where RucE= @RucE and Cd_MIS=@Cd_MIS and Item=@Item)
	set @msj = 'Asiento no existe'
else
begin
	delete from Asiento where RucE= @RucE and Cd_MIS=@Cd_MIS and Item=@Item

	if @@rowcount <= 0
	set @msj = 'Asiento no pudo ser eliminado'	
end*/

------------
--J : 14-04-2010 - <Creacion del procedimiento almacenado>


GO

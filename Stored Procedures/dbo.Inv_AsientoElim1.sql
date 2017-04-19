SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_AsientoElim1] --<Procedimiento que elimina los asientos>
@RucE nvarchar(11),
@Cd_MIS char(3),
@Item int,
@Ejer varchar(4),
@msj varchar(100) output
as
if not exists(select * from Asiento where RucE= @RucE and Cd_MIS=@Cd_MIS and Item=@Item and Ejer=@Ejer)
	set @msj = 'Asiento no existe'
else
begin
	delete from Asiento where RucE= @RucE and Cd_MIS=@Cd_MIS and Item=@Item and Ejer=@Ejer

	if @@rowcount <= 0
	set @msj = 'Asiento no pudo ser eliminado'	
end

------------
--J : 14-04-2010 - <Creacion del procedimiento almacenado>
--FL: 26-01-2011 <modificacion del ejercicio para que elimine por ejercicio>


GO

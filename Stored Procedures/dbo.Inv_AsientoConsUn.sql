SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_AsientoConsUn] --<Procedimiento que consulta x asiento>
@RucE nvarchar(11),
@Cd_MIS char(3),
@Item int,
@msj varchar(100) output
as
set @msj = 'Debe de actualizar el sistema'
/*if not exists (select * from Asiento where RucE= @RucE and Cd_MIS=@Cd_MIS and Item=@Item)
	set @msj = 'El asiento no existe'
else	select * from Asiento where RucE= @RucE and Cd_MIS=@Cd_MIS and Item=@Item
print @msj*/
------------
--J : 14-04-2010 - <Creacion del procedimiento almacenado>

GO

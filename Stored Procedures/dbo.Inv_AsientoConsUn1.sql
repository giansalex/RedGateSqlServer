SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_AsientoConsUn1] --<Procedimiento que consulta x asiento>
@RucE nvarchar(11),
@Cd_MIS char(3),
@Item int,
@Ejer varchar(4),
@msj varchar(100) output
as
if not exists (select * from Asiento where RucE= @RucE and Cd_MIS=@Cd_MIS and Item=@Item and Ejer=@Ejer)
	set @msj = 'El asiento no existe'
else	select * from Asiento where RucE= @RucE and Cd_MIS=@Cd_MIS and Item=@Item and Ejer=@Ejer
print @msj
------------
--J : 14-04-2010 - <Creacion del procedimiento almacenado>
--FL: 26-01-2011 - <Modificacion del sp para ejercicio>
GO

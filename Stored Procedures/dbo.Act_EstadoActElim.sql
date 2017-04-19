SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Act_EstadoActElim]
@RucE nvarchar(11),
@Cd_EA nvarchar(6),
@msj varchar(100) output
as
if not exists (select * from EstadoAct where RucE=@RucE and Cd_EA=@Cd_EA)
	set @msj = 'Estado Actividad no existe'
else
begin
	delete EstadoAct Where RucE=@RucE and Cd_EA=@Cd_EA		
	if @@rowcount <= 0
		set @msj = 'Estado Actividad no pudo ser eliminado'
end
print @msj
GO

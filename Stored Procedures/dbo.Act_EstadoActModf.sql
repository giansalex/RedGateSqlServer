SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Act_EstadoActModf]
@RucE nvarchar(11),
@Cd_EA nvarchar(6),
@Descrip varchar(50),
@NomCorto varchar(6),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from EstadoAct where RucE=@RucE and Cd_EA=@Cd_EA)
	set @msj = 'Estado Actividad no existe'
else
begin
	update EstadoAct set Cd_EA=@Cd_EA, Descrip=@Descrip, NomCorto=@NomCorto, Estado=@Estado
		where RucE=@RucE and Cd_EA=@Cd_EA
	if @@rowcount <= 0
		set @msj = 'Estado Actividad no pudo ser modificado'
end
print @msj
GO

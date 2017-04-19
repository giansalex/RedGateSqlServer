SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Act_Actividad_Elim]
@Cd_Act int,
@msj varchar(100) output
as
if not exists (select * from Actividad where Cd_Act=@Cd_Act)
	set @msj = 'Actividad no existe'
else
begin
	delete from Actividad
	where Cd_Act=@Cd_Act

	if @@rowcount <= 0
	   set @msj = 'Actividad no pudo ser eliminada'
end
print @msj
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Act_EstadoActCrea]
@RucE nvarchar(11),
@Cd_EA nvarchar(6),
@Descrip varchar(50),
@NomCorto varchar(6),
@msj varchar(100) output
as
if exists (select * from EstadoAct where RucE=@RucE and Cd_EA=@Cd_EA)
	set @msj = 'Estado Actividad ya existe'
else
begin
	insert into EstadoAct(RucE,Cd_EA,Descrip,NomCorto,Estado)
		  values(@RucE,@Cd_EA,@Descrip,@NomCorto,1)
	
	if @@rowcount <= 0
		set @msj = 'Estado Actividad no pudo ser ingresado'
end
print @msj
GO

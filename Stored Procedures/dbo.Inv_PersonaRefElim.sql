SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PersonaRefElim]
--Eliminación de datos de Persona referencia
@RucE nvarchar(11),
@Cd_Per char(7),
@msj varchar(100) output
as
if not exists (select * from PersonaRef where RucE= @RucE and Cd_Per=@Cd_Per)
	set @msj = 'Persona de Referencia no existe'
else
begin
	delete from PersonaRef where RucE= @RucE and Cd_Per=@Cd_Per

	if @@rowcount <= 0
	set @msj = 'Persona de Referencia no pudo ser eliminado'	
end
GO

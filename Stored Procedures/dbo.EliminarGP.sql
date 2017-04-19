SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[EliminarGP]
@Cd_GP int,
@RucE nvarchar(11),
@msj varchar(100) output
as
if not exists (select * from GrupoPermisos where Cd_GP=@Cd_GP)
	set @msj = 'Grupo de Permisos no existe'
else
begin
	delete from PermisosE where RucE=@RucE and Cd_GP=@Cd_GP
	delete from GrupoPermisos where Cd_GP=@Cd_GP
	if @@rowcount <= 0
	   set @msj = 'Grupo Permisos no pudo ser eliminado'
end
print @msj

GO

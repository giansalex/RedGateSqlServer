SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[EliminarGA]
@Cd_GA int,
@RucE nvarchar(11),
@msj varchar(100) output
as
if not exists (select * from GrupoAcceso where Cd_GA=@Cd_GA)
	set @msj = 'Grupo de Acceso no existe'
else if exists (select * from AccesoE where Cd_GA=@Cd_GA)
	set @msj = 'El Grupo de Acceso no se puede eliminar porque esta en uso'
else
begin
	delete from AccesoE where RucE=@RucE and Cd_GA=@Cd_GA
	delete from accesoM where Cd_GA=@Cd_GA 
	delete from GrupoAcceso where Cd_GA=@Cd_GA
	if @@rowcount <= 0
	   set @msj = 'Grupo Acceso no pudo ser eliminado'
end
print @msj

GO

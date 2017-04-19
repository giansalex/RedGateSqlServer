SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PermisosEElim_F]  --Procedimiento Final
@Cd_Prf nvarchar(3),
@RucE nvarchar(11),
@msj varchar(100) output
as
if not exists (select * from Perfil where Cd_Prf=@Cd_Prf)
begin
	Set @msj = 'Perfil no existe'
	return
end
if not exists (select * from PermisosE where Cd_Prf=@Cd_Prf and RucE=@RucE)
begin
	Set @msj = 'Permiso no existe'
	return
end
else
begin
	delete from PermisosE where Cd_Prf=@Cd_Prf and RucE=@RucE

	if @@rowcount <= 0
		Set @msj = 'Permiso a empresa no puedo ser eliminado'
end

-- Leyenda --
-------------
-- FL : 20/06/2010 : Creacion del procedimiento almacenado
GO

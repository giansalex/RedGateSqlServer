SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PermXPerfilElim]
@Cd_Prf nvarchar(3),
@Cd_Pm nvarchar(2),
--@Estado bit,
@msj varchar(100) output
as
if not exists (select * from PermisosXPerfil where Cd_Prf=@Cd_Prf and Cd_Pm=@Cd_Pm)
	set @msj = 'No existe permiso del perfil'
else
begin
	delete from PermisosXPerfil where Cd_Prf=@Cd_Prf and Cd_Pm=@Cd_Pm

	if @@rowcount <= 0
	   set @msj = 'Permiso(s) del Perfil no pudo ser eliminado'
end
print @msj
GO

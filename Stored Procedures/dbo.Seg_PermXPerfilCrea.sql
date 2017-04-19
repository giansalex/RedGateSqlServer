SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PermXPerfilCrea]
@Cd_Prf nvarchar(3),
@Cd_Pm nvarchar(2),
--@Estado bit,
@msj varchar(100) output
as
if exists (select * from PermisosXPerfil where Cd_Prf=@Cd_Prf and Cd_Pm=@Cd_Pm)
	set @msj = 'Ya exite una relacion similar'
else
begin
	insert into PermisosXPerfil(Cd_Prf,Cd_Pm,Estado)
			     values(@Cd_Prf,@Cd_Pm,1)

	if @@rowcount <= 0
	   set @msj = 'Permiso(s) del Perfil no pudo ser registrado'
end
print @msj
GO

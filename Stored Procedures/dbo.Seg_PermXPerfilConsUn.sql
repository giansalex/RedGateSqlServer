SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PermXPerfilConsUn]
@Cd_Prf nvarchar(3),
@Cd_Pm nvarchar(2),
--@Estado bit,
@msj varchar(100) output
as
if not exists (select * from PermisosXPerfil where Cd_Prf=@Cd_Prf and Cd_Pm=@Cd_Pm)
	set @msj = 'No existe permiso del perfil'
else    select * from PermisosXPerfil where Cd_Prf=@Cd_Prf and Cd_Pm=@Cd_Pm
print @msj
GO

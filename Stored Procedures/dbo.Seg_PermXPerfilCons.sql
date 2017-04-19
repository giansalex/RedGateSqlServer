SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PermXPerfilCons]
@Cd_Prf nvarchar(3),
--@Cd_Pm nvarchar(2),
@msj varchar(100) output
as
/*if not exists (select top 1 * from PermisosXPerfil where Cd_Prf=@Cd_Prf and Cd_Pm=@Cd_Pm)
	set @msj = 'No se encontraron permisos del perfil'
else  */select * from PermisosXPerfil where Cd_Prf=@Cd_Prf
print @msj
GO

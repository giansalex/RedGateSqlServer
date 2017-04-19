SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PermXPerfilConsAsig]
@Cd_Prf nvarchar(3)
as
/*MOSTRAR PERMISOS ASIGNADAS*/
select c.Cd_Pm, c.Descrip,a.Estado,0 as Nuevo from PermisosXPerfil a, Perfil b, Permisos c where a.Cd_Prf=@Cd_Prf and a.Cd_Prf=b.Cd_Prf and a.Cd_Pm=c.Cd_Pm
GO

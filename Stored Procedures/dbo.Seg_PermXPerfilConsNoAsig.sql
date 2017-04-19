SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PermXPerfilConsNoAsig]
@Cd_Prf nvarchar(3)
as
/*MOSTRAR PERMISOS POR ASIGNADAR*/
select Cd_Pm,Descrip,estado,1 as Nuevo from Permisos where Cd_Pm not in (select a.Cd_Pm from PermisosXPerfil a, Perfil b, Permisos c where a.Cd_Prf=@Cd_Prf and a.Cd_Prf=b.Cd_Prf and a.Cd_Pm=c.Cd_Pm) and Estado=1
GO

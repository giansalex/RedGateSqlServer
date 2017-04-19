SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PermisosxGPxGrupoPermisosCons]
@Cd_GP int,
@msj varchar(100) output
as

if(@Cd_GP = 0)
begin
	select distinct 0 Cd_GP, a.Cd_Pm, a.Descrip, a.Estado from Permisos a
	where a.Estado = 1
	order by a.Cd_Pm
end
else
begin
	select a.Cd_GP, a.Cd_Pm, m.Descrip, a.Estado from PermisosxGP a
	inner join Permisos m on a.Cd_Pm = m.Cd_Pm
	where Cd_GP = @Cd_GP and a.Estado = 1 and m.Estado = 1
	order by a.Cd_Pm
end
--Leyenda--
-- FL 2011/06/17 : <Creacion del procedimiento almacenado>






	
GO

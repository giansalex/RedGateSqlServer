SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_GrupoPermXUsu_Cons]
@RucE nvarchar(11),
@Cd_GP int,
@msj varchar(100) output
as
begin
select a.Cd_Prf,u.NomUsu,u.Estado as IB_Estado
from Usuario u
left join PermisosE a on a.Cd_Prf=u.Cd_Prf
where a.RucE=@RucE and a.Cd_GP=@Cd_GP
end
print @msj
-- Leyenda --
-- FL : 2011-06-06	: <Creacion del procedimiento almacenado>


GO

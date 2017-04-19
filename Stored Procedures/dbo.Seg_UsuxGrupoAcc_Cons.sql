SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_UsuxGrupoAcc_Cons]
@RucE nvarchar(11),
@Cd_GA int,
@msj varchar(100) output
as
begin
select distinct a.Cd_Prf,u.NomUsu,u.Estado as IB_Estado
from Usuario u
inner join AccesoE a on a.Cd_Prf=u.Cd_Prf
where /*a.RucE=@RucE and */a.Cd_GA=@Cd_GA
end
print @msj
-- Leyenda --
-- FL : 2011-05-30	: <Creacion del procedimiento almacenado>
-- MP : 288-09-2011 : <Modificacion del procedimiento almacenado>


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_AccesoMxGrupoAccCons]
@Cd_GA int,
@msj varchar(100) output
as

if(@Cd_GA = 0)
begin
	select distinct 0 Cd_GA, a.Cd_MN, a.Nombre, a.Estado from Menu a
	where a.Estado = 1
	order by a.Cd_MN
end
else
begin
	select a.Cd_GA, a.Cd_MN, m.Nombre, a.Estado from AccesoM a
	inner join Menu m on a.Cd_MN = m.Cd_MN
	where Cd_GA = @Cd_GA and a.Estado = 1 and m.Estado = 1
	order by a.Cd_MN
end
--Leyenda--

-- MP 2011/03/27 : <Creacion del procedimiento almacenado>
--exec Seg_AccesoMxGrupoAccCons '001', null
-- MP 2011/06/01 : <Modificacion del procedimiento almacenado>
-- MP 2011/06/13 : <Modificacion del procedimiento almacenado>




	
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_GrupoAccCons_Hijo]
@Cd_GA int,
@msj varchar(100) output
as
select 
	len(a.Cd_MN)/2 as Nivel,
	a.Cd_MN,m.Nombre
from GrupoAcceso g --On g.Cd_GA=e.Cd_GA
left join AccesoM a On a.Cd_GA=g.Cd_GA
left join Menu m On m.Cd_MN=a.Cd_MN
where a.Cd_GA = @Cd_GA
Group by a.Cd_MN,m.Nombre

--Leyenda--
-----------
--DI : 21/09/2009 : <Creacion del procedimiento almacenado>
--MP : 01/04/2011 : <Modificacion del procedimiento almacenado>
GO

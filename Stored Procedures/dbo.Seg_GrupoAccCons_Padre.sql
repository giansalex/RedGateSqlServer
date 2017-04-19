SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_GrupoAccCons_Padre]
@NomUsu nvarchar(10),
@msj varchar(100) output
as
select 
	len(a.Cd_MN)/2 as Nivel,
	a.Cd_MN,m.Nombre
from Usuario u
inner join AccesoE e On e.Cd_Prf=u.Cd_Prf
left join GrupoAcceso g On g.Cd_GA=e.Cd_GA
left join AccesoM a On a.Cd_GA=g.Cd_GA
left join Menu m On m.Cd_MN=a.Cd_MN
where u.NomUsu = @NomUsu
Group by a.Cd_MN,m.Nombre

--Leyenda--
-----------
--DI  21/09/2009 : Creacion del procedimiento almacenado
GO

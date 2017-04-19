SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_PrfCons_Jefe]
@NomUsu nvarchar(10),
@msj varchar(100) output
as
select 
	u.Cd_Prf,p.NomP,p.Descrip,p.Estado
from ControlGrupos c
inner join Usuario u On u.NomUsu=c.NomUsu
left join Perfil p On p.Cd_Prf=u.Cd_Prf
where c.Nivel like ( select Nivel 
		     from ControlGrupos 
		     where NomUsu=@NomUsu
		    ) +'%' and c.Nivel <> (select Nivel from ControlGrupos where NomUsu=@NomUsu)
Group by u.Cd_Prf,p.NomP,p.Descrip,p.Estado

-- Leyenda --
-------------

-- DI 22/09/2009 Creacion del procedimiento almacenado

GO

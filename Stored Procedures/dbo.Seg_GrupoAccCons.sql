SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_GrupoAccCons]
@NomUsu nvarchar(10),
@msj varchar(100) output
as


select 
	a.Cd_GA,g.Descrip
from ControlGrupos c
inner join Usuario u On u.NomUsu=c.NomUsu
inner join AccesoE a On a.Cd_Prf=u.Cd_Prf
left join GrupoAcceso g On g.Cd_GA=a.Cd_GA
where c.Nivel like ( select Nivel 
		     from ControlGrupos 
		     where NomUsu=@NomUsu
		    ) +'%'
Group by a.Cd_GA,g.Descrip
/*
select  Cd_GA,Descrip from GrupoAcceso
*/
--Leyenda--
-----------
--DI  16/09/2009 : Creacion del procedimiento almacenado
--DI  21/09/2009 : Modificacion mostrar los grupos por jefe
GO

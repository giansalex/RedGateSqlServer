SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_ControlGruposCons]
@NomUsu nvarchar(10),
@msj varchar(100) output
as

Declare @Codigo nvarchar(50)
Declare @Nivel int

Select @Codigo=Nivel,@Nivel=len(Nivel)/2 from ControlGrupos where NomUsu=@NomUsu

print @Codigo
print @Nivel

select
	len(c.Nivel)/2-@Nivel as Nivel,c.Nivel as Codigo,
	--left(convert(char,c.NomUsu+'          '),10)+' | '+u.NomComp as NomUsu 
	c.NomUsu as NomUsu
from ControlGrupos c
left join Usuario u On u.NomUsu=c.NomUsu
where c.Nivel like (@Codigo)+'%'
and  c.Nivel <> (@Codigo)
Order by 2

-- Leyenda --
-------------

-- DI 28/09/2009 : Creacion del procedimiento almacenado
GO

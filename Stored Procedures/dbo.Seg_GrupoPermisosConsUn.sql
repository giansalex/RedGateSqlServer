SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_GrupoPermisosConsUn]
@Cd_GP int,
@msj varchar(100) output
as
/*
Select
	len(a.Cd_MN)/2 as Nivel,
	a.Cd_MN,
	m.Nombre	 
from AccesoM a
Left Join Menu m On m.Cd_MN=a.Cd_MN
where Cd_GA=@Cd_GA and a.Estado=1*/
select * from GrupoPermisos where Cd_GP=@Cd_GP

--Leyenda--
-----------
-- FL 17/06/2010 : creacion de procedimiento almacenado

GO

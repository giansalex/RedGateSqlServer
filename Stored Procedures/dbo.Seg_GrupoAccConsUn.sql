SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_GrupoAccConsUn]
@Cd_GA int,
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
select * from GrupoAcceso where Cd_GA=@Cd_GA

--Leyenda--
-----------

-- DI 17/09/2009 : Creacion del procedimiento almacenado
-- DI 18/09/2009 : Modificacion procedimiento (Agrego Nivel)

GO

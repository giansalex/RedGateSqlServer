SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Seg_AccMCons] --Consulta MenuXEmpXPerfil
@Cd_Prf nvarchar(3),
@RucE nvarchar(11)
as
select distinct b.Cd_MN, c.Nombre, len(b.Cd_MN)/2 as Nivel, c.ImgIdx 
--, b.Estado 'EAccM', c.Estado 'EMenu'
from AccesoE a, AccesoM b, Menu c
where a.Cd_Prf=@Cd_Prf and a.RucE=@RucE and a.Cd_GA=b.Cd_GA 
and b.Cd_MN = c.Cd_MN and b.Estado=1 and c.Estado=1 order by b.Cd_MN

--PV  --> Lun10/11/08
--DI  --> Mie25/02/09

--MP : 2011/06/06 : <Modificacion del procedimiento almacenado>
--exec [dbo].[Seg_AccMCons] '001', '11111111111'

GO

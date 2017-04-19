SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [user321].[Inv_ServXProvCons]
@RucE nvarchar(11),
@Cd_Prv char(7),
@msj varchar(100) output
as
select distinct
sp.Cd_Srv, s.Nombre, sp.CodigoAlt, sp.DescripAlt, --c.Descrip as DescripC, cs.Descrip as DescripCS,
--css.Descrip as DescripCSS,
sp.Obs, s.Estado, sp.CA01, sp.CA02, sp.CA03
from ServProv sp
left join Servicio2 s on s.RucE=sp.RucE and s.Cd_Srv=sp.Cd_Srv
--left join CCostos c on c.RucE=s.RucE and c.Cd_CC=s.Cd_CC
--left join CCSub cs on cs.RucE=s.RucE and cs.Cd_SC=s.Cd_SC
--left join CCSubSub css on css.RucE=s.RucE and css.Cd_SS=s.Cd_SS
where sp.RucE=@RucE and sp.Cd_Prv=@Cd_Prv
-- Leyenda --
--FL : 08/02/2011 <Creacion del procedimiento almacenado, se dejaron esos campos comentados por si se quieren mostrar mas adelante>
GO

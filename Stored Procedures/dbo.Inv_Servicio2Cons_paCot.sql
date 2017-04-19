SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
--CONSULTAR SERVICIOS PARA COTIZACION
CREATE procedure [dbo].[Inv_Servicio2Cons_paCot]

--exec Inv_Servicio2Cons_paCot '11111111111',null

@RucE nvarchar(11),
@msj varchar(100) output

as

declare @check bit
set @check=0

select 
	@check as Sel,
	s.Cd_Srv,
	s.CodCo as CodComer,
	s.Nombre as Descrip,
	g.Descrip as Grupo,
	a.NCorto as CCostos,
	b.NCorto as SCCostos,
	c.NCorto as SSCCostos
from Servicio2 s
left join GrupoSrv g On g.RucE=s.RucE and g.Cd_GS=s.Cd_GS
left join CCostos a On a.RucE=s.RucE and a.Cd_CC=s.Cd_CC
left join CCSub b On b.RucE=s.RucE and b.Cd_CC=s.Cd_CC and b.Cd_SC=s.Cd_SC
left join CCSubSub c On c.RucE=s.RucE and c.Cd_CC=s.Cd_CC and c.Cd_SC=s.Cd_SC and c.Cd_SS=s.Cd_SS
where s.RucE=@RucE and s.Estado=1 and s.IC_TipServ = 'v'


-- Leyedan --

--DI : 05/04/2010 <Creacion del procedimiento almacenado>
GO

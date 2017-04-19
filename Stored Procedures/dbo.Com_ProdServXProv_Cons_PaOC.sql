SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ProdServXProv_Cons_PaOC]
@RucE varchar(11),
@Cd_SC char(10),
@Cd_Prv char(7),
@msj varchar(100) output
as
select	pp.Cd_Prod, sp.Cd_Srv, isnull(scd.ID_UMP,0) as ID_UMP		
from SolicitudComDet scd
left join ProdProv pp on pp.RucE = scd.RucE and pp.Cd_Prod = scd.Cd_Prod  and pp.ID_UMP = scd.ID_UMP and pp.Cd_Prv = @Cd_Prv
left join ServProv sp on sp.RucE = scd.RucE and sp.Cd_Srv = scd.Cd_Srv and sp.Cd_Prv = @Cd_Prv
where scd.RucE = @RucE and scd.Cd_SC = @Cd_SC and (pp.Cd_Prod is not null or sp.Cd_Srv is not null )
GO

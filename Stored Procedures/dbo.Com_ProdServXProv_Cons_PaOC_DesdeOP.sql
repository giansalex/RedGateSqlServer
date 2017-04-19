SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ProdServXProv_Cons_PaOC_DesdeOP]
@RucE varchar(11),
@Cd_OP char(10),
@Cd_Prv char(7),
@msj varchar(100) output
as
select pp.Cd_Prod, sp.Cd_Srv, isnull(opd.ID_UMP,0) as ID_UMP
from OrdPedidoDet opd 
left join ProdProv pp on pp.RucE = opd.RucE and pp.Cd_Prod = opd.Cd_Prod  and pp.ID_UMP = opd.ID_UMP and pp.Cd_Prv = @Cd_Prv
left join ServProv sp on sp.RucE = opd.RucE and sp.Cd_Srv = opd.Cd_Srv and sp.Cd_Prv = @Cd_Prv
where opd.Cd_OP = @Cd_OP and opd.RucE = @RucE

--	LEYENDA
/*	MM : <08/11/11 : Creacion del SP>
	
*/
--	PRUEBAS
/*	exec Com_ProdServXProv_Cons_PaOC_DesdeOP '11111111111','OP00000091','PRV0004',null
	exec Com_ProdServXProv_Cons_PaOC_DesdeOP '11111111111','OP00000091','PRV0227',null
*/
GO

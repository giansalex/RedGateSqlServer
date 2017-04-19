SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Vta_CotizacionVtaDet_Cons_paOP]
@RucE nvarchar(11),
@Cd_Cot char(10),
@msj varchar(100) output
as

select @RucE as RucE,ct.ID_CtD,ct.Cd_Prod, ct.Cd_Srv, ct.Descrip, ct.ID_UMP, ct.Cant, ct.PU, ct.Valor, ct.DsctoP, ct.DsctoI,ct.BIM,
case(isnull(ct.IGV,0)) when 0 then 0 else 1 end as IncIGV , ct.IGV, ct.Total, ct.Obs
from CotizacionDet ct
where  ct.RucE = @RucE and ct.Cd_Cot = @Cd_Cot
print @msj



GO

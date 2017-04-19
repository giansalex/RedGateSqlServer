SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Com_OrdCompraDetCons_explo2]
@RucE nvarchar(11),
@Cd_OC char(10),
@msj varchar(100) output
as

select oc.Item,IsNull(oc.Cd_Prod,oc.Cd_Srv) as CodPrdSrv,oc.Descrip,oc.ID_UMP,um.DescripAlt,oc.PU,oc.Cant,oc.PendRcb,oc.Cd_Alm,oc.Valor,oc.DsctoP,oc.DsctoI,
       oc.BIM,oc.IGV,oc.Total,oc.CA01,oc.CA02,oc.CA03,oc.CA04,oc.CA05 
from OrdCompraDet oc, Prod_UM um
where (oc.RucE= um.RucE and oc.ID_UMP = um.ID_UMP and oc.Cd_Prod = um.Cd_Prod) and oc.RucE = @RucE and oc.Cd_OC = @Cd_OC 
print @msj
--exec Com_OrdCompraDetCons_explo '11111111111','OC00000005'


-- Leyenda --
-- JU : 2010-07-26 : <Creacion del procedimiento almacenado>
-- JS : 2011-01-24 : <Modificación del procedimiento almacenado>
GO

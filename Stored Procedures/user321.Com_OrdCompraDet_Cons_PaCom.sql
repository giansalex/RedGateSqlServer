SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [user321].[Com_OrdCompraDet_Cons_PaCom]
@RucE nvarchar(11),
@Cd_OC char(10),
@msj varchar(100) output
as
select oc.RucE, oc.Item,oc.Cd_Prod,oc.Descrip, oc.PU, oc.ID_UMP, pu.DescripAlt as UM ,oc.Cant, oc.BIM as IMP, oc.IGV,
	case(isnull(oc.IGV,0)) when 0 then 0 else 1 end as IncIGV, oc.Total,oc.Cd_Alm,co.Cd_CC,co.Cd_SC,co.Cd_SS, 
	oc.Obs,oc.CA01, oc.CA02, oc.CA03, oc.CA04, oc.CA05 
from OrdCompraDet oc
inner join Prod_UM pu on oc.RucE = pu.RucE and oc.Cd_Prod = pu.Cd_Prod and oc.ID_UMP = pu.ID_UMP
inner join OrdCompra co on oc.RucE = co.RucE and oc.Cd_OC = co.Cd_OC
where  oc.RucE = @RucE and oc.Cd_OC=@Cd_OC
--exec Com_OrdCompraDet_Cons_PaCom '11111111111','OC00000008',null
-- Leyenda --
-- JU : 2010-09-07 : <Creacion del procedimiento almacenado>
GO

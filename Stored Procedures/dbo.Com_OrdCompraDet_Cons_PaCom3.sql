SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompraDet_Cons_PaCom3]
@RucE nvarchar(11),
@Cd_OC char(10),
@msj varchar(100) output
as
select oc.RucE, oc.Item,oc.Cd_Prod as CodPrdSrv,oc.Descrip, oc.PU, isnull(oc.ID_UMP,0) as ID_UMP, isnull(pu.DescripAlt,'') as UM ,oc.Cant, oc.BIM as IMP, oc.IGV,
	case(isnull(oc.IGV,0)) when 0 then 0 else 1 end as IncIGV, oc.Total,oc.Cd_Alm,co.Cd_CC,co.Cd_SC,co.Cd_SS, 
	oc.Obs,oc.CA01, oc.CA02, oc.CA03, oc.CA04, oc.CA05 
from OrdCompraDet oc
inner join Prod_UM pu on oc.RucE = pu.RucE and oc.Cd_Prod = pu.Cd_Prod and oc.ID_UMP = pu.ID_UMP
inner join OrdCompra co on oc.RucE = co.RucE and oc.Cd_OC = co.Cd_OC
--and oc.Cd_SRV = 
where  oc.RucE = @RucE and oc.Cd_OC=@Cd_OC
union
select oc.RucE, oc.Item,oc.Cd_Srv as CodPrdSrv,oc.Descrip, oc.PU, isnull(oc.ID_UMP,0) as ID_UMP, null as UM ,oc.Cant, oc.BIM as IMP, oc.IGV,
	case(isnull(oc.IGV,0)) when 0 then 0 else 1 end as IncIGV, oc.Total,oc.Cd_Alm,co.Cd_CC,co.Cd_SC,co.Cd_SS, 
	oc.Obs,oc.CA01, oc.CA02, oc.CA03, oc.CA04, oc.CA05 
from OrdCompraDet oc
inner join OrdCompra co on oc.RucE = co.RucE and oc.Cd_OC = co.Cd_OC
where  oc.RucE = @RucE and oc.Cd_OC=@Cd_OC and oc.Cd_SRV is not null

-- exec Com_OrdCompraDet_Cons_PaCom3 '11111111111','OC00000158',null
-- Leyenda --
-- JU : 2010-09-07 : <Creacion del procedimiento almacenado>
-- JS : 2011-01-24 : <Modificación del procedimiento almacenado>
-- CAM : 2011-08-01 : <Modif. Se cambio para que muestre productos y servicios cuando se jala una OC a CP>

GO

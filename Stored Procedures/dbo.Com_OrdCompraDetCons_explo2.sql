SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_OrdCompraDetCons_explo2]
@RucE nvarchar(11),
@Cd_OC char(10),
@msj varchar(100) output
as

select od.Item,od.Cd_Prod,pr.CodCo1_ as CodCo, od.Descrip,pu.ID_UMP,pu.DescripAlt,od.PU,od.Cant,od.PendRcb,od.Cd_Alm,od.Valor,od.DsctoP,
od.DsctoI,od.BIM,od.IGV,od.Total,od.CA01,od.CA02,od.CA03,od.CA04,od.CA05 
from OrdCompraDet od
inner join Producto2 pr on pr.RucE = od.RucE and pr.Cd_Prod = od.Cd_Prod
inner join Prod_UM pu on pu.RucE = od.RucE and pu.Cd_Prod = od.Cd_Prod
where od.RucE = @RucE and od.Cd_OC = @Cd_OC
union all
select od.Item,od.Cd_SRV,sv.CodCo as CodCo, sv.Nombre as Descrip,'-' as ID_UMP,'-' as DescripAlt,od.PU,1.000 as Cant,od.PendRcb,od.Cd_Alm,od.Valor,od.DsctoP,
od.DsctoI,od.BIM,od.IGV,od.Total,od.CA01,od.CA02,od.CA03,od.CA04,od.CA05 
from OrdCompraDet od
inner join Servicio2 sv on sv.RucE = od.RucE and sv.Cd_SRV = od.Cd_SRV
where od.RucE = @RucE and od.Cd_OC = @Cd_OC
print @msj

--exec Com_OrdCompraDetCons_explo2 '11111111111','OC00000012',''
-- Leyenda --
-- JU : 2010-07-26 : <Creacion del procedimiento almacenado>
-- JA : 2013-01-04 : <Modificacion: Le quite la tabla Prod_UM al query para los servicios.>
-- bg : 2013-02-18 : <Modificacion de sp porque se duplicaban datos>
GO

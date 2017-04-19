SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ProdProvPrecioCons_paOrdCom]
@RucE nvarchar(11),
@Cd_Prv char(7),
@Cd_Prod char(7),
@msj varchar(100) output
as

begin
declare @check bit
set @check = 0
select @check as Sel,ppp.Cd_Prod, ppp.ID_PrecPrv,convert(nvarchar,Fecha,103) as Fecha, pum.ID_UMP,pum.DescripAlt as Unidad,pum.Cd_UM, Factor, mon.Nombre as Moneda,PrecioCom as Precio,IB_IncIGV,ppp.Cd_Mda,Obs
from ProdProvPrecio ppp
left join Prod_UM pum on ppp.RucE = pum.RucE and ppp.Cd_Prod = pum.Cd_Prod and ppp.ID_UMP = pum.ID_UMP 
left join Moneda mon on ppp.RucE = pum.RucE and ppp.Cd_Mda = mon.Cd_Mda 
where ppp.RucE = @RucE and Cd_Prv = @Cd_Prv and ppp.Cd_Prod = @Cd_Prod and ppp.Estado = 1 
order by year(Fecha)desc,month(Fecha)desc,day(Fecha)desc
end
print @msj

-- Leyenda --
-- JU : 2010-07-26 : <Creacion del procedimiento almacenado>


GO

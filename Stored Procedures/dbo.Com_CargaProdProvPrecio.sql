SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_CargaProdProvPrecio]
@RucE nvarchar(11),
@Cd_Prv char(7),
@msj varchar(100) output
as
select ppp.Fecha,p.Nombre1,pum.DescripAlt,ppp.PrecioCom,ppp.IB_IncIGV,mo.Nombre,ppp.Obs,ppp.Estado, ppp.ID_PrecPrv, ppp.ID_UMP,ppp.Cd_Prod from ProdProvPrecio ppp
left join Prod_UM pum on pum.Cd_Prod=ppp.Cd_Prod and pum.ID_UMP=ppp.ID_UMP and pum.RucE=ppp.RucE
left join Producto2 p on p.Cd_Prod=ppp.Cd_Prod and p.RucE=ppp.RucE
left join Moneda mo on mo.Cd_Mda=ppp.Cd_Mda
where ppp.Ruce=@RucE and ppp.Cd_Prv=@Cd_Prv
-- Leyedana --
--FL : 20/08/2010 <Creacion del procedimiento almacenado>

GO

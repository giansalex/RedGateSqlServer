SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ProdProvCarga]
@RucE nvarchar(11),
@Cd_Prv char(7),
@msj varchar(100) output
as
declare @check bit
set @check=0

select @check as Sel,pp.Cd_Prod,p.Nombre1,um.DescripAlt,pp.DescripAlt,pp.Obs,um.ID_UMP from ProdProv pp
left join Producto2 p on p.RucE=pp.RucE and p.Cd_Prod=pp.Cd_Prod
left join Prod_UM um on um.RucE=pp.RucE and um.Cd_Prod=pp.Cd_Prod and um.ID_UMP=pp.ID_UMP
where pp.RucE=@RucE and pp.Cd_Prv=@Cd_Prv
-- Leyenda --
--FL : 20/08/2010 <Creacion del procedimiento almacenado>

GO

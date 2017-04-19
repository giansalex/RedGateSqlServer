SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Vta_PronosticosXVtaProd]
@RucE nvarchar(11),
@msj varchar(100) output
as
BEGIN
select /*v.Cd_Clt,*/top 10
p.Cd_Prod,p.Nombre1 ,Sum(vd.cant) as MontoTotal 
from Venta v 
inner join VentaDet vd on v.RucE=vd.RucE and v.Cd_Vta=vd.Cd_Vta
inner join Producto2 p on (p.RucE=v.RucE and p.Cd_Prod=vd.Cd_Prod)
--inner join inventario i on (i.RucE=v.RucE and i.Cd_Prod=p.Cd_Prod and i.Cd_Prod=vd.Cd_Prod)
where v.RucE=@RucE and v.eje='2012' --and c.Cd_Clt='CLT0000003'
group by p.Cd_Prod,p.Nombre1
order by MontoTotal desc , p.Nombre1
END
print @msj
-- Leyenda --
-- FL : 26-02-2011 : <Creacion del procedimiento almacenado>
--exec dbo.Prd_OrdFabricacionCons '11111111111',null







GO

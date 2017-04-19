SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_StockXAlmacenCons]
@RucE char(11),
@Cd_Alm varchar(20),
@FecH datetime,
@msj varchar(100) output
as

--Detallado
select * from (
select a.RucE, a.Cd_Alm, a.Cd_Prod, a.Producto, isnull(s.CantAlm,'0') as CantAlm, isnull(c.StockOrd,'0') as StockOrd, isnull(r.StockRcb,'0') as StockRcb, isnull(c.StockOrd,'0') - isnull(r.StockRcb,'0') as StockPenRcb, isnull(p.StockPed,'0') as StockPed, isnull(e.StockEnt,'0') as StockEnt, isnull(p.StockPed,'0') - isnull(e.StockEnt,'0') as StockPenEnt
from (select p.RucE, p.Cd_Prod, a.Cd_Alm, p.Nombre1 as Producto  from Almacen as a,producto2 as p where P.RucE =@RucE and p.RucE = a.RucE and  a.Cd_Alm like @Cd_Alm+'%') as a 
left join (select RucE, Cd_Prod, Cd_Alm, sum(Cant) as CantAlm from Inventario where RucE = @RucE and Cd_Alm like @Cd_Alm+'%' and FecMov <= @FecH group by RucE, Cd_Prod, Cd_Alm) as  s on s.RucE = a.RucE and s.Cd_Prod = a.Cd_Prod and s.Cd_Alm = a.Cd_Alm
left join (select d.RucE, d.Cd_Prod, d.Cd_Alm, sum(d.Cant) as StockOrd from OrdCompraDet d inner join OrdCompra o on d.RucE = o.RucE and d.Cd_OC = o.Cd_OC and FecE <= @FecH where d.RucE = @RucE and d.Cd_Alm like @Cd_Alm+'%' group by d.RucE, d.Cd_Prod, d.Cd_Alm) as c on c.RucE = a.RucE and c.Cd_Prod = a.Cd_Prod and c.Cd_Alm = a.Cd_Alm
left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, sum(i.Cant) as StockRcb from Inventario i inner join OrdCompra o on i.RucE = o.RucE and i.Cd_OC = o.Cd_OC where i.RucE = @RucE and i.Cd_Alm like @Cd_Alm+'%' and id_EstOC not in ('06','07') and IC_ES='E' and FecMov <= @FecH group by i.RucE, i.Cd_Prod, i.Cd_Alm) as r on r.RucE = a.RucE and r.Cd_Prod = a.Cd_Prod and r.Cd_Alm = a.Cd_Alm
left join (select d.RucE, d.Cd_Prod, d.Cd_Alm, sum(d.Cant) as StockPed from OrdPedidoDet d inner join OrdPedido o on d.RucE = o.RucE and d.Cd_OP = o.Cd_OP and FecE <= @FecH where d.RucE = @RucE and d.Cd_Alm like @Cd_Alm+'%' group by d.RucE, d.Cd_Prod, d.Cd_Alm) as p on p.RucE = a.RucE and p.Cd_Prod = a.Cd_Prod and p.Cd_Alm = a.Cd_Alm
left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, abs(sum(i.Cant)) as StockEnt from Inventario i inner join OrdPedido o on i.RucE = o.RucE and i.Cd_OP = o.Cd_OP where i.RucE = @RucE and i.Cd_Alm like @Cd_Alm+'%' and id_EstOP not in ('06') and IC_ES='S' and FecMov <= @FecH group by i.RucE, i.Cd_Prod, i.Cd_Alm) as e on e.RucE = a.RucE and e.Cd_Prod = a.Cd_Prod and e.Cd_Alm = a.Cd_Alm
where (s.CantAlm is not null or c.StockOrd is not null or r.StockRcb is not null or p.StockPed is not null or e.StockEnt is not null) 
) as  Stock order  by  Cd_Alm, Cd_Prod

--Resumido
select * from (
select a.RucE, a.Cd_Prod, a.Producto, isnull(s.CantAlm,'0') as CantAlm, isnull(c.StockOrd,'0') as StockOrd, isnull(r.StockRcb,'0') as StockRcb, isnull(c.StockOrd,'0') - isnull(r.StockRcb,'0') as StockPenRcb, isnull(p.StockPed,'0') as StockPed, isnull(e.StockEnt,'0') as StockEnt, isnull(p.StockPed,'0') - isnull(e.StockEnt,'0') as StockPenEnt
from (select p.RucE, p.Cd_Prod, p.Nombre1 as Producto  from producto2 as p where p.RucE = @RucE) as a 
left join (select RucE, Cd_Prod, sum(Cant) as CantAlm from Inventario where RucE = @RucE and Cd_Alm like @Cd_Alm+'%' and FecMov <= @FecH group by RucE, Cd_Prod) as  s on s.RucE = a.RucE and s.Cd_Prod = a.Cd_Prod
left join (select d.RucE, d.Cd_Prod, sum(d.Cant) as StockOrd from OrdCompraDet d inner join OrdCompra o on d.RucE = o.RucE and d.Cd_OC = o.Cd_OC and FecE <= @FecH where d.RucE = @RucE and d.Cd_Alm like @Cd_Alm+'%' group by d.RucE, d.Cd_Prod) as c on c.RucE = a.RucE and c.Cd_Prod = a.Cd_Prod
left join (select i.RucE, i.Cd_Prod, sum(i.Cant) as StockRcb from Inventario i inner join OrdCompra o on i.RucE = o.RucE and i.Cd_OC = o.Cd_OC where i.RucE = @RucE and i.Cd_Alm like @Cd_Alm+'%' and id_EstOC not in ('06','07') and IC_ES='E' and FecMov <= @FecH group by i.RucE, i.Cd_Prod) as r on r.RucE = a.RucE and r.Cd_Prod = a.Cd_Prod
left join (select d.RucE, d.Cd_Prod, sum(d.Cant) as StockPed from OrdPedidoDet d inner join OrdPedido o on d.RucE = o.RucE and d.Cd_OP = o.Cd_OP and FecE <= @FecH where d.RucE = @RucE and d.Cd_Alm like @Cd_Alm+'%' group by d.RucE, d.Cd_Prod) as p on p.RucE = a.RucE and p.Cd_Prod = a.Cd_Prod
left join (select i.RucE, i.Cd_Prod, abs(sum(i.Cant)) as StockEnt from Inventario i inner join OrdPedido o on i.RucE = o.RucE and i.Cd_OP = o.Cd_OP where i.RucE = @RucE and i.Cd_Alm like @Cd_Alm+'%' and id_EstOP not in ('06') and IC_ES='S' and FecMov <= @FecH group by i.RucE, i.Cd_Prod) as e on e.RucE = a.RucE and e.Cd_Prod = a.Cd_Prod
where (s.CantAlm is not null or c.StockOrd is not null or r.StockRcb is not null or p.StockPed is not null or e.StockEnt is not null) 
) as  Stock order  by  Cd_Prod

-- Leyenda --
-- JJ/FL : 2011-03-17 : <Creacion del procedimiento almacenado>


GO

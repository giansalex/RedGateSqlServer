SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--CONSULTAR PRODUCTOS PARA COTIZACION
CREATE procedure [dbo].[Inv_Producto2Cons_paCot]

--exec Inv_Producto2Cons_paCot '11111111111',null

@RucE nvarchar(11),
@msj varchar(100) output

as

declare @check bit
set @check=0
/*
select 
	@check as Sel,p.Cd_Prod,p.Nombre1 as NomProd,
	cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase,
	p.StockActual,p.StockCot,p.StockSol,
	0.000 as StockPR --PENDIENTE
from Producto2 p 
left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS
left join ClaseSub sc On sc.RucE=ss.RucE and sc.Cd_CLS=ss.Cd_CLS
left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=sc.Cd_CL
where p.RucE=@RucE and p.Estado=1
*/

select 
	0 AS 'Sel',
	prod.Cd_Prod, prod.NomProd, prod.Clase, prod.SClase, prod.SSClase, prod.StockActual, prod.StockOrden,
	prod.StockRecibido, prod.StockPedido, prod.StockEntregado,
	isnull(scd.cant,0) as 'StockSolicitado', isnull(cd.cant, 0) as 'StockCotizado'
from(
	select 
		p.Cd_Prod,p.Nombre1 as NomProd,
		cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase,
		sum(isnull(vas.StockActual,0)) as 'StockActual',sum(isnull(vas.StockOrd,0)) as 'StockOrden', sum(isnull(vas.StockRcb,0)) as 'StockRecibido',
		sum(isnull(vas.StockPed,0))  as 'StockPedido', sum(isnull(vas.StockEnt,0)) as 'StockEntregado'
		from Producto2 p
			left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
			left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
			left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
			left join Vst_AlmacenStockGen vas on p.Cd_Prod = vas.Cd_Prod and vas.RucE=@RucE
		where p.RucE=@RucE and p.Estado=1
		group by p.Cd_Prod, p.Nombre1, cc.Nombre, sc.Nombre, ss.Nombre
	) as prod
left join (select Cd_Prod, sum(Cant)as 'Cant' from SolicitudComDet where RucE = @RucE group by Cd_Prod) as scd on prod.Cd_Prod = scd.Cd_Prod
left join (select Cd_Prod, sum(Cant) as 'Cant' from CotizacionDet where RucE = @RucE and Cd_Prod is not null group by Cd_Prod) as cd on prod.Cd_Prod = cd.Cd_Prod
order by prod.Cd_Prod

--exec Inv_Producto2Cons_paCot '11111111111',null
-- Leyedan --

--DI : 24/02/2010 <Creacion del procedimiento almacenado>
--MM : 03/12/2010 Modificacion del sp agregagando mas campos
--JJ : 22/12/2010 Modificacion del sp se corrigue RucE
--JJ : 23/02/2011 Modificacion del sp se se agrego and vas.RucE=p.RucE dentro del from()
--PP : 25/02/2011 Modificacion del por k  emer no ve  productos
--PP : 07/03/2011 Modificacion del sp se se modifico and vas.RucE=p.RucE por and vas.RucE=@RucE
GO

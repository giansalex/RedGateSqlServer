SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--CONSULTAR PRODUCTOS PARA COTIZACION
CREATE procedure [dbo].[Inv_Producto2Cons_paCot2]

--exec Inv_Producto2Cons_paCot1_Prueba '20160000001',null,null

@RucE nvarchar(11),
@Cd_Alm varchar(20),
@msj varchar(100) output

as

declare @check bit
set @check=0

if(ISNULL(@Cd_Alm,'')<>'')
begin



select 
	@check AS 'Sel',
	prod.Cd_Prod, prod.NomProd, prod.NomProd2, prod.Clase, prod.SClase, prod.SSClase, prod.StockActual, prod.StockOrden,
	prod.StockRecibido, prod.StockPedido, prod.StockEntregado, prod.CodComer,
	isnull(scd.cant,0) as 'StockSolicitado', isnull(cd.cant, 0) as 'StockCotizado'
	,prod.Cd_CC, prod.Cd_SC, prod.Cd_SS,prod.Ib_Srs,prod.NombreMarca,prod.CA01,prod.CA02,prod.CA03,prod.CA04,prod.CA05,prod.CA06,prod.CA07,prod.CA08,prod.CA09,prod.CA10,prod.Descrip
from (
	select 
		p.Cd_Prod,p.Nombre1 as NomProd,p.Nombre2 as NomProd2,
		isnull(isnull(p.CodCo1_,isnull(p.CodCo2_,p.CodCo3_)),'') as CodComer,
		cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase,
		sum(isnull(vas.StockActual,0)) as 'StockActual',sum(isnull(vas.StockOrd,0)) as 'StockOrden', sum(isnull(vas.StockRcb,0)) as 'StockRecibido',
		sum(isnull(vas.StockPed,0))  as 'StockPedido', sum(isnull(vas.StockEnt,0)) as 'StockEntregado'
		,p.Cd_CC, p.Cd_SC, p.Cd_SS,p.Ib_Srs, mc.Nombre As NombreMarca, p.CA01,p.CA02,p.CA03,p.CA04,p.CA05,p.CA06,p.CA07,p.CA08,p.CA09,p.CA10, p.Descrip
		from Producto2 p
			left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
			left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
			left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
			left join Vst_AlmacenStockGen vas on vas.RucE=p.RucE and p.Cd_Prod = vas.Cd_Prod 
			left join Marca mc on mc.Cd_Mca = p.Cd_Mca and mc.RucE = p.RucE
			left join Almacen a on a.RucE=vas.RucE  and a.Cd_Alm=vas.Cd_Alm
		where p.RucE=@RucE and p.Estado=1 and p.IB_PV = 1 and a.Cd_Alm like @Cd_Alm+'%'
		group by p.Cd_Prod, p.Nombre1,p.Nombre2,cc.Nombre, sc.Nombre, ss.Nombre, p.CodCo1_,p.CodCo2_,p.CodCo3_, p.Cd_CC, p.Cd_SC, p.Cd_SS,p.IB_Srs, mc.Nombre,p.CA01,p.CA02,p.CA03,p.CA04,p.CA05,p.CA06,p.CA07,p.CA08,p.CA09,p.CA10,p.Descrip
	) as prod
left join (select Cd_Prod, sum(Cant)as 'Cant' from SolicitudComDet where RucE = @RucE group by Cd_Prod) as scd on prod.Cd_Prod = scd.Cd_Prod
left join (select Cd_Prod, sum(Cant) as 'Cant' from CotizacionDet where RucE = @RucE and Cd_Prod is not null group by Cd_Prod) as cd on prod.Cd_Prod = cd.Cd_Prod
order by prod.Cd_Prod


end
else 
select 
	@check AS 'Sel',
	prod.Cd_Prod, prod.NomProd, prod.NomProd2, prod.Clase, prod.SClase, prod.SSClase, prod.StockActual, prod.StockOrden,
	prod.StockRecibido, prod.StockPedido, prod.StockEntregado, prod.CodComer,
	isnull(scd.cant,0) as 'StockSolicitado', isnull(cd.cant, 0) as 'StockCotizado'
	,prod.Cd_CC, prod.Cd_SC, prod.Cd_SS,prod.Ib_Srs,prod.NombreMarca,prod.CA01,prod.CA02,prod.CA03,prod.CA04,prod.CA05,prod.CA06,prod.CA07,prod.CA08,prod.CA09,prod.CA10,prod.Descrip
from (
	select 
		p.Cd_Prod,p.Nombre1 as NomProd,p.Nombre2 as NomProd2,
		isnull(isnull(p.CodCo1_,isnull(p.CodCo2_,p.CodCo3_)),'') as CodComer,
		cc.Nombre as Clase,sc.Nombre as SClase,ss.Nombre as SSClase,
		sum(isnull(vas.StockActual,0)) as 'StockActual',sum(isnull(vas.StockOrd,0)) as 'StockOrden', sum(isnull(vas.StockRcb,0)) as 'StockRecibido',
		sum(isnull(vas.StockPed,0))  as 'StockPedido', sum(isnull(vas.StockEnt,0)) as 'StockEntregado'
		,p.Cd_CC, p.Cd_SC, p.Cd_SS,p.Ib_Srs, mc.Nombre As NombreMarca, p.CA01,p.CA02,p.CA03,p.CA04,p.CA05,p.CA06,p.CA07,p.CA08,p.CA09,p.CA10, p.Descrip
		from Producto2 p
			left join Clase cc On cc.RucE=p.RucE and cc.Cd_CL=p.Cd_CL
			left join ClaseSub sc On sc.RucE=p.RucE and sc.Cd_CLS=p.Cd_CLS and sc.Cd_CL=p.Cd_CL
			left join ClaseSubSub ss On ss.RucE=p.RucE and ss.Cd_CLSS=p.Cd_CLSS and ss.Cd_CLS=p.Cd_CLS and ss.Cd_CL=p.Cd_CL
			left join Vst_AlmacenStockGen vas on vas.RucE=p.RucE and p.Cd_Prod = vas.Cd_Prod 
			left join Marca mc on mc.Cd_Mca = p.Cd_Mca and mc.RucE = p.RucE			
		where p.RucE=@RucE and p.Estado=1 and p.IB_PV = 1 
		group by p.Cd_Prod, p.Nombre1,p.Nombre2,cc.Nombre, sc.Nombre, ss.Nombre, p.CodCo1_,p.CodCo2_,p.CodCo3_, p.Cd_CC, p.Cd_SC, p.Cd_SS,p.IB_Srs, mc.Nombre,p.CA01,p.CA02,p.CA03,p.CA04,p.CA05,p.CA06,p.CA07,p.CA08,p.CA09,p.CA10,p.Descrip
	) as prod
left join (select Cd_Prod, sum(Cant)as 'Cant' from SolicitudComDet where RucE = @RucE group by Cd_Prod) as scd on prod.Cd_Prod = scd.Cd_Prod
left join (select Cd_Prod, sum(Cant) as 'Cant' from CotizacionDet where RucE = @RucE and Cd_Prod is not null group by Cd_Prod) as cd on prod.Cd_Prod = cd.Cd_Prod
order by prod.Cd_Prod




--select* from Vst_AlmacenStockGen where RucE='20160000001'


--exec Inv_Producto2Cons_paCot1 '20536756541',null
-- Leyedan --

--DI : 24/02/2010 <Creacion del procedimiento almacenado>
--MM : 03/12/2010 Modificacion del sp agregagando mas campos
--JJ : 22/12/2010 Modificacion del sp se corrigue RucE
--JJ : 23/02/2011 Modificacion del sp se se agrego and vas.RucE=p.RucE dentro del from()
--PP : 25/02/2011 Modificacion del por k  emer no ve  productos
--PP : 07/03/2011 Modificacion del sp se se modifico and vas.RucE=p.RucE por and vas.RucE=@RucE
--AC : 16/10/2012 Modificacion del sp se agrego el campo de IB_Srs a la consulta
-- GGONZ : 29/12/2016 Modifiacion del sp se agrego la relacion con Almacén.
--exec Inv_Producto2Cons_paCot1 '11111111111',null
--select * from producto2 where RucE = '11111111111'

GO

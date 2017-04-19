SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_InventarioCons_StockxAlm1]
@RucE nvarchar (11),
@Cd_Prod char(7),
@Cd_Alm varchar(20),
@FecD datetime = null,
@FecH datetime = null,
@msj varchar(100) output
as

if not exists (select top 1 * from inventario where RucE=@RucE)
		set @msj = 'No se encontro Cliente'
else

	DECLARE @Temp1 TABLE(RucE nvarchar(11), Cd_Alm varchar(20), Almacen nvarchar(100), 
	CantAlm numeric, StockOrd numeric, StockRcb numeric, EntSinOC numeric,SalSinOP numeric,  StockPenRcb numeric, 
	StockPed numeric, StockEnt numeric, StockPenEnt numeric)		
--	insert into @Temp1 values (@RucE, @Cd_Alm, 'Saldo al '+convert(nvarchar,@FecD,103), 0, 0, 0, 0, 0, 0, 0)
	if(@Cd_Alm = '')
	insert into @Temp1 values (@RucE, @Cd_Alm, 'Saldo al '+convert(nvarchar,DATEADD(d, -1, @FecD),103), 0, 0, 0,0,0, 0, 0, 0, 0)
	else
	insert into @Temp1 values (@RucE, '------------', 'Saldo al '+convert(nvarchar,DATEADD(d, -1, @FecD),103), 0, 0,0,0 ,0, 0, 0, 0, 0)
	
	begin
	if(isnull(@Cd_Alm,'')='')
	begin
		select * from (select top 1 * from(

		select a.RucE, '------------' as Cd_Alm, 'Saldo al '+convert(nvarchar,DATEADD(d, -1, @FecD),103) as Almacen, sum(isnull(s.CantAlm,'0')) as CantAlm, sum(isnull(c.StockOrd,'0')) as StockOrd, sum(isnull(r.StockRcb,'0')) as StockRcb,sum(isnull(soc.EntSinOC,'0')) as EntSinOC, sum(ISNULL(sop.SalSinOP,'0')) as SalSinOP, sum(isnull(c.StockOrd,'0') - isnull(r.StockRcb,'0')) as StockPenRcb, sum(isnull(p.StockPed,'0')) as StockPed, sum(isnull(e.StockEnt,'0')) as StockEnt, sum(isnull(p.StockPed,'0') - isnull(e.StockEnt,'0')) as StockPenEnt
		from (select p.RucE, p.Cd_Prod, a.Cd_Alm from producto2 as p, Almacen as a where p.RucE = a.RucE) as a 
		left join (select RucE, Cd_Prod, Cd_Alm, sum(Cant) as CantAlm from Inventario where RucE = @RucE and Cd_Prod = @Cd_Prod and FecMov <= @FecD group by RucE, Cd_Prod, Cd_Alm) as  s on s.RucE = a.RucE and s.Cd_Prod = a.Cd_Prod and s.Cd_Alm = a.Cd_Alm
		left join (select d.RucE, d.Cd_Prod, d.Cd_Alm, sum(d.Cant) as StockOrd 
				   from OrdCompraDet d 
						inner join OrdCompra o on d.RucE = o.RucE and d.Cd_OC = o.Cd_OC and FecE <= @FecD 
				   where d.RucE = @RucE and d.Cd_Prod = @Cd_Prod
				   group by d.RucE, d.Cd_Prod, d.Cd_Alm) as c on c.RucE = a.RucE and c.Cd_Prod = a.Cd_Prod and c.Cd_Alm = a.Cd_Alm
		
		--Strart GG : Agregando campo EntSinOC 
		left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, sum(i.Cant) as EntSinOC
							from Inventario i 			
							where i.RucE = @RucE and i.Cd_Prod = @Cd_Prod and i.Cd_OC is null and IC_ES='E' and FecMov <= @FecD
							group by i.RucE, i.Cd_Prod, i.Cd_Alm) as soc 
				   on soc.RucE = a.RucE and soc.Cd_Prod = a.Cd_Prod and soc.Cd_Alm = a.Cd_Alm
		--End GG: Agregando campo EntSinOC
		
		--Strart GG : Agregando campo SalSinOP 
		left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, sum(i.Cant) as SalSinOP
							from Inventario i 			
							where i.RucE = @RucE and i.Cd_Prod = @Cd_Prod and i.Cd_OP is null and IC_ES='S' and FecMov <= @FecD
							group by i.RucE, i.Cd_Prod, i.Cd_Alm) as sop 
					on sop.RucE = a.RucE and sop.Cd_Prod = a.Cd_Prod and sop.Cd_Alm = a.Cd_Alm
		--End GG: Agregando campo SalSinOP


		left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, sum(i.Cant) as StockRcb from Inventario i inner join OrdCompra o on i.RucE = o.RucE and i.Cd_OC = o.Cd_OC where i.RucE = @RucE and i.Cd_Prod = @Cd_Prod and id_EstOC not in ('06','07') and IC_ES='E' and FecMov <= @FecD group by i.RucE, i.Cd_Prod, i.Cd_Alm) as r on r.RucE = a.RucE and r.Cd_Prod = a.Cd_Prod and r.Cd_Alm = a.Cd_Alm
		left join (select d.RucE, d.Cd_Prod, d.Cd_Alm, sum(d.Cant) as StockPed from OrdPedidoDet d inner join OrdPedido o on d.RucE = o.RucE and d.Cd_OP = o.Cd_OP and FecE <= @FecD where d.RucE = @RucE and d.Cd_Prod = @Cd_Prod group by d.RucE, d.Cd_Prod, d.Cd_Alm) as p on p.RucE = a.RucE and p.Cd_Prod = a.Cd_Prod and p.Cd_Alm = a.Cd_Alm
		left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, abs(sum(i.Cant)) as StockEnt from Inventario i inner join OrdPedido o on i.RucE = o.RucE and i.Cd_OP = o.Cd_OP where i.RucE = @RucE and i.Cd_Prod = @Cd_Prod and id_EstOP not in ('06') and IC_ES='S' and FecMov <= @FecD group by i.RucE, i.Cd_Prod, i.Cd_Alm) as e on e.RucE = a.RucE and e.Cd_Prod = a.Cd_Prod and e.Cd_Alm = a.Cd_Alm
		where (s.CantAlm is not null or c.StockOrd is not null or r.StockRcb is not null or soc.EntSinOC is not null or sop.SalSinOP is not null or p.StockPed is not null or e.StockEnt is not null) 

		
		group by a.RucE

		union all
		select * from @Temp1
		
		) as T order by CantAlm desc)
		as Temporal
	
		union all
		
		select a.RucE, a.Cd_Alm, a.Almacen, isnull(s.CantAlm,'0') as CantAlm, isnull(c.StockOrd,'0') as StockOrd, isnull(r.StockRcb,'0') as StockRcb, isnull(c.StockOrd,'0') - isnull(r.StockRcb,'0') as StockPenRcb, isnull(soc.EntSinOC,'0') as EntSinOC, ISNULL(sop.SalSinOP,'0') as SalSinOP, isnull(p.StockPed,'0') as StockPed, isnull(e.StockEnt,'0') as StockEnt, isnull(p.StockPed,'0') - isnull(e.StockEnt,'0') as StockPenEnt
		from (select p.RucE, p.Cd_Prod, a.Cd_Alm, a.Nombre as Almacen  from producto2 as p, Almacen as a where p.RucE = a.RucE) as a 
		left join (select RucE, Cd_Prod, Cd_Alm, sum(Cant) as CantAlm from Inventario where RucE = @RucE and Cd_Prod = @Cd_Prod and FecMov between @FecD and @FecH group by RucE, Cd_Prod, Cd_Alm) as  s on s.RucE = a.RucE and s.Cd_Prod = a.Cd_Prod and s.Cd_Alm = a.Cd_Alm
		left join (select d.RucE, d.Cd_Prod, d.Cd_Alm, sum(d.Cant) as StockOrd from OrdCompraDet d inner join OrdCompra o on d.RucE = o.RucE and d.Cd_OC = o.Cd_OC and FecE between @FecD and @FecH where d.RucE = @RucE and d.Cd_Prod = @Cd_Prod group by d.RucE, d.Cd_Prod, d.Cd_Alm) as c on c.RucE = a.RucE and c.Cd_Prod = a.Cd_Prod and c.Cd_Alm = a.Cd_Alm
		
		--Strart GG : Agregando campo EntSinOC 
		left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, sum(i.Cant) as EntSinOC
							from Inventario i 			
							where i.RucE = @RucE and i.Cd_Prod = @Cd_Prod and i.Cd_OC is null and IC_ES='E' and FecMov <= @FecD
							group by i.RucE, i.Cd_Prod, i.Cd_Alm) as soc 
				   on soc.RucE = a.RucE and soc.Cd_Prod = a.Cd_Prod and soc.Cd_Alm = a.Cd_Alm
		--End GG: Agregando campo EntSinOC
		
		--Strart GG : Agregando campo SalSinOP 
		left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, sum(i.Cant) as SalSinOP
							from Inventario i 			
							where i.RucE = @RucE and i.Cd_Prod = @Cd_Prod and i.Cd_OP is null and IC_ES='S' and FecMov <= @FecD
							group by i.RucE, i.Cd_Prod, i.Cd_Alm) as sop 
					on sop.RucE = a.RucE and sop.Cd_Prod = a.Cd_Prod and sop.Cd_Alm = a.Cd_Alm
		--End GG: Agregando campo SalSinOP
		
		left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, sum(i.Cant) as StockRcb from Inventario i inner join OrdCompra o on i.RucE = o.RucE and i.Cd_OC = o.Cd_OC where i.RucE = @RucE and i.Cd_Prod = @Cd_Prod and id_EstOC not in ('06','07') and IC_ES='E' and FecMov between @FecD and @FecH group by i.RucE, i.Cd_Prod, i.Cd_Alm) as r on r.RucE = a.RucE and r.Cd_Prod = a.Cd_Prod and r.Cd_Alm = a.Cd_Alm
		left join (select d.RucE, d.Cd_Prod, d.Cd_Alm, sum(d.Cant) as StockPed from OrdPedidoDet d inner join OrdPedido o on d.RucE = o.RucE and d.Cd_OP = o.Cd_OP and FecE between @FecD and @FecH where d.RucE = @RucE and d.Cd_Prod = @Cd_Prod group by d.RucE, d.Cd_Prod, d.Cd_Alm) as p on p.RucE = a.RucE and p.Cd_Prod = a.Cd_Prod and p.Cd_Alm = a.Cd_Alm
		left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, abs(sum(i.Cant)) as StockEnt from Inventario i inner join OrdPedido o on i.RucE = o.RucE and i.Cd_OP = o.Cd_OP where i.RucE = @RucE and i.Cd_Prod = @Cd_Prod and id_EstOP not in ('06') and IC_ES='S' and FecMov between @FecD and @FecH group by i.RucE, i.Cd_Prod, i.Cd_Alm) as e on e.RucE = a.RucE and e.Cd_Prod = a.Cd_Prod and e.Cd_Alm = a.Cd_Alm
		where (s.CantAlm is not null or c.StockOrd is not null or r.StockRcb is not null or soc.EntSinOC is not null or sop.SalSinOP is not null or p.StockPed is not null or e.StockEnt is not null) 


	end
	else
	begin
		select * from (select top 1 * from(

		select a.RucE, '------------' as Cd_Alm, 'Saldo al '+convert(nvarchar,@FecD,103) as Almacen, sum(isnull(s.CantAlm,'0')) as CantAlm, sum(isnull(c.StockOrd,'0')) as StockOrd, sum(isnull(r.StockRcb,'0')) as StockRcb, sum(isnull(soc.EntSinOC,'0')) as EntSinOC, sum(ISNULL(sop.SalSinOP,'0')) as SalSinOP, sum(isnull(c.StockOrd,'0') - isnull(r.StockRcb,'0')) as StockPenRcb, sum(isnull(p.StockPed,'0')) as StockPed, sum(isnull(e.StockEnt,'0')) as StockEnt, sum(isnull(p.StockPed,'0') - isnull(e.StockEnt,'0')) as StockPenEnt
		from (select p.RucE, p.Cd_Prod, a.Cd_Alm from producto2 as p, Almacen as a where p.RucE = a.RucE and Cd_Alm like @Cd_Alm+'%') as a 
		left join (select RucE, Cd_Prod, Cd_Alm, sum(Cant) as CantAlm from Inventario where RucE = @RucE and Cd_Prod = @Cd_Prod and FecMov <= @FecD group by RucE, Cd_Prod, Cd_Alm) as  s on s.RucE = a.RucE and s.Cd_Prod = a.Cd_Prod and s.Cd_Alm = a.Cd_Alm
		left join (select d.RucE, d.Cd_Prod, d.Cd_Alm, sum(d.Cant) as StockOrd from OrdCompraDet d inner join OrdCompra o on d.RucE = o.RucE and d.Cd_OC = o.Cd_OC and FecE <= @FecD where d.RucE = @RucE and d.Cd_Prod = @Cd_Prod group by d.RucE, d.Cd_Prod, d.Cd_Alm) as c on c.RucE = a.RucE and c.Cd_Prod = a.Cd_Prod and c.Cd_Alm = a.Cd_Alm
		
		
		left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, sum(i.Cant) as StockRcb 
				   from Inventario i 
						inner join OrdCompra o on i.RucE = o.RucE and i.Cd_OC = o.Cd_OC 
					where i.RucE = @RucE and i.Cd_Prod = @Cd_Prod and id_EstOC not in ('06','07') and IC_ES='E' and FecMov <= @FecD 
					group by i.RucE, i.Cd_Prod, i.Cd_Alm) as r 
		on r.RucE = a.RucE and r.Cd_Prod = a.Cd_Prod and r.Cd_Alm = a.Cd_Alm
		

		--Strart GG : Agregando campo EntSinOC 
		left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, sum(i.Cant) as EntSinOC
							from Inventario i 			
							where i.RucE = @RucE and i.Cd_Prod = @Cd_Prod and i.Cd_OC is null and IC_ES='E' and FecMov <= @FecD
							group by i.RucE, i.Cd_Prod, i.Cd_Alm) as soc 
				   on soc.RucE = a.RucE and soc.Cd_Prod = a.Cd_Prod and soc.Cd_Alm = a.Cd_Alm
		--End GG: Agregando campo EntSinOC
		
		--Strart GG : Agregando campo SalSinOP 
		left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, sum(i.Cant) as SalSinOP
							from Inventario i 			
							where i.RucE = @RucE and i.Cd_Prod = @Cd_Prod and i.Cd_OP is null and IC_ES='S' and FecMov <= @FecD
							group by i.RucE, i.Cd_Prod, i.Cd_Alm) as sop 
					on sop.RucE = a.RucE and sop.Cd_Prod = a.Cd_Prod and sop.Cd_Alm = a.Cd_Alm
		--End GG: Agregando campo SalSinOP
		
		left join (select d.RucE, d.Cd_Prod, d.Cd_Alm, sum(d.Cant) as StockPed from OrdPedidoDet d inner join OrdPedido o on d.RucE = o.RucE and d.Cd_OP = o.Cd_OP and FecE <= @FecD where d.RucE = @RucE and d.Cd_Prod = @Cd_Prod group by d.RucE, d.Cd_Prod, d.Cd_Alm) as p on p.RucE = a.RucE and p.Cd_Prod = a.Cd_Prod and p.Cd_Alm = a.Cd_Alm
		left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, abs(sum(i.Cant)) as StockEnt from Inventario i inner join OrdPedido o on i.RucE = o.RucE and i.Cd_OP = o.Cd_OP where i.RucE = @RucE and i.Cd_Prod = @Cd_Prod and id_EstOP not in ('06') and IC_ES='S' and FecMov <= @FecD group by i.RucE, i.Cd_Prod, i.Cd_Alm) as e on e.RucE = a.RucE and e.Cd_Prod = a.Cd_Prod and e.Cd_Alm = a.Cd_Alm
    	where (s.CantAlm is not null or c.StockOrd is not null or r.StockRcb is not null or soc.EntSinOC is not null or sop.SalSinOP is not null or p.StockPed is not null or e.StockEnt is not null) 

		
		group by a.RucE
		
		union all
		select * from @Temp1
		
		) as T order by CantAlm desc)
		as Temporal
		
		union all
		
		select a.RucE, a.Cd_Alm, a.Almacen, isnull(s.CantAlm,'0') as CantAlm, isnull(c.StockOrd,'0') as StockOrd, isnull(r.StockRcb,'0') as StockRcb,isnull(soc.EntSinOC,'0') as EntSinOC, ISNULL(sop.SalSinOP,'0') as SalSinOP,  isnull(c.StockOrd,'0') - isnull(r.StockRcb,'0') as StockPenRcb, isnull(p.StockPed,'0') as StockPed, isnull(e.StockEnt,'0') as StockEnt, isnull(p.StockPed,'0') - isnull(e.StockEnt,'0') as StockPenEnt
		from (select p.RucE, p.Cd_Prod, a.Cd_Alm, a.Nombre as Almacen  from producto2 as p, Almacen as a where p.RucE = a.RucE and Cd_Alm like @Cd_Alm+'%') as a 
		left join (select RucE, Cd_Prod, Cd_Alm, sum(Cant) as CantAlm from Inventario where RucE = @RucE and Cd_Prod = @Cd_Prod and FecMov between @FecD and @FecH group by RucE, Cd_Prod, Cd_Alm) as  s on s.RucE = a.RucE and s.Cd_Prod = a.Cd_Prod and s.Cd_Alm = a.Cd_Alm
		left join (select d.RucE, d.Cd_Prod, d.Cd_Alm, sum(d.Cant) as StockOrd from OrdCompraDet d inner join OrdCompra o on d.RucE = o.RucE and d.Cd_OC = o.Cd_OC and FecE between @FecD and @FecH where d.RucE = @RucE and d.Cd_Prod = @Cd_Prod group by d.RucE, d.Cd_Prod, d.Cd_Alm) as c on c.RucE = a.RucE and c.Cd_Prod = a.Cd_Prod and c.Cd_Alm = a.Cd_Alm
		left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, sum(i.Cant) as StockRcb from Inventario i inner join OrdCompra o on i.RucE = o.RucE and i.Cd_OC = o.Cd_OC where i.RucE = @RucE and i.Cd_Prod = @Cd_Prod and id_EstOC not in ('06','07') and IC_ES='E' and FecMov between @FecD and @FecH group by i.RucE, i.Cd_Prod, i.Cd_Alm) as r on r.RucE = a.RucE and r.Cd_Prod = a.Cd_Prod and r.Cd_Alm = a.Cd_Alm
			--Strart GG : Agregando campo EntSinOC 
		left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, sum(i.Cant) as EntSinOC
							from Inventario i 			
							where i.RucE = @RucE and i.Cd_Prod = @Cd_Prod and i.Cd_OC is null and IC_ES='E' and FecMov <= @FecD
							group by i.RucE, i.Cd_Prod, i.Cd_Alm) as soc 
				   on soc.RucE = a.RucE and soc.Cd_Prod = a.Cd_Prod and soc.Cd_Alm = a.Cd_Alm
		--End GG: Agregando campo EntSinOC
		
		--Strart GG : Agregando campo SalSinOP 
		left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, sum(i.Cant) as SalSinOP
							from Inventario i 			
							where i.RucE = @RucE and i.Cd_Prod = @Cd_Prod and i.Cd_OP is null and IC_ES='S' and FecMov <= @FecD
							group by i.RucE, i.Cd_Prod, i.Cd_Alm) as sop 
					on sop.RucE = a.RucE and sop.Cd_Prod = a.Cd_Prod and sop.Cd_Alm = a.Cd_Alm
		--End GG: Agregando campo SalSinOP
		
		
		
		left join (select d.RucE, d.Cd_Prod, d.Cd_Alm, sum(d.Cant) as StockPed from OrdPedidoDet d inner join OrdPedido o on d.RucE = o.RucE and d.Cd_OP = o.Cd_OP and FecE between @FecD and @FecH where d.RucE = @RucE and d.Cd_Prod = @Cd_Prod group by d.RucE, d.Cd_Prod, d.Cd_Alm) as p on p.RucE = a.RucE and p.Cd_Prod = a.Cd_Prod and p.Cd_Alm = a.Cd_Alm
		left join (select i.RucE, i.Cd_Prod, i.Cd_Alm, abs(sum(i.Cant)) as StockEnt from Inventario i inner join OrdPedido o on i.RucE = o.RucE and i.Cd_OP = o.Cd_OP where i.RucE = @RucE and i.Cd_Prod = @Cd_Prod and id_EstOP not in ('06') and IC_ES='S' and FecMov between @FecD and @FecH group by i.RucE, i.Cd_Prod, i.Cd_Alm) as e on e.RucE = a.RucE and e.Cd_Prod = a.Cd_Prod and e.Cd_Alm = a.Cd_Alm
		where (s.CantAlm is not null or c.StockOrd is not null or r.StockRcb is not null or soc.EntSinOC is not null or sop.SalSinOP is not null or p.StockPed is not null or e.StockEnt is not null) 

	end
end

-- Leyenda --
-- JJ : 2010-08-02 	: <Creacion del procedimiento almacenado>
-- JJ : 2010-08-04 	: <Correccion del procedimiento almacenado>
-- JJ : 2010-08-05 	: <Correccion del procedimiento almacenado>
-- PP : 2011-02-24 	: <Correccion del procedimiento almacenado>








GO

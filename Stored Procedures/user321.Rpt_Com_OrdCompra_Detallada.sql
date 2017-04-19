SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Rpt_Com_OrdCompra_Detallada]
@RucE nvarchar(11)
as


--Grilla 1
select 	Com1.Cd_CC,Max(Com1.CCosto) CCosto,
	(isnull(Com1.Cd_CC,'')+'-'+Max(isnull(Com1.CCosto,''))) NCosto,
	Com1.Cd_SC,Max(Com1.CCSub)CCSub,
	(isnull(Com1.Cd_SC,'')+'-'+Max(isnull(Com1.CCSub,''))) NCSub,
	Com1.Cd_SS,Max(Com1.CCSubSub) CCSubSub,
	(isnull(Com1.Cd_SS,'')+'-'+Max(isnull(Com1.CCSubSub,''))) NSubSub,
	SUM(Com1.CostOrd) CostOrd, Sum(Com1.CostRcb) CostRcb,Sum(Com1.CostPend) CostPend
from(
select *from (select
	oc.Cd_CC,
	Max(cc.Descrip) CCosto,
	oc.Cd_SC,
	Max(cs.Descrip) CCSub,
	oc.Cd_SS,
	Max(ss.Descrip) CCSubSub,
	SUM(isnull(ocd.BIM,0)*isnull(ocd.Cant,0)) CostOrd,
	Max(isnull(inv.Cant,0)*isnull(inv.CosUnt,0)) CostRcb,
	SUM(isnull(ocd.BIM,0)*isnull(ocd.Cant,0)) - Max(Inv.Total) CostPend,
	SUM(ocd.BIM) BIM
from 	
	OrdCompra oc 
	inner join OrdCompraDet OCD on ocd.RucE=oc.RucE and ocd.Cd_OC=oc.Cd_OC
	inner join CCostos cc on cc.RucE=oc.RucE and cc.Cd_CC=oc.Cd_CC
	inner join CCSub cs on cs.RucE=oc.RucE and cs.Cd_CC=oc.Cd_CC and cs.Cd_SC=oc.Cd_SC
	inner join CCSubSub ss on ss.RucE=oc.RucE and ss.Cd_CC=oc.Cd_CC and ss.Cd_SC=oc.Cd_SC and ss.Cd_SS=oc.Cd_SS
	inner join (select Max(RucE) RucE , Cd_OC,SUM(Cant) Cant,max(CosUnt) CosUnt,SUM(isnull(Cant*CosUnt,0)) Total
	from Inventario where RucE=@RucE and Cd_OC is not null group by Cd_OC
	) as inv on inv.RucE=oc.RucE and inv.Cd_OC=ocd.Cd_OC and Inv.Cd_OC=oc.Cd_OC
where 	OCD.RucE=@RucE
group by oc.Cd_CC,oc.Cd_SC,oc.Cd_SS) as Com1
union all
select *from(
select 	
	oc.Cd_CC,
	Max(cc.Descrip) CCosto,
	oc.Cd_SC,
	Max(cs.Descrip) CCSub,
	oc.Cd_SS,
	Max(ss.Descrip) CCSubSub,
	SUM(isnull(ocd.BIM,0)*isnull(ocd.Cant,0)) CostOrd,
	0.00 CostRcb,
	SUM(isnull(ocd.BIM,0)*isnull(ocd.Cant,0)) - 0.00 CostPend,
	SUM(ocd.BIM) BIM
from 	
	OrdCompra oc 
	inner join OrdCompraDet OCD on ocd.RucE=oc.RucE and ocd.Cd_OC=oc.Cd_OC
	left join CCostos cc on cc.RucE=oc.RucE and cc.Cd_CC=oc.Cd_CC
	left join CCSub cs on cs.RucE=oc.RucE and cs.Cd_CC=oc.Cd_CC and cs.Cd_SC=oc.Cd_SC
	left join CCSubSub ss on ss.RucE=oc.RucE and ss.Cd_CC=oc.Cd_CC and ss.Cd_SC=oc.Cd_SC and ss.Cd_SS=oc.Cd_SS
where 	OCD.RucE=@RucE and ocd.Cd_OC not in(select Cd_OC from Inventario where Cd_OC is not null and RucE=@RucE)
group by oc.Cd_CC,oc.Cd_SC,oc.Cd_SS) as Com2
) as Com1
group by Com1.Cd_CC,Com1.Cd_SC,Com1.Cd_SS
order by Com1.Cd_CC,Com1.Cd_SC,Com1.Cd_SS



--Grilla 2

select 	Com2.Cd_OC, Max(Com2.Cd_CC) Cd_CC, Max(Com2.Cd_SC) Cd_SC,Max(Com2.Cd_SS) Cd_SS,Max(Com2.Asunto) Asunto,
	Sum(Com2.CostOrd) CostOrd1, Sum(Com2.CostRcb) CostRcb1, Sum(Com2.CostPend) CostPend1
from(
select *from(
select 	ocd.Cd_OC,
	Max(oc.Cd_CC) Cd_CC,
	Max(oc.Cd_SC) Cd_SC,
	Max(oc.Cd_SS) Cd_SS,
	Max(oc.Obs) Asunto,
	SUM(isnull(ocd.Cant,0)*isnull(ocd.BIM,0)) CostOrd,
	Max(Inv.Total) CostRcb,
	SUM(isnull(ocd.Cant,0)*isnull(ocd.BIM,0)) - Max(Inv.Total) CostPend
	from OrdCompra oc inner join OrdCompraDet ocd on
	ocd.RucE=oc.RucE and ocd.Cd_OC=oc.Cd_OC inner join 
	(select Max(RucE) RucE,Cd_OC,SUM(isnull(Cant,0)) Cant,Sum(isnull(CosUnt,0)) CosUnt,Sum(isnull(Cant,0)*isnull(CosUnt,0)) Total
	 from inventario where RucE=@RucE and Cd_OC is not null group by Cd_OC)
	as Inv on inv.RucE=ocd.RucE and inv.Cd_OC=ocd.Cd_OC
where 	ocd.RucE=@RucE
group by ocd.Cd_OC
) as OC1
union all
select *from(
select 	ocd.Cd_OC,
	Max(oc.Cd_CC) Cd_CC,
	Max(oc.Cd_SC) Cd_SC,
	Max(oc.Cd_SS) Cd_SS,
	Max(oc.Obs) Asunto,
	SUM(isnull(ocd.Cant,0)*isnull(ocd.BIM,0)) CostOrd,
	0.00 CostRcb,
	SUM(isnull(ocd.Cant,0)*isnull(ocd.BIM,0)) CostPend
	from OrdCompra oc inner join OrdCompraDet ocd on
	ocd.RucE=oc.RucE and ocd.Cd_OC=oc.Cd_OC
where 	ocd.RucE=@RucE and ocd.Cd_OC not in (select Cd_OC from Inventario Where RucE=@RucE and Cd_OC is not null)
group by ocd.Cd_OC
) as OC2
) as Com2
Group By Cd_OC
order by Cd_CC,Cd_SC,Cd_SS, Cd_OC

--Grilla 3
select *from(
select *from(
select 	ocd.Cd_OC,
	oc.Cd_CC,
	oc.Cd_SC,
	oc.Cd_SS,
	p2.Cd_Prod,
	p2.Nombre1 as Producto,
	inv.CosUnt CosUnt,
	isnull(ocd.Cant,0) CantOrd,
	isnull(ocd.Cant*ocd.BIM,0) TotOrd,
	isnull(inv.Cant,0) CantRcb,
	isnull(inv.Total,0) TotRcb,
	isnull(ocd.Cant - Inv.Cant,0) as CantPend,
	isnull(ocd.Cant*ocd.BIM,0) - isnull(Inv.Total,0) as TotPend
from 
	OrdCompra oc inner join OrdCompraDet ocd on
	ocd.RucE=oc.RucE and ocd.Cd_OC=oc.Cd_OC
	inner join Producto2 p2 on p2.RucE=ocd.RucE and p2.Cd_Prod=ocd.Cd_Prod
	inner join (select RucE,Cd_OC,Cd_Prod,isnull(Cant,0) Cant,isnull(CosUnt,0)CosUnt,isnull(Cant*CosUnt,0) as total from Inventario
	where RucE=@RucE and Cd_OC is not null) as inv on inv.RucE=ocd.RucE and inv.Cd_OC=ocd.Cd_OC and inv.Cd_Prod=ocd.Cd_Prod
where ocd.RucE=@RucE) as Prd1
union all
select *from(
select 	ocd.Cd_OC,
	oc.Cd_CC,
	oc.Cd_SC,
	oc.Cd_SS,
	p2.Cd_Prod,
	p2.Nombre1 as Producto,
	ocd.BIM CosUnt,
	isnull(ocd.Cant,0) CantOrd,
	isnull(ocd.Cant*ocd.BIM,0) TotOrd,
	0.00 CantRcb,
	0.00 TotRcb,
	isnull(ocd.Cant,0) as CantPend,
	isnull(ocd.Cant*ocd.BIM,0) as TotPend
from 
	OrdCompra oc inner join OrdCompraDet ocd on
	ocd.RucE=oc.RucE and ocd.Cd_OC=oc.Cd_OC
	inner join Producto2 p2 on p2.RucE=ocd.RucE and p2.Cd_Prod=ocd.Cd_Prod
where ocd.RucE=@RucE and ocd.Cd_OC not in(select Cd_OC from Inventario where RucE=@RucE and Cd_OC is not null)
) as Prd2
) as Com3
order by Com3.Cd_CC,Com3.Cd_SC,Com3.Cd_SS,Com3.Cd_OC

--select *from OrdCompraDet where RucE='20504743561'
--select *from Inventario

-- Leyenda
-- JJ 18/03/2011:	<Creacion del Procedimiento almacenado>

--exec Rpt_Com_OrdCompra_Detallada '20504743561'








GO

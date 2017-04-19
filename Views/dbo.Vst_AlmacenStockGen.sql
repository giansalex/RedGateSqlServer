SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[Vst_AlmacenStockGen] as
select 	a.RucE, a.Cd_Prod, a.Cd_Alm, 
	case when CantAlm is not null then CantAlm else (isnull(CantAlm,'0')) end as StockActual,
	case when StockOrd is not null then StockOrd else (isnull(StockOrd,'0')) end as StockOrd,
	case when StockRcb is not null then StockRcb else (isnull(StockRcb,'0')) end as StockRcb,
	case when StockOrd is not null then StockOrd else (isnull(StockOrd,'0')) end - case when StockRcb is not null then StockRcb else (isnull(StockRcb,'0')) end as StockPenRcb,
	case when StockPed is not null then StockPed else (isnull(StockPed,'0')) end as StockPed,
	case when StockEnt is not null then StockEnt else (isnull(StockEnt,'0')) end as StockEnt,
	case when StockPed is not null then StockPed else (isnull(StockPed,'0')) end - case when StockEnt is not null then StockEnt else (isnull(StockEnt,'0')) end as StockPenEnt
	from Vst_AlmacenStockAct a
	left join Vst_AlmacenStockOrd o on a.RucE = o.RucE and a.Cd_Prod = o.Cd_Prod and a.Cd_Alm=o.Cd_Alm
     	left join Vst_AlmacenStockRcb r on a.RucE = r.RucE  and a.Cd_Prod = r.Cd_Prod and a.Cd_Alm=r.Cd_Alm
     	left join Vst_AlmacenStockPed p on a.RucE = p.RucE and a.Cd_Prod = p.Cd_Prod and a.Cd_Alm=p.Cd_Alm
     	left join Vst_AlmacenStockEnt e on a.RucE = e.RucE  and a.Cd_Prod = e.Cd_Prod and a.Cd_Alm=e.Cd_Alm
	where (CantAlm is not null or StockOrd is not null or StockRcb is not null or StockPed is not null or StockEnt is not null) --and a.RucE = '11111111111' order by  1,2,3

	
--select * from Vst_AlmacenStockAct a where  a.RucE = '11111111111' and  CantAlm is not null order by  1,2,3
--order by 1,2,3 
--Leyenda
-- JJ : 2010-08-04	: <Creacion de la Vista>
-- PP  : 2011-02-18	: <Arregle

GO

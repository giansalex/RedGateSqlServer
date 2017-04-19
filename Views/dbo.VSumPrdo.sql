SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VSumPrdo]

AS

--VISTA
select
	RucE,Ejer,NroCta,Cd_CC,Cd_SC,Cd_SS,
	Sum(Case(Prdo) when '01' then (MtoD-MtoH)else 0 end) as Ene,
	Sum(Case(Prdo) when '02' then (MtoD-MtoH)else 0 end) as Feb,
	Sum(Case(Prdo) when '03' then (MtoD-MtoH)else 0 end) as Mar,
	Sum(Case(Prdo) when '04' then (MtoD-MtoH)else 0 end) as Abr,
	Sum(Case(Prdo) when '05' then (MtoD-MtoH)else 0 end) as May,
	Sum(Case(Prdo) when '06' then (MtoD-MtoH)else 0 end) as Jun,
	Sum(Case(Prdo) when '07' then (MtoD-MtoH)else 0 end) as Jul,
	Sum(Case(Prdo) when '08' then (MtoD-MtoH)else 0 end) as Ago,
	Sum(Case(Prdo) when '09' then (MtoD-MtoH)else 0 end) as Sep,
	Sum(Case(Prdo) when '10' then (MtoD-MtoH)else 0 end) as Oct,
	Sum(Case(Prdo) when '11' then (MtoD-MtoH)else 0 end) as Nov,
	Sum(Case(Prdo) when '12' then (MtoD-MtoH)else 0 end) as Dic,

	Sum(Case(Prdo) when '01' then (MtoD_ME-MtoH_ME)else 0 end) as Ene_ME,
	Sum(Case(Prdo) when '02' then (MtoD_ME-MtoH_ME)else 0 end) as Feb_ME,
	Sum(Case(Prdo) when '03' then (MtoD_ME-MtoH_ME)else 0 end) as Mar_ME,
	Sum(Case(Prdo) when '04' then (MtoD_ME-MtoH_ME)else 0 end) as Abr_ME,
	Sum(Case(Prdo) when '05' then (MtoD_ME-MtoH_ME)else 0 end) as May_ME,
	Sum(Case(Prdo) when '06' then (MtoD_ME-MtoH_ME)else 0 end) as Jun_ME,
	Sum(Case(Prdo) when '07' then (MtoD_ME-MtoH_ME)else 0 end) as Jul_ME,
	Sum(Case(Prdo) when '08' then (MtoD_ME-MtoH_ME)else 0 end) as Ago_ME,
	Sum(Case(Prdo) when '09' then (MtoD_ME-MtoH_ME)else 0 end) as Sep_ME,
	Sum(Case(Prdo) when '10' then (MtoD_ME-MtoH_ME)else 0 end) as Oct_ME,
	Sum(Case(Prdo) when '11' then (MtoD_ME-MtoH_ME)else 0 end) as Nov_ME,
	Sum(Case(Prdo) when '12' then (MtoD_ME-MtoH_ME)else 0 end) as Dic_ME
from Voucher 
--where RucE='11111111111' and Ejer='2009' and NroCta='67.6.0.01'
Group by RucE,Ejer,NroCta,Cd_CC,Cd_SC,Cd_SS

GO

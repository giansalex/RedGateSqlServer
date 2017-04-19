SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VPresupuesto]

AS

--VISTA

select
	RucE,Cd_Psp,Ejer,NroCta,Cd_CC,Cd_SC,Cd_SS,
	isnull(Ene,0) as Ene, isnull(Ene_ME,0) as Ene_ME,
	isnull(Feb,0) as Feb, isnull(Feb_ME,0) as Feb_ME,
	isnull(Mar,0) as Mar, isnull(Mar_ME,0) as Mar_ME,
	isnull(Abr,0) as Abr, isnull(Abr_ME,0) as Abr_ME,
	isnull(May,0) as May, isnull(May_ME,0) as May_ME,
	isnull(Jun,0) as Jun, isnull(Jun_ME,0) as Jun_ME,
	isnull(Jul,0) as Jul, isnull(Jul_ME,0) as Jul_ME,
	isnull(Ago,0) as Ago, isnull(Ago_ME,0) as Ago_ME,
	isnull(Sep,0) as Sep, isnull(Sep_ME,0) as Sep_ME,
	isnull(Oct,0) as Oct, isnull(Oct_ME,0) as Oct_ME,
	isnull(Nov,0) as Nov, isnull(Nov_ME,0) as Nov_ME,
	isnull(Dic,0) as Dic, isnull(Dic_ME,0) as Dic_ME,
	
	isnull(Ene,0) +	isnull(Feb,0) +	isnull(Mar,0) +	isnull(Abr,0) +	isnull(May,0) +	isnull(Jun,0) +	isnull(Jul,0) +	isnull(Ago,0) +	isnull(Sep,0) +	isnull(Oct,0) +	isnull(Nov,0)+	isnull(Dic,0) as Total,
	isnull(Ene_ME,0) + isnull(Feb_ME,0) + isnull(Mar_ME,0) + isnull(Abr_ME,0) + isnull(May_ME,0) + isnull(Jun_ME,0) + isnull(Jul_ME,0) + isnull(Ago_ME,0) +	isnull(Sep_ME,0) + isnull(Oct_ME,0) + isnull(Nov_ME,0)+ isnull(Dic_ME,0) as Total_ME
--from Presupuesto Order by NroCta desc,Cd_CC,Cd_SC,Cd_SS 
from Presupuesto Group by RucE,Cd_Psp,Ejer,NroCta,Cd_CC,Cd_SC,Cd_SS,Ene,Feb,Mar,Abr,May,Jun,Jul,Ago,Sep,Oct,Nov,Dic,Ene_ME,Feb_ME,Mar_ME,Abr_ME,May_ME,Jun_ME,Jul_ME,Ago_ME,Sep_ME,Oct_ME,Nov_ME,Dic_ME

GO

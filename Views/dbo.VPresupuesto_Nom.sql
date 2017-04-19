SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VPresupuesto_Nom]

AS

--VISTA
select
	p.RucE,p.Cd_Psp,p.Ejer,p.NroCta,cc.NCorto as Cd_CC,sc.NCorto as Cd_SC,ss.NCorto as Cd_SS,
	isnull(p.Ene,0) as Ene, isnull(p.Ene_ME,0) as Ene_ME,
	isnull(p.Feb,0) as Feb, isnull(p.Feb_ME,0) as Feb_ME,
	isnull(p.Mar,0) as Mar, isnull(p.Mar_ME,0) as Mar_ME,
	isnull(p.Abr,0) as Abr, isnull(p.Abr_ME,0) as Abr_ME,
	isnull(p.May,0) as May, isnull(p.May_ME,0) as May_ME,
	isnull(p.Jun,0) as Jun, isnull(p.Jun_ME,0) as Jun_ME,
	isnull(p.Jul,0) as Jul, isnull(p.Jul_ME,0) as Jul_ME,
	isnull(p.Ago,0) as Ago, isnull(p.Ago_ME,0) as Ago_ME,
	isnull(p.Sep,0) as Sep, isnull(p.Sep_ME,0) as Sep_ME,
	isnull(p.Oct,0) as Oct, isnull(p.Oct_ME,0) as Oct_ME,
	isnull(p.Nov,0) as Nov, isnull(p.Nov_ME,0) as Nov_ME,
	isnull(p.Dic,0) as Dic, isnull(p.Dic_ME,0) as Dic_ME,
	
	isnull(Ene,0) +	isnull(Feb,0) +	isnull(Mar,0) +	isnull(Abr,0) +	isnull(May,0) +	isnull(Jun,0) +	isnull(Jul,0) +	isnull(Ago,0) +	isnull(Sep,0) +	isnull(Oct,0) +	isnull(Nov,0)+	isnull(Dic,0) as Total,
	isnull(Ene_ME,0) + isnull(Feb_ME,0) + isnull(Mar_ME,0) + isnull(Abr_ME,0) + isnull(May_ME,0) + isnull(Jun_ME,0) + isnull(Jul_ME,0) + isnull(Ago_ME,0) +	isnull(Sep_ME,0) + isnull(Oct_ME,0) + isnull(Nov_ME,0)+ isnull(Dic_ME,0) as Total_ME
--from Presupuesto Order by NroCta desc,Cd_CC,Cd_SC,Cd_SS 
from Presupuesto p
left join CCostos cc on cc.RucE=p.RucE and cc.Cd_CC=p.Cd_CC
left join CCSub sc on cc.RucE=p.RucE and cc.Cd_CC=p.Cd_CC and sc.Cd_SC=p.Cd_SC
left join CCSubSub ss on cc.RucE=p.RucE and cc.Cd_CC=p.Cd_CC and sc.Cd_SC=p.Cd_SC and ss.Cd_SS=p.Cd_SS
Group by p.RucE,p.Cd_Psp,p.Ejer,p.NroCta,
	 cc.NCorto,sc.NCorto,ss.NCorto,
	 p.Ene,p.Feb,p.Mar,p.Abr,p.May,p.Jun,p.Jul,p.Ago,p.Sep,p.Oct,p.Nov,p.Dic,p.Ene_ME,p.Feb_ME,p.Mar_ME,p.Abr_ME,p.May_ME,p.Jun_ME,p.Jul_ME,p.Ago_ME,p.Sep_ME,p.Oct_ME,p.Nov_ME,p.Dic_ME



GO

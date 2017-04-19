SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[PresupFCTot]

AS

Select  RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta,'01' As Prdo,Sum(Ene) As Mto,Sum(Ene_ME) As Mto_ME from PresupFC Group by RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta
Union All Select RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta,'02' As Prdo,Sum(Feb) As Mto,Sum(Feb_ME) As Mto_ME from PresupFC Group by RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta
Union All Select RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta,'03' As Prdo,Sum(Mar) As Mto,Sum(Mar_ME) As Mto_ME from PresupFC Group by RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta
Union All Select RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta,'04' As Prdo,Sum(Abr) As Mto,Sum(Abr_ME) As Mto_ME from PresupFC Group by RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta
Union All Select RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta,'05' As Prdo,Sum(May) As Mto,Sum(May_ME) As Mto_ME from PresupFC Group by RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta
Union All Select RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta,'06' As Prdo,Sum(Jun) As Mto,Sum(Jun_ME) As Mto_ME from PresupFC Group by RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta
Union All Select RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta,'07' As Prdo,Sum(Jul) As Mto,Sum(Jul_ME) As Mto_ME from PresupFC Group by RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta
Union All Select RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta,'08' As Prdo,Sum(Ago) As Mto,Sum(Ago_ME) As Mto_ME from PresupFC Group by RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta
Union All Select RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta,'09' As Prdo,Sum(Sep) As Mto,Sum(Sep_ME) As Mto_ME from PresupFC Group by RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta
Union All Select RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta,'10' As Prdo,Sum(Oct) As Mto,Sum(Oct_ME) As Mto_ME from PresupFC Group by RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta
Union All Select RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta,'11' As Prdo,Sum(Nov) As Mto,Sum(Nov_ME) As Mto_ME from PresupFC Group by RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta
Union All Select RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta,'12' As Prdo,Sum(Dic) As Mto,Sum(Dic_ME) As Mto_ME from PresupFC Group by RucE,Cd_PspFC,Ejer,Cd_CC,Cd_SC,Cd_SS,NroCta



-- Leyenda -- 
-- Di : 25/01/2011 <Creacion de la vista>





GO

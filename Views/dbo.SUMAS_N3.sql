SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[SUMAS_N3]
--with encryption
AS

--VISTA
select RucE, Ejer, Cd_Fte, left(NroCta,6) as NroCta,Cd_CC, Cd_SC, Cd_SS,
--sum(case(Prdo) when '00' then MtoD else 0 end ) Debe, sum(case(Prdo) when '00' then MtoH else 0 end ) Haber, 
sum(case(Prdo) when '00' then MtoD else 0 end ) D00, sum(case(Prdo) when '00' then MtoH else 0 end ) H00, 
sum(case(Prdo) when '01' then MtoD else 0 end ) D01, sum(case(Prdo) when '01' then MtoH else 0 end ) H01,
sum(case(Prdo) when '02' then MtoD else 0 end ) D02, sum(case(Prdo) when '02' then MtoH else 0 end ) H02, 
sum(case(Prdo) when '03' then MtoD else 0 end ) D03, sum(case(Prdo) when '03' then MtoH else 0 end ) H03, 
sum(case(Prdo) when '04' then MtoD else 0 end ) D04, sum(case(Prdo) when '04' then MtoH else 0 end ) H04, 
sum(case(Prdo) when '05' then MtoD else 0 end ) D05, sum(case(Prdo) when '05' then MtoH else 0 end ) H05, 
sum(case(Prdo) when '06' then MtoD else 0 end ) D06, sum(case(Prdo) when '06' then MtoH else 0 end ) H06, 
sum(case(Prdo) when '07' then MtoD else 0 end ) D07, sum(case(Prdo) when '07' then MtoH else 0 end ) H07, 
sum(case(Prdo) when '08' then MtoD else 0 end ) D08, sum(case(Prdo) when '08' then MtoH else 0 end ) H08, 
sum(case(Prdo) when '09' then MtoD else 0 end ) D09, sum(case(Prdo) when '09' then MtoH else 0 end ) H09, 
sum(case(Prdo) when '10' then MtoD else 0 end ) D10, sum(case(Prdo) when '10' then MtoH else 0 end ) H10, 
sum(case(Prdo) when '11' then MtoD else 0 end ) D11, sum(case(Prdo) when '11' then MtoH else 0 end ) H11, 
sum(case(Prdo) when '12' then MtoD else 0 end ) D12, sum(case(Prdo) when '12' then MtoH else 0 end ) H12, 
sum(case(Prdo) when '13' then MtoD else 0 end ) D13, sum(case(Prdo) when '13' then MtoH else 0 end ) H13, 
sum(case(Prdo) when '14' then MtoD else 0 end ) D14, sum(case(Prdo) when '14' then MtoH else 0 end ) H14, 
sum(MtoD) TotDeb, sum(MtoH) TotHab

from Voucher where IB_Anulado=0 group by RucE, Ejer, Cd_Fte, left(NroCta,6),Cd_CC, Cd_SC, Cd_SS --order by RucE, NroCta




GO

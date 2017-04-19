SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- View

CREATE VIEW [dbo].[SUMAS]
--with encryption
AS

--VISTA
select RucE, Ejer, Cd_Fte, NroCta, 
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
sum(MtoD) TotDeb, sum(MtoH) TotHab,


sum(case(Prdo) when '00' then MtoD_ME else 0 end ) DME00, sum(case(Prdo) when '00' then MtoH_ME else 0 end ) HME00, 
sum(case(Prdo) when '01' then MtoD_ME else 0 end ) DME01, sum(case(Prdo) when '01' then MtoH_ME else 0 end ) HME01, 
sum(case(Prdo) when '02' then MtoD_ME else 0 end ) DME02, sum(case(Prdo) when '02' then MtoH_ME else 0 end ) HME02, 
sum(case(Prdo) when '03' then MtoD_ME else 0 end ) DME03, sum(case(Prdo) when '03' then MtoH_ME else 0 end ) HME03,
sum(case(Prdo) when '04' then MtoD_ME else 0 end ) DME04, sum(case(Prdo) when '04' then MtoH_ME else 0 end ) HME04, 
sum(case(Prdo) when '05' then MtoD_ME else 0 end ) DME05, sum(case(Prdo) when '05' then MtoH_ME else 0 end ) HME05, 
sum(case(Prdo) when '06' then MtoD_ME else 0 end ) DME06, sum(case(Prdo) when '06' then MtoH_ME else 0 end ) HME06, 
sum(case(Prdo) when '07' then MtoD_ME else 0 end ) DME07, sum(case(Prdo) when '07' then MtoH_ME else 0 end ) HME07, 
sum(case(Prdo) when '08' then MtoD_ME else 0 end ) DME08, sum(case(Prdo) when '08' then MtoH_ME else 0 end ) HME08, 
sum(case(Prdo) when '09' then MtoD_ME else 0 end ) DME09, sum(case(Prdo) when '09' then MtoH_ME else 0 end ) HME09, 
sum(case(Prdo) when '10' then MtoD_ME else 0 end ) DME10, sum(case(Prdo) when '10' then MtoH_ME else 0 end ) HME10, 
sum(case(Prdo) when '11' then MtoD_ME else 0 end ) DME11, sum(case(Prdo) when '11' then MtoH_ME else 0 end ) HME11, 
sum(case(Prdo) when '12' then MtoD_ME else 0 end ) DME12, sum(case(Prdo) when '12' then MtoH_ME else 0 end ) HME12, 
sum(case(Prdo) when '13' then MtoD_ME else 0 end ) DME13, sum(case(Prdo) when '13' then MtoH_ME else 0 end ) HME13,
sum(case(Prdo) when '14' then MtoD_ME else 0 end ) DME14, sum(case(Prdo) when '14' then MtoH_ME else 0 end ) HME14, 
sum(MtoD_ME) TotDeb_ME, sum(MtoH_ME) TotHab_ME

from Voucher group by RucE, Ejer, Cd_Fte, NroCta --order by RucE, NroCta
GO

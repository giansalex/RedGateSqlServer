SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[SaldosXPrdo]
--with encryption
AS


--VISTA
select a.RucE, a.NroCta, b.Nivel,
--sum(case(Prdo) when '00' then MtoD else 0 end ) Debe, sum(case(Prdo) when '00' then MtoH else 0 end ) Haber, 
sum(case(Prdo) when '00' then MtoD-MtoH else 0 end ) Saldo00, 
sum(case(Prdo) when '01' then MtoD-MtoH else 0 end ) Saldo01, 
sum(case(Prdo) when '02' then MtoD-MtoH else 0 end ) Saldo02, 
sum(case(Prdo) when '03' then MtoD-MtoH else 0 end ) Saldo03, 
sum(case(Prdo) when '04' then MtoD-MtoH else 0 end ) Saldo04, 
sum(case(Prdo) when '05' then MtoD-MtoH else 0 end ) Saldo05, 
sum(case(Prdo) when '06' then MtoD-MtoH else 0 end ) Saldo06, 
sum(case(Prdo) when '07' then MtoD-MtoH else 0 end ) Saldo07, 
sum(case(Prdo) when '08' then MtoD-MtoH else 0 end ) Saldo08, 
sum(case(Prdo) when '09' then MtoD-MtoH else 0 end ) Saldo09, 
sum(case(Prdo) when '10' then MtoD-MtoH else 0 end ) Saldo10, 
sum(case(Prdo) when '11' then MtoD-MtoH else 0 end ) Saldo11, 
sum(case(Prdo) when '12' then MtoD-MtoH else 0 end ) Saldo12, 
sum(case(Prdo) when '13' then MtoD-MtoH else 0 end ) Saldo13, 
sum(case(Prdo) when '14' then MtoD-MtoH else 0 end ) Saldo14, 
sum(MtoD-MtoH) Total
from Voucher a  --order by RucE, NroCta
left join PlanCtas b on a.RucE=b.RucE and a.NroCta=b.NroCta
group by a.RucE, a.NroCta, b.Nivel
GO

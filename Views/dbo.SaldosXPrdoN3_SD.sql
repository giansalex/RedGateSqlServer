SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[SaldosXPrdoN3_SD]
--with encryption
AS
--VISTA
select RucE, Ejer, left(NroCta,6) as NroCtaN3,

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
sum(MtoD-MtoH) Total,

-- MONEDA EXTRANJERA
sum(case(Prdo) when '00' then MtoD_ME-MtoH_ME else 0 end ) Saldo_ME00, 
sum(case(Prdo) when '01' then MtoD_ME-MtoH_ME else 0 end ) Saldo_ME01, 
sum(case(Prdo) when '02' then MtoD_ME-MtoH_ME else 0 end ) Saldo_ME02, 
sum(case(Prdo) when '03' then MtoD_ME-MtoH_ME else 0 end ) Saldo_ME03, 
sum(case(Prdo) when '04' then MtoD_ME-MtoH_ME else 0 end ) Saldo_ME04, 
sum(case(Prdo) when '05' then MtoD_ME-MtoH_ME else 0 end ) Saldo_ME05, 
sum(case(Prdo) when '06' then MtoD_ME-MtoH_ME else 0 end ) Saldo_ME06, 
sum(case(Prdo) when '07' then MtoD_ME-MtoH_ME else 0 end ) Saldo_ME07, 
sum(case(Prdo) when '08' then MtoD_ME-MtoH_ME else 0 end ) Saldo_ME08, 
sum(case(Prdo) when '09' then MtoD_ME-MtoH_ME else 0 end ) Saldo_ME09, 
sum(case(Prdo) when '10' then MtoD_ME-MtoH_ME else 0 end ) Saldo_ME10, 
sum(case(Prdo) when '11' then MtoD_ME-MtoH_ME else 0 end ) Saldo_ME11, 
sum(case(Prdo) when '12' then MtoD_ME-MtoH_ME else 0 end ) Saldo_ME12, 
sum(case(Prdo) when '13' then MtoD_ME-MtoH_ME else 0 end ) Saldo_ME13, 
sum(case(Prdo) when '14' then MtoD_ME-MtoH_ME else 0 end ) Saldo_ME14, 
sum(MtoD_ME-MtoH_ME) Total_ME

from Voucher where IB_Anulado=0  group by RucE, Ejer, left(NroCta,6)


GO

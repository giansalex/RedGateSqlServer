SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Tsr_ConcBanCons]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta nvarchar(10),
@Prdo nvarchar(2),
@Cd_Mda nvarchar(2),
@msj varchar(100) output
as
(select
	v.Cd_Vou,v.RegCtb,v.Prdo,Convert(varchar,v.FecMov,103) as FecMov,
	v.TipOper,v.NroChke,v.Grdo,v.Glosa,
	Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end as Debe,
	Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end as Haber,
	v.IB_Conc,
	'' as [SConta],
	'' as [SBanca]
	--case(isnull(v.IB_Conc,0)) when 1 then v.IB_Conc else 0 end IB_Conc
from Voucher v 
where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta=@NroCta and v.Prdo=@Prdo and v.IB_Anulado=0
--Order by year(v.FecMov) asc, month(v.FecMov) asc, day(v.FecMov) asc
UNION ALL
select
	v.Cd_Vou,v.RegCtb,v.Prdo,Convert(varchar,v.FecMov,103) as FecMov,
	v.TipOper,v.NroChke,v.Grdo,v.Glosa,
	Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end as Debe,
	Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end as Haber,
	v.IB_Conc,
	'' as [SConta],
	'' as [SBanca]
	--case(isnull(v.IB_Conc,0)) when 1 then v.IB_Conc else 0 end IB_Conc
from Voucher v 
where v.RucE=@RucE and v.Ejer=@Ejer and v.IB_Anulado=0 and v.NroCta=@NroCta and v.Prdo<@Prdo and isnull(v.IB_Conc,0)<>1)
Order by 3 asc, 4 asc


select
	'1' as Concepto,
	Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
	Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
	Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
from Voucher v 
where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta=@NroCta and v.Prdo<@Prdo and v.IB_Anulado=0
UNION ALL
select
	'2' as Concepto,
	Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
	Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
	Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
from Voucher v 
where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta=@NroCta and v.Prdo=@Prdo and v.IB_Anulado=0
UNION ALL
select
	'3' as Concepto,
	Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
	Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
	Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
from Voucher v 
where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta=@NroCta and v.Prdo<=@Prdo and v.IB_Anulado=0
UNION ALL
select
	'4' as Concepto,
	Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
	Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
	Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
from Voucher v 
where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta=@NroCta and v.Prdo<@Prdo and isnull(v.IB_Conc,0)=0  and v.IB_Anulado=0
UNION ALL
select
	'5' as Concepto,
	Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
	Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
	Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
from Voucher v 
where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta=@NroCta and v.Prdo=@Prdo and isnull(v.IB_Conc,0)=0 and v.IB_Anulado=0
GO

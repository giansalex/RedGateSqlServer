SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Tsr_ConcBanCons2]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta nvarchar(10),
@Prdo nvarchar(2),
@Cd_Mda nvarchar(2),
@msj varchar(100) output

as

/*
Declare @RucE nvarchar(11)
Declare @Ejer nvarchar(4)
Declare @NroCta nvarchar(10)
Declare @Prdo nvarchar(2)
Declare @Cd_Mda nvarchar(2)

Set @RucE = '11111111111'
Set @Ejer = '2010'
Set @NroCta = '10.1.0.01'
Set @Prdo = '01'
Set @Cd_Mda = '01'

*/

/* CONSULTA DE LOS DATOS CONCILIADOS O NO CONCILIADOS*/

select	
	v.Cd_Vou,v.RegCtb,v.Prdo,Convert(varchar,v.FecMov,103) as FecMov,
	v.TipOper,v.NroChke,v.Grdo,v.Glosa,
	Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end as Debe,
	Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end as Haber,
	Case(@Ejer+Convert(varchar,Convert(int,@Prdo))) when Convert(varchar,year(v.FecConc))+Convert(varchar,month(v.FecConc)) then v.IB_Conc else 0 end as IB_Conc,
	Case(@Ejer+Convert(varchar,Convert(int,@Prdo))) when Convert(varchar,year(v.FecConc))+Convert(varchar,month(v.FecConc)) then Convert(varchar,v.FecConc,103) else NULL end as FecConc,
	'' as [SConta],
	'' as [SBanca],
	v.Ejer,
	Case(v.IB_Conc) when 1 then '1' else '0' end as esConc,
	Convert(varchar,v.FecConc,103) as esFConc
from Voucher v 
where v.RucE=@RucE and v.Ejer<=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and v.Prdo not in ('00','13','14') and
	(     (((v.Ejer=@Ejer and v.Prdo<=@Prdo) or v.Ejer<@Ejer) and isnull(v.IB_Conc,0)=0)
	   or (year(v.FecConc)=@Ejer and month(v.FecConc)=convert(int,@Prdo))
	   or (v.Ejer=@Ejer and v.Prdo=@Prdo and month(v.FecConc)>convert(int,@Prdo) and v.IB_Conc=1)
	)
Order by v.Ejer asc, v.Prdo asc

/* PRIMER CUERPO ******************************************************************** */

select	
	'1' as Concepto, -- Todos los movimientos de los meses y años anteriores 
	Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
	Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
	Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
from Voucher v 
where v.RucE=@RucE and Ejer<=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and  v.Prdo not in ('00','13','14') and
	(   (Ejer=@Ejer and Prdo<@Prdo)
	 or (Ejer<@Ejer)
	)
UNION ALL
select	
	'2' as Concepto, -- Todos los movimientos del mes y año actual
	Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
	Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
	Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
from Voucher v 
where v.RucE=@RucE and Ejer=@Ejer and Prdo=@Prdo and v.NroCta=@NroCta and v.IB_Anulado<>1  and v.Prdo not in ('00','13','14')

/* SEGUNDO CUERPO ******************************************************************** */

UNION ALL
select	
	'4' as Concepto, -- Todos las conciliaciones anteriores
	Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
	Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
	Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
from Voucher v 
where v.RucE=@RucE and Ejer<=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and v.IB_Conc=1 and v.Prdo not in ('00','13','14') 
	and 
	( (Ejer=@Ejer and Prdo<@Prdo and month(v.FecConc)<>convert(int,@Prdo)) or (Ejer<@Ejer))
UNION ALL
select	
	'5' as Concepto, -- Todos los conciliados del mes actual
	Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
	Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
	Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
from Voucher v 
where v.RucE=@RucE and v.NroCta=@NroCta and v.IB_Anulado<>1 and v.IB_Conc=1 and v.Prdo not in ('00','13','14') and 
	year(v.FecConc)=@Ejer and month(v.FecConc)=convert(int,@Prdo)


/* TERCER CUERPO ******************************************************************** */


UNION ALL
select	
	'7' as Concepto, -- Todos las pendientes anteriores
	Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
	Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
	Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
from Voucher v 
where v.RucE=@RucE and Ejer<=@Ejer and v.NroCta=@NroCta and isnull(v.IB_Conc,0)=0 and v.IB_Anulado<>1 and  v.Prdo not in ('00','13','14') and
	(   (Ejer=@Ejer and Prdo<@Prdo)
	 or (Ejer<@Ejer)
	)
UNION ALL
select	
	'8' as Concepto, -- Todos los pendientes del mes actual
	Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
	Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
	Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
from Voucher v 
where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and v.Prdo=@Prdo and v.Prdo not in ('00','13','14') 
	and ( (isnull(v.IB_Conc,0)=0)
	 	or (v.Ejer=@Ejer and v.Prdo=@Prdo and month(v.FecConc)>convert(int,@Prdo) and v.IB_Conc=1))



-- Leyenda --

-- DI : 07/05/2010 < Creacion del procedimiento almacenado : la cual reemplazo Tsr_ConcBanCons>
		-- < Se cambio la logica para obtener los resultados>
GO

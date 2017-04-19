SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Tsr_ConcBanCons_Pend_Dep]
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

select	
	v.Cd_Vou,v.RegCtb,v.Prdo,Convert(varchar,v.FecMov,103) as FecMov,
	Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end as Deposito,
	v.TipOper,v.NroChke,v.Grdo,v.Glosa
	--,
	--Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end as Haber,
	--Case(@Ejer+Convert(varchar,Convert(int,@Prdo))) when Convert(varchar,year(v.FecConc))+Convert(varchar,month(v.FecConc)) then v.IB_Conc else 0 end as IB_Conc,
	--Case(@Ejer+Convert(varchar,Convert(int,@Prdo))) when Convert(varchar,year(v.FecConc))+Convert(varchar,month(v.FecConc)) then Convert(varchar,v.FecConc,103) else NULL end as FecConc
	--,
	--'' as [SConta],
	--'' as [SBanca],
	--v.Ejer,
	--Case(v.IB_Conc) when 1 then '1' else '0' end as esConc,
	--Convert(varchar,v.FecConc,103) as esFConc
from Voucher v 
where v.RucE=@RucE and v.Ejer<=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and v.Prdo not in ('00','13','14') and
	(     (((v.Ejer=@Ejer and v.Prdo<=@Prdo) or v.Ejer<@Ejer) and isnull(v.IB_Conc,0)=0) --Pendientes de cancelar
		   --or (year(v.FecConc)=@Ejer and month(v.FecConc)=convert(int,@Prdo))  -- Los Conciliados en este mes
		   --or (v.Ejer=@Ejer and v.Prdo=@Prdo and month(v.FecConc)>convert(int,@Prdo) and v.IB_Conc=1)
  		   --or ( ((v.Ejer=@Ejer and v.Prdo<=@Prdo) or v.Ejer<@Ejer) and ((year(v.FecConc)=@Ejer and month(v.FecConc)>convert(int,@Prdo)) or year(v.FecConc)>@Ejer) and v.IB_Conc=1)  --Los conciliados en un mes y año posterior pero que pertenecen a este periodo
		   or (v.Prdo=@Prdo and v.IB_Conc=1 and v.FecConc is null) -- Los que estan conciliados pero no tienen FecConc (esto es xq se conciliaron antes de que se agregue este campo o xq estan usando un ejecutable muy antiguo)
	)
	and v.MtoD>0
Order by v.Ejer asc, v.Prdo asc


-- Leyenda --

-- DI : 12/05/2010 < Creacion del procedimiento almacenado>
GO

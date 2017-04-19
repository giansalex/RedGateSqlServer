SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Tsr_ConcBanCons4]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta nvarchar(10),
@Prdo nvarchar(2),
@Cd_Mda nvarchar(2),
@SinIni bit, --> Variable que nos indica que debe contar con el periodo inicial
@msj varchar(100) output

as

/*
Declare @RucE nvarchar(11)
Declare @Ejer nvarchar(4)
Declare @NroCta nvarchar(10)
Declare @Prdo nvarchar(2)
Declare @Cd_Mda nvarchar(2)
Declare @SinIni bit Set @SinIni=0

Set @RucE = '20100977037'
Set @Ejer = '2011'
Set @NroCta = '10.4.1.12'
Set @Prdo = '12'
Set @Cd_Mda = '01'
*/

/* CONSULTA DE LOS DATOS CONCILIADOS O NO CONCILIADOS*/

if(@SinIni = 1)	--> Con periodo inicial
begin
	select	
		v.Cd_Vou,v.RegCtb,v.Prdo,Convert(varchar,v.FecMov,103) as FecMov,
		v.TipOper,v.NroChke,v.Grdo,v.Glosa,
		Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end as Debe,
		Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end as Haber,
		Case(@Ejer+Convert(varchar,Convert(int,@Prdo))) when Convert(varchar,year(v.FecConc))+Convert(varchar,month(v.FecConc)) then Convert(bit,v.IB_Conc) else Convert(bit,0) end as IB_Conc,
		--isnull(v.IB_Conc,0) as IB_Conc, VER: DA ERROR
		--Case(@Ejer+Convert(varchar,Convert(int,@Prdo))) when Convert(varchar,year(v.FecConc))+Convert(varchar,month(v.FecConc)) then Convert(varchar,v.FecConc,103) else NULL end as FecConc,
		case(isnull(v.FecConc,0)) when 0 then   case(isnull(Convert(bit,v.IB_Conc),Convert(bit,0))) when 0 then NULL else 'Conciliado / Sin Fec.' end   else Convert(varchar,v.FecConc,103) end as FecConc,
		'' as [SConta],
		'' as [SBanca],
		v.Ejer,
		Case(v.IB_Conc) when 1 then '1' else '0' end as esConc,
		Convert(varchar,v.FecConc,103) as esFConc
	from Voucher v 
	where v.RucE=@RucE and v.Ejer<=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and v.Prdo not in ('00','13','14') and
		(     (((v.Ejer=@Ejer and v.Prdo<=@Prdo) or v.Ejer<@Ejer) and isnull(v.IB_Conc,0)=0) --Pendientes de cancelar
		   or (year(v.FecConc)=@Ejer and month(v.FecConc)=convert(int,@Prdo))  -- Los Conciliados en este mes
		   --or (v.Ejer=@Ejer and v.Prdo=@Prdo and month(v.FecConc)>convert(int,@Prdo) and v.IB_Conc=1)
  		   or ( ((v.Ejer=@Ejer and v.Prdo<=@Prdo) or v.Ejer<@Ejer) and ((year(v.FecConc)=@Ejer and month(v.FecConc)>convert(int,@Prdo)) or year(v.FecConc)>@Ejer) and v.IB_Conc=1)  --Los conciliados en un mes y año posterior pero que pertenecen a este periodo
		   or (v.Prdo=@Prdo and v.IB_Conc=1 and v.FecConc is null) -- Los que estan conciliados pero no tienen FecConc (esto es xq se conciliaron antes de que se agregue este campo o xq estan usando un ejecutable muy antiguo)
		)
	Order by v.Ejer asc, v.RegCtb asc
	
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
		( (Ejer=@Ejer and Prdo<@Prdo and month(v.FecConc)<convert(int,@Prdo)) or (Ejer<@Ejer))
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
		where v.RucE=@RucE and Ejer<=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and  v.Prdo not in ('13','14')
		and ((isnull(v.IB_Conc,0)=0 and ((Ejer=@Ejer and Prdo<@Prdo) or (Ejer<@Ejer))) or (isnull(v.IB_Conc,0)=1 and Ejer=@Ejer and Prdo<@Prdo and ((year(v.FecConc)=@Ejer and month(v.FecConc)>convert(int,@Prdo)) or (year(v.FecConc)>@Ejer))))
		
	UNION ALL
	select	
		'8' as Concepto, -- Todos los pendientes del mes actual
		Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
		Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
		Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
	from Voucher v 
	where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and v.Prdo=@Prdo and v.Prdo not in ('00','13','14') 
		and ( (isnull(v.IB_Conc,0)=0)
		    or (v.Ejer=@Ejer and v.Prdo=@Prdo and year(v.FecConc)>convert(int,v.Ejer) and v.IB_Conc=1)
		 	or (v.Ejer=@Ejer and v.Prdo=@Prdo and year(v.FecConc)=convert(int,v.Ejer) and month(v.FecConc)>convert(int,v.Prdo) and v.IB_Conc=1))
end
--> ***********************************************************************************
else --> Sin periodo inicial ***********************************************************************************
--> ***********************************************************************************
begin 

select	
		v.Cd_Vou,v.RegCtb,v.Prdo,Convert(varchar,v.FecMov,103) as FecMov,
		v.TipOper,v.NroChke,v.Grdo,v.Glosa,
		Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end as Debe,
		Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end as Haber,
		Case(@Ejer+Convert(varchar,Convert(int,@Prdo))) when Convert(varchar,year(v.FecConc))+Convert(varchar,month(v.FecConc)) then Convert(bit,v.IB_Conc) else Convert(bit,0) end as IB_Conc,
		--Case(@Ejer+Convert(varchar,Convert(int,@Prdo))) when Convert(varchar,year(v.FecConc))+Convert(varchar,month(v.FecConc)) then Convert(varchar,v.FecConc,103) else NULL end as FecConc,
		case(isnull(v.FecConc,0)) when 0 then   case(isnull(v.IB_Conc,0)) when 0 then NULL else 'Conciliado / Sin Fec.' end   else Convert(varchar,v.FecConc,103) end as FecConc,
		'' as [SConta],
		'' as [SBanca],
		v.Ejer,
		Case(v.IB_Conc) when 1 then '1' else '0' end as esConc,
		Convert(varchar,v.FecConc,103) as esFConc
	from Voucher v 
	where v.RucE=@RucE and v.Ejer<=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and v.Prdo not in ('13','14') and
		(     (((v.Ejer=@Ejer and v.Prdo<=@Prdo) or v.Ejer<@Ejer) and isnull(v.IB_Conc,0)=0) --Pendientes de cancelar
		   or (year(v.FecConc)=@Ejer and month(v.FecConc)=convert(int,@Prdo)) -- Los Conciliados en este mes
		   --or (v.Ejer=@Ejer and v.Prdo=@Prdo and month(v.FecConc)>convert(int,@Prdo) and v.IB_Conc=1)
		   or ( ((v.Ejer=@Ejer and v.Prdo<=@Prdo) or v.Ejer<@Ejer) and ((year(v.FecConc)=@Ejer and month(v.FecConc)>convert(int,@Prdo)) or year(v.FecConc)>@Ejer) and v.IB_Conc=1)  --Los conciliados en un mes y año posterior pero que pertenecen a este periodo
		   or (v.Prdo=@Prdo and v.IB_Conc=1 and v.FecConc is null) -- Los que estan conciliados pero no tienen FecConc (esto es xq se conciliaron antes de que se agregue este campo o xq estan usando un ejecutable muy antiguo)
		)
		--and year(v.FecMov)>=@Ejer
		and Case When @RucE in ('20100977037','20516086239') Then year(v.FecMov) Else 0 End >= Case When @RucE in ('20100977037','20516086239') Then @Ejer Else 0 End
	Order by v.Ejer asc, v.RegCtb asc
	
	/* PRIMER CUERPO ******************************************************************** */
	
	select	
		'1' as Concepto, -- Todos los movimientos de los meses y años anteriores 
		Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
		Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
		Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
	from Voucher v 
	where v.RucE=@RucE and Ejer<=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and  v.Prdo not in ('13','14') and
		(   (Ejer=@Ejer and Prdo<@Prdo)
		 or (Ejer<@Ejer)
		)
		--and year(v.FecMov)>=@Ejer
		and Case When @RucE in ('20100977037','20516086239') Then year(v.FecMov) Else 0 End >= Case When @RucE in ('20100977037','20516086239') Then @Ejer Else 0 End
	UNION ALL
	select	
		'2' as Concepto, -- Todos los movimientos del mes y año actual
		Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
		Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
		Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
	from Voucher v 
	where v.RucE=@RucE and Ejer=@Ejer and Prdo=@Prdo and v.NroCta=@NroCta and v.IB_Anulado<>1  and v.Prdo not in ('13','14')
		--and year(v.FecMov)>=@Ejer
		and Case When @RucE in ('20100977037','20516086239') Then year(v.FecMov) Else 0 End >= Case When @RucE in ('20100977037','20516086239') Then @Ejer Else 0 End
	
	/* SEGUNDO CUERPO ******************************************************************** */
	
	UNION ALL
	select	
		'4' as Concepto, -- Todos las conciliaciones anteriores
		Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
		Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
		Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
	from Voucher v 
	where v.RucE=@RucE and Ejer<=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and v.IB_Conc=1 and v.Prdo not in ('13','14') 
		and 
		( (Ejer=@Ejer and Prdo<@Prdo and month(v.FecConc)<convert(int,@Prdo)) or (Ejer<@Ejer))
		--and year(v.FecMov)>=@Ejer
		and Case When @RucE in ('20100977037','20516086239') Then year(v.FecMov) Else 0 End >= Case When @RucE in ('20100977037','20516086239') Then @Ejer Else 0 End
	UNION ALL
	select	
		'5' as Concepto, -- Todos los conciliados del mes actual
		Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
		Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
		Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
	from Voucher v 
	where v.RucE=@RucE and v.NroCta=@NroCta and v.IB_Anulado<>1 and v.IB_Conc=1 and v.Prdo not in ('13','14') and 
		year(v.FecConc)=@Ejer and month(v.FecConc)=convert(int,@Prdo)
		--and year(v.FecMov)>=@Ejer
		and Case When @RucE in ('20100977037','20516086239') Then year(v.FecMov) Else 0 End >= Case When @RucE in ('20100977037','20516086239') Then @Ejer Else 0 End
	
	/* TERCER CUERPO ******************************************************************** */
	
	
	UNION ALL
	select	
		'7' as Concepto, -- Todos las pendientes anteriores
		Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
		Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
		Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
	from Voucher v 
	where v.RucE=@RucE and Ejer<=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and  v.Prdo not in ('13','14')
		and ((isnull(v.IB_Conc,0)=0 and ((Ejer=@Ejer and Prdo<@Prdo) or (Ejer<@Ejer))) or (isnull(v.IB_Conc,0)=1 and Ejer=@Ejer and Prdo<@Prdo and ((year(v.FecConc)=@Ejer and month(v.FecConc)>convert(int,@Prdo)) or (year(v.FecConc)>@Ejer))))
		--and year(v.FecMov)>=@Ejer
		and Case When @RucE in ('20100977037','20516086239') Then year(v.FecMov) Else 0 End >= Case When @RucE in ('20100977037','20516086239') Then @Ejer Else 0 End
	UNION ALL
	select	
		'8' as Concepto, -- Todos los pendientes del mes actual
		Sum(Case(@Cd_Mda) when '01' then v.MtoD else v.MtoD_ME end) as Debe,
		Sum(Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end) as Haber,
		Sum(Case(@Cd_Mda) when '01' then v.MtoD-v.MtoH else v.MtoD_ME-v.MtoH_ME end) as Saldo
	from Voucher v 
	where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and v.Prdo=@Prdo and v.Prdo not in ('13','14') 
		and ( (isnull(v.IB_Conc,0)=0)
		    or (v.Ejer=@Ejer and v.Prdo=@Prdo and year(v.FecConc)>convert(int,v.Ejer) and v.IB_Conc=1)
		 	or (v.Ejer=@Ejer and v.Prdo=@Prdo and year(v.FecConc)=convert(int,v.Ejer) and month(v.FecConc)>convert(int,v.Prdo) and v.IB_Conc=1))
		--and year(v.FecMov)>=@Ejer
		and Case When @RucE in ('20100977037','20516086239') Then year(v.FecMov) Else 0 End >= Case When @RucE in ('20100977037','20516086239') Then @Ejer Else 0 End
end


--Pruebas:
/*
select * from Empresa where RSocial like '%bafur%'
exec Tsr_ConcBanCons3 '20100977037','2010','10.4.0.10','06','01',0,null
*/


-- Leyenda --

-- DI : 07/05/2010 < Creacion del procedimiento almacenado : la cual reemplazo Tsr_ConcBanCons>
		-- < Se cambio la logica para obtener los resultados >
-- DI : 13/06/2010 < Creacion del procedimiento almacenado : la cual reemplazo Tsr_ConcBanCons2>
		-- < Se agrego el campo si contiene periodo inicial >
-- PV: 19/10/2010 Mdf: se agrego "or (v.Prdo=@Prdo and v.IB_Conc=1 and v.FecConc is null)" y comentario "'Conciliado / Sin Fec.'"

-- DI : 08/01/2011 <Se agrego modifico la condicion > "   or ( ((v.Ejer=@Ejer and v.Prdo<=@Prdo) or v.Ejer<@Ejer) and ((year(v.FecConc)=@Ejer and month(v.FecConc)>convert(int,@Prdo)) or year(v.FecConc)>@Ejer) and v.IB_Conc=1)"

-- DI : 12/04/2012 <Se agrego condicion año>

GO

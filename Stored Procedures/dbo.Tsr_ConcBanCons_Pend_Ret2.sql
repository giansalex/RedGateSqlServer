SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Tsr_ConcBanCons_Pend_Ret2]
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

Set @RucE = '11111111111'
Set @Ejer = '2010'
Set @NroCta = '10.1.0.01'
Set @Prdo = '01'
Set @Cd_Mda = '01'

*/

if(@SinIni = 0)
Begin
	select	
		v.Cd_Vou,v.RegCtb,v.Prdo,Convert(varchar,v.FecMov,103) as FecMov,
		Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end as Retiro,
		v.TipOper,v.NroChke,v.Grdo,v.Glosa
	From 
		Voucher v
	where 
		/*
		v.RucE=@RucE and v.Ejer<=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and v.Prdo not in ('13','14') and
		(     (((v.Ejer=@Ejer and v.Prdo<=@Prdo) or v.Ejer<@Ejer) and isnull(v.IB_Conc,0)=0) --Pendientes de cancelar
			   --or (year(v.FecConc)=@Ejer and month(v.FecConc)=convert(int,@Prdo))  -- Los Conciliados en este mes
			   --or (v.Ejer=@Ejer and v.Prdo=@Prdo and month(v.FecConc)>convert(int,@Prdo) and v.IB_Conc=1)
  			   --or ( ((v.Ejer=@Ejer and v.Prdo<=@Prdo) or v.Ejer<@Ejer) and ((year(v.FecConc)=@Ejer and month(v.FecConc)>convert(int,@Prdo)) or year(v.FecConc)>@Ejer) and v.IB_Conc=1)  --Los conciliados en un mes y año posterior pero que pertenecen a este periodo
			   or (v.Prdo=@Prdo and v.IB_Conc=1 and v.FecConc is null) -- Los que estan conciliados pero no tienen FecConc (esto es xq se conciliaron antes de que se agregue este campo o xq estan usando un ejecutable muy antiguo)
		)
		and v.MtoH>0
		*/
		v.RucE=@RucE 
			and Ejer<=@Ejer 
			and v.NroCta=@NroCta 
			and v.IB_Anulado<>1 
			and  v.Prdo not in ('13','14')
			and 
			(	(
				(
					isnull(v.IB_Conc,0)=0 
					and 
					(
						(Ejer=@Ejer and Prdo<@Prdo) 
						or 
						(Ejer<@Ejer)
					)
				) 
				or 
				(	
					isnull(v.IB_Conc,0)=1 
					and 
					Ejer=@Ejer 
					and 
					Prdo<@Prdo 
					and 
					(	
						(
							year(v.FecConc)=@Ejer 
							and 
							month(v.FecConc)>convert(int,@Prdo)
						) 
						or 
						(
							year(v.FecConc)>@Ejer
						)
					)
				)
				)
				or
				((isnull(v.IB_Conc,0)=0) or (v.Ejer=@Ejer and v.Prdo=@Prdo and month(v.FecConc)>convert(int,@Prdo) and v.IB_Conc=1))
			)
			--and year(v.FecMov)>=@Ejer
			and Case When @RucE in ('20100977037','20516086239') Then year(v.FecMov) Else 0 End >= Case When @RucE in ('20100977037','20516086239') Then @Ejer Else 0 End
	Order by v.Ejer asc, v.Prdo asc
End
Else
Begin
	select	
		v.Cd_Vou,v.RegCtb,v.Prdo,Convert(varchar,v.FecMov,103) as FecMov,
		Case(@Cd_Mda) when '01' then v.MtoH else v.MtoH_ME end as Retiro,
		v.TipOper,v.NroChke,v.Grdo,v.Glosa
	From 
		Voucher v
	where 
		/*
		v.RucE=@RucE and v.Ejer<=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and v.Prdo not in ('13','14') and
		(     (((v.Ejer=@Ejer and v.Prdo<=@Prdo) or v.Ejer<@Ejer) and isnull(v.IB_Conc,0)=0) --Pendientes de cancelar
			   --or (year(v.FecConc)=@Ejer and month(v.FecConc)=convert(int,@Prdo))  -- Los Conciliados en este mes
			   --or (v.Ejer=@Ejer and v.Prdo=@Prdo and month(v.FecConc)>convert(int,@Prdo) and v.IB_Conc=1)
  			   --or ( ((v.Ejer=@Ejer and v.Prdo<=@Prdo) or v.Ejer<@Ejer) and ((year(v.FecConc)=@Ejer and month(v.FecConc)>convert(int,@Prdo)) or year(v.FecConc)>@Ejer) and v.IB_Conc=1)  --Los conciliados en un mes y año posterior pero que pertenecen a este periodo
			   or (v.Prdo=@Prdo and v.IB_Conc=1 and v.FecConc is null) -- Los que estan conciliados pero no tienen FecConc (esto es xq se conciliaron antes de que se agregue este campo o xq estan usando un ejecutable muy antiguo)
		)
		and v.MtoH>0
		*/
		v.RucE=@RucE 
			and Ejer<=@Ejer 
			and v.NroCta=@NroCta 
			and v.IB_Anulado<>1 
			and  v.Prdo not in ('00','13','14')
			and 
			(	(
				(
					isnull(v.IB_Conc,0)=0 
					and 
					(
						(Ejer=@Ejer and Prdo<@Prdo) 
						or 
						(Ejer<@Ejer)
					)
				) 
				or 
				(	
					isnull(v.IB_Conc,0)=1 
					and 
					Ejer=@Ejer 
					and 
					Prdo<@Prdo 
					and 
					(	
						(
							year(v.FecConc)=@Ejer 
							and 
							month(v.FecConc)>convert(int,@Prdo)
						) 
						or 
						(
							year(v.FecConc)>@Ejer
						)
					)
				)
				)
				or
				((isnull(v.IB_Conc,0)=0) or (v.Ejer=@Ejer and v.Prdo=@Prdo and month(v.FecConc)>convert(int,@Prdo) and v.IB_Conc=1))
			)
	Order by v.Ejer asc, v.Prdo asc
End

-- Leyenda --
-- exec [Tsr_ConcBanCons_Pend_Ret2] '20100977037','2011','10.4.1.11','11','1','01',null
-- DI : 17/11/2011 < Creacion del procedimiento almacenado>
GO

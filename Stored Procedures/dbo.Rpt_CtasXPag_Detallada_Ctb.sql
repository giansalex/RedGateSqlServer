SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXPag_Detallada_Ctb]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@FechaIni smalldatetime,
@FechaFin smalldatetime,
@Cd_Mda nvarchar(2),
@IB_VerSaldados bit
as

declare @VarNum decimal(8,5)
set @VarNum = 0.00
if @IB_VerSaldados = 1
begin
	set @VarNum = 937.67676 -- cual numero que tenga mas de 2 decimales
end
--Grilla 1
	
select 	RucC,
	Max(RSocial) RSocial,
	Sum(Debe1) Debe,
	Sum(Haber1) Haber,
	Sum(Saldo1) Saldo,
	Sum(Vencido) Vencido,
	Sum(Hasta30) Hasta30,
	Sum(Hasta60) Hasta60,
	Sum(Hasta90) Hasta90,
	Sum(Amas) Amas
from
	(select 	
	Max(RucC) RucC,
	Max(RSocial) RSocial,
	RegCtb,
	Max(NDoc) NDoc,
	Max(FecED) FecED,
	Max(FecVD) FecVD,
	Sum(Debe) Debe1,
	Sum(Haber) Haber1,
	Sum(Saldo) Saldo1,
	Sum(Vencido) Vencido,
	Sum(Hasta30) Hasta30,
	Sum(Hasta60) Hasta60,
	Sum(Hasta90) Hasta90,
	Sum(Amas) Amas
from	
	(Select	
		COALESCE(IsNull(Max(c.NDoc),Max(pr.NDoc)),'---Sin Informacion---') as RucC,
		case(isnull(len(Max(v.Cd_Clt)),0)) when 0 then case(isnull(len(Max(v.Cd_Prv)),0)) when 0 then null
		else case(isnull(len(Max(pr.RSocial)),0)) when 0 then isnull(nullif(Max(pr.ApPat) +' '+Max(pr.ApMat)+' '+Max(pr.Nom),''),'------- SIN NOMBRE ------') else Max(pr.RSocial)  end  
		end else case(isnull(len(Max(c.RSocial)),0)) when 0 then isnull(nullif(Max(c.ApPat) +' '+Max(c.ApMat)+' '+Max(c.Nom),''),'------- SIN NOMBRE ------') else Max(c.RSocial) end 
		end as RSocial,
		v.RegCtb,
		Max(v.Cd_TD) +'-'+Max(v.NroSre)+'-'+Max(v.NroDoc) as NDoc,
		Max(v.FecED) FecED,
		Max(v.FecVD) FecVD,
		case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
		case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
		DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) as Dias,
		case when DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) <=0 then  sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)- sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) else 0.00 end as Vencido,
		case when DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) > 0 and DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) <=30 then  sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)- sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) else 0.00 end as Hasta30,
		case when DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) > 30 and DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) <=60 then  sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)- sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) else 0.00 end as Hasta60,
		case when DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) > 60 and DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) <=90 then  sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)- sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) else 0.00 end as Hasta90,
		case when DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) > 90 then  sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)- sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) else 0.00 end as Amas
	from 	voucher as v
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt --<<-- Nueva Linea
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
	where 
		v.RucE=@RucE and v.Ejer=@Ejer and  
		convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and convert(varchar,@FechaFin,102) 
		and p.IB_CtasXPag=1 and v.IB_Anulado<>'1' 
	group by 
		c.NDoc,
		pr.NDoc,
		v.RegCtb
	having 	
		sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) - sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) + @VarNum <> 0
	) as Con
	Group by RegCtb
) as Con group by RucC
	 Order by RucC desc
	 
--Grilla 2 
select 	
	Max(RucC) RucC,
	RegCtb,
	Max(NDoc) NDoc,
	Max(FecED) FecED,
	Max(FecVD) FecVD,
	Sum(Debe) Debe1,
	Sum(Haber) Haber1,
	Sum(Saldo) Saldo1,
	Sum(Vencido) Vencido,
	Sum(Hasta30) Hasta30,
	Sum(Hasta60) Hasta60,
	Sum(Hasta90) Hasta90,
	Sum(Amas) Amas
from	
	(Select	
		COALESCE(IsNull(Max(c.NDoc),Max(pr.NDoc)),'---Sin Informacion---') as RucC,
		v.RegCtb,
		Max(v.Cd_TD) +'-'+Max(v.NroSre)+'-'+Max(v.NroDoc) as NDoc,
		Max(v.FecED) FecED,
		Max(v.FecVD) FecVD,
		case(@Cd_Mda) when '01' then sum(v.MtoD) else sum(v.MtoD_ME) end as Debe, 
		case(@Cd_Mda) when '01' then sum(v.MtoH) else sum(v.MtoH_ME) end as Haber,
		sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
		DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) as Dias,
		case when DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) <=0 then  sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)- sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) else 0.00 end as Vencido,
		case when DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) > 0 and DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) <=30 then  sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)- sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) else 0.00 end as Hasta30,
		case when DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) > 30 and DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) <=60 then  sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)- sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) else 0.00 end as Hasta60,
		case when DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) > 60 and DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) <=90 then  sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)- sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) else 0.00 end as Hasta90,
		case when DateDiff(Day,Convert(Nvarchar,Max(v.FecED),103),@FechaFin) > 90 then  sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)- sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) else 0.00 end as Amas
	from 	voucher as v
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt --<<-- Nueva Linea
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
	where 
		v.RucE=@RucE and v.Ejer=@Ejer and  
		convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and convert(varchar,@FechaFin,102)
		and p.IB_CtasXPag=1 and v.IB_Anulado<>'1'
	group by 
		c.NDoc,
		pr.NDoc,
		v.RegCtb
	having 	
		sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) - sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) + @VarNum <> 0
	) as Con
	Group by RegCtb
	Order by RucC desc




--JJ:  JUE 07/04/2011 -- Creacion del sp
--exec dbo.Rpt_CtasXCbr_Detallada_Ctb '11111111111','2010','01/12/2010','31/12/2010','01',1
--exec dbo.Rpt_CtasXCbr_Detallada_Ctb '11111111111','2010','01/03/2010','31/05/2010','01',0




GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[Rpt_CtasXPag_Detallada]
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


--Grilla 1 --

select 	
	RucC,
	Max(RSocial) RSocial,
	Sum(Debe) Debe,
	Sum(Haber) Haber, 
	Sum(Saldo) Saldo,
	Sum(Vencido) Vencido, 
	Sum(Hasta30) Hasta30,
	Sum(Hasta60) Hasta60,
	Sum(Hasta90) Hasta90,
	Sum(Amas) Amas
 from (
	select RucC,RSocial,RegCtb,NDoc,FecED,FecVD,Debe,Haber,Saldo,Dias,Vencido,Hasta30,Hasta60,Hasta90,Amas
	from (
		select 
			Case(Isnull(Len(Max(p.NDoc)),0)) when 0 then 'Sin Informacion' else Max(p.NDoc) end as RucC,
			Case(Isnull(Len(Max(p.NDoc)),0)) when 0 then 'Sin Informacion' else Case(isnull(len(Max(p.RSocial)),0)) when 0 then isnull(Max(p.ApPat),'')+' '+isnull(Max(p.ApMat),'')+' '+isnull(Max(p.Nom),'') else Max(p.RSocial) end end as RSocial,
			con.RegCtb,
			Max(con.NDoc) NDoc,
			Max(con.FecED) FecED,
			Max(con.FecVD) FecVD,
			Sum(con.Debe) Debe,
			Sum(con.Haber) Haber,
			Sum(con.Saldo) Saldo,
			Max(Con.Dias) Dias,
			Sum(con.Vencido) Vencido,
			Sum(con.HASTA30) Hasta30,
			Sum(con.Hasta60) Hasta60,
			Sum(con.Hasta90) Hasta90,
			Sum(con.AMAS) AMAS
		from (
			select 
				r.RucE, 
				r.Ejer, 
				r.RegCtb, 
				Convert(nvarchar,Max(r.FecED),103) FecED,
				Convert(nvarchar,Max(r.FecVD),103) FecVD,
				Convert(nvarchar,r.FecMov,103) FecMov,
				r.NroCta,
				case(isnull(len(r.Cd_Prv),0)) when 0 then '---Sin Informacion---' else r.Cd_Prv end as Cd_Clt,

				isnull(r.Cd_TD,'')+'-'+isnull(r.NroSre,'')+'-'+isnull(r.NroDoc,'') NDoc,
				r.Monto As Debe,
				isnull(Sum(v.Monto), 0.00) As Haber,
				r.Monto+isnull(Sum(v.Monto),0.00) As Saldo,
				Max(r.Dias) Dias,
				case when Max(r.Dias) <= 0 then r.Monto else '0.00' end as Vencido,
				case when Max(r.Dias) > 0 and Max(r.Dias) <= 30  then r.Monto else '0.00' end as HASTA30,
				case when Max(r.Dias) > 30 and Max(r.Dias) <= 60  then r.Monto else '0.00' end as HASTA60,
				case when Max(r.Dias) > 60 and Max(r.Dias) <= 90  then r.Monto else '0.00' end as HASTA90,
				case when Max(r.Dias) > 90 then r.Monto else '0.00' end as AMAS
			from (
				select v.*,
					DATEDIFF(day, convert(nvarchar,FecED,103),@FechaFin) as Dias
				from 
					Vou_CtasXPag v 
					left join PlanCtas p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
				Where 
					v.RucE=@RucE and 
					v.Ejer=@Ejer and 
					v.Cd_Fte='RC' and 
					p.IB_CtasXPag=1 and
					Isnull(v.IB_Anulado,0)=0 and
					v.FecMov between Convert(datetime,@FechaIni) and Convert(datetime,@FechaFin)
			) as r
			left join (
				select	
					v.*
				from 
					Vou_CtasXPag v 
					left join PlanCtas p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
				Where 
					v.RucE=@RucE and 
					v.Ejer=@Ejer and 
					v.Cd_Fte='CB' and 
					p.IB_CtasXPag=1 and
					--NroCta like '12%' and 
					Isnull(v.IB_Anulado,0)=0 and
					v.FecMov between Convert(datetime,@FechaIni) and Convert(datetime,@FechaFin)
			) as v
			  on v.RucE=r.RucE and v.Ejer=r.Ejer and v.NroCta=r.NroCta and v.Cd_Prv=r.Cd_Prv and v.Cd_TD=r.Cd_TD and v.NroSre=r.NroSre and v.NroDoc=r.NroDoc and isnull(v.IB_Anulado,0)=0
			where
				r.RucE=@RucE 
				and r.Ejer=@Ejer
				and r.FecMov between Convert(datetime,@FechaIni) and Convert(datetime,@FechaFin)
			Group by 
				r.RucE,
				r.Ejer,
				r.RegCtb,
				r.FecMov,
				r.NroCta,
				r.Cd_Prv,
				r.Cd_TD,
				r.NroSre,
				r.NroDoc,
				r.Monto
			Having 
				r.Monto+isnull(Sum(v.Monto),0.00)+ @VarNum<>0
		) as Con left join Proveedor2 p on p.RucE=con.RucE and p.Cd_Prv=con.Cd_Clt
		group by con.RegCtb
		union all
	select  
		Max(RucC) RucC,
		Max(RSocial) RSocial,
		RegCtb,
		Max(NDoc) NDoc,
		Max(FecMov) FecED, 
		'' FecVD,
		Sum(Debe) Debe, 
		Sum(Haber) Haber,
		Sum(Saldo) Saldo,
		Max(Dias) Dias,
		Sum(Saldo) Vencido,
		0.00 HASTA30,
		0.00 HASTA60,
		0.00 HASTA90,
		0.00 AMAS
	from (
		select 	
			v.RucE, 
			v.Ejer, 
			v.RegCtb,
			v.Cd_Prv,
			Convert(nvarchar,v.FecMov,103) FecMov,
			Case(Isnull(Len(c.NDoc),0)) when 0 then 'Sin Informacion' else c.NDoc end as RucC,
			Case(Isnull(Len(C.NDoc),0)) when 0 then 'Sin Informacion' else Case(isnull(len(c.RSocial),0)) when 0 then isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'') else c.RSocial end end as RSocial,
			isnull(v.Cd_TD,'') +'-'+isnull(v.NroSre,'')+'-'+isnull(v.NroDoc,'') NDoc,
			Total Debe,
			0.00 Haber, 
			Total Saldo,
			-200 dias
		from 	
			Compra v 
			left join Proveedor2 c on c.RucE=v.RucE and c.Cd_Prv=v.Cd_Prv	
		where 	v.RucE=@RucE and 
			v.Ejer=@Ejer and 
			v.IB_Anulado=0 and 
			v.FecMov between Convert(datetime,@FechaIni) and Convert(datetime,@FechaFin) and
			v.RegCtb not in
			(Select 
				RegCtb 
			 from 
				Voucher
			 Where 
				RucE=@RucE and 
				Ejer=@Ejer and 
				Cd_Fte='RC' and 
				--NroCta like '12%' and 
				RegCtb like 'CP%' and 
				FecMov between Convert(datetime,@FechaIni) and Convert(datetime,@FechaFin) and 
				IB_ANULADO=0
			)
		) as Con1 group by RegCtb
	) as Con2 ) as Con3 
	group by RucC
	order by RucC desc


-- Grilla 2 --


select RucC,RSocial,RegCtb,NDoc,FecED,FecVD,Debe,Haber,Saldo,Dias,Vencido,Hasta30,Hasta60,Hasta90,Amas
	from (
		select 
			Case(Isnull(Len(Max(p.NDoc)),0)) when 0 then 'Sin Informacion' else Max(p.NDoc) end as RucC,
			Case(Isnull(Len(Max(p.NDoc)),0)) when 0 then 'Sin Informacion' else Case(isnull(len(Max(p.RSocial)),0)) when 0 then isnull(Max(p.ApPat),'')+' '+isnull(Max(p.ApMat),'')+' '+isnull(Max(p.Nom),'') else Max(p.RSocial) end end as RSocial,
			con.RegCtb,
			Max(con.NDoc) NDoc,
			Max(con.FecED) FecED,
			Max(con.FecVD) FecVD,
			Sum(con.Debe) Debe,
			Sum(con.Haber) Haber,
			Sum(con.Saldo) Saldo,
			Max(Con.Dias) Dias,
			Sum(con.Vencido) Vencido,
			Sum(con.HASTA30) Hasta30,
			Sum(con.Hasta60) Hasta60,
			Sum(con.Hasta90) Hasta90,
			Sum(con.AMAS) AMAS
		from (
			select 
				r.RucE, 
				r.Ejer, 
				r.RegCtb, 
				Convert(nvarchar,Max(r.FecED),103) FecED,
				Convert(nvarchar,Max(r.FecVD),103) FecVD,
				Convert(nvarchar,r.FecMov,103) FecMov,
				r.NroCta,
				case(isnull(len(r.Cd_Prv),0)) when 0 then '---Sin Informacion---' else r.Cd_Prv end as Cd_Clt,

				isnull(r.Cd_TD,'')+'-'+isnull(r.NroSre,'')+'-'+isnull(r.NroDoc,'') NDoc,
				r.Monto As Debe,
				isnull(Sum(v.Monto), 0.00) As Haber,
				r.Monto+isnull(Sum(v.Monto),0.00) As Saldo,
				Max(r.Dias) Dias,
				case when Max(r.Dias) <= 0 then r.Monto else '0.00' end as Vencido,
				case when Max(r.Dias) > 0 and Max(r.Dias) <= 30  then r.Monto else '0.00' end as HASTA30,
				case when Max(r.Dias) > 30 and Max(r.Dias) <= 60  then r.Monto else '0.00' end as HASTA60,
				case when Max(r.Dias) > 60 and Max(r.Dias) <= 90  then r.Monto else '0.00' end as HASTA90,
				case when Max(r.Dias) > 90 then r.Monto else '0.00' end as AMAS
			from (
				select v.*,
					DATEDIFF(day, convert(nvarchar,FecED,103),@FechaFin) as Dias
				from 
					Vou_CtasXPag v 
					left join PlanCtas p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
				Where 
					v.RucE=@RucE and 
					v.Ejer=@Ejer and 
					v.Cd_Fte='RC' and 
					p.IB_CtasXPag=1 and
					Isnull(v.IB_Anulado,0)=0 and
					v.FecMov between Convert(datetime,@FechaIni) and Convert(datetime,@FechaFin)
			) as r
			left join (
				select	
					v.*
				from 
					Vou_CtasXPag v 
					left join PlanCtas p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
				Where 
					v.RucE=@RucE and 
					v.Ejer=@Ejer and 
					v.Cd_Fte='CB' and 
					p.IB_CtasXPag=1 and
					--NroCta like '12%' and 
					Isnull(v.IB_Anulado,0)=0 and
					v.FecMov between Convert(datetime,@FechaIni) and Convert(datetime,@FechaFin)
			) as v
			  on v.RucE=r.RucE and v.Ejer=r.Ejer and v.NroCta=r.NroCta and v.Cd_Prv=r.Cd_Prv and v.Cd_TD=r.Cd_TD and v.NroSre=r.NroSre and v.NroDoc=r.NroDoc and isnull(v.IB_Anulado,0)=0
			where
				r.RucE=@RucE 
				and r.Ejer=@Ejer
				and r.FecMov between Convert(datetime,@FechaIni) and Convert(datetime,@FechaFin)
			Group by 
				r.RucE,
				r.Ejer,
				r.RegCtb,
				r.FecMov,
				r.NroCta,
				r.Cd_Prv,
				r.Cd_TD,
				r.NroSre,
				r.NroDoc,
				r.Monto
			Having 
				r.Monto+isnull(Sum(v.Monto),0.00)+ @VarNum<>0
		) as Con left join Proveedor2 p on p.RucE=con.RucE and p.Cd_Prv=con.Cd_Clt
		group by con.RegCtb
		union all
	select  
		Max(RucC) RucC,
		Max(RSocial) RSocial,
		RegCtb,
		Max(NDoc) NDoc,
		Max(FecMov) FecED, 
		'' FecVD,
		Sum(Debe) Debe, 
		Sum(Haber) Haber,
		Sum(Saldo) Saldo,
		Max(Dias) Dias,
		Sum(Saldo) Vencido,
		0.00 HASTA30,
		0.00 HASTA60,
		0.00 HASTA90,
		0.00 AMAS
	from (
		select 	
			v.RucE, 
			v.Ejer, 
			v.RegCtb,
			v.Cd_Prv,
			Convert(nvarchar,v.FecMov,103) FecMov,
			Case(Isnull(Len(c.NDoc),0)) when 0 then 'Sin Informacion' else c.NDoc end as RucC,
			Case(Isnull(Len(C.NDoc),0)) when 0 then 'Sin Informacion' else Case(isnull(len(c.RSocial),0)) when 0 then isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'') else c.RSocial end end as RSocial,
			isnull(v.Cd_TD,'') +'-'+isnull(v.NroSre,'')+'-'+isnull(v.NroDoc,'') NDoc,
			Total Debe,
			0.00 Haber, 
			Total Saldo,
			-200 dias
		from 	
			Compra v 
			left join Proveedor2 c on c.RucE=v.RucE and c.Cd_Prv=v.Cd_Prv	
		where 	v.RucE=@RucE and 
			v.Ejer=@Ejer and 
			v.IB_Anulado=0 and 
			v.FecMov between Convert(datetime,@FechaIni) and Convert(datetime,@FechaFin) and
			v.RegCtb not in
			(Select 
				RegCtb 
			 from 
				Voucher
			 Where 
				RucE=@RucE and 
				Ejer=@Ejer and 
				Cd_Fte='RC' and 
				--NroCta like '12%' and 
				RegCtb like 'CP%' and 
				FecMov between Convert(datetime,@FechaIni) and Convert(datetime,@FechaFin) and 
				IB_ANULADO=0
			)
		) as Con1 group by RegCtb
	) as Con2 order by RucC desc

-- Leyenda --
--JJ: 30/03/2011 : <Creacion del Procedimiento Almacenado>
--exec Rpt_CtasXCbr_Detallada '11111111111','2010','','31/12/2010','01',0
--exec Rpt_CtasXCbr_Asientos '11111111111','2010','01','CTGE_CB03-00007'
--exec Rpt_CtasXCbr_Producto '11111111111','2010','''CTGE_RV10-00001'''


GO

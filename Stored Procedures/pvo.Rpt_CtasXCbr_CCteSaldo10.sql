SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Rpt_CtasXCbr_CCteSaldo10]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Clt char(10),--Se modifico, antes era @Cd_Aux
@NroCta1 nvarchar(10),
--@Prdo nvarchar(2),
@NroCta2 nvarchar(10),
@FechaIni smalldatetime,
@FechaFin smalldatetime,
@Cd_Mda nvarchar(2),
@IB_VerSaldados bit,
@msj varchar(100) output
as

SET CONCAT_NULL_YIELDS_NULL OFF

declare @VarNum decimal(8,5)
set @VarNum = 0.00
if @IB_VerSaldados = 1
begin
	set @VarNum = 937.67676 -- cual numero que tenga mas de 2 decimales
end

if(@NroCta1='' or @NroCta1 is null)
set @NroCta1 = '00'

if(@NroCta2='' or @NroCta2 is null)
set @NroCta2 = '99'


--TABLA CABECERA
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha  from Empresa where Ruc=@RucE





--TABLA DETALLE
if(@Cd_Clt!='' and @Cd_Clt is not null)
begin
	
		select 	
			--isnull(a.NDoc,'No identificado') as NDocAux, 
			v.RucE,
			COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Información---') as NDocAux,
			--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
			case(isnull(len(v.Cd_Clt),0)) when 0 then 
			case(isnull(len(v.Cd_Prv),0)) when 0 then '-----'
			else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
			end
			else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
			end 
			as NomAux,
			v.NroCta,
			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, v.NroCta,
			--Max(v.Cd_TD) as Cd_TD, Max(v.NroSre) as NroSre, Max(v.NroDoc) as NroDoc,
			Convert(varchar,isnull(v.Cd_TD,'')) as Cd_TD,Convert(varchar,isnull(v.NroSre,'')) as NroSre,Convert(varchar,isnull(v.NroDoc,'')) as NroDoc,
			-- ANTES  					
			
			-- DESPUES (MEJORA)
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED, -- else '00/00/0000' end) as FecED, 
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD, -- else '00/00/0000' end) as FecVD, 
			--sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,v.FecCbr) else 0 end) as Saldo_Dias,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaFin,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificación')))) else 0 end) as Saldo_Dias, --ver 
			
			--convert(varchar,@FechaAl,103) as FechaAl,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) as Debe, 
			sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Haber,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
			@Cd_Mda as Cd_MdRg--, --> DEBERIA JALAR LA MONEDA DEL VOUCHER
			--case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end as Simbolo
			,v.DR_CdTD, v.DR_NSre, v.DR_NDoc
			,Case When len(ltrim(isnull(t.DR_CdTD,'')))>0 Then 1 Else 0 End ConNC
			,isnull(sum(t.debe),0) as DebeDR, isnull(sum(t.haber),0) as HaberDR

		from voucher as v
		left join Empresa emp on emp.Ruc=v.RucE
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv = v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		
		
		left join (
			select 	v.DR_CdTD, v.DR_NSre, v.DR_NDoc,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) as Debe, 
			sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Haber
			from voucher as v
			left join Empresa as e on e.Ruc=v.RucE
			--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
			left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
			left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv = v.Cd_Prv
			left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		
	
			where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta>=@NroCta1 and v.NroCta<=@NroCta2 
			/*(v.NroCta between @NroCta1 and @NroCta2)*/and /*(v.FecMov <= @FechaAl)*/ 
			convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and 
			convert(varchar,@FechaFin,102) 
			and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
			and v.DR_CdTD is not null and  v.DR_NSre is not null and v.DR_NDoc is not null
			--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
	
			--group by a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD,v.NroSre,v.NroDoc--,v.Cd_MdRg, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg
			group by c.NDoc, c.ApPat,c.ApMat,c.Nom,c.RSocial, v.NroCta, v.Cd_TD,v.NroSre,v.NroDoc,v.Cd_Prv,pr.NDoc,pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial,v.Cd_Clt,v.DR_CdTD, v.DR_NSre, v.DR_NDoc
			having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) + @VarNum <>0
			) as t
			ON t.DR_CdTD=v.Cd_TD and t.DR_NSre=v.NroSre and t.DR_NDoc=v.NroDoc

		where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta>=@NroCta1 and v.NroCta<=@NroCta2 
		/*(v.NroCta between @NroCta1 and @NroCta2)*/ 
		and v.Cd_Clt= @Cd_Clt and /*(v.FecMov <= @FechaAl)*/
		convert(varchar,v.FecMov,102) 
		between convert(varchar,@FechaIni,102) and convert(varchar,@FechaFin,102)
		and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		and v.DR_CdTD is null and  v.DR_NSre is null and v.DR_NDoc is null
		--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'

		group by v.RucE,t.DR_CdTD,c.NDoc, c.ApPat,c.ApMat,c.Nom,c.RSocial, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD,v.NroSre,v.NroDoc,v.Cd_Prv,pr.NDoc,pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial,v.Cd_Clt,v.DR_CdTD, v.DR_NSre, v.DR_NDoc--,v.Cd_MdRg, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg
		having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) + @VarNum <>0
		order by NomAux--,v.Cd_TD,v.NroSre, v.NroDoc,FecED,a.NDoc

		/************************************Docs Relacionados***************************/


		select 	
			--isnull(a.NDoc,'No identificado') as NDocAux, 
			COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Información---') as NDocAux,
			--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
			case(isnull(len(v.Cd_Clt),0)) when 0 then 
			case(isnull(len(v.Cd_Prv),0)) when 0 then '----'
			else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
			end
			else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
			end 
			as NomAux,


			 v.NroCta,
			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, v.NroCta,
			--Max(v.Cd_TD) as Cd_TD, Max(v.NroSre) as NroSre, Max(v.NroDoc) as NroDoc,
			isnull(v.DR_CdTD,'') as Cd_TD,isnull(v.DR_NSre,'') as NroSre,isnull(v.DR_NDoc,'') as NroDoc,
			-- ANTES

			-- DESPUES (MEJORA)
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED, -- else '00/00/0000' end) as FecED, 
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD, -- else '00/00/0000' end) as FecVD, 
			--sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,v.FecCbr) else 0 end) as Saldo_Dias,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaFin,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificación')))) else 0 end) as Saldo_Dias,  --ver

			--convert(varchar,@FechaAl,103) as FechaAl,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) as Debe, 
			sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Haber,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
			@Cd_Mda as Cd_MdRg--, ---> DEBERIA JALAR LA MONEDA DEL VOUCHER
			,Convert(varchar,v.Cd_TD) As DR_CdTD, Convert(varchar,v.NroSre) As DR_NSre, Convert(varchar,v.NroDoc) As DR_NDoc
		--case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end as Simbolo
		from voucher as v
		left join Empresa as e on e.Ruc=v.RucE
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv = v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
	

		where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta>=@NroCta1 and v.NroCta<=@NroCta2 
		and v.Cd_Clt= @Cd_Clt
		/*(v.NroCta between @NroCta1 and @NroCta2)*/and /*(v.FecMov <= @FechaAl)*/ 
		convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and 
		convert(varchar,@FechaFin,102) 
		and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		and v.DR_CdTD is not null and  v.DR_NSre is not null and v.DR_NDoc is not null
		--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'

		--group by a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD,v.NroSre,v.NroDoc--,v.Cd_MdRg, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg
		group by c.NDoc, c.ApPat,c.ApMat,c.Nom,c.RSocial, v.NroCta, v.Cd_TD,v.NroSre,v.NroDoc,v.Cd_Prv,pr.NDoc,pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial,v.Cd_Clt,v.DR_CdTD, v.DR_NSre, v.DR_NDoc
		having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) + @VarNum <>0
		order by NomAux


end
else -- No tiene aux
begin
--select *from Cliente2
		select 	
			--isnull(a.NDoc,'No identificado') as NDocAux, 
			v.RucE,
			COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Información---') as NDocAux,
			--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
			case(isnull(len(v.Cd_Clt),0)) when 0 then 
			case(isnull(len(v.Cd_Prv),0)) when 0 then '----'
			else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
			end
			else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
			end 
			as NomAux,


			 v.NroCta,
			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, v.NroCta,
			--Max(v.Cd_TD) as Cd_TD, Max(v.NroSre) as NroSre, Max(v.NroDoc) as NroDoc,
			Convert(varchar,isnull(v.Cd_TD,'')) as Cd_TD,Convert(varchar,isnull(v.NroSre,'')) as NroSre,Convert(varchar,isnull(v.NroDoc,'')) as NroDoc,

			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED, -- else '00/00/0000' end) as FecED, 
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD, -- else '00/00/0000' end) as FecVD, 
			--sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,v.FecCbr) else 0 end) as Saldo_Dias,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaFin,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificación')))) else 0 end) as Saldo_Dias,  --ver

			--convert(varchar,@FechaAl,103) as FechaAl,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) as Debe, 
			sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Haber,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
			@Cd_Mda as Cd_MdRg--, ---> DEBERIA JALAR LA MONEDA DEL VOUCHER
			,v.DR_CdTD, v.DR_NSre, v.DR_NDoc
			,Case When len(ltrim(isnull(t.DR_CdTD,'')))>0  Then 1 Else 0 End ConNC
			,isnull(sum(t.debe),0) as DebeDR, isnull(sum(t.haber),0) as HaberDR

		--case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end as Simbolo
		from voucher as v
		left join Empresa as e on e.Ruc=v.RucE
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv = v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer

		left join (
			select 	v.DR_CdTD, v.DR_NSre, v.DR_NDoc,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) as Debe, 
			sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Haber
			from voucher as v
			left join Empresa as e on e.Ruc=v.RucE
			--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
			left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
			left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv = v.Cd_Prv
			left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		
	
			where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta>=@NroCta1 and v.NroCta<=@NroCta2 
			/*(v.NroCta between @NroCta1 and @NroCta2)*/and /*(v.FecMov <= @FechaAl)*/ 
			convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and 
			convert(varchar,@FechaFin,102) 
			and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
			and v.DR_CdTD is not null and  v.DR_NSre is not null and v.DR_NDoc is not null
			--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
	
			--group by a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD,v.NroSre,v.NroDoc--,v.Cd_MdRg, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg
			group by c.NDoc, c.ApPat,c.ApMat,c.Nom,c.RSocial, v.NroCta, v.Cd_TD,v.NroSre,v.NroDoc,v.Cd_Prv,pr.NDoc,pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial,v.Cd_Clt,v.DR_CdTD, v.DR_NSre, v.DR_NDoc
			having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) + @VarNum <>0
			) as t
			ON t.DR_CdTD=v.Cd_TD and t.DR_NSre=v.NroSre and t.DR_NDoc=v.NroDoc


		where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta>=@NroCta1 and v.NroCta<=@NroCta2 
		and convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and convert(varchar,@FechaFin,102) 
		and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		and v.DR_CdTD is null and  v.DR_NSre is null and v.DR_NDoc is null

		group by v.RucE,t.DR_CdTD,c.NDoc, c.ApPat,c.ApMat,c.Nom,c.RSocial, v.NroCta, v.Cd_TD,v.NroSre,v.NroDoc,v.Cd_Prv,pr.NDoc,pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial,v.Cd_Clt,v.DR_CdTD, v.DR_NSre, v.DR_NDoc
		having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) + @VarNum <>0
		order by NomAux






		/**********************Docs Relacionsdos************************/

		select 	
			--isnull(a.NDoc,'No identificado') as NDocAux, 
			COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Información---') as NDocAux,
			--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
			case(isnull(len(v.Cd_Clt),0)) when 0 then 
			case(isnull(len(v.Cd_Prv),0)) when 0 then '----'
			else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
			end
			else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
			end 
			as NomAux,


			 v.NroCta,
			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, v.NroCta,
			--Max(v.Cd_TD) as Cd_TD, Max(v.NroSre) as NroSre, Max(v.NroDoc) as NroDoc,
			--isnull(v.Cd_TD,'') as Cd_TD,isnull(v.NroSre,'') as NroSre,isnull(v.NroDoc,'') as NroDoc,
			isnull(v.DR_CdTD,'') as Cd_TD,isnull(v.DR_NSre,'') as NroSre,isnull(v.DR_NDoc,'') as NroDoc,
			-- ANTES

			-- DESPUES (MEJORA)
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED, -- else '00/00/0000' end) as FecED, 
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD, -- else '00/00/0000' end) as FecVD, 
			--sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaAl,v.FecCbr) else 0 end) as Saldo_Dias,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaFin,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificación')))) else 0 end) as Saldo_Dias,  --ver

			--convert(varchar,@FechaAl,103) as FechaAl,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) as Debe, 
			sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Haber,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
			@Cd_Mda as Cd_MdRg--, ---> DEBERIA JALAR LA MONEDA DEL VOUCHER
			,Convert(varchar,v.Cd_TD) As DR_CdTD, Convert(varchar,v.NroSre) As DR_NSre, Convert(varchar,v.NroDoc) As DR_NDoc
		--case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end as Simbolo
		from voucher as v
		left join Empresa as e on e.Ruc=v.RucE
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv = v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
	

		where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta>=@NroCta1 and v.NroCta<=@NroCta2 
		/*(v.NroCta between @NroCta1 and @NroCta2)*/and /*(v.FecMov <= @FechaAl)*/ 
		convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and 
		convert(varchar,@FechaFin,102) 
		and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		and v.DR_CdTD is not null and  v.DR_NSre is not null and v.DR_NDoc is not null
		--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'

		--group by a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD,v.NroSre,v.NroDoc--,v.Cd_MdRg, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg
		group by c.NDoc, c.ApPat,c.ApMat,c.Nom,c.RSocial, v.NroCta, v.Cd_TD,v.NroSre,v.NroDoc,v.Cd_Prv,pr.NDoc,pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial,v.Cd_Clt,v.DR_CdTD, v.DR_NSre, v.DR_NDoc
		having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) + @VarNum <>0
		order by NomAux


end
print @msj
/*---PRUEBAS---*/
--JE : 22/01/2009 : SE CREO ESTE PROCEDIMIENTO PARA AGREGAR EL CAMPO FECHA_AL PARA QUE SE PUEDA VISUALIZAR
--Jesus -> 16-07-2010 : Se agrego la sentencia -> case(Cd_MdRg) when '01' then 'S/.' else 'US$' end as Cd_MdRg
--Jesus -> Creado 31/07/2010 -> Se agregaron las variables @FechaIni & @FechaFin para consulta entre rangos
/*exec pvo.Rpt_CtasXCbr_CCteSaldo7_Fec '111111111111','2010','','','','01/01/2010','31/12/2010','01',null*/
	
--select * from voucher where ruce = '11111111111' and regctb = 'CTGE_RC04-00009'
--select * from voucher where ruce = '11111111111' and cd_prv = 'PRV0439'107
--select * from Proveedor2 where ruce = '11111111111' and cd_prv = 'PRV0439' 
--DEMO
--exec pvo.Rpt_CtasXCbr_CCteSaldo7_Fec '111111111111','2010','CLT0000002','12.1.0.01','12.1.0.01','01/01/2009','30/09/2010','01',null
--MP: VIE 17-09-2010 --> Se quito las referencias a la tabla auxiliar y se enlazo con Cliente2
		     --> Se cambia un parametro de @Cd_Aux a @Cd_Clt
--CM: PR03
--CM: RA01

--exec pvo.Rpt_CtasXCbr_CCteSaldo10 '111111111111','2011','CLT0003621','','','01/02/2011','30/05/2011','01',1,null--CLT0003621

--select * from TipDoc



GO

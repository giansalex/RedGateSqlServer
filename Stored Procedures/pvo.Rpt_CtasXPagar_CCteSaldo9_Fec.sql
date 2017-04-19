SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--pvo.Rpt_CtasXPagar_CCteSaldo9_Fec '20504743561','2010','','','','01/11/2010','31/12/2010','01',0,null
CREATE procedure [pvo].[Rpt_CtasXPagar_CCteSaldo9_Fec]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Prv char(7),--Modificado, antes era @Cd_Aux nvarchar(7)
@NroCta1 nvarchar(10),
--@Prdo nvarchar(2),
@NroCta2 nvarchar(10),
@FechaIni smalldatetime,
@FechaFin smalldatetime,
@Cd_Mda nvarchar(2),
@IB_VerSaldados bit,

@msj varchar(100) output
as

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
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha from Empresa where Ruc=@RucE

--TABLA DETALLE
if(@Cd_Prv!='' and @Cd_Prv is not null)
begin
		
		select 	
			--isnull(a.NDoc,'No identificado') as NDocAux, 
			COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Información---') as NDocAux,	
			--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,
			
			
			case(isnull(len(v.Cd_Clt),0)) when 0 then 
			case(isnull(len(v.Cd_Prv),0)) when 0 then null
			else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
			end
			else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
			end 
			as NomAux,
			

			v.NroCta,
			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, v.NroCta,
			--Max(v.Cd_TD) as Cd_TD, Max(v.NroSre) as NroSre, Max(v.NroDoc) as NroDoc,
			isnull(v.Cd_TD,'') as Cd_TD,isnull(v.NroSre,'') as NroSre,isnull(v.NroDoc,'') as NroDoc,
			--v.RegCtb,
			-- ANTES
			-- convert(varchar,v.FecED,103) as FecED, 
			-- v.FecVD as FecVD, /*v.FecVD,*/ 
			-- datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,  
			--v.FecMov,		
			-- DESPUES (MEJORA)
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED, -- else '00/00/0000' end) as FecED, 
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD, -- else '00/00/0000' end) as FecVD, 
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaFin,v.FecCbr) else 0 end) as Saldo_Dias,  
			--v.Glosa,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) as Debe, 
			sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Haber,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
			@Cd_Mda as Cd_MdRg--, --> DEBERIA JALAR LA MONEDA DEL VOUCHER
			--case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end as Simbolo
		
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		--left join Proveedor2 as a on a.RucE=v.RucE and a.Cd_Prv=v.Cd_Prv
		left join Cliente2 as c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt --<<-- Nueva Linea
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer--p.Ejer=@Ejer
		--left join Empresa as e on e.Ruc=v.RucE
		
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2)
		and convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and convert(varchar,@FechaFin,102)  
		and isnull(p.IB_CtasXPag,0)=1/*and v.Cd_Aux= @Cd_Aux*//*==*//*and v.IB_Anulado<>'1'*/ /*and ==*/ 
		and isnull(v.IB_Anulado,0)<>1 
		and v.Cd_Prv= @Cd_Prv
			/*and a.NDoc not in (select 	
							a.NDoc
						from voucher as v
						left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
						left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
						where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXPag=1 and v.FecMov <= @FechaAl and v.IB_Anulado<>1 and v.Cd_Aux= @Cd_Aux
						group by a.NDoc
						having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)=0
					   )*/
		group by pr.NDoc, pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD,v.NroSre,v.NroDoc,v.Cd_Prv,v.Cd_Clt,c.NDoc,c.ApPat,c.ApMat,c.Nom,c.RSocial--,v.Glosa,v.FecMov,v.RegCtb--,v.Cd_MdRg--, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg
		having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) + @VarNum<>0
		order by NomAux--,v.Cd_TD,v.NroSre, v.NroDoc,FecED,a.NDoc
		

		--where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 /*and v.Cd_Aux= @Cd_Aux*//*==*//*and v.IB_Anulado<>'1'*/ /*and ==*/ and v.FecMov <= @FechaAl and v.IB_Anulado<>1 and v.Cd_Aux= @Cd_Aux
		--group by a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD,v.NroSre,v.NroDoc--, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg
		--having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)<>0
		--order by NomAux--,v.Cd_TD,v.NroSre, v.NroDoc,FecED,a.NDoc
		
end
else -- No tiene aux
begin
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
			isnull(v.Cd_TD,'') as Cd_TD,isnull(v.NroSre,'') as NroSre,isnull(v.NroDoc,'') as NroDoc,
			--v.RegCtb,
			-- ANTES
			-- convert(varchar,v.FecED,103) as FecED, 
			-- v.FecVD as FecVD, /*v.FecVD,*/ 
			-- datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,  
			--v.FecMov,
			-- DESPUES (MEJORA)
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED, -- else '00/00/0000' end) as FecED, 
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD, -- else '00/00/0000' end) as FecVD, 
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaFin,v.FecCbr) else 0 end) as Saldo_Dias,  
			--v.Glosa,-- Jesus que es esto !!!!!!!!
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) as Debe, 
			sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Haber,
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Saldo,
			@Cd_Mda as Cd_MdRg--, --> DEBERIA JALAR LA MONEDA DEL VOUCHER
			--case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end as Simbolo
			
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		--left join Proveedor2 as a on a.RucE=v.RucE and a.Cd_Prv=v.Cd_Prv
		left join Cliente2 as c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt --<<-- Nueva Linea
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer--p.Ejer=@Ejer
		--left join Empresa as e on e.Ruc=v.RucE
		
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2)/*and v.Cd_Aux= @Cd_Aux*//*==*//*and v.IB_Anulado<>'1'*/ /*and ==*/ 
		and convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and convert(varchar,@FechaFin,102) 
		and isnull(p.IB_CtasXPag,0)=1
		and isnull(v.IB_Anulado,0)<>1
			/*and a.NDoc not in (select 	
							a.NDoc
						from voucher as v
						left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
						left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
						where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXPag=1 and v.FecMov <= @FechaAl and v.IB_Anulado<>1
						group by a.NDoc
						having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)=0
					   )*/
		group by pr.NDoc, pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD,v.NroSre,v.NroDoc,v.Cd_Prv,v.Cd_Clt,c.NDoc,c.ApPat,c.ApMat,c.Nom,c.RSocial--,v.Glosa--,v.FecMov--,v.RegCtb--,v.Cd_MdRg--, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg
		having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) + @VarNum <>0
		order by NomAux--,v.Cd_TD,v.NroSre, v.NroDoc,FecED,a.NDoc
		

		--where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXCbr=1 /*and v.Cd_Aux= @Cd_Aux*//*==*//*and v.IB_Anulado<>'1'*/ /*and ==*/ and v.FecMov <= @FechaAl and v.IB_Anulado<>1
		--group by a.NDoc, a.ApPat,a.ApMat,a.Nom,a.RSocial, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD,v.NroSre,v.NroDoc--, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg
		--having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end)-sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)<>0
		--order by NomAux--,v.Cd_TD,v.NroSre, v.NroDoc,FecED,a.NDoc

end
--Pruebas:
--exec pvo.Rpt_CtasXPagar_CCteSaldo8_Fec '11111111111','2010','','','','01/01/2010','01/12/2010','01',null
--PV: VIE 05/06/2009 : CREADO
--PV: VIE 03/07/2009 : MODF: se arreglo la No_agrupacion por fecha diferente y los saldos dias
--JS: LUN 02/11/2009 : MODF: se arreglo que el reporte no jale los voucher Anulados
--JS: LUN 19/07/2010 : MODF: se agrego para que muestre la mda. rg.
--Jesus : Creado 31/07/2010 -> Se agregaron las variables @FechaIni & @FechaFin para consulta entre rangos
-- PV:  VIE 06/08/2010 -- Mdf: Error en between de fechas
-- MP: VIE 17-09-2010 --> Se quito las referencias a la tabla Auxiliar y se enlazo a Proveedor2
--CM: PR03
--CM: RA01
print @msj
GO

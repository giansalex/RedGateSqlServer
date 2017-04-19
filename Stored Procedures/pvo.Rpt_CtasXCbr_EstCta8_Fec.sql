SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Rpt_CtasXCbr_EstCta8_Fec]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Clt char(10), --Se modifico, antes era @Cd_Aux
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@FechaIni smalldatetime,
@FechaFin smalldatetime,
@Cd_Mda nvarchar(2),
@msj varchar(100) output
as

/*
SET CONCAT_NULL_YIELDS_NULL OFF

if(@NroCta1='' or @NroCta1 is null)
set @NroCta1 = '00'

if(@NroCta2='' or @NroCta2 is null)
set @NroCta2 = '99'

--TABLA CABECERA
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha from Empresa where Ruc=@RucE

--TABLA DETALLE

if(@Cd_Clt!='' and @Cd_Clt is not null)
begin
print 'Tiene Aux'
--PRINT datediff(second,v.FecMov,@FechaAl)

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

			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, 
			v.RegCtb,
			v.NroCta,
			v.Cd_TD,
			v.NroSre,
			v.NroDoc, 
			--convert(varchar,v.FecMov,103) as FecED,'' as FecVD,datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaFin,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin EspecificaciÃ³n')))) else 0 end) as Saldo_Dias,

			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) as Debe, 
			sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Haber,
			@Cd_Mda as Cd_MdRg, --> DEBERIA JALAR LA MONEDA DEL VOUCHER
		case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end as Simbolo
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv = v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer

		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Clt= @Cd_Clt and /*(v.FecMov <= @FechaAl)*/
		convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and 
		convert(varchar,@FechaFin,102) and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'

		group by c.NDoc, c.ApPat,c.ApMat,c.Nom,c.RSocial,
			 v.RegCtb,
			 v.NroCta,v.Cd_TD, v.NroSre, v.NroDoc, 
			 v.FecMov,datediff(day,v.FecMov,@FechaFin),
			 pr.NDoc,v.Cd_Prv,pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial,v.Cd_Clt,v.Cd_MdRg
		--having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) - sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)<>0
		order by v.FecMov--,a.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc	

 
end
else -- No tiene aux
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

			--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux, 
			v.RegCtb,
			v.NroCta,v.Cd_TD,v.NroSre,v.NroDoc, 
			--convert(varchar,v.FecMov,103) as FecED,'' as FecVD,datediff(day,v.FecMov,@FechaAl) as Saldo_Dias,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaFin,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin EspecificaciÃ³n')))) else 0 end) as Saldo_Dias,  
			sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) as Debe, 
			sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end) as Haber,
			@Cd_Mda as Cd_MdRg, --> DEBERIA JALAR LA MONEDA DEL VOUCHER
			case(v.Cd_MdRg) when '01' then 'S/.' else 'US$' end as Simbolo
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv = v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and /*(v.FecMov <= @FechaAl)*/ 
		convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and 
		convert(varchar,@FechaFin,102)and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
--(Otra Forma)	where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and v.Cd_Aux= @Cd_Aux and /*(v.FecMov <= @FechaAl)*/ datediff(day,FecMov,@FechaAl) >=0 and p.IB_CtasXCbr=1 and v.IB_Anulado<>'1'
		
		group by c.NDoc, c.ApPat,c.ApMat,c.Nom,c.RSocial,
			-- v.RegCtb,v.NroCta,v.Cd_TD, v.NroSre, v.NroDoc, v.FecMov,datediff(day,v.FecMov,@FechaFin),v.Cd_MdRg
			 v.RegCtb,
			 v.NroCta,v.Cd_TD, v.NroSre, v.NroDoc, 
			 v.FecMov,datediff(day,v.FecMov,@FechaFin),
			 pr.NDoc,v.Cd_Prv,pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial,v.Cd_Clt,v.Cd_MdRg
		having sum(case(@Cd_Mda) when '01' then (v.MtoD) else (v.MtoD_ME) end) - sum(case(@Cd_Mda) when '01' then (v.MtoH) else (v.MtoH_ME) end)<>0
		order by v.FecMov--,a.NDoc,NomAux,v.Cd_TD, v.NroSre, v.NroDoc
end

--Pruebas:
--exec pvo.Rpt_CtasXCbr_CCteSaldo3 '11111111111','2009','','','','05/02/2009','01',null
--Ejemplos
/*exec pvo.Rpt_CtasXCbr_CCteSaldo3 '11111111111','2009','','','','05/02/2009','01',null
exec pvo.Rpt_CtasXCbr_EstCta5 '20513272848','2009','AUX0490','12.1.0.01','12.1.0.01','30/11/2009','01',null
exec pvo.Rpt_CtasXCbr_EstCta5 '20513272848','2009','AUX0490','12.1.0.01','12.1.0.01','01/12/2009','01',null
2009-11-30 14:34:00 <= 2009-11-30 00:00:00
DECLARE @FechaAl smalldatetime
--SET @FechaAl = CONVERT(smalldatetime,'30/11/2009 14:33:00')
SET @FechaAl = CONVERT(smalldatetime,'01/10/2009')
PRINT @FechaAl

--SELECT * FROM VOUCHER WHERE RUCE='20513272848' and REGCTB='VTGN_RV11-00077' AND CD_VOU='58015'
SELECT datediff(day,FecMov,@FechaAl) FROM VOUCHER WHERE RUCE='20513272848' and REGCTB='VTGN_RV11-00077' AND CD_VOU='58015'

datediff(day,FecMov,@FechaAl) >=0

-----------------
DECLARE @FechaAl smalldatetime
SET @FechaAl = CONVERT(smalldatetime,'30/11/2009 14:33:00')
PRINT @FechaAl
print convert(varchar,@FechaAl,102)
convert(varchar,@FecMov,102) <= convert(varchar,@FechaAl,102)
25072009 <= 20112009
2009.07.25 <= 2009.12.20
--SELECT * FROM VOUCHER WHERE RUCE='20513272848' and REGCTB='VTGN_RV11-00077' AND CD_VOU='58015'
SELECT datediff(second,FecMov,@FechaAl) FROM VOUCHER WHERE RUCE='20513272848' and REGCTB='VTGN_RV11-00077' AND CD_VOU='58015'
datediff(second,FecMov,@FechaAl) >=0
PRINT datediff(second,v.FecMov,@FechaAl)*/


*/
--RETURN

--CABECERA
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha from Empresa where Ruc=@RucE

--DETALLE
Select 
	isnull(c.NDoc,isnull(r.NDoc,'')) As NDocAux,
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
																									   Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
																	 End 							  
	End As NomAux,
	v.RegCtb,
	v.NroCta,
	isnull(v.Cd_TD,'') As Cd_TD,
	isnull(v.NroSre,'') As NroSre,
	isnull(v.NroDoc,'') As NroDoc,
	
	Sum(Case When isnull(v.IB_EsProv,0)=1 Then Datediff(Day,@FechaFin,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificar')))) Else 0 End) As Saldo_Dias,
	
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) As Debe,
	Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Haber,
	v.Cd_MdRg as Cd_MdRg,
	Case When v.Cd_MdRg='01' Then 'S/.' Else 'US$' end as Simbolo
	,Convert(varchar,v.FecMov,103) as FecED
	--,isnull(g.IB_Saldado,0)
From 
	Voucher v
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	Left Join 
	(	Select v.RucE,	v.Ejer,	v.NroCta,isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,isnull(v.Cd_TD,'') As Cd_TD,isnull(v.NroSre,'') As NroSre,isnull(v.NroDoc,'') As NroDoc,1 As IB_Saldado
		From Voucher v Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
		Where  v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IB_Anulado,0)<>1 and Convert(varchar,v.FecMov,102) between Convert(varchar,@FechaIni,102) and Convert(varchar,@FechaFin,102)
		Group by v.RucE, v.Ejer, v.NroCta, isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')), isnull(v.Cd_TD,''), isnull(v.NroSre,''), isnull(v.NroDoc,'')
		Having Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End)-Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End)=0
	) As g On g.RucE=v.RucE and g.Ejer=v.Ejer and (g.NroCta=v.NroCta and isnull(g.CodAux,'')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc)
	
Where 
	v.RucE=@RucE
	and v.Ejer=@Ejer
	and isnull(v.IB_Anulado,0)<>1
	and Convert(varchar,v.FecMov,102) between Convert(varchar,@FechaIni,102) and Convert(varchar,@FechaFin,102)
	and Case When isnull(@NroCta1,'')<>'' Then v.NroCta Else '' End>=isnull(@NroCta1,'')
	and Case When isnull(@NroCta2,'')<>'' Then v.NroCta Else '' End<=isnull(@NroCta2,'')
	and Case When isnull(@Cd_Clt,'')<>'' Then isnull(v.Cd_Clt,'') Else '' End =isnull(@Cd_Clt,'')
Group by 
	v.RegCtb,
	v.NroCta,
	isnull(c.NDoc,isnull(r.NDoc,'')),
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
																									   Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
																	 End 							  
	End,
	isnull(v.Cd_TD,''),
	isnull(v.NroSre,''),
	isnull(v.NroDoc,''),
	v.Cd_MdRg,
	Convert(varchar,v.FecMov,103)
	
	--,isnull(g.IB_Saldado,0)

Having
	Sum(isnull(g.IB_Saldado,0))=0
	and Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) + Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End)<>0
	
Order by Convert(varchar,v.FecMov,103)


--LEYENDA--
--PV: VIE 05/06/2009 : CREADO
--J : JUE 06/08/2009 : MODIFICADO
--J y D : MIE 06/01/2010 : MODICADO LAS CONSULTAS (Having y el Where)
--Jesus -> 16-07-2010 : Se agrego la sentencia -> case(Cd_MdRg) when '01' then 'S/.' else 'US$' end as Cd_MdRg
--Jesus -> Creado 31/07/2010 -> Se agregaron las variables @FechaIni & @FechaFin para consulta entre rangos
--Ejemplo
--exec pvo.Rpt_CtasXCbr_EstCta8_Fec '11111111111','2012','','','','01/11/2012','30/11/2012','01',null

--MP: VIE 17-09-2010 --> Se quito la relacion a la tabla Auxiliar y se enlazo con Cliente2
		     --> Se modifico un parametro de Cd_Aux a Cd_Clt
--CM: PR03
--CM: RA01
--DI: 24/06/2011 <Reestructurado>
--DI 02/08/2011 <Se quito el cambo IB_Saldadp en el Group by y se asigno como Suma en el Having>

print @msj

GO

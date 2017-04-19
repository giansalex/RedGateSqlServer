SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Rpt_CtasXPagar_CCteResumAmb4_Fec] --falta completar el cambio a Prv
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_Prv char(7),--Cd_Prv char 7
@FechaIni smalldatetime,
@FechaFin smalldatetime,
--@Cd_Mda nvarchar(2),
@msj varchar(100) output
as

SET CONCAT_NULL_YIELDS_NULL OFF

/*
if(@NroCta1='' or @NroCta1 is null)
set @NroCta1 = '00'

if(@NroCta2='' or @NroCta2 is null)
set @NroCta2 = '99'

select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha from Empresa where Ruc=@RucE

if(@Cd_Prv!='' and @Cd_Prv is not null)
--if not exists(select * from voucher where rucE=@RucE and ejer=@Ejer)
--set @msj='Error de Consulta'
	begin
		select v.RucE,	
		--isnull(a.NDoc,'No identificado') as NDoc, --<<-- Modificado en linea 26
		--isnull(pr.NDoc,'No identificado') as NDoc, --<<-- Nueva

		COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Información---') as NDoc,

		--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,	--<<-- Modificado Linea 28
		--isnull(pr.RSocial,(isnull(pr.ApPat,'')+' '+isnull(pr.ApMat,'')+' '+isnull(pr.Nom,''))) as NomAux, --<<-- Nueva

		case(isnull(len(v.Cd_Clt),0)) when 0 then 
		case(isnull(len(v.Cd_Prv),0)) when 0 then '----'
		else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
		end
		else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
		end 
		as NomAux,

		--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		sum(v.MtoD)Debe, 
		sum(v.MtoH)Haber,
		(sum(v.MtoD)-sum(v.MtoH)) as Saldo,
		sum(v.MtoD_ME) Debe_ME,
		sum(v.MtoH_ME) Haber_ME,		
		(sum(v.MtoD_ME)-sum(v.MtoH_ME)) as Saldo_ME
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux--<<-- Modificado linea 38
		--left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
		left join Cliente2 as c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt --<<-- Nueva Linea
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) 
		and convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and convert(varchar,@FechaFin,102) 
		and p.IB_CtasXPag=1 and v.IB_Anulado<>'1' 		
		and v.Cd_Prv=@Cd_Prv
		--group by v.RucE,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom--<<--Modificado en linea 45
		group by v.RucE,pr.NDoc,pr.RSocial,pr.ApPat,pr.ApMat,pr.Nom,v.Cd_Prv,c.NDoc,v.Cd_Clt,c.ApPat,c.ApMat,c.Nom,c.RSocial --<<-- Nueva
		having sum(v.MtoD)-sum(v.MtoH)<>0 or sum(v.MtoD_ME)-sum(v.MtoH_ME)<>0
		--order by a.RSocial,a.ApPat,a.ApMat,a.Nom--<<-- Modificado en linea 48
		order by pr.RSocial,pr.ApPat,pr.ApMat,pr.Nom --<<-- Nueva


	end
else
	begin
	
		select v.RucE,	
		--isnull(a.NDoc,'No identificado') as NDoc,--<<-- Modificado en linea 57
		--isnull(pr.NDoc,'No identificado') as NDoc,--<<--Nueva

		COALESCE(IsNull(c.NDoc,pr.NDoc),'---Sin Información---') as NDoc,		

		--isnull(a.RSocial,(isnull(a.ApPat,'')+' '+isnull(a.ApMat,'')+' '+isnull(a.Nom,''))) as NomAux,--<<-- Modificado en linea 59
		--isnull(pr.RSocial,(isnull(pr.ApPat,'')+' '+isnull(pr.ApMat,'')+' '+isnull(pr.Nom,''))) as NomAux,--<<-- Nueva

		case(isnull(len(v.Cd_Clt),0)) when 0 then 
		case(isnull(len(v.Cd_Prv),0)) when 0 then '----'
		else case(isnull(len(pr.RSocial),0)) when 0 then isnull(nullif(pr.ApPat +' '+pr.ApMat+' '+pr.Nom,''),'------- SIN NOMBRE ------') else pr.RSocial  end  
		end
		else case(isnull(len(c.RSocial),0)) when 0 then isnull(nullif(c.ApPat +' '+c.ApMat+' '+c.Nom,''),'------- SIN NOMBRE ------') else c.RSocial end 
		end 
		as NomAux,

		--case(isnull(len(a.RSocial),0)) when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom else a.RSocial end as NomAux,
		sum(v.MtoD)Debe, 
		sum(v.MtoH)Haber,
		(sum(v.MtoD)-sum(v.MtoH)) as Saldo,
		sum(v.MtoD_ME) Debe_ME,
		sum(v.MtoH_ME) Haber_ME,		
		(sum(v.MtoD_ME)-sum(v.MtoH_ME)) as Saldo_ME
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux--<<--Modificado en linea 69
		--left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv --<<-- Nueva
		left join Cliente2 as c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt --<<-- Nueva Linea
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=@Ejer
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) 
		and convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) 
		and convert(varchar,@FechaFin,102)
		and p.IB_CtasXPag=1 and v.IB_Anulado<>'1' 		
		--and v.Cd_Aux=@Cd_Aux 
		--group by v.RucE,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom--<<-- Modificado en linea 77
		group by v.RucE,pr.NDoc,pr.RSocial,pr.ApPat,pr.ApMat,pr.Nom,v.Cd_Prv,c.NDoc,v.Cd_Clt,c.ApPat,c.ApMat,c.Nom,c.RSocial --<<-- Nueva
		having sum(v.MtoD)-sum(v.MtoH)<>0 or sum(v.MtoD_ME)-sum(v.MtoH_ME)<>0
		--order by a.RSocial,a.ApPat,a.ApMat,a.Nom --<<-- modificado en linea 80		
		order by pr.RSocial,pr.ApPat,pr.ApMat,pr.Nom --<<-- Nueva

	end
print @msj
*/
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha from Empresa where Ruc=@RucE

Select 
	v.RucE,
	isnull(c.NDoc,isnull(r.NDoc,'')) As NDocAux,
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
																									   Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
																	 End 							  
	End As NomAux,
	Sum(v.MtoD) As Debe,
	Sum(v.MtoH) As Haber,
	Sum(v.MtoD) - Sum(v.MtoH) As Saldo,
	Sum(v.MtoD_ME) As Debe_ME,
	Sum(v.MtoH_ME) As Haber_ME,
	Sum(v.MtoD_ME) - Sum(v.MtoH_ME) As Saldo_ME
	--,isnull(g.IB_Saldado,0) As IB_Saldado
From 
	Voucher v
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	Left Join 
	(	Select v.RucE,	v.Ejer,	v.NroCta,isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,isnull(v.Cd_TD,'') As Cd_TD,isnull(v.NroSre,'') As NroSre,isnull(v.NroDoc,'') As NroDoc,1 As IB_Saldado
		From Voucher v Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
		Where  v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IB_Anulado,0)<>1 
		and Convert(varchar,v.FecMov,102) between Convert(varchar,@FechaIni,102) and Convert(varchar,@FechaFin,102)
		Group by v.RucE, v.Ejer,	v.NroCta, isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')), isnull(v.Cd_TD,''), isnull(v.NroSre,''), isnull(v.NroDoc,'')
		Having Sum(v.MtoD) - Sum(v.MtoH)=0 and Sum(v.MtoD_ME) - Sum(v.MtoH_ME)=0
	) As g On g.RucE=v.RucE and g.Ejer=v.Ejer and (g.NroCta=v.NroCta and isnull(g.CodAux,'')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc)
	
Where 
	v.RucE=@RucE
	and v.Ejer=@Ejer
	and isnull(v.IB_Anulado,0)<>1
	and Convert(varchar,v.FecMov,102) between Convert(varchar,@FechaIni,102) and Convert(varchar,@FechaFin,102)
	and Case When isnull(@NroCta1,'')<>'' Then v.NroCta Else '' End>=isnull(@NroCta1,'')
	and Case When isnull(@NroCta2,'')<>'' Then v.NroCta Else '' End<=isnull(@NroCta2,'')
	and Case When isnull(@Cd_Prv,'')<>'' Then v.Cd_Prv Else '' End =isnull(@Cd_Prv,'')
Group by 
	v.RucE,
	isnull(c.NDoc,isnull(r.NDoc,'')),
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
																									   Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
																	 End 							  
	End--,
	--g.IB_Saldado

Having
	sum(isnull(g.IB_Saldado,0))=0
	and Sum(v.MtoD) + Sum(v.MtoH)<>0  and Sum(v.MtoD_ME) + Sum(v.MtoH_ME)<>0
	
Order by NomAux

--Jesus : Creado 31/07/2010 -> Se agregaron las variables @FechaIni & @FechaFin para consulta entre rangos
--exec pvo.Rpt_CtasXPagar_CCteResumAmb4_Fec '11111111111','2010','','','','01/01/2010','01/12/2010',null

-- PV:  VIE 06/08/2010 -- Mdf: Error en between de fechas
--CAM VIE 17/09/2010 Modificado quite Auxiliar puse Proveedor2.
--				Cambie parametros @Cd_Aux por @Cd_Prv
--DI 02/08/2011 <Se quito el cambo IB_Saldadp en el Group by y se asigno como Suma en el Having>
GO

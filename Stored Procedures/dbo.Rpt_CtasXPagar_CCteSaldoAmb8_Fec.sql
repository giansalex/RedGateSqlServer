SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXPagar_CCteSaldoAmb8_Fec]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Prv char(7),--Modificado, antes era @Cd_Aux nvarchar(7)
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@FechaIni smalldatetime,
@FechaFin smalldatetime,
@IB_VerSaldados bit,
@msj varchar(100) output
as

/*

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
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha from Empresa where Ruc=@RucE
--TABLA DETALLE
if(@Cd_Prv!='' and @Cd_Prv is not null)
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
			isnull(v.Cd_TD,'') as Cd_TD,isnull(v.NroSre,'') as NroSre,isnull(v.NroDoc,'') as NroDoc,
			--v.RegCtb,
			--v.FecMov,			
			-- DESPUES (MEJORA)
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED,
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaFin,v.FecCbr) else 0 end) as Saldo_Dias,  
			--v.Glosa,
			
			sum(v.MtoD)Debe, 
			sum(v.MtoH)Haber,
			(sum(v.MtoD)-sum(v.MtoH)) as Saldo,
			sum(v.MtoD_ME) Debe_ME,
			sum(v.MtoH_ME) Haber_ME,		
			(sum(v.MtoD_ME)-sum(v.MtoH_ME)) as Saldo_ME

		
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		--left join Proveedor2 as a on a.RucE=v.RucE and a.Cd_Prv=v.Cd_Prv
		left join Cliente2 as c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt --<<-- Nueva Linea
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) 
		and p.IB_CtasXPag=1 /*and v.Cd_Aux= @Cd_Aux*//*==*//*and v.IB_Anulado<>'1'*/ /*and ==*/ 
		and convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and convert(varchar,@FechaFin,102)
		and v.IB_Anulado<>1 and v.Cd_Prv = @Cd_Prv /*v.Cd_Aux= @Cd_Aux*/
			/*and a.NDoc not in (select 	
							a.NDoc
						from voucher as v
						left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
						left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
						where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXPag=1 and v.FecMov <= @FechaAl and v.IB_Anulado<>1 and v.Cd_Aux= @Cd_Aux
						group by a.NDoc
						having (sum(v.MtoD)-sum(v.MtoH))=0
					   )*/
		group by pr.NDoc, pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD,v.NroSre,v.NroDoc,c.NDoc,v.Cd_Clt,v.Cd_Prv,c.ApPat,c.ApMat,c.Nom,c.RSocial--,v.RegCtb,v.FecMov,v.Glosa
		having sum(v.MtoD)-sum(v.MtoH)<>0 or sum(v.MtoD_ME)-sum(v.MtoH_ME) + @VarNum <>0
		order by NomAux
		
end
else
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
			isnull(v.Cd_TD,'') as Cd_TD,isnull(v.NroSre,'') as NroSre,isnull(v.NroDoc,'') as NroDoc,
			--v.RegCtb,
			-- DESPUES (MEJORA)
			--v.FecMov,
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecED,103) else '' end) as FecED,
			Max(case(v.IB_EsProv) when '1' then convert(varchar,v.FecCbr,103) else '' end) as FecVD,
			sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaFin,v.FecCbr) else 0 end) as Saldo_Dias,  
		
			--v.Glosa,
			sum(v.MtoD)Debe, 
			sum(v.MtoH)Haber,
			(sum(v.MtoD)-sum(v.MtoH)) as Saldo,
			sum(v.MtoD_ME) Debe_ME,
			sum(v.MtoH_ME) Haber_ME,		
			(sum(v.MtoD_ME)-sum(v.MtoH_ME)) as Saldo_ME

		
		from voucher as v
		--left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
		--left join Proveedor2 as a on a.RucE=v.RucE and a.Cd_Prv=v.Cd_Prv
		left join Cliente2 as c on c.RucE = v.RucE and c.Cd_Clt = v.Cd_Clt --<<-- Nueva Linea
		left join Proveedor2 as pr on pr.RucE=v.RucE and pr.Cd_Prv=v.Cd_Prv
		left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	
		where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) 
		and p.IB_CtasXPag=1 /*and v.Cd_Aux= @Cd_Aux*//*==*//*and v.IB_Anulado<>'1'*/ /*and ==*/ 
		and convert(varchar,v.FecMov,102) between convert(varchar,@FechaIni,102) and convert(varchar,@FechaFin,102)
		and v.IB_Anulado<>1
			/*and a.NDoc not in (select 	
							a.NDoc
						from voucher as v
						left join Auxiliar as a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
						left join PlanCtas as p on p.RucE=v.RucE and p.NroCta=v.NroCta
						where v.RucE=@RucE and v.Ejer=@Ejer and (v.NroCta between @NroCta1 and @NroCta2) and p.IB_CtasXPag=1 and v.FecMov <= @FechaAl and v.IB_Anulado<>1
						group by a.NDoc
						having (sum(v.MtoD)-sum(v.MtoH))=0
				)*/
		group by pr.NDoc, pr.ApPat,pr.ApMat,pr.Nom,pr.RSocial, v.NroCta, /*v.Cd_Aux,*/ v.Cd_TD,v.NroSre,v.NroDoc,c.NDoc,v.Cd_Clt,v.Cd_Prv,c.ApPat,c.ApMat,c.Nom,c.RSocial--,v.RegCtb,v.FecMov,v.Glosa--, convert(varchar,v.FecMov,103), /*v.FecVD,*/ datediff(day,v.FecMov,@FechaAl) --,v.Cd_MdRg
		having sum(v.MtoD)-sum(v.MtoH)<>0 or sum(v.MtoD_ME)-sum(v.MtoH_ME) + @VarNum <>0
		order by NomAux

end

*/

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
	v.NroCta,
	isnull(v.Cd_TD,'') As Cd_TD,
	isnull(v.NroSre,'') As NroSre,
	isnull(v.NroDoc,'') As NroDoc,
	
	Max(Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecED,103) else '' end) as FecED,
	Max(Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecCbr,103) else '' end) as FecVD,
	
	Sum(case(v.IB_EsProv) when '1' then datediff(day,@FechaFin,v.FecCbr) else 0 end) as Saldo_Dias,  
	
	Sum(v.MtoD) As Debe,
	Sum(v.MtoH) As Haber,
	Sum(v.MtoD) - Sum(v.MtoH) As Saldo,
	
	Sum(v.MtoD_ME) As Debe_ME,
	Sum(v.MtoH_ME) As Haber_ME,
	Sum(v.MtoD_ME) - Sum(v.MtoH_ME) As Saldo_ME
	--@Cd_Mda as Cd_MdRg,
	--Max(Convert(varchar,v.FecMov,103)) As FecMov
	--,isnull(g.IB_Saldado,0) As IB_Saldado
From 
	Voucher v
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	Left Join 
	(	Select v.RucE,	v.Ejer,	v.NroCta,isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,isnull(v.Cd_TD,'') As Cd_TD,isnull(v.NroSre,'') As NroSre,isnull(v.NroDoc,'') As NroDoc,1 As IB_Saldado
		From Voucher v Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
		Where  v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IB_Anulado,0)<>1 and Convert(varchar,v.FecMov,102) between Convert(varchar,@FechaIni,102) and Convert(varchar,@FechaFin,102)
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
	v.NroCta,
	isnull(c.NDoc,isnull(r.NDoc,'')),
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
																									   Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
																	 End 							  
	End,
	isnull(v.Cd_TD,''),
	isnull(v.NroSre,''),
	isnull(v.NroDoc,'')--,
	--Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecED,103) else '' end,
	--Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecCbr,103) else '' end,
	--Convert(varchar,v.FecMov,103),
	--g.IB_Saldado

Having
	Sum(isnull(g.IB_Saldado + Convert(int,@IB_VerSaldados),0))=0
	and (Sum(v.MtoD)+Sum(v.MtoH)<>0 and Sum(v.MtoD_ME)+Sum(v.MtoH_ME)<>0)
	
Order by NomAux,NroDoc

--Pruebas:
--exec dbo.Rpt_CtasXPagar_CCteSaldoAmb7_Fec '11111111111','2010','','','','01/01/2010','01/12/2010',null
--PV: VIE 05/06/2009 : CREADO
--PV: VIE 03/07/2009 : MODF: se arreglo la No_agrupacion por fecha diferente y los saldos dias
--JS: LUN 02/11/2009 : MODF: se arreglo que el reporte no jale los voucher Anulados
--Jesus : Creado 31/07/2010 -> Se agregaron las variables @FechaIni & @FechaFin para consulta entre rangos
-- PV:  VIE 06/08/2010 -- Mdf: Error en between de fechas
--MP: DOM 19-09-2010 -->Modf: Se quito las relaciones con la tabla Auxiliar y se enlazo con Proveedor2
--CM: PR03
--CM: RA01
--DI 02/08/2011 <Se quito el cambo IB_Saldadp en el Group by y se asigno como Suma en el Having>

--print @msj
GO

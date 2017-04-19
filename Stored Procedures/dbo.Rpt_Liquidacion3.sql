SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--DECLARE @RucE nvarchar(11)
--DECLARE @Ejer nvarchar(4)
--DECLARE @FecIni nvarchar(12)
--DECLARE @FecFin nvarchar(12)
--declare @cd_SC nvarchar(16)
--declare @usu nvarchar(15)

--SET @RucE='20111412341'
--SET @Ejer='2011'
--SET @FecIni='01/06/2011'
--SET @FecFin='30/06/2011'
--set @cd_SC='A4'
--set @usu = 'jacho'

CREATE Procedure [dbo].[Rpt_Liquidacion3]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@FecIni nvarchar(12),
@FecFin nvarchar(12),
@cd_SC nvarchar(16),
@usu nvarchar(15)
as


/************Ingresos****************/

select t.*, 
	isnull(v.NroCta,isnull(t.NroCta,'')) as NroCtaAso ,
	isnull(p.NomCta,'Otros Ingresos') as NomCtaAso ,
 	'' As S1,
	'' As S2,
	'' As S3,
	'' As S4,
	'' As S5 
	from
(
Select 
	
	Case When Max(Month(g.FecMov))<Month(@FecIni) Then 'P' Else 'A' End As Ind,
	--Max(v.RegCtb) as RegCtb,
	isnull(t.RegCtb,Max(v.RegCtb)) as RegCtb,
	--v.Cd_Fte,
	max(v.cd_cc) as cd_CC,
	max(v.Cd_SC) as cd_SC,
	isnull(c.NDoc,isnull(r.NDoc,'')) As NDocAux,
	Case When isnull(v.Cd_Clt,'')='' Then isnull(c.CA01,'') Else isnull(r.CA01,'') End +' - '+
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.Nom,'')+' '+isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')) 
																									   Else isnull(r.RSocial,isnull(r.Nom,'')+' '+isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')) 
																	 End 							  
	End As NomAux,
	v.NroCta,
	--Max(Convert(varchar,year(g.FecMov))+' - '+g.Prdo) As Periodo,
	Max(Convert(varchar,year(isnull(g.FecMov,v.FecMov)))+' - '+isnull(g.Prdo,v.Prdo)) As Periodo,
	Max(Convert(varchar,g.FecMov,103)) As FecMov,
	Max(Convert(varchar,v.FecED,103)) As FecED,
	Max(Convert(varchar,v.FecMov,103)) As FecCbr,
	isnull(v.Cd_TD,'') As Cd_TD,
	isnull(v.NroSre,'') As NroSre,
	isnull(v.NroDoc,'') As NroDoc,
	Sum(v.MtoD) As Debe, 
	Sum(v.MtoH) As Haber,
	Sum(v.MtoD)-Sum(v.MtoH) As Saldo,
	'' IB_Saldado



From 
	Voucher v
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	Left Join 
	(	
		select distinct
		v.RucE,
		isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,
		max(convert(nvarchar,f.FecMov,103)) as FecMov,
		max(isnull(f.Prdo,'')) as Prdo,
		v.Ejer,
		v.NroCta,
		v.Cd_TD,
		v.NroSre,
		v.NroDoc
		from Voucher v
			  inner join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1 
			  inner join (select * from Voucher where RucE = @RucE and Ejer = @Ejer and IB_EsProv = 1 /*and Cd_Fte = 'RV'*/) as f on f.RucE = v.RucE and f.Ejer = v.Ejer and f.Cd_TD = v.Cd_TD and f.NroSre = v.NroSre and f.NroDoc = v.NroDoc
		where v.RucE = @RucE and v.Ejer = @Ejer and isnull(v.IB_Anulado,0)<>1

		and v.FecMov between CONVERT(datetime,@FecIni) and CONVERT(datetime,@FecFin)
		and ISNULL(v.Cd_Clt,'')<>'' and ISNULL(v.Cd_Prv,'')<>''
		--and v.NroDoc like '%1666%'
		group by 
		v.RucE,
		isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')),
		Case When isnull(v.IB_EsProv,0)<>1 Then Convert(varchar,v.FecMov,103) Else '' End,
		v.Ejer,
		v.NroCta,
		v.Cd_TD,
		v.NroSre,
		v.NroDoc
		having 
		Sum(v.MtoD)-Sum(v.MtoH)<=0 
		and Sum(v.MtoD)+Sum(v.MtoH)<>0 
	) As g On g.RucE=v.RucE and g.Ejer=v.Ejer and (g.NroCta=v.NroCta and isnull(g.CodAux,'')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc)
	left join
	(
		select v.* from Voucher v where v.RucE = @RucE and v.Ejer = @Ejer and v.Cd_Fte = 'RV'-- and isnull(v.IC_TipAfec,'')<>''
	) as t on t.RucE = v.RucE and t.Ejer = v.Ejer and t.NroDoc = v.NroDoc and t.Cd_TD = v.Cd_TD and t.NroSre = v.NroSre
	--left join PlanCtas p2 on  p2.RucE = v.RucE and p2.Ejer = v.Ejer and p2.NroCta = t.NroCta
Where 
	v.RucE=@RucE
	and v.Ejer=@Ejer
	and v.FecMov between CONVERT(datetime,@FecIni) and CONVERT(datetime,@FecFin)
	and isnull(v.IB_Anulado,0)=0
	and v.Cd_SC = @cd_SC
	--and v.NroDoc like '%1612%'
	and v.Cd_Fte in('CB','LD')
	
Group by
	t.RegCtb,
	isnull(v.Cd_TD,''),
	isnull(v.NroSre,''),
	isnull(v.NroDoc,''),
	v.Cd_Fte,
	isnull(c.NDoc,isnull(r.NDoc,'')),
	Case When isnull(v.Cd_Clt,'')='' Then isnull(c.CA01,'') Else isnull(r.CA01,'') End +' - '+
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.Nom,'')+' '+isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')) 
																									   Else isnull(r.RSocial,isnull(r.Nom,'')+' '+isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')) 
																	 End 							  
	End,
	v.NroCta,
	isnull(t.NroCta,'')
having 
sum(v.MtoH)>0
) as t
left join Voucher v on v.RegCtb = t.RegCtb and v.RucE = @RucE and v.Ejer = @Ejer and isnull(v.IC_TipAfec,'')<>''
left join PlanCtas p on p.RucE = v.RucE and p.Ejer = v.Ejer and p.NroCta = v.NroCta

group by 
t.Ind,t.RegCtb,t.cd_CC,t.Cd_SC,t.NDocAux, t.NomAux,t.NroCta,t.Periodo,t.FecMov,t.FecED,t.FecCbr,t.Cd_TD,t.NroSre,t.NroDoc,t.Debe,t.Haber,t.Saldo,t.IB_Saldado, v.NroCta,p.NomCta

/************Ingresos Pendientes******/

select t.*, 
	isnull(v.NroCta,isnull(t.NroCta,'')) as NroCtaAso ,
	isnull(p.NomCta,'Otros Ingresos') as NomCtaAso ,
 	'' As S1,
	'' As S2,
	'' As S3,
	'' As S4,
	'' As S5 
	from
(
select 
	Case When Max(Month(v.FecMov))<Month(@FecIni) Then 'P' Else 'A' End As Ind,
	max(v.RegCtb) as RegCtb,
	max(v.Cd_CC) as Cd_CC,
	max(v.Cd_SC) as Cd_SC,
	isnull(max(c.NDoc),isnull(max(r.NDoc),'')) as NDocAux,
	Case When isnull(max(v.Cd_Clt),'')='' Then isnull(max(c.CA01),'') Else isnull(max(r.CA01),'') End +' - '+
	Case When isnull(max(v.Cd_Clt),'')='' and isnull(max(v.Cd_Prv),'')='' Then '-- Sin Auxiliar --' 
																Else Case When isnull(max(v.Cd_Clt),'')<>'' Then isnull(max(c.RSocial),isnull(max(c.Nom),'')+' '+isnull(max(c.ApPat),'')+' '+isnull(max(c.ApMat),'')) 
																									   Else isnull(max(r.RSocial),isnull(max(r.Nom),'')+' '+isnull(max(r.ApPat),'')+' '+isnull(max(r.ApMat),'')) 
																	 End 							  
	End As NomAux,
	max(v.Nrocta) as NroCta,
	Max(Convert(varchar,year(isnull(g.FecMov,v.FecMov)))+' - '+isnull(v.Prdo,'')) As Periodo,
	Max(Convert(varchar,g.FecMov,103)) As FecMov,
	Max(Convert(varchar,v.FecED,103)) As FecED,
	Max(Convert(varchar,v.FecMov,103)) As FecCbr,
	isnull(v.Cd_TD,'') As Cd_TD,
	isnull(v.NroSre,'') As NroSre,
	isnull(v.NroDoc,'') As NroDoc,
	sum(v.MtoD) as Debe,
	sum(v.MtoH) as Haber,
	sum(v.MtoD) - sum(v.MtoH) as Saldo,
	0 as Ib_Saldado
	from voucher v 
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE = v.RucE and r.Cd_Prv = v.Cd_Prv 

	inner join
	(
			Select v.RucE,
			Max(Case When isnull(v.IB_EsProv,0)<>1 Then Convert(varchar,v.FecMov,103) Else '' End) As FecMov,
			v.Ejer,
			v.NroCta,
			isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,
			isnull(v.Cd_TD,'') As Cd_TD,
			isnull(v.NroSre,'') As NroSre,
			isnull(v.NroDoc,'') As NroDoc

			From 
			Voucher v Inner Join 
			PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1

			Where  v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IB_Anulado,0)<>1 
			--and isnull(v.IB_Anulado,0)=0
			--and v.NroDoc = '0001668'
			--and v.FecMov between @FecIni and @FecFin
			and v.FecMov <= @FecFin + ' 23:59:29'
			Group by 
			v.RucE, 
			v.Ejer,
			v.NroCta, 
			isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')), 
			isnull(v.Cd_TD,''), 
			isnull(v.NroSre,''), 
			isnull(v.NroDoc,'')
			Having 
			Sum(v.MtoD)-Sum(v.MtoH)>0 and Sum(v.MtoD)+Sum(v.MtoH)<>0 --and Max(Case When isnull(v.IB_EsProv,0)<>1 Then Month(v.FecMov) Else 0 End) between Month(@FecIni) and Month(@FecFin)
			
	) as g On g.RucE=v.RucE and g.Ejer=v.Ejer and g.NroCta=v.NroCta and isnull(g.CodAux,'')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc

	where v.Cd_SC = @Cd_SC 
	--and v.FecMov between @FecIni and @FecFin 
	and v.FecMov <= @FecFin + ' 23:59:29'
	and isnull(v.IB_Anulado,0)<>1
	group by
	v.Cd_TD,
	v.NroSre,
	v.NroDoc
	--,isnull(t.RegCtb,v.RegCtb)
	having 
	sum(v.MtoD) - sum(v.MtoH)>0
) as t
left join Voucher v on v.RegCtb = t.RegCtb and v.RucE = @RucE and v.Ejer = @Ejer and isnull(v.IC_TipAfec,'')<>''
left join PlanCtas p on p.RucE = v.RucE and p.Ejer = v.Ejer and p.NroCta = v.NroCta

group by 
t.Ind,t.RegCtb,t.cd_CC,t.Cd_SC,t.NDocAux, t.NomAux,t.NroCta,t.Periodo,t.FecMov,t.FecED,t.FecCbr,t.Cd_TD,t.NroSre,t.NroDoc,t.Debe,t.Haber,t.Saldo,t.IB_Saldado, v.NroCta,p.NomCta

/************Egresos******************/

select 
	Case When Max(Month(v.FecMov))<Month(@FecIni) Then 'P' Else 'A' End As Ind,
	v.RegCtb,
	v.Cd_CC,
	v.Cd_SC,
	'' as NDocAux,
	v.Glosa as NomAux,
	'' as NroCta,
	Max(Convert(varchar,year(v.FecMov))+' - '+v.Prdo) As Periodo,
	convert(nvarchar,v.FecMov,103) as FecMov,
	max(convert(nvarchar,v.FecEd,103)) as FecED,
	'' as FecCbr,
	max(isnull(v.Cd_Td,'')) as Cd_Td,
	max(isnull(v.NroSre,'')) as NroSre,
	max(isnull(v.NroDoc,'')) as NroDoc,
	sum(v.MtoD) as Debe,
	sum(v.MtoH) as Haber,
	0 - sum(v.MtoH) as Saldo,
	1 as IB_Saldado,
	'' as NroCtaAso,
	'VARIOS' as NomCtaAso,
		'' As S1,
	'' As S2,
	'' As S3,
	'' As S4,
	'' As S5 
	--max(isnull(v.Cd_Prv,'')) as Cd_Prv,
	--v.NroChke
	
from 
	Voucher v
where 
	v.RucE = @RucE
	and v.Ejer=@Ejer
	and v.FecMov between @FecIni and @FecFin
	and v.Cd_SC = @Cd_SC
	and isnull(v.NroChke,'')<>''
	and isnull(v.NroDoc,'')=''
	
group by 
	v.RegCtb, v.FecMov, v.Glosa, v.NroChke, v.Cd_CC,
	v.Cd_SC

having 
	sum(v.MtoD) - sum(v.MtoH) = 0
/**************************************************/

Union All

/***************************************************/
select 
	--t.*,
	MAX(t.Ind) as Ind,
	max(t.RegCtb) as Regctb,
	MAX(t.cd_CC) as Cd_CC,
	MAX(t.cd_SC) as Cd_SC,
	MAX(t.NDocAux) as NDocAux,
	MAX(t.NomAux) as NomAux,
	MAX(t.NroCta) as NroCta,
	MAX(t.Periodo) as Periodo,
	MAX(t.FecMov) as FecMov,
	MAX(t.FecED) as FecED,
	MAX(t.FecCbr) as FecCbr,
	MAX(t.Cd_TD) as Cd_TD,
	MAX(t.NroSre) as NroSre,
	t.NroDoc,
	'Debe' = case when max(t.Debe) <> 0 then 0 else MAX(t.Debe) end ,
	'Haber' = case when max(t.Debe)<> 0 then max(t.Debe) else MAX(t.Haber) end,
	'Saldo' = case when max(t.Debe) <> 0 then -1*MAX(t.Debe) else MAX(t.Saldo)end,	
	--MAX(t.Debe) as Debe,
	--Max(t.Haber) as Haber,
	--MAX(t.Saldo) as Saldo,
	MAX(t.IB_Saldado) as IB_Saldado,
	/*****varios***/	
	max(v.NroCta) as NroCtaAso ,
	isnull(max(p.NomCta),'VARIOS') as NomCtaAso ,
	'' As S1,
	'' As S2,
	'' As S3,
	'' As S4,
	'' As S5 
from

( 
Select 
	Case When Max(Month(v.FecMov))<Month(@FecIni) Then 'P' Else 'A' End As Ind,
	v.IB_EsProv,
	v.RegCtb,
	MAX(v.Cd_CC) as cd_CC,
	MAX(v.Cd_SC) as cd_SC,
	isnull(c.NDoc,isnull(r.NDoc,'')) As NDocAux,
	Case When isnull(v.Cd_Clt,'')='' Then isnull(c.CA01,'') Else isnull(r.CA01,'') End +' - '+
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.Nom,'')+' '+isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')) 
																									   Else isnull(r.RSocial,isnull(r.Nom,'')+' '+isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')) 
																	 End 							  
	End As NomAux,
	v.NroCta,
	--Max(Convert(varchar,year(v.FecMov))+' - '+right('00'+ltrim(Month(v.FecMov)),2)) As Periodo,
	Max(Convert(varchar,year(v.FecMov))+' - '+v.Prdo) As Periodo,
	Max(Convert(varchar,v.FecMov,103)) As FecMov,
	Max(Convert(varchar,v.FecED,103)) As FecED,
	Max(Convert(varchar,g.FecMov,103)) As FecCbr,
	isnull(v.Cd_TD,'') As Cd_TD,
	isnull(v.NroSre,'') As NroSre,
	isnull(v.NroDoc,'') As NroDoc,
	Sum(v.MtoD) As Debe, 
	Sum(v.MtoH) As Haber,
	Sum(v.MtoD)-Sum(v.MtoH) As Saldo,
	isnull(g.IB_Saldado,0) AS IB_Saldado


From 
	Voucher v
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	Left Join 
	(
		Select v.RucE,
		Max(Case When isnull(v.IB_EsProv,0)<>1 Then Convert(varchar,v.FecMov,103) Else '' End) As FecMov,
		v.Ejer,
		v.NroCta,
		isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,
		isnull(v.Cd_TD,'') As Cd_TD,
		isnull(v.NroSre,'') As NroSre,
		isnull(v.NroDoc,'') As NroDoc,
		1 As IB_Saldado
		From Voucher v Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
		Where  v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IB_Anulado,0)<>1 
			and isnull(v.IB_Anulado,0)=0
			--and NroDoc like '%000145%'
			and v.FecMov between @FecIni and @FecFin
			and (ISNULL(v.Cd_Clt,'')<>'' or ISNULL(v.Cd_Prv,'')<>'')
		Group by v.RucE, v.Ejer,v.NroCta, isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')), isnull(v.Cd_TD,''), 
		isnull(v.NroSre,''), 
		isnull(v.NroDoc,'')
		Having 
		Sum(v.MtoD)-Sum(v.MtoH)=0 
		and Sum(v.MtoD)+Sum(v.MtoH)<>0 
	) As g On g.RucE=v.RucE and g.Ejer=v.Ejer and (g.NroCta=v.NroCta and isnull(g.CodAux,'')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc)

Where 
	v.RucE=@RucE
	and v.Ejer=@Ejer
	--and Convert(datetime,v.FecMov,103) <= @FecFin--'30/04/2011'
	and v.FecMov between @FecIni and @FecFin
	--and isnull(v.IB_EsProv,0)=1
	and isnull(v.IB_Anulado,0)=0
	and v.Cd_SC = @cd_SC

Group by
	v.RegCtb,
	v.IB_EsProv,
	isnull(c.NDoc,isnull(r.NDoc,'')),
	Case When isnull(v.Cd_Clt,'')='' Then isnull(c.CA01,'') Else isnull(r.CA01,'') End +' - '+
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.Nom,'')+' '+isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')) 
																									   Else isnull(r.RSocial,isnull(r.Nom,'')+' '+isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')) 
																	 End 							  
	End,
	v.NroCta,
	isnull(v.Cd_TD,''),
	isnull(v.NroSre,''),
	isnull(v.NroDoc,''),
	g.IB_Saldado
Having 
	isnull(g.IB_Saldado,0)=1

) as t	
left join Voucher v on v.RegCtb = t.RegCtb and v.RucE = @RucE and v.Ejer = @Ejer and isnull(v.IC_TipAfec,'')<>''
left join PlanCtas p on p.RucE = v.RucE and p.Ejer = v.Ejer and p.NroCta = v.NroCta

group by 
--t.Ind,t.RegCtb,t.IB_EsProv ,t.cd_CC,t.Cd_SC,t.NDocAux, t.NomAux,t.NroCta,t.Periodo,t.FecMov,t.FecED,t.FecCbr,t.Cd_TD,t.NroSre,t.NroDoc,t.Debe,t.Haber,t.Saldo,t.IB_Saldado, v.NroCta,p.NomCta
t.NroDoc,t.Periodo,t.NomAux

order by
Periodo Desc,
NomAux



/************Egresos Pendientes*******/

Select 
	Case When Max(Month(v.FecMov))<Month(@FecIni) Then 'P' Else 'A' End As Ind,
	v.RegCtb,
	MAX(v.Cd_CC) as cd_CC,
	MAX(v.Cd_SC) as cd_SC,
	isnull(c.NDoc,isnull(r.NDoc,'')) As NDocAux,
	Case When isnull(v.Cd_Clt,'')='' Then isnull(c.CA01,'') Else isnull(r.CA01,'') End +' - '+
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.Nom,'')+' '+isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')) 
																									   Else isnull(r.RSocial,isnull(r.Nom,'')+' '+isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')) 
																	 End 							  
	End As NomAux,
	v.NroCta,
	--Max(Convert(varchar,year(v.FecMov))+' - '+right('00'+ltrim(Month(v.FecMov)),2)) As Periodo,
	Max(Convert(varchar,year(v.FecMov))+' - '+v.Prdo) As Periodo,
	Max(Convert(varchar,v.FecMov,103)) As FecMov,
	Max(Convert(varchar,v.FecED,103)) As FecED,
	Max(Convert(varchar,g.FecMov,103)) As FecCbr,
	isnull(v.Cd_TD,'') As Cd_TD,
	isnull(v.NroSre,'') As NroSre,
	isnull(v.NroDoc,'') As NroDoc,
	Sum(v.MtoD) As Debe, Sum(v.MtoH) As Haber,
	Sum(v.MtoD)-Sum(v.MtoH) As Saldo,
	isnull(g.IB_Saldado,0) AS IB_Saldado,
	isnull(t.NroCta,'') As NroCtaAso,
	isnull(p2.NomCta,Case When v.Prdo='00' Then 'Periodo Inicial' Else '' End) As NomCtaAso,
	'' As S1,
	'' As S2,
	'' As S3,
	'' As S4,
	'' As S5
From 
	Voucher v
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	inner Join 
	(	Select v.RucE,
		Max(Case When isnull(v.IB_EsProv,0)<>1 Then Convert(varchar,v.FecMov,103) Else '' End) As FecMov,
		v.Ejer,v.NroCta,isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,isnull(v.Cd_TD,'') As Cd_TD,isnull(v.NroSre,'') As NroSre,isnull(v.NroDoc,'') As NroDoc,1 As IB_Saldado
		From Voucher v Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
		Where  v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IB_Anulado,0)<>1 
			and isnull(v.IB_Anulado,0)=0
			and v.FecMov <= @FecFin
		Group by v.RucE, v.Ejer,	v.NroCta, isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')), isnull(v.Cd_TD,''), isnull(v.NroSre,''), isnull(v.NroDoc,'')
		Having Sum(v.MtoD)-Sum(v.MtoH)>=0 and Sum(v.MtoD)+Sum(v.MtoH)<>0 --and Max(Case When isnull(v.IB_EsProv,0)<>1 Then Month(v.FecMov) Else 0 End) between Month(@FecIni) and Month(@FecFin)
	) As g On g.RucE=v.RucE and g.Ejer=v.Ejer and (g.NroCta=v.NroCta and isnull(g.CodAux,'')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc)
	Left Join
	(	Select v.* From Voucher v Where v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IC_TipAfec,'')<>''
	) As t On t.RucE=v.RucE and t.Ejer=v.Ejer and t.RegCtb=v.RegCtb
	Left Join PlanCtas p2 On p2.RucE=t.RucE and p2.Ejer=t.Ejer and p2.NroCta=t.NroCta
Where 
	v.RucE=@RucE
	and v.Ejer=@Ejer
	--and Convert(datetime,v.FecMov,103) <= @FecFin--'30/04/2011'
	--and v.FecMov between @FecIni and @FecFin
	and v.FecMov <= @FecFin
	and isnull(v.IB_EsProv,0)=1
	and isnull(v.IB_Anulado,0)=0
	and v.Cd_SC = @cd_SC
Group by
	v.RegCtb,
	isnull(c.NDoc,isnull(r.NDoc,'')),
	Case When isnull(v.Cd_Clt,'')='' Then isnull(c.CA01,'') Else isnull(r.CA01,'') End +' - '+
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.Nom,'')+' '+isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')) 
																									   Else isnull(r.RSocial,isnull(r.Nom,'')+' '+isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')) 
																	 End 							  
	End,
	v.NroCta,
	isnull(v.Cd_TD,''),
	isnull(v.NroSre,''),
	isnull(v.NroDoc,''),
	g.IB_Saldado,
	isnull(t.NroCta,'')
	,isnull(p2.NomCta,Case When v.Prdo='00' Then 'Periodo Inicial' Else '' End)
Having 
	isnull(g.IB_Saldado,0)=0 and isnull(p2.NomCta,Case When v.Prdo='00' Then 'Periodo Inicial' Else '' End)<>''
Order by 
	Periodo Desc,
	NomAux
	,isnull(p2.NomCta,Case When v.Prdo='00' Then 'Periodo Inicial' Else '' End)

/*************** Ingresos Servicios *********/

Select 
	v.Cd_Vta,v.RegCtb,v.Cd_TD,v.NroSre,v.NroDoc,d.Nro_RegVdt,
	d.Cd_Srv,isnull(s.CA01,'') As IndSrv,
	s.Nombre As NomSrv,
	v.Cd_SC,
	d.Total
From 
	Venta v
	Left Join VentaDet d On d.RucE=v.RucE and d.Cd_Vta=v.Cd_Vta
	Left Join Servicio2 s On s.RucE=d.RucE and s.Cd_Srv=d.Cd_Srv
Where v.RucE=@RucE and v.Eje=@Ejer and isnull(v.IB_Anulado,0)<>1 and v.Cd_SC = @cd_SC

/****************Otros Datos*****************************/

select NomComp, '' As IF01,'' As IF02,'' As IF03,'' As IF04,'' As IF05, (select top 1 Descrip from CCSub where RucE = @RucE and Cd_SC = @cd_SC group by Descrip) as IF06, '' as IF07 from Usuario where NomUsu = @usu

/*****************Saldo Anterior***************************/
declare @dato_1_R float
declare @dato_2_R float

declare @dato_7_R float
declare @dato_8_R float
declare @Prdo nvarchar(2)
declare @NroCta nvarchar(11)

if(month(@FecIni)<10)
begin
set @Prdo = '0'+Convert(nvarchar,month(@FecIni)-1)
end
else
begin
set @Prdo = Convert(nvarchar,month(@FecIni)-1)
end


if(@RucE ='20524012325')
begin
set @NroCta = '10.4.1.10'
end
else 
	if(@RucE ='20522703673')
	begin
	set @NroCta = '10.4.1.10'
	end
	else
		if(@RucE ='20111412341')
		begin
			if(@cd_SC = 'A4')
			begin
			set @NroCta = '10.4.1.06'
			end
			else
			begin
			set @NroCta = '' 
			end
		end
		
		
		
		
set @dato_1_R = 
(
select	
		Sum(v.MtoD-v.MtoH) as Saldo
	from Voucher v 
	where v.RucE=@RucE and Ejer<=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and  v.Prdo not in ('13','14') and
		(   (Ejer=@Ejer and Prdo<@Prdo)
		 or (Ejer<@Ejer)
		)
)

set @dato_2_R = 
(
	select	
		Sum(v.MtoD-v.MtoH) as Saldo
	from Voucher v 
	where v.RucE=@RucE and Ejer=@Ejer and v.Prdo=@Prdo and v.NroCta=@NroCta and v.IB_Anulado<>1  and v.Prdo not in ('13','14')
)

set @dato_7_R = 
(
	select	
		Sum(v.MtoD-v.MtoH) as Saldo
	from Voucher v 
		where v.RucE=@RucE and Ejer<=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and  v.Prdo not in ('13','14')
		and ((isnull(v.IB_Conc,0)=0 and ((Ejer=@Ejer and v.Prdo<@Prdo) or (Ejer<@Ejer))) or (isnull(v.IB_Conc,0)=1 and Ejer=@Ejer and Prdo<@Prdo and ((year(v.FecConc)=@Ejer and month(v.FecConc)>convert(int,@Prdo)) or (year(v.FecConc)>@Ejer))))
) 


set @dato_8_R =
(		
	select	
		Sum(v.MtoD-v.MtoH) as Saldo
	from Voucher v 
	where v.RucE=@RucE and v.Ejer=@Ejer and v.NroCta=@NroCta and v.IB_Anulado<>1 and v.Prdo=@Prdo and v.Prdo not in ('13','14') 
		and ( (isnull(v.IB_Conc,0)=0)
		 	or (v.Ejer=@Ejer and v.Prdo=@Prdo and month(v.FecConc)>convert(int,@Prdo) and v.IB_Conc=1))
) 


Select (isnull(@dato_1_R,0) + isnull(@dato_2_R,0))-(isnull(@dato_7_R,0)+isnull(@dato_8_R,0)) as SaldoAnterior


--select SUM(T.Saldo) as SaldoAnterior
--from
--(

--select t.*, 
--	isnull(v.NroCta,isnull(t.NroCta,'')) as NroCtaAso ,
--	isnull(p.NomCta,'Otros Ingresos') as NomCtaAso ,
-- 	'' As S1,
--	'' As S2,
--	'' As S3,
--	'' As S4,
--	'' As S5 
--	from
--(
--Select 
	
--	Case When Max(Month(g.FecMov))<Month(@FecIni) Then 'P' Else 'A' End As Ind,
--	--Max(v.RegCtb) as RegCtb,
--	isnull(t.RegCtb,Max(v.RegCtb)) as RegCtb,
--	--v.Cd_Fte,
--	max(v.cd_cc) as cd_CC,
--	max(v.Cd_SC) as cd_SC,
--	isnull(c.NDoc,isnull(r.NDoc,'')) As NDocAux,
--	Case When isnull(v.Cd_Clt,'')='' Then isnull(c.CA01,'') Else isnull(r.CA01,'') End +' - '+
--	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
--																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.Nom,'')+' '+isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')) 
--																									   Else isnull(r.RSocial,isnull(r.Nom,'')+' '+isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')) 
--																	 End 							  
--	End As NomAux,
--	v.NroCta,
--	--Max(Convert(varchar,year(g.FecMov))+' - '+g.Prdo) As Periodo,
--	Max(Convert(varchar,year(isnull(g.FecMov,v.FecMov)))+' - '+isnull(g.Prdo,v.Prdo)) As Periodo,
--	Max(Convert(varchar,g.FecMov,103)) As FecMov,
--	Max(Convert(varchar,v.FecED,103)) As FecED,
--	Max(Convert(varchar,v.FecMov,103)) As FecCbr,
--	isnull(v.Cd_TD,'') As Cd_TD,
--	isnull(v.NroSre,'') As NroSre,
--	isnull(v.NroDoc,'') As NroDoc,
--	Sum(v.MtoD) As Debe, 
--	Sum(v.MtoH) As Haber,
--	Sum(v.MtoD)-Sum(v.MtoH) As Saldo,
--	'' IB_Saldado



--From 
--	Voucher v
--	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
--	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
--	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
--	Left Join 
--	(	
--		select distinct
--		v.RucE,
--		isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,
--		max(convert(nvarchar,f.FecMov,103)) as FecMov,
--		max(isnull(f.Prdo,'')) as Prdo,
--		v.Ejer,
--		v.NroCta,
--		v.Cd_TD,
--		v.NroSre,
--		v.NroDoc
--		from Voucher v
--			  inner join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1 
--			  inner join (select * from Voucher where RucE = @RucE and Ejer = @Ejer and IB_EsProv = 1 /*and Cd_Fte = 'RV'*/) as f on f.RucE = v.RucE and f.Ejer = v.Ejer and f.Cd_TD = v.Cd_TD and f.NroSre = v.NroSre and f.NroDoc = v.NroDoc
--		where v.RucE = @RucE and v.Ejer = @Ejer and isnull(v.IB_Anulado,0)<>1

--		and v.FecMov < CONVERT(datetime,@FecFin)
--		--and v.NroDoc like '%1666%'
--		group by 
--		v.RucE,
--		isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')),
--		Case When isnull(v.IB_EsProv,0)<>1 Then Convert(varchar,v.FecMov,103) Else '' End,
--		v.Ejer,
--		v.NroCta,
--		v.Cd_TD,
--		v.NroSre,
--		v.NroDoc
--		having 
--		Sum(v.MtoD)-Sum(v.MtoH)<=0 
--		and Sum(v.MtoD)+Sum(v.MtoH)<>0 
--	) As g On g.RucE=v.RucE and g.Ejer=v.Ejer and (g.NroCta=v.NroCta and isnull(g.CodAux,'')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc)
--	left join
--	(
--		select v.* from Voucher v where v.RucE = @RucE and v.Ejer = @Ejer and v.Cd_Fte = 'RV'-- and isnull(v.IC_TipAfec,'')<>''
--	) as t on t.RucE = v.RucE and t.Ejer = v.Ejer and t.NroDoc = v.NroDoc and t.Cd_TD = v.Cd_TD and t.NroSre = v.NroSre
--	--left join PlanCtas p2 on  p2.RucE = v.RucE and p2.Ejer = v.Ejer and p2.NroCta = t.NroCta
--Where 
--	v.RucE=@RucE
--	and v.Ejer=@Ejer
--	and v.FecMov < CONVERT(datetime,@FecFin)
--	and isnull(v.IB_Anulado,0)=0
--	and v.Cd_SC = @cd_SC
--	--and v.NroDoc like '%1612%'
--	and v.Cd_Fte = 'CB'
	
--Group by
--	t.RegCtb,
--	isnull(v.Cd_TD,''),
--	isnull(v.NroSre,''),
--	isnull(v.NroDoc,''),
--	v.Cd_Fte,
--	isnull(c.NDoc,isnull(r.NDoc,'')),
--	Case When isnull(v.Cd_Clt,'')='' Then isnull(c.CA01,'') Else isnull(r.CA01,'') End +' - '+
--	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
--																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.Nom,'')+' '+isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')) 
--																									   Else isnull(r.RSocial,isnull(r.Nom,'')+' '+isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')) 
--																	 End 							  
--	End,
--	v.NroCta,
--	isnull(t.NroCta,'')
--having 
--sum(v.MtoH)>0
--) as t
--left join Voucher v on v.RegCtb = t.RegCtb and v.RucE = @RucE and v.Ejer = @Ejer and isnull(v.IC_TipAfec,'')<>''
--left join PlanCtas p on p.RucE = v.RucE and p.Ejer = v.Ejer and p.NroCta = v.NroCta

--group by 
--t.Ind,t.RegCtb,t.cd_CC,t.Cd_SC,t.NDocAux, t.NomAux,t.NroCta,t.Periodo,t.FecMov,t.FecED,t.FecCbr,t.Cd_TD,t.NroSre,t.NroDoc,t.Debe,t.Haber,t.Saldo,t.IB_Saldado, v.NroCta,p.NomCta

--union all


--select 
--	Case When Max(Month(v.FecMov))<Month(@FecIni) Then 'P' Else 'A' End As Ind,
--	v.RegCtb,
--	v.Cd_CC,
--	v.Cd_SC,
--	'' as NDocAux,
--	v.Glosa as NomAux,
--	'' as NroCta,
--	Max(Convert(varchar,year(v.FecMov))+' - '+v.Prdo) As Periodo,
--	convert(nvarchar,v.FecMov,103) as FecMov,
--	max(convert(nvarchar,v.FecEd,103)) as FecED,
--	'' as FecCbr,
--	max(isnull(v.Cd_Td,'')) as Cd_Td,
--	max(isnull(v.NroSre,'')) as NroSre,
--	max(isnull(v.NroDoc,'')) as NroDoc,
--	sum(v.MtoD) as Debe,
--	sum(v.MtoH) as Haber,
--	0 - sum(v.MtoH) as Saldo,
--	1 as IB_Saldado,
--	'' as NroCtaAso,
--	'VARIOS' as NomCtaAso,
--		'' As S1,
--	'' As S2,
--	'' As S3,
--	'' As S4,
--	'' As S5 
--	--max(isnull(v.Cd_Prv,'')) as Cd_Prv,
--	--v.NroChke
	
--from 
--	Voucher v
--where 
--	v.RucE = @RucE
--	and v.Ejer=@Ejer
--	and v.FecMov between @FecIni and @FecFin
--	and v.Cd_SC = @Cd_SC
--	and isnull(v.NroChke,'')<>''
--	and isnull(v.NroDoc,'')=''
	
--group by 
--	v.RegCtb, v.FecMov, v.Glosa, v.NroChke, v.Cd_CC,
--	v.Cd_SC

--having 
--	sum(v.MtoD) - sum(v.MtoH) = 0
--/**************************************************/

--Union All

--/***************************************************/
--select 
--	--t.*,
--	MAX(t.Ind) as Ind,
--	max(t.RegCtb) as Regctb,
--	MAX(t.cd_CC) as Cd_CC,
--	MAX(t.cd_SC) as Cd_SC,
--	MAX(t.NDocAux) as NDocAux,
--	MAX(t.NomAux) as NomAux,
--	MAX(t.NroCta) as NroCta,
--	MAX(t.Periodo) as Periodo,
--	MAX(t.FecMov) as FecMov,
--	MAX(t.FecED) as FecED,
--	MAX(t.FecCbr) as FecCbr,
--	MAX(t.Cd_TD) as Cd_TD,
--	MAX(t.NroSre) as NroSre,
--	t.NroDoc,
--	'Debe' = case when max(t.Debe) <> 0 then 0 else MAX(t.Debe) end ,
--	'Haber' = case when max(t.Debe)<> 0 then max(t.Debe) else MAX(t.Haber) end,
--	'Saldo' = case when max(t.Debe) <> 0 then -1*MAX(t.Debe) else MAX(t.Saldo)end,	
--	--MAX(t.Debe) as Debe,
--	--Max(t.Haber) as Haber,
--	--MAX(t.Saldo) as Saldo,
--	MAX(t.IB_Saldado) as IB_Saldado,
--	/*****varios***/	
--	max(v.NroCta) as NroCtaAso ,
--	isnull(max(p.NomCta),'VARIOS') as NomCtaAso ,
--	'' As S1,
--	'' As S2,
--	'' As S3,
--	'' As S4,
--	'' As S5 
--from

--( 
--Select 
--	Case When Max(Month(v.FecMov))<Month(@FecIni) Then 'P' Else 'A' End As Ind,
--	v.IB_EsProv,
--	v.RegCtb,
--	MAX(v.Cd_CC) as cd_CC,
--	MAX(v.Cd_SC) as cd_SC,
--	isnull(c.NDoc,isnull(r.NDoc,'')) As NDocAux,
--	Case When isnull(v.Cd_Clt,'')='' Then isnull(c.CA01,'') Else isnull(r.CA01,'') End +' - '+
--	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
--																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.Nom,'')+' '+isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')) 
--																									   Else isnull(r.RSocial,isnull(r.Nom,'')+' '+isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')) 
--																	 End 							  
--	End As NomAux,
--	v.NroCta,
--	--Max(Convert(varchar,year(v.FecMov))+' - '+right('00'+ltrim(Month(v.FecMov)),2)) As Periodo,
--	Max(Convert(varchar,year(v.FecMov))+' - '+v.Prdo) As Periodo,
--	Max(Convert(varchar,v.FecMov,103)) As FecMov,
--	Max(Convert(varchar,v.FecED,103)) As FecED,
--	Max(Convert(varchar,g.FecMov,103)) As FecCbr,
--	isnull(v.Cd_TD,'') As Cd_TD,
--	isnull(v.NroSre,'') As NroSre,
--	isnull(v.NroDoc,'') As NroDoc,
--	Sum(v.MtoD) As Debe, 
--	Sum(v.MtoH) As Haber,
--	Sum(v.MtoD)-Sum(v.MtoH) As Saldo,
--	isnull(g.IB_Saldado,0) AS IB_Saldado


--From 
--	Voucher v
--	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
--	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
--	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
--	Left Join 
--	(
--		Select v.RucE,
--		Max(Case When isnull(v.IB_EsProv,0)<>1 Then Convert(varchar,v.FecMov,103) Else '' End) As FecMov,
--		v.Ejer,
--		v.NroCta,
--		isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,
--		isnull(v.Cd_TD,'') As Cd_TD,
--		isnull(v.NroSre,'') As NroSre,
--		isnull(v.NroDoc,'') As NroDoc,
--		1 As IB_Saldado
--		From Voucher v Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
--		Where  v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IB_Anulado,0)<>1 
--			and isnull(v.IB_Anulado,0)=0
--			--and NroDoc like '%000145%'
--			and v.FecMov < @FecFin
--		Group by v.RucE, v.Ejer,v.NroCta, isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')), isnull(v.Cd_TD,''), 
--		isnull(v.NroSre,''), 
--		isnull(v.NroDoc,'')
--		Having 
--		Sum(v.MtoD)-Sum(v.MtoH)=0 
--		and Sum(v.MtoD)+Sum(v.MtoH)<>0 
--	) As g On g.RucE=v.RucE and g.Ejer=v.Ejer and (g.NroCta=v.NroCta and isnull(g.CodAux,'')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc)

--Where 
--	v.RucE=@RucE
--	and v.Ejer=@Ejer
--	--and Convert(datetime,v.FecMov,103) <= @FecFin--'30/04/2011'
--	and v.FecMov < @FecFin
--	--and isnull(v.IB_EsProv,0)=1
--	and isnull(v.IB_Anulado,0)=0
--	and v.Cd_SC = @cd_SC

--Group by
--	v.RegCtb,
--	v.IB_EsProv,
--	isnull(c.NDoc,isnull(r.NDoc,'')),
--	Case When isnull(v.Cd_Clt,'')='' Then isnull(c.CA01,'') Else isnull(r.CA01,'') End +' - '+
--	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
--																Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.Nom,'')+' '+isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')) 
--																									   Else isnull(r.RSocial,isnull(r.Nom,'')+' '+isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')) 
--																	 End 							  
--	End,
--	v.NroCta,
--	isnull(v.Cd_TD,''),
--	isnull(v.NroSre,''),
--	isnull(v.NroDoc,''),
--	g.IB_Saldado
--Having 
--	isnull(g.IB_Saldado,0)=1

--) as t	
--left join Voucher v on v.RegCtb = t.RegCtb and v.RucE = @RucE and v.Ejer = @Ejer and isnull(v.IC_TipAfec,'')<>''
--left join PlanCtas p on p.RucE = v.RucE and p.Ejer = v.Ejer and p.NroCta = v.NroCta

--group by 
----t.Ind,t.RegCtb,t.IB_EsProv ,t.cd_CC,t.Cd_SC,t.NDocAux, t.NomAux,t.NroCta,t.Periodo,t.FecMov,t.FecED,t.FecCbr,t.Cd_TD,t.NroSre,t.NroDoc,t.Debe,t.Haber,t.Saldo,t.IB_Saldado, v.NroCta,p.NomCta
--t.NroDoc,t.Periodo,t.NomAux

--) as T


--Cread0 por Javier
--10/08/2011
--Prueba
--Exec Rpt_Liquidacion3 '20111412341','2011','01/09/2011','30/09/2011','01010101','jacho'

GO

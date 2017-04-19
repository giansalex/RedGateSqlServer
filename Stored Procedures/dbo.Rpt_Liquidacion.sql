SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--DECLARE @RucE nvarchar(11)
--DECLARE @Ejer nvarchar(4)
--DECLARE @FecIni nvarchar(12)
--DECLARE @FecFin nvarchar(12)

--SET @RucE='20111412341'
--SET @Ejer='2011'
--SET @FecIni='01/04/2011'
--SET @FecFin='30/04/2011'


CREATE Procedure [dbo].[Rpt_Liquidacion]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@FecIni nvarchar(12),
@FecFin nvarchar(12)

as

--********************************** INGRESOS SALDADOS **********************************

Select 
	Case When Max(Month(v.FecMov))<Month(@FecIni) Then 'P' Else 'A' End As Ind,
	v.RegCtb,
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
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	Left Join 
	(	Select v.RucE,
		Max(Case When isnull(v.IB_EsProv,0)<>1 Then Convert(varchar,v.FecMov,103) Else '' End) As FecMov,
		v.Ejer,v.NroCta,isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,isnull(v.Cd_TD,'') As Cd_TD,isnull(v.NroSre,'') As NroSre,isnull(v.NroDoc,'') As NroDoc,1 As IB_Saldado
		From Voucher v Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
		Where  v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IB_Anulado,0)<>1 
			and isnull(v.IB_Anulado,0)=0
		Group by v.RucE, v.Ejer,	v.NroCta, isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')), isnull(v.Cd_TD,''), isnull(v.NroSre,''), isnull(v.NroDoc,'')
		Having Sum(v.MtoD)-Sum(v.MtoH)=0 and Sum(v.MtoD)+Sum(v.MtoH)<>0 and Max(Case When isnull(v.IB_EsProv,0)<>1 Then Month(v.FecMov) Else 0 End) between Month(@FecIni) and Month(@FecFin)
	) As g On g.RucE=v.RucE and g.Ejer=v.Ejer and (g.NroCta=v.NroCta and isnull(g.CodAux,'')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc)
	Left Join
	(	Select v.* From Voucher v Where v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IC_TipAfec,'')<>''
	) As t On t.RucE=v.RucE and t.Ejer=v.Ejer and t.RegCtb=v.RegCtb
	Left Join PlanCtas p2 On p2.RucE=t.RucE and p2.Ejer=t.Ejer and p2.NroCta=t.NroCta
Where 
	v.RucE=@RucE
	and v.Ejer=@Ejer
	--and Convert(datetime,v.FecMov,103) between '01/04/2011' and '30/04/2011'
	and isnull(v.IB_EsProv,0)=1
	and isnull(v.IB_Anulado,0)=0
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
	isnull(t.NroCta,''),
	isnull(p2.NomCta,Case When v.Prdo='00' Then 'Periodo Inicial' Else '' End)
Having 
	isnull(g.IB_Saldado,0)=1 --and isnull(p2.NomCta,'')<>''
Order by 
	Periodo Desc,
	NomAux,
	isnull(p2.NomCta,Case When v.Prdo='00' Then 'Periodo Inicial' Else '' End)
	
	
--********************************** INGRESOS PENDIENTES **********************************	

Select 
	Case When Max(Month(v.FecMov))<Month(@FecIni) Then 'P' Else 'A' End As Ind,
	v.RegCtb,
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
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	Left Join 
	(	Select v.RucE,
		Max(Case When isnull(v.IB_EsProv,0)<>1 Then Convert(varchar,v.FecMov,103) Else '' End) As FecMov,
		v.Ejer,v.NroCta,isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,isnull(v.Cd_TD,'') As Cd_TD,isnull(v.NroSre,'') As NroSre,isnull(v.NroDoc,'') As NroDoc,1 As IB_Saldado
		From Voucher v Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
		Where  v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IB_Anulado,0)<>1 
			and isnull(v.IB_Anulado,0)=0
		Group by v.RucE, v.Ejer,	v.NroCta, isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')), isnull(v.Cd_TD,''), isnull(v.NroSre,''), isnull(v.NroDoc,'')
		Having Sum(v.MtoD)-Sum(v.MtoH)=0 and Sum(v.MtoD)+Sum(v.MtoH)<>0 and Max(Case When isnull(v.IB_EsProv,0)<>1 Then Month(v.FecMov) Else 0 End) between Month(@FecIni) and Month(@FecFin)
	) As g On g.RucE=v.RucE and g.Ejer=v.Ejer and (g.NroCta=v.NroCta and isnull(g.CodAux,'')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc)
	Left Join
	(	Select v.* From Voucher v Where v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IC_TipAfec,'')<>''
	) As t On t.RucE=v.RucE and t.Ejer=v.Ejer and t.RegCtb=v.RegCtb
	Left Join PlanCtas p2 On p2.RucE=t.RucE and p2.Ejer=t.Ejer and p2.NroCta=t.NroCta
Where 
	v.RucE=@RucE
	and v.Ejer=@Ejer
	--and Convert(datetime,v.FecMov,103) between '01/04/2011' and '30/04/2011'
	and isnull(v.IB_EsProv,0)=1
	and isnull(v.IB_Anulado,0)=0
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
	isnull(t.NroCta,''),
	isnull(p2.NomCta,Case When v.Prdo='00' Then 'Periodo Inicial' Else '' End)
Having 
	isnull(g.IB_Saldado,0)=0 and isnull(p2.NomCta,Case When v.Prdo='00' Then 'Periodo Inicial' Else '' End)<>''
Order by 
	Periodo Desc,
	NomAux,
	isnull(p2.NomCta,Case When v.Prdo='00' Then 'Periodo Inicial' Else '' End)
	
	
	
	
--********************************** EGRESOS SALDADOS **********************************	



Select 
	Case When Max(Month(v.FecMov))<Month(@FecIni) Then 'P' Else 'A' End As Ind,
	v.RegCtb,
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
	Left Join 
	(	Select v.RucE,
		Max(Case When isnull(v.IB_EsProv,0)<>1 Then Convert(varchar,v.FecMov,103) Else '' End) As FecMov,
		v.Ejer,v.NroCta,isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,isnull(v.Cd_TD,'') As Cd_TD,isnull(v.NroSre,'') As NroSre,isnull(v.NroDoc,'') As NroDoc,1 As IB_Saldado
		From Voucher v Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
		Where  v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IB_Anulado,0)<>1 
			and isnull(v.IB_Anulado,0)=0
		Group by v.RucE, v.Ejer,	v.NroCta, isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')), isnull(v.Cd_TD,''), isnull(v.NroSre,''), isnull(v.NroDoc,'')
		Having Sum(v.MtoD)-Sum(v.MtoH)=0 and Sum(v.MtoD)+Sum(v.MtoH)<>0 and Max(Case When isnull(v.IB_EsProv,0)<>1 Then Month(v.FecMov) Else 0 End) between Month(@FecIni) and Month(@FecFin)
	) As g On g.RucE=v.RucE and g.Ejer=v.Ejer and (g.NroCta=v.NroCta and isnull(g.CodAux,'')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc)
	Left Join
	(	Select v.* From Voucher v Where v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IC_TipAfec,'')<>''
	) As t On t.RucE=v.RucE and t.Ejer=v.Ejer and t.RegCtb=v.RegCtb
	Left Join PlanCtas p2 On p2.RucE=t.RucE and p2.Ejer=t.Ejer and p2.NroCta=t.NroCta
Where 
	v.RucE=@RucE
	and v.Ejer=@Ejer
	and Convert(datetime,v.FecMov,103) <= @FecFin--'30/04/2011'
	and isnull(v.IB_EsProv,0)=1
	and isnull(v.IB_Anulado,0)=0
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
	isnull(t.NroCta,''),
	isnull(p2.NomCta,Case When v.Prdo='00' Then 'Periodo Inicial' Else '' End)
Having 
	isnull(g.IB_Saldado,0)=1 --and isnull(p2.NomCta,'')<>''
Order by 
	Periodo Desc,
	NomAux,
	isnull(p2.NomCta,Case When v.Prdo='00' Then 'Periodo Inicial' Else '' End)
	
	
	
--********************************** INGRESOS PENDIENTES **********************************	

Select 
	Case When Max(Month(v.FecMov))<Month(@FecIni) Then 'P' Else 'A' End As Ind,
	v.RegCtb,
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
	Left Join 
	(	Select v.RucE,
		Max(Case When isnull(v.IB_EsProv,0)<>1 Then Convert(varchar,v.FecMov,103) Else '' End) As FecMov,
		v.Ejer,v.NroCta,isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,isnull(v.Cd_TD,'') As Cd_TD,isnull(v.NroSre,'') As NroSre,isnull(v.NroDoc,'') As NroDoc,1 As IB_Saldado
		From Voucher v Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
		Where  v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IB_Anulado,0)<>1 
			and isnull(v.IB_Anulado,0)=0
		Group by v.RucE, v.Ejer,	v.NroCta, isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')), isnull(v.Cd_TD,''), isnull(v.NroSre,''), isnull(v.NroDoc,'')
		Having Sum(v.MtoD)-Sum(v.MtoH)=0 and Sum(v.MtoD)+Sum(v.MtoH)<>0 and Max(Case When isnull(v.IB_EsProv,0)<>1 Then Month(v.FecMov) Else 0 End) between Month(@FecIni) and Month(@FecFin)
	) As g On g.RucE=v.RucE and g.Ejer=v.Ejer and (g.NroCta=v.NroCta and isnull(g.CodAux,'')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc)
	Left Join
	(	Select v.* From Voucher v Where v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IC_TipAfec,'')<>''
	) As t On t.RucE=v.RucE and t.Ejer=v.Ejer and t.RegCtb=v.RegCtb
	Left Join PlanCtas p2 On p2.RucE=t.RucE and p2.Ejer=t.Ejer and p2.NroCta=t.NroCta
Where 
	v.RucE=@RucE
	and v.Ejer=@Ejer
	and Convert(datetime,v.FecMov,103) <= @FecFin--'30/04/2011'
	and isnull(v.IB_EsProv,0)=1
	and isnull(v.IB_Anulado,0)=0
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
	isnull(t.NroCta,''),
	isnull(p2.NomCta,Case When v.Prdo='00' Then 'Periodo Inicial' Else '' End)
Having 
	isnull(g.IB_Saldado,0)=0 and isnull(p2.NomCta,Case When v.Prdo='00' Then 'Periodo Inicial' Else '' End)<>''
Order by 
	Periodo Desc,
	NomAux,
	isnull(p2.NomCta,Case When v.Prdo='00' Then 'Periodo Inicial' Else '' End)
	
	
--********************************** INGRESOS - SERVICIOS **********************************	

	
Select 
	v.Cd_Vta,v.RegCtb,v.Cd_TD,v.NroSre,v.NroDoc,d.Nro_RegVdt,
	d.Cd_Srv,isnull(s.CA01,'') As IndSrv,
	s.Nombre As NomSrv,
	d.Total
From 
	Venta v
	Left Join VentaDet d On d.RucE=v.RucE and d.Cd_Vta=v.Cd_Vta
	Left Join Servicio2 s On s.RucE=d.RucE and s.Cd_Srv=d.Cd_Srv
Where v.RucE=@RucE and v.Eje=@Ejer and isnull(v.IB_Anulado,0)<>1



	
--********************************** OTROS DATOS **********************************	
SELECT '' As IF01,'' As IF02,'' As IF03,'' As IF04,'' As IF05


--Creado por.
--Diego  <30/06/2011>
--Prueba: exec Rpt_Liquidacion '20111412341','2011','01/04/2011','30/04/2011'
GO

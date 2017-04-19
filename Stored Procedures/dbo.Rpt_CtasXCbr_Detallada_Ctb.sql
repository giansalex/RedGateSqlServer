SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXCbr_Detallada_Ctb]
@RucE nvarchar(11),
@Ejer varchar(4),
@FechaIni datetime,
@FechaFin datetime,
@Cd_Mda char(2),
@IB_VerSaldados bit
as


--Grilla 1
select 
	RucC,
	MAX(RSocial) As RSocial,
	SUM(Debe) As Debe,
	SUM(Haber) As Haber,
	SUM(Saldo) As Saldo,
	SUM(Saldo_Dias) SaldoDias,
	Case when SUM(Saldo_Dias) <= 0 then SUM(Saldo) else 0.00 end As Vencido,
	Case when SUM(Saldo_Dias) > 0 and SUM(Saldo_Dias) <= 30 then SUM(Saldo) else 0.00 end As Hasta30,
	Case when SUM(Saldo_Dias) > 30 and SUM(Saldo_Dias) <= 60 then SUM(Saldo) else 0.00 end As Hasta60,
	Case when SUM(Saldo_Dias) > 60 and SUM(Saldo_Dias) <= 90 then SUM(Saldo) else 0.00 end As Hasta90,
	Case when SUM(Saldo_Dias) > 90 then SUM(Saldo) else 0.00 end As AMAS
	--*
from
(
	Select 
		NDocAux As RucC,
		NomAux As RSocial,
		--RegCtb,
		NroDoc,
		FecED,
		FecVD,
		Debe,
		Haber,
		Saldo,
		Saldo_Dias
	from (
		Select 
			  isnull(c.NDoc,isnull(r.NDoc,'--Sin Documento--')) As NDocAux,
			  Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
			  Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) End
			  End As NomAux,
			  
			  isnull(v.Cd_TD,'') As Cd_TD,
			  isnull(v.NroSre,'') As NroSre,
			  isnull(v.NroDoc,'') As NroDoc,
			  Max(Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecED,103) else '' end) as FecED,
			  Max(Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecCbr,103) else '' end) as FecVD,
		      
			  Sum(Case When isnull(v.IB_EsProv,0)=1 Then Datediff(Day,@FechaFin,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificar')))) Else 0 End) As Saldo_Dias,
			  Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) As Debe,
			  Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Haber,
			  Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Saldo,
			  @Cd_Mda as Cd_MdRg,
			  Max(Convert(varchar,v.FecMov,103)) As FecMov
		From 
			  Voucher v
			  Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
			  left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
			  left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
		Where 
			  v.RucE=@RucE
			  and v.Ejer=@Ejer
			  and v.FecMov between @FechaIni and @FechaFin
			  and isnull(v.IB_Anulado,0)<>1
			  
		Group by 
			  isnull(c.NDoc,isnull(r.NDoc,'--Sin Documento--')),
			  Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
			  Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
			  Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) End                                       
			  End,
			  isnull(v.Cd_TD,''),
			  isnull(v.NroSre,''),
			  isnull(v.NroDoc,'')

		Having
			  --isnull(g.IB_Saldado + Convert(int,@IB_VerSaldados),0)<>1 and 
			  Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) + @IB_VerSaldados <>0
	) As con
) As Con
group by RucC,RSocial
Order by RSocial

--Grilla 2
select 
	Max(RucC) As RucC,
	RegCtb,
	MAX(NroDoc) As NroDoc,
	MAX(FecED) As FecED,
	MAX(FecVD) As FecVD,
	SUM(Debe) As Debe1,
	SUM(Haber) As Haber1,
	SUM(Saldo) As Saldo1,
	SUM(Saldo_Dias) SaldoDias,
	Case when SUM(Saldo_Dias) <= 0 then SUM(Saldo) else 0.00 end As Vencido,
	Case when SUM(Saldo_Dias) > 0 and SUM(Saldo_Dias) <= 30 then SUM(Saldo) else 0.00 end As Hasta30,
	Case when SUM(Saldo_Dias) > 30 and SUM(Saldo_Dias) <= 60 then SUM(Saldo) else 0.00 end As Hasta60,
	Case when SUM(Saldo_Dias) > 60 and SUM(Saldo_Dias) <= 90 then SUM(Saldo) else 0.00 end As Hasta90,
	Case when SUM(Saldo_Dias) > 90 then SUM(Saldo) else 0.00 end As AMAS
from
(
	Select 
		NDocAux As RucC,
		NomAux As RSocial,
		RegCtb,
		NroDoc,
		FecED,
		FecVD,
		Debe,
		Haber,
		Saldo,
		Saldo_Dias
	from (
		Select 
			  isnull(c.NDoc,isnull(r.NDoc,'--Sin Documento--')) As NDocAux,
			  Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
			  Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) End
			  End As NomAux,
			  v.NroCta,
			  isnull(v.Cd_TD,'') As Cd_TD,
			  isnull(v.NroSre,'') As NroSre,
			  isnull(v.NroDoc,'') As NroDoc,
			  Max(RegCtb) As RegCtb,
			  Max(Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecED,103) else '' end) as FecED,
			  Max(Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecCbr,103) else '' end) as FecVD,
		      
			  Sum(Case When isnull(v.IB_EsProv,0)=1 Then Datediff(Day,@FechaFin,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificar')))) Else 0 End) As Saldo_Dias,
			  Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) As Debe,
			  Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Haber,
			  Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Saldo,
			  @Cd_Mda as Cd_MdRg,
			  Max(Convert(varchar,v.FecMov,103)) As FecMov
		From 
			  Voucher v
			  Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
			  left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
			  left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
		Where 
			  v.RucE=@RucE
			  and v.Ejer=@Ejer
			  and isnull(v.IB_Anulado,0)<>1
			  and Convert(varchar,v.FecMov,102) between Convert(varchar,@FechaIni,102) and Convert(varchar,@FechaFin,102)
		Group by 
			  v.NroCta,
			  isnull(c.NDoc,isnull(r.NDoc,'--Sin Documento--')),
			  Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
			  Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
			  Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) End                                       
			  End,
			  isnull(v.Cd_TD,''),
			  isnull(v.NroSre,''),
			  isnull(v.NroDoc,'')
		Having
			  --isnull(g.IB_Saldado + Convert(int,@IB_VerSaldados),0)<>1 and 
			  Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) + Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) + @IB_VerSaldados <> 0
	) As con
) As Con
group by RegCtb
Order by RucC Desc
-- Leyenda -- 
--JJ <Creado por Jujo>
--DI 24/06/2011 <Reestructurwado> 
--exec dbo.Rpt_CtasXCbr_Detallada_Ctb '11111111111','2011','01/01/2011','30/09/2011','01',0
--exec dbo.Rpt_CtasXCbr_Detallada_Ctb '11111111111','2010','01/03/2010','31/05/2010','01',0
GO

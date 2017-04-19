SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--declare @RucE nvarchar(11)
--declare @Ejer varchar(4)
--declare @FecIni datetime
--declare @FecFin datetime
--declare @Cd_Mda char(2)
--declare @IB_VerSaldados bit
--declare @Cd_Prv char(7)
--declare @NroCta1 nvarchar(10)
--declare @NroCta2 nvarchar(10)
--declare @Cd_TipProv nvarchar(3)
--declare @msj varchar(100)


--set @RucE ='11111111111'
--set @Ejer ='2011'
--set @FecIni ='08/06/2011'
--set @FecFin ='15/06/2011'
--set @Cd_Mda ='02'
--set @IB_VerSaldados = 1
--set @Cd_Prv =''
--set @NroCta1 =''
--set @NroCta2 =''
--set @Cd_TipProv = ''
--set @msj =''

CREATE procedure [dbo].[Rpt_CtasXPagar_CCteSaldo12_Fec]
@RucE nvarchar(11),
@Ejer varchar(4),
@FecIni datetime,
@FecFin datetime,
@Cd_Mda char(2),
@IB_VerSaldados bit,
@Cd_Prv char(7),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_TipProv nvarchar(3),
@msj varchar(100) output
as


--CABECERA
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FecIni,103)+ ' Al :' + Convert(varchar,@FecFin,103) as Fecha from Empresa where Ruc=@RucE

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
	
	Sum(Case When isnull(v.IB_EsProv,0)=1 Then Datediff(Day,@FecFin,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificar')))) Else 0 End) As Saldo_Dias,
	
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) As Debe,
	Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Haber,
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Saldo,
	@Cd_Mda as Cd_MdRg,
	Max(Convert(varchar,v.FecMov,103)) As FecMov
	--,isnull(g.IB_Saldado,0) As IB_Saldado
From 
	Voucher v
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	Left Join 
	(	Select v.RucE,	v.Ejer,	v.NroCta,isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,isnull(v.Cd_TD,'') As Cd_TD,isnull(v.NroSre,'') As NroSre,isnull(v.NroDoc,'') As NroDoc,1 As IB_Saldado
		From Voucher v Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXPag,0)=1
		Where  v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IB_Anulado,0)<>1 and Convert(varchar,v.FecMov,102) between Convert(varchar,@FecIni,102) and Convert(varchar,@FecFin,102)
		Group by v.RucE, v.Ejer,	v.NroCta, isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')), isnull(v.Cd_TD,''), isnull(v.NroSre,''), isnull(v.NroDoc,'')
		Having Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End)-Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End)=0
	) As g On g.RucE=v.RucE and g.Ejer=v.Ejer and (g.NroCta=v.NroCta and isnull(g.CodAux,'')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc)
	left join TipProv as tp on tp.Cd_TPrv = r.Cd_TPrv
	

Where 
	v.RucE=@RucE
	and v.Ejer=@Ejer
	and isnull(v.IB_Anulado,0)<>1
	and Convert(varchar,v.FecMov,102) between Convert(varchar,@FecIni,102) and Convert(varchar,@FecFin,102)
	and Case When isnull(@NroCta1,'')<>'' Then v.NroCta Else '' End>=isnull(@NroCta1,'')
	and Case When isnull(@NroCta2,'')<>'' Then v.NroCta Else '' End<=isnull(@NroCta2,'')
	and Case When isnull(@Cd_Prv,'')<>'' Then v.Cd_Prv Else '' End =isnull(@Cd_Prv,'')
	and case When isnull(@Cd_TipProv,'') <> '' then r.Cd_TPrv else '' End = isnull(@Cd_TipProv,'')
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
	sum(isnull(g.IB_Saldado + Convert(int,@IB_VerSaldados),0))=0
	and Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) + Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End)<>0
	
Order by NomAux,NroDoc

-- Leyenda --
-- JJ <Creado>
--DI : 24/05/2011 <reestructurado>
GO

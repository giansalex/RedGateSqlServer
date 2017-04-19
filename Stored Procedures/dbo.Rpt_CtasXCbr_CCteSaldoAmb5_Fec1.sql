SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXCbr_CCteSaldoAmb5_Fec1]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@FechaIni datetime,
@FechaFin datetime,
@IB_VerSaldados bit,
@Cd_Clt char(10),--Se cambio de nombre, antes era @Cd_Aux nvarchar(7)
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_TipClt nvarchar(3),
@msj varchar(100) output
as


--TABLA CABECERA
select Ruc, Rsocial, @Ejer ejer,'1' IB_ImpFR,'Del :' + Convert(varchar,@FechaIni,103)+ ' Al :' + Convert(varchar,@FechaFin,103) as Fecha  from Empresa where Ruc=@RucE

--TABLA DETALLE
select
	NDocAux,
	Max(NomAux) As NomAux,
	Max(NroCta) As NroCta,
	Max(Cd_TD) As Cd_TD,
	Max(NroSre) As NroSre,
	Max(NroDoc) As NroDoc,
	Max(FecED) As FecED,
	Max(FecVD) As FecVD,
	Sum(Saldo_Dias) As Saldo_Dias,
	Sum(Debe) As Debe,
	Sum(Haber) As Haber,
	Sum(Saldo) As Saldo,
	Sum(Debe_ME) As Debe_ME,
	Sum(Haber_ME) As Haber_ME,
	Sum(Saldo_ME) As Saldo_ME
from(
	Select
		isnull(c.NDoc,isnull(r.NDoc,'')) As NDocAux,
		Case When isnull(v.Cd_Clt,'') = '' and isnull(v.Cd_Prv,'') = '' Then '-- Sin Auxiliar --'
																	Else Case When isnull(v.Cd_Clt,'') <> '' Then isnull(c.RSocial, isnull(c.ApPat,'') + ' ' + isnull(c.ApMat,'') + ' ' + isnull(c.Nom,''))
																											 Else isnull(r.RSocial, isnull(r.ApPat,'') + ' ' + isnull(r.ApMat,'') + ' ' + isnull(r.Nom,''))
																		End
		End As NomAux,
		v.NroCta,
		Isnull(v.Cd_TD,'') As Cd_TD,
		Isnull(v.NroSre,'') As NroSre,
		Isnull(v.NroDoc,'') As NroDoc,
		Max(Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecED,103) else '' end) as FecED,
		Max(Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecCbr,103) else '' end) as FecVD,
		Sum(Case When isnull(v.IB_EsProv,0)=1 Then Datediff(Day,@FechaFin,IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,'Sin Especificar')))) Else 0 End) As Saldo_Dias,
		Sum(v.MtoD) As Debe,
		Sum(v.MtoH) As Haber,
		(Sum(v.MtoD) - Sum(v.MtoH)) As Saldo,
		Sum(v.MtoD_ME) As Debe_ME,
		Sum(v.MtoH_ME) As Haber_ME,
		(Sum(v.MtoD_ME) - Sum(v.MtoH_ME)) As Saldo_ME
	From 
		Voucher v
		Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
		left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
		left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
		Left Join 
		(	Select v.RucE,	v.Ejer,	v.NroCta,isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) As CodAux,isnull(v.Cd_TD,'') As Cd_TD,isnull(v.NroSre,'') As NroSre,isnull(v.NroDoc,'') As NroDoc,1 As IB_Saldado
			From Voucher v Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
			Where  v.RucE=@RucE and v.Ejer=@Ejer and isnull(v.IB_Anulado,0)<>1 and Convert(varchar,v.FecMov,102) between Convert(varchar,@FechaIni,102) and Convert(varchar,@FechaFin,102)
			Group by v.RucE, v.Ejer,	v.NroCta, isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')), isnull(v.Cd_TD,''), isnull(v.NroSre,''), isnull(v.NroDoc,'')
			Having Sum(v.MtoD) - Sum(v.MtoH) <> 0 or Sum(v.MtoD_ME) - Sum(v.MtoH_ME) <> 0
		) As g On g.RucE=v.RucE and g.Ejer=v.Ejer and (g.NroCta=v.NroCta and isnull(g.CodAux,'')=isnull(v.Cd_Clt,isnull(v.Cd_Prv,'')) and g.Cd_TD=v.Cd_TD and g.NroSre=v.NroSre and g.NroDoc=v.NroDoc)

	Where 
		v.RucE=@RucE
		and v.Ejer=@Ejer
		and isnull(v.IB_Anulado,0)<>1
		and Convert(varchar,v.FecMov,102) between Convert(varchar,@FechaIni,102) and Convert(varchar,@FechaFin,102)
		and Case When isnull(@NroCta1,'')<>'' Then v.NroCta Else '' End>=isnull(@NroCta1,'')
		and Case When isnull(@NroCta2,'')<>'' Then v.NroCta Else '' End<=isnull(@NroCta2,'')
		and Case When isnull(@Cd_Clt,'')<>'' Then v.Cd_Clt Else '' End =isnull(@Cd_Clt,'')
		and Case When isnull(@Cd_TipClt,'')<>'' Then c.Cd_TClt Else '' End =isnull(@Cd_TipClt,'')
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
		isnull(v.NroDoc,'')
	Having
		Sum(isnull(g.IB_Saldado + Convert(int,@IB_VerSaldados),0))=0
		and (
		Sum(v.MtoD) + Sum(v.MtoH) + Sum(v.MtoD_ME) + Sum(v.MtoH_ME) <> 0
		)
) As Con
Group By
	NDocAux
Order by 
	NomAux,NroDoc

		
		
	
--Pruebas:
--exec Rpt_CtasXCbr_CCteSaldoAmb5_Fec1 '11111111111','2011','01/01/2011','31/12/2011',0,null,null,null,null,null
--exec Rpt_CtasXCbr_CCteSaldoAmb5 '11111111111','2010','','','','31/12/2010',null
--JJ<06/08/2011>: REESTRUCTURADO
print @msj
GO

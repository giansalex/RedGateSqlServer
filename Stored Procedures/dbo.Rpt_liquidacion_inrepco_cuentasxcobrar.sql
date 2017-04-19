SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_liquidacion_inrepco_cuentasxcobrar]
@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Mda char(2),
--@NroCta nvarchar(10),
@PrdoIni varchar(2),
@PrdoFin varchar(2),
@Cd_MdRg nvarchar(4)

as

select Max(Dpto) + ' ' +Max(NomAux)+ ' ('+ Left(DateName( month , DateAdd( month , Convert(int,Min(Prdo)) , 0 ) - 1 ),3) + ' a '+ Left(DateName( month , DateAdd( month , Convert(int,MAx(Prdo)) , 0 ) - 1 ),3) + MAx(Right(Ejer,2)) + ')' as Cliente
		,sum(Saldo) as Deuda

from(
select
	isnull(c.NDoc,isnull(r.NDoc,'-- Sin Documento --')) As NDocAux,
	Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
	Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
	Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
	End End As NomAux,
	v.Prdo,
	v.Ejer,
	v.NroCta As NroCta,
	isnull(v.Cd_TD,'') As Cd_TD,
	isnull(v.NroSre,'') As NroSre,
	isnull(v.NroDoc,'') As NroDoc,
	
	Max(Case When isnull(IB_EsProv,0)=1 Then Convert(varchar,v.FecED,103) Else null End) as FecED,
	Max(Case When isnull(IB_EsProv,0)=1 Then Convert(varchar,v.FecCbr,103) Else null End) as FecVD,
	
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) As Debe,
	Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Haber,
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) As Saldo,
	max(v.Cd_MdRg) as Cd_MdRg,
	Max(Convert(varchar,v.FecMov,103)) As FecMov
	,isnull(c.RSocial,'--') as Dpto
	,mg.Descrip
 
from Voucher v 
	Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
	left join MantenimientoGN mg on v.RucE = mg.RucE and mg.Codigo = case when isnull(c.CA01,'')<>''then c.CA01 else c.CA02 end
Where v.RucE = @RucE /*Ruc */ and v.Ejer = @Ejer and v.Prdo between  @PrdoIni and @PrdoFin
and isnull(v.Ib_Anulado,0)=0
	and Case When isnull('','')<>'' Then c.Cd_TClt Else '' End =isnull('','')
	and Case When '          '='' Then '' Else v.Cd_Clt End =isnull('          ','')
 

			Group by 
				v.NroCta,
				isnull(c.NDoc,isnull(r.NDoc,'-- Sin Documento --')),
				Case When isnull(v.Cd_Clt,'')='' and isnull(v.Cd_Prv,'')='' Then '-- Sin Auxiliar --' 
				Else Case When isnull(v.Cd_Clt,'')<>'' Then isnull(c.RSocial,isnull(c.ApPat,'')+' '+isnull(c.ApMat,'')+' '+isnull(c.Nom,'')) 
				Else isnull(r.RSocial,isnull(r.ApPat,'')+' '+isnull(r.ApMat,'')+' '+isnull(r.Nom,'')) 
				End End,
				v.Prdo,
				v.Ejer,
				isnull(v.Cd_TD,''),
				isnull(v.NroSre,''),
				isnull(v.NroDoc,'')
				,isnull(c.RSocial,'--')
				,mg.Descrip			
				

Having
	Sum(Case When @Cd_Mda='01' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When @Cd_Mda='01' Then v.MtoH Else v.MtoH_ME End) 
	+ 0.00000 <> 0
) as t


--  exec Rpt_liquidacion_inrepco_cuentasxcobrar '20252619926','2012','01','01','11','01'
GO

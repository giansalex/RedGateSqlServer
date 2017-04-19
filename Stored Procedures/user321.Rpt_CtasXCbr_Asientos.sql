SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Rpt_CtasXCbr_Asientos]
@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Mda char(2),
@RegCtb varchar(8000),
@RegCtb1 varchar(8000),
@RegCtb2 varchar(8000),
@RegCtb3 varchar(8000),
@IB_VerSaldados bit
as

declare @Consulta11 varchar(4000)
declare @Consulta12 varchar(4000)

set @Consulta11='
select 
	Con.RegCtb,
	Con.Cd_TD,
	Con.NroSre,
	Con.NroDoc,
	Con.NDocAux,
	Con.Cd_Fte,
	
	Con.NroCta,
	Con.NomCta,
	Con.Debe,
	Con.Haber,
	Con.IC_TipAfec
from(
select 	
	v.RegCtb,
	case when Isnull(c.NDoc,'''')='''' then ''P'' else ''C'' End As CliProv,
	Isnull(v.Cd_TD,'''') as Cd_TD,
	Isnull(v.NroSre,'''') as NroSre,
	Isnull(v.NroDoc,'''') As NroDoc,
	isnull(c.NDoc,isnull(r.NDoc,''--Sin Documento--'')) As NDocAux,
	v.Cd_Fte,
	
	v.NroCta,
	p.NomCta,
	case('''+@Cd_Mda+''') when ''01'' then v.MtoD else v.MtoD_ME end as Debe,
	case('''+@Cd_Mda+''') when ''01'' then v.MtoH else v.MtoH_ME end as Haber,
	Case(isnull(Len(v.IC_TipAfec),0)) when 0 then ''X'' else isnull(UPPER(v.IC_TipAfec),'''') end as IC_TipAfec
from 
	Voucher v inner join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
Where 	
	v.RucE='''+@RucE+''' and 
	v.Ejer='''+@Ejer+''' and
	v.RegCtb in ('
set @Consulta12=
	
	') and
	Isnull(v.IB_Anulado,0)=0
) As Con
	--order by Con.RegCtb, NDocAux
'
declare @Consulta13 varchar(Max)
set @Consulta13='
inner join (
select 
	RucC,
	RegCtb,
	Max(Isnull(Cd_TD,'''')) Cd_TD,
	Max(Isnull(NroSre,'''')) NroSre,
	MAX(NroDoc) As NroDoc
from
(
	Select 
		NDocAux As RucC,RegCtb,
		Cd_TD,NroSre,NroDoc
	from (
		Select 
			  isnull(c.NDoc,isnull(r.NDoc,''--Sin Documento--'')) As NDocAux,
			  v.NroCta,
			  isnull(v.Cd_TD,'''') As Cd_TD,
			  isnull(v.NroSre,'''') As NroSre,
			  isnull(v.NroDoc,'''') As NroDoc,
			  Max(RegCtb) As RegCtb,
			   Max(Convert(varchar,v.FecMov,103)) As FecMov
		From 
			  Voucher v
			  Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
			  left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
			  left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
		Where 
			  v.RucE='''+@RucE+'''
			  and v.Ejer='''+@Ejer+'''
			  and isnull(v.IB_Anulado,0)<>1
		Group by 
			  v.NroCta,
			  isnull(c.NDoc,isnull(r.NDoc,''--Sin Documento--'')),
			  isnull(v.Cd_TD,''''),
			  isnull(v.NroSre,''''),
			  isnull(v.NroDoc,'''')
		Having
			  --isnull(g.IB_Saldado + Convert(int,@IB_VerSaldados),0)<>1 and 
			  Sum(Case When '''+Isnull(@Cd_Mda,'')+'''=''01'' Then v.MtoD Else v.MtoD_ME End) + Sum(Case When '''+Isnull(@Cd_Mda,'')+'''=''01'' Then v.MtoH Else v.MtoH_ME End) + '+Convert(varchar,@IB_VerSaldados)+' <> 0
	) As con
) As Con1
group by Con1.RucC,Con1.RegCtb
) As Con1 on Con1.RegCtb=Con.RegCtb 
--	and Con1.Cd_TD=Con.Cd_TD and Con1.NroSre=Con.NroSre and Con1.NroDoc=Con.NroDoc
--	and Con1.RucC=Con.NDocAux
Order by Con1.RucC Desc	
'

Print @Consulta11
Print @RegCtb
Print @RegCtb1
Print @RegCtb2
Print @RegCtb3
Print @Consulta12
print @Consulta13

Exec (
	@Consulta11+
	@RegCtb+
	@RegCtb1+
	@RegCtb2+
	@RegCtb3+
	@Consulta12+
	@Consulta13
     )

-- Leyenda --
--JJ: 30/03/2011 : <Creacion del Procedimiento Almacenado>
--exec Rpt_CtasXCbr_Detallada '11111111111','2010','','31/12/2010','01',0
/*
exec user321.Rpt_CtasXCbr_Asientos '11111111111','2011','01'
,' ''CTGE_LD10-00002'',''CTGE_RV05-00003'',''VTGE_RV05-00025'',''VTGE_RV11-00015'',''VTGE_RV04-00007'',''VTGE_RV04-00009'',''CTGE_LD11-00001'',''CTGE_LD07-00001'' ',null,null,null,0
*/
--exec Rpt_CtasXCbr_Producto '11111111111','2011','''CTGE_RV10-00001'''


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec  Ctb_CtasxPag_Explorador '11111111111','2011','01/12/2011','31/12/2011',1,1,1,1
CREATE procedure [dbo].[Ctb_CtasxPag_Explorador]
@RucE nvarchar(11),
@Ejer varchar(4),
@FechaIni Date,
@FechaFin Date,
@IbVersaldados bit,
@Nivel1 bit,
@Nivel2 bit
As

--interno
declare @VarNum decimal(5,3), @Consulta1 varchar(max), @Consulta2 varchar(max), @Consulta3 varchar(max), @Consulta4 varchar(max)
set @VarNum=0.0

if(@IbVersaldados=1) set @VarNum=12.101
declare @Consulta varchar(max)

set @Consulta=
'
select 
		OrderPrv, Max(Cd_Prv)  as Cod, NULL NDoc, ''Total Ctas. x Pagar'' NomAux, NULL NroCta,
		Null as Glosa, NULL Cd_TD, NULL Doc, NULL NroSre, NULL NroDoc, NULL Cd_MdRg, Sum(Debe) Debe, Sum(Haber) Haber, Sum(Saldo) Saldo,
		Sum(DebeME) DebeME, Sum(HaberME) HaberME, Sum(SaldoME) SaldoME,
		NULL FecED, NULL FecVD, NULL Cd_CC, NULL Cd_SC, NULL Cd_SS, NULL Cd_Area, NULL FecReg
		,NULL Msj
from (
select OrderPrv, Max(Cd_Prv) Cd_Prv, Ndoc, ''  Total Doc. ''+ Isnull(NroDoc,''Sin Documento'') as NomAux, NULL Glosa, Cd_TD, Doc, NroSre, NroDoc, NULL Cd_MdRg, Sum(Debe) Debe, Sum(Haber) Haber, Sum(Saldo) Saldo, Sum(DebeME) DebeME, Sum(HaberME) HaberME, Sum(SaldoME) SaldoME,
		NULL FecED, NULL FecVD, NULL Cd_CC,NULL Cd_SC, NULL Cd_SS, NULL Cd_Area, Max(FecReg) FecReg
		, Case when Isnull(Max(MsjMN),'''')='''' then case when Isnull(Max(MsjME),'''')='''' then NULL else ''US$. ''+ Max(MsjME) end else 
		  Case When Isnull(Max(MsjME),'''')='''' then ''S/. ''+Max(MsjMN) else ''S/. ''+Max(MsjMN)+'' y US$. ''+Max(MsjME)  End End
   	     Msj 
   	    , Max(Proveedor) Proveedor
from 
(select
    0 as OrderPrv 
    , Max(v.Cd_Prv) Cd_Prv
	, COALESCE(p2.NDoc,''--Sin Informacion--'') As NDoc
	, ''      ''+RegCtb NomAux , v.Cd_TD,td.NCorto as Doc, v.NroSre, v.NroDoc
	, Sum(v.MtoD) Debe, Sum(v.MtoH) Haber, Sum(v.MtoD - v.MtoH) Saldo
	, Sum(v.MtoD_ME) DebeME, Sum(v.MtoH_ME) HaberME, Sum(v.MtoD_ME - v.MtoH_ME) SaldoME
	, case when (SUM(v.MtoD))=0 then case when (Sum(v.MtoH))=0 then ''Debe y Haber son 0.0'' else null end else null end as msjMN
	, case when (SUM(v.MtoD_ME))=0 then case when (Sum(v.MtoH_ME))=0 then ''Debe y Haber son 0.0'' else null end else null end as msjME
	, Max(v.Glosa) Glosa, Max(v.Cd_MdRg) Cd_MdRg, Convert(varchar,Max(v.FecED),103) FecED
	, Convert(varchar,Max(v.FecVD),103) FecVD, Convert(varchar,Max(v.FecReg),103) FecReg
	, Max(Cd_CC) Cd_CC, Max(Cd_SC) Cd_SC, Max(Cd_SS) Cd_SS, Max(Cd_Area) Cd_Area
	, COALESCE(case when Isnull(Len(Max(p2.RSocial)),0)=0 then Max(p2.ApPat)+'' ''+Max(p2.ApMat)+'', ''+Max(p2.Nom) else Max(p2.RSocial) end,''--Sin Informacion--'') as Proveedor
from 
	Voucher v left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	left join Proveedor2 p2 on p2.RucE=v.RucE and p2.Cd_Prv=v.Cd_Prv
	left join TipDoc td on td.Cd_TD=v.Cd_TD
where 
	v.RucE='''+Convert(varchar,Isnull(@RucE,''))+''' and v.Ejer='''+Convert(Varchar,Isnull(@Ejer,''))+''' and p.IB_CtasXPag=1 and isnull(v.IB_Anulado,0)<>1 
	and Convert(varchar,v.FecMov,103) between '''+Convert(Varchar,@FechaIni,103)+''' and '''+Convert(varchar,@FechaFin,103)+'''
Group By
	p2.NDoc, v.RegCtb,v.Cd_TD,td.NCorto, v.NroSre, v.NroDoc
having 	
	sum(v.MtoD - v.MtoH)  + Sum(MtoD_ME - MtoH_ME) + '+Convert(varchar,Isnull(@VarNum,0.0))+' <> 0
) as Con
group by OrderPrv,NDoc, Cd_TD, Doc, NroSre,NroDoc
) as Con
Group By 
	orderPrv
'


set @Consulta1='
union all
select 
		Max(OrderPrv) OrderPrv, Max(Cd_Prv)  as Cod, NDoc, ''Total ''+Max(Proveedor) as NomAux, NULL NroCta,
		Null as Glosa, NULL Cd_TD, NULL Doc, NULL NroSre, NULL NroDoc, NULL Cd_MdRg, Sum(Debe) Debe, Sum(Haber) Haber, Sum(Saldo) Saldo,
		Sum(DebeME) DebeME, Sum(HaberME) HaberME, Sum(SaldoME) SaldoME,
		NULL FecED, NULL FecVD, NULL Cd_CC, NULL Cd_SC, NULL Cd_SS, NULL Cd_Area, NULL FecReg
		,Max(Msj) Msj
from (
select OrderPrv,Max(Cd_Prv) Cd_Prv, Ndoc, ''  Total Doc. ''+ Isnull(NroDoc,''Sin Documento'') as NomAux, NULL Glosa, Cd_TD, Doc, NroSre, NroDoc, NULL Cd_MdRg, Sum(Debe) Debe, Sum(Haber) Haber, Sum(Saldo) Saldo, Sum(DebeME) DebeME, Sum(HaberME) HaberME, Sum(SaldoME) SaldoME,
		NULL FecED, NULL FecVD, NULL Cd_CC,NULL Cd_SC, NULL Cd_SS, NULL Cd_Area, Max(FecReg) FecReg
		, Case when Isnull(Max(MsjMN),'''')='''' then case when Isnull(Max(MsjME),'''')='''' then NULL else ''US$. ''+ Max(MsjME) end else 
		  Case When Isnull(Max(MsjME),'''')='''' then ''S/. ''+Max(MsjMN) else ''S/. ''+Max(MsjMN)+'' y US$. ''+Max(MsjME)  End End
   	     Msj 
   	    , Max(Proveedor) Proveedor
from 
(select
    1 as OrderPrv 
    , Max(v.Cd_Prv) Cd_Prv
	, COALESCE(p2.NDoc,''--Sin Informacion--'') As NDoc
	, ''      ''+RegCtb NomAux , v.Cd_TD,td.NCorto as Doc, v.NroSre, v.NroDoc
	, Sum(v.MtoD) Debe, Sum(v.MtoH) Haber, Sum(v.MtoD - v.MtoH) Saldo
	, Sum(v.MtoD_ME) DebeME, Sum(v.MtoH_ME) HaberME, Sum(v.MtoD_ME - v.MtoH_ME) SaldoME
	, case when (SUM(v.MtoD))=0 then case when (Sum(v.MtoH))=0 then ''Debe y Haber son 0.0'' else null end else null end as msjMN
	, case when (SUM(v.MtoD_ME))=0 then case when (Sum(v.MtoH_ME))=0 then ''Debe y Haber son 0.0'' else null end else null end as msjME
	, Max(v.Glosa) Glosa, Max(v.Cd_MdRg) Cd_MdRg, Convert(varchar,Max(v.FecED),103) FecED
	, Convert(varchar,Max(v.FecVD),103) FecVD, Convert(varchar,Max(v.FecReg),103) FecReg
	, Max(Cd_CC) Cd_CC, Max(Cd_SC) Cd_SC, Max(Cd_SS) Cd_SS, Max(Cd_Area) Cd_Area
	, COALESCE(case when Isnull(Len(Max(p2.RSocial)),0)=0 then Max(p2.ApPat)+'' ''+Max(p2.ApMat)+'', ''+Max(p2.Nom) else Max(p2.RSocial) end,''--Sin Informacion--'') as Proveedor
from 
	Voucher v left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	left join Proveedor2 p2 on p2.RucE=v.RucE and p2.Cd_Prv=v.Cd_Prv
	left join TipDoc td on td.Cd_TD=v.Cd_TD
where 
	v.RucE='''+Convert(Varchar,Isnull(@RucE,''))+''' and v.Ejer='''+Convert(varchar,Isnull(@Ejer,''))+''' and p.IB_CtasXPag=1 and isnull(v.IB_Anulado,0)<>1 
	and Convert(varchar,v.FecMov,103) between '''+Convert(varchar,@FechaIni,103)+''' and '''+Convert(varchar,@FechaFin,103)+'''
Group By
	p2.NDoc, v.RegCtb,v.Cd_TD,td.NCorto, v.NroSre, v.NroDoc
having 	
	sum(v.MtoD - v.MtoH)  + Sum(MtoD_ME - MtoH_ME) + '+Convert(varchar,Isnull(@VarNum,0.0))+' <> 0
) as Con
group by OrderPrv,NDoc, Cd_TD, Doc, NroSre,NroDoc
) as Con
Group By 
	NDoc
'

set @Consulta2=''
if(Isnull(@Nivel1,0)=1)
set @Consulta2='
union all
select 
		Max(OrderPrv) OrderPrv, Max(Cd_Prv)  as Cod, Ndoc, ''  Total Doc. ''+ Isnull(NroDoc,''Sin Documento'') as NomAux, NULL NroCta, NULL Glosa, Cd_TD, Doc, NroSre, NroDoc, NULL Cd_MdRg, Sum(Debe) Debe, Sum(Haber) Haber, Sum(Saldo) Saldo, Sum(DebeME) DebeME, Sum(HaberME) HaberME, Sum(SaldoME) SaldoME,
		NULL FecED, NULL FecVD, NULL Cd_CC,NULL Cd_SC, NULL Cd_SS, NULL Cd_Area, Max(FecReg) FecReg
		, Max(Msj) Msj

from  (
select OrderPrv, Cd_Prv, Ndoc, NomAux, NULL NroCta, Glosa, Cd_TD, Doc, NroSre, NroDoc, Cd_MdRg, Debe, Haber, Saldo, DebeME, HaberME, SaldoME,
		FecED, FecVD, Cd_CC,Cd_SC,Cd_SS, Cd_Area, FecReg
		, Case when Isnull(MsjMN,'''')='''' then case when Isnull(MsjME,'''')='''' then NULL else ''US$. ''+ msjME end else 
		  Case When Isnull(MsjME,'''')='''' then ''S/. ''+msjMN else ''S/. ''+msjMN+'' y US$. ''+msjME  End End
		 Msj 
from 
(select
    2 as OrderPrv
    , Max(v.Cd_Prv) Cd_Prv
	, COALESCE(p2.NDoc,''--Sin Informacion--'') As NDoc
	, ''      ''+RegCtb NomAux , v.Cd_TD,td.NCorto as Doc, v.NroSre, v.NroDoc
	, Sum(v.MtoD) Debe, Sum(v.MtoH) Haber, Sum(v.MtoD - v.MtoH) Saldo
	, Sum(v.MtoD_ME) DebeME, Sum(v.MtoH_ME) HaberME, Sum(v.MtoD_ME - v.MtoH_ME) SaldoME
	, case when (SUM(v.MtoD))=0 then case when (Sum(v.MtoH))=0 then ''Debe y Haber son 0.0'' else null end else null end as msjMN
	, case when (SUM(v.MtoD_ME))=0 then case when (Sum(v.MtoH_ME))=0 then ''Debe y Haber son 0.0'' else null end else null end as msjME
	, Max(v.Glosa) Glosa, Max(v.Cd_MdRg) Cd_MdRg, Convert(varchar,Max(v.FecED),103) FecED
	, Convert(varchar,Max(v.FecVD),103) FecVD, Convert(varchar,Max(v.FecReg),103) FecReg
	, Max(Cd_CC) Cd_CC, Max(Cd_SC) Cd_SC, Max(Cd_SS) Cd_SS, Max(Cd_Area) Cd_Area
from 
	Voucher v left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	left join Proveedor2 p2 on p2.RucE=v.RucE and p2.Cd_Prv=v.Cd_Prv
	left join TipDoc td on td.Cd_TD=v.Cd_TD
where 
	v.RucE='''+Convert(Varchar,Isnull(@RucE,''))+''' and v.Ejer='''+Convert(varchar,Isnull(@Ejer,''))+''' and p.IB_CtasXPag=1 and isnull(v.IB_Anulado,0)<>1 
	and Convert(varchar,v.FecMov,103) between '''+Convert(Varchar,@FechaIni,103)+''' and '''+Convert(varchar,@FechaFin,103)+'''
Group By
	p2.NDoc, v.RegCtb, v.Cd_TD, td.NCorto, v.NroSre, v.NroDoc
having 	
	sum(v.MtoD - v.MtoH)  + Sum(MtoD_ME - MtoH_ME) + '+Convert(varchar,Isnull(@VarNum,0.0))+' <> 0
) as Con
) as Con group by Ndoc, Cd_TD, Doc, NroSre, NroDoc
'
set @Consulta3=''
if(Isnull(@Nivel2,0)=1)
set @Consulta3='
union all
select OrderPrv, Cd_Prv  as Cod, Ndoc, NomAux, NULL NroCta, Glosa, Cd_TD, Doc, NroSre, NroDoc, Cd_MdRg, Debe, Haber, Saldo, DebeME, HaberME, SaldoME,
		FecED, FecVD, Cd_CC,Cd_SC,Cd_SS, Cd_Area, FecReg
		, Case when Isnull(MsjMN,'''')='''' then case when Isnull(MsjME,'''')='''' then NULL else ''US$. ''+ msjME end else 
		  Case When Isnull(MsjME,'''')='''' then ''S/. ''+msjMN else ''S/. ''+msjMN+'' y US$. ''+msjME  End End
		 Msj 
from 
(select
    3 as OrderPrv 
    , Max(v.Cd_Prv) Cd_Prv
	, COALESCE(p2.NDoc,''--Sin Informacion--'') As NDoc
	, ''      ''+RegCtb NomAux , v.Cd_TD,td.NCorto as Doc, v.NroSre, v.NroDoc
	, Sum(v.MtoD) Debe, Sum(v.MtoH) Haber, Sum(v.MtoD - v.MtoH) Saldo
	, Sum(v.MtoD_ME) DebeME, Sum(v.MtoH_ME) HaberME, Sum(v.MtoD_ME - v.MtoH_ME) SaldoME
	, case when (SUM(v.MtoD))=0 then case when (Sum(v.MtoH))=0 then ''Debe y Haber son 0.0'' else null end else null end as msjMN
	, case when (SUM(v.MtoD_ME))=0 then case when (Sum(v.MtoH_ME))=0 then ''Debe y Haber son 0.0'' else null end else null end as msjME
	, Max(v.Glosa) Glosa, Max(v.Cd_MdRg) Cd_MdRg, Convert(varchar,Max(v.FecED),103) FecED
	, Convert(varchar,Max(v.FecVD),103) FecVD, Convert(varchar,Max(v.FecReg),103) FecReg
	, Max(Cd_CC) Cd_CC, Max(Cd_SC) Cd_SC, Max(Cd_SS) Cd_SS, Max(Cd_Area) Cd_Area
from 
	Voucher v left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	left join Proveedor2 p2 on p2.RucE=v.RucE and p2.Cd_Prv=v.Cd_Prv
	left join TipDoc td on td.Cd_TD=v.Cd_TD
where 
	v.RucE='''+Convert(varchar,Isnull(@RucE,''))+''' and v.Ejer='''+Convert(varchar,Isnull(@Ejer,''))+''' and p.IB_CtasXPag=1 and isnull(v.IB_Anulado,0)<>1 
	and Convert(varchar,v.FecMov,103) between '''+Convert(varchar,@FechaIni,103)+''' and '''+Convert(varchar,@FechaFin,103)+'''
Group By
	p2.NDoc, v.RegCtb, v.Cd_TD, td.NCorto, v.NroSre, v.NroDoc
having 	
	sum(v.MtoD - v.MtoH)  + Sum(MtoD_ME - MtoH_ME) + '+Convert(varchar,isnull(@VarNum,0.0))+' <> 0
) as Con
'

declare @OrderBy varchar(70)
set @OrderBy='order by NDoc, Cd_TD, NroSre,NroDoc, OrderPrv '
--set @OrderBy='order by NDoc, Cd_TD, NroSre,NroDoc,NomAux, PlanCta desc, OrderPrv'


print @Consulta
print @Consulta1
print @Consulta2
print @Consulta3
print @Consulta4
print @OrderBy
exec(@Consulta+@Consulta1+@Consulta2+@Consulta3+@Consulta4+@OrderBy)


select  NroCta, NomCta
from 
(select
     v.NroCta, p.NomCta
from 
	Voucher v left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	left join Proveedor2 p2 on p2.RucE=v.RucE and p2.Cd_Prv=v.Cd_Prv
	left join TipDoc td on td.Cd_TD=v.Cd_TD
where 
	v.RucE=@RucE and v.Ejer=@Ejer and p.IB_CtasXPag=1 and isnull(v.IB_Anulado,0)<>1 
	and Convert(varchar,v.FecMov,103) between Convert(varchar,@FechaIni,103) and Convert(varchar,@FechaFin,103)
Group By
	p2.NDoc, v.RegCtb, v.NroCta,p.NomCta, v.Cd_TD, td.NCorto, v.NroSre, v.NroDoc
having 	
	sum(v.MtoD - v.MtoH)  + Sum(MtoD_ME - MtoH_ME) + @VarNum <> 0
) as Con 
group By NroCta, NomCta
order by NroCta

--exec  Ctb_CtasxPag_Explorador '11111111111','2011','01/12/2011','31/12/2011',1,1,1
/*

CPGE_RC05-00007
CPGE_RC05-00009
CPGE_RC05-00010


*/

GO

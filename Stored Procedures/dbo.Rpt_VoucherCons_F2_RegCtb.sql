SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_VoucherCons_F2_RegCtb] --procedimiento final de la consulta de vouchers
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb nvarchar(4000),
@msj varchar(100) output
as
print @RegCtb

DECLARE @SQL1 nvarchar(4000)
DECLARE @SQL2_1 nvarchar(4000)
DECLARE @SQL2_2 nvarchar(4000)
DECLARE @SQL2_3 nvarchar(4000)
DECLARE @SQL3 nvarchar(4000)
DECLARE @SQL4 nvarchar(4000)
DECLARE @SQL5 nvarchar(4000)

Set @SQL1 = ''
Set @SQL2_1 = ''
Set @SQL2_2 = ''
Set @SQL2_3 = ''
Set @SQL3 = ''
Set @SQL4 = ''
Set @SQL5 = ''

/************ TITULO ***********/


Set @SQL1 = 
	'
	select 
		v.RucE,e.RSocial,v.RegCtb,''S/.'' as Mda1, ''US$.'' as Mda2,v.UsuCrea as Usuario,v.IB_Anulado as Anulado, 0 as SumaDestino
	from Voucher v, Empresa e
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and e.Ruc=v.RucE
	      and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RucE,e.RSocial,v.RegCtb,v.UsuCrea,v.IB_Anulado
	'		

/************ CEBECERA ***********/

/*CB*/

Set @SQL2_1 = 
	'
	select 
		v.RegCtb,p.NomCta as Nombre,b.NCtaB as NroCta,v.CamMda as TipCmb,
		CASE(v.IB_Anulado) WHEN 1 THEN 0.00 ELSE Case(v.Cd_MdRg) when ''01'' then abs(v.MtoD) else abs(v.MtoD_ME) end end TotalI,
		CASE(v.IB_Anulado) WHEN 1 THEN 0.00 ELSE Case(v.Cd_MdRg) when ''01'' then abs(v.MtoH) else abs(v.MtoH_ME) end end TotalS,
		v.Cd_MdRg as MdaReg,
		--v.MtoD+v.MtoH as MtoMN, v.MtoD_ME+v.MtoH_ME as MtoME,
		--v.MtoD-v.MtoH as MtoMN, v.MtoD_ME-v.MtoH_ME as MtoME,
		Case(isnull(v.NroChke,0)) when ''0'' then isnull(v.TipOper,'''') else isnull(v.TipOper,'''')+''    ''+isnull(v.NroChke,'''') end as Oper
	from Voucher v 
	left join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	left join Banco b on b.RucE=v.RucE and b.NroCta=v.NroCta and b.Ejer=v.Ejer 
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Cd_Fte=''CB'' and left(v.NroCta,2)=''10''
	      and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RegCtb,p.NomCta,NCtaB,v.CamMda,v.Cd_MdRg,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME,v.NroChke,v.TipOper,v.IB_Anulado
	
	UNION ALL
	'

/*RV y RC*/
/*Set @SQL2_2 = 
	'
	select 
		v.RegCtb,isnull(a.RSocial,a.ApPat+'' ''+a.ApMat+'' ''+a.Nom)as Nombre,'''' as NroCta,v.CamMda as TipCmb,
		CASE(v.IB_Anulado) WHEN 1 THEN 0.00 ELSE Case(v.Cd_MdRg) when ''01'' then abs(v.MtoD) else abs(v.MtoD_ME) end end TotalI,
		CASE(v.IB_Anulado) WHEN 1 THEN 0.00 ELSE Case(v.Cd_MdRg) when ''01'' then abs(v.MtoH) else abs(v.MtoH_ME) end end TotalS, 
		v.Cd_MdRg as MdaReg,
		--v.MtoD+v.MtoH as MtoMN, v.MtoD_ME+v.MtoH_ME as MtoME,
		--v.MtoD-v.MtoH as MtoMN, v.MtoD_ME-v.MtoH_ME as MtoME,
		v.RegCtb as Oper
	from Voucher v  
	left join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	--left join Auxiliar a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	left join Proveedor2 as p on vou.Cd_Prv = p.Cd_Prv and vou.RucE = p.RucE	
	left join Cliente2 as c on vou.Cd_Clt = c.Cd_Clt and vou.RucE = c.RucE  
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Cd_Fte in (''RV'',''RC'') and left(v.NroCta,2) in (''12'',''42'',''46'')
	      and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RegCtb,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.CamMda,v.Cd_MdRg,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME,v.RegCtb,v.IB_Anulado
	
	UNION ALL
	'*/
declare @auxCd_Clt char(10)
set @auxCd_Clt = (select top  1 Cd_Clt from Voucher where RucE = @RucE and Ejer = @Ejer and RegCtb in (@RegCtb) 
		and Cd_Fte in ('RV','RC') 
		and left(NroCta,2) in ('12','42','46'))
--print @auxCd_Clt
if(@auxCd_Clt is not null and @auxCd_Clt != '')
begin
Set @SQL2_2 = 
	'
	select 
	v.RegCtb,
	case(isnull(len(cl2.RSocial),0)) when 0 then 
		isnull(nullif(cl2.ApPat +'' ''+cl2.ApMat+'' ''+cl2.Nom,''''),''------- SIN NOMBRE ------'')
	else cl2.RSocial  end as Nombre,
	'''' as NroCta,v.CamMda as TipCmb,
	CASE(v.IB_Anulado) WHEN 1 THEN 0.00 ELSE Case(v.Cd_MdRg) when ''01'' then abs(v.MtoD) else abs(v.MtoD_ME) end end TotalI,
	CASE(v.IB_Anulado) WHEN 1 THEN 0.00 ELSE Case(v.Cd_MdRg) when ''01'' then abs(v.MtoH) else abs(v.MtoH_ME) end end TotalS, 
	v.Cd_MdRg as MdaReg,
	v.RegCtb as Oper
	from Voucher v  
	left join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	left join Cliente2 as cl2 on v.Cd_Clt = cl2.Cd_Clt and v.RucE = cl2.RucE
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Cd_Fte in (''RV'',''RC'') 
	and left(v.NroCta,2) in (''12'',''42'',''46'')and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RegCtb,cl2.RSocial,cl2.ApPat,cl2.ApMat,cl2.Nom,v.CamMda,v.Cd_MdRg,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME,v.RegCtb,v.IB_Anulado
	UNION ALL
	'
end
else
begin
Set @SQL2_2 = 
	'
	select 
	v.RegCtb,
	case(isnull(len(pv2.RSocial),0)) when 0 then 
		isnull(nullif(pv2.ApPat +'' ''+pv2.ApMat+'' ''+pv2.Nom,''''),''------- SIN NOMBRE ------'')
	else pv2.RSocial  end as Nombre,
	'''' as NroCta,v.CamMda as TipCmb,
	CASE(v.IB_Anulado) WHEN 1 THEN 0.00 ELSE Case(v.Cd_MdRg) when ''01'' then abs(v.MtoD) else abs(v.MtoD_ME) end end TotalI,
	CASE(v.IB_Anulado) WHEN 1 THEN 0.00 ELSE Case(v.Cd_MdRg) when ''01'' then abs(v.MtoH) else abs(v.MtoH_ME) end end TotalS, 
	v.Cd_MdRg as MdaReg,
	v.RegCtb as Oper
	from Voucher v  
	left join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	left join Proveedor2 as pv2 on v.Cd_Prv = pv2.Cd_Prv and v.RucE = pv2.RucE
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Cd_Fte in (''RV'',''RC'') 
	and left(v.NroCta,2) in (''12'',''42'',''46'')and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RegCtb,pv2.RSocial,pv2.ApPat,pv2.ApMat,pv2.Nom,v.CamMda,v.Cd_MdRg,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME,v.RegCtb,v.IB_Anulado
	UNION ALL
	'
end

/*LD*/
/*Set @SQL2_3 = 
	'
	select 
		v.RegCtb,isnull(v.Grdo,isnull(a.RSocial,a.ApPat+'' ''+a.ApMat+'' ''+a.Nom)) as Nombre,'''' as NroCta,
		--,v.CamMda as TipCmb,
		0.000 as TipCmb,
		--Max(Case(v.Cd_MdRg) when ''01'' then abs(v.MtoD-v.MtoH) else abs(v.MtoD_ME-v.MtoH_ME) end) Total, 
		0.00 as TotalI, 
		0.00 as TotalS,
		--v.Cd_MdRg as MdaReg,
		''01'' as MdaReg,
		--v.MtoD-v.MtoH as MtoMN, v.MtoD_ME-v.MtoH_ME as MtoME,
	Case(isnull(v.NroChke,0)) when ''0'' then isnull(v.TipOper,'''') else isnull(v.TipOper,'''')+''    ''+isnull(v.NroChke,'''') end as Oper
	from Voucher v  
	left join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	left join Auxiliar a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Cd_Fte=''LD''
	      and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RegCtb,v.Grdo,a.RSocial,a.ApPat,a.ApMat,a.Nom*//*,v.CamMda,v.Cd_MdRg*//*,v.NroChke,v.TipOper--,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME
	--having isnull(v.Grdo,isnull(a.RSocial,a.ApPat+'' ''+a.ApMat+'' ''+a.Nom))!= ''NULL''
	'
*/
set @auxCd_Clt = (select top  1 Cd_Clt from Voucher where RucE=@RucE and Ejer=@Ejer 
		and Cd_Fte='LD' and RegCtb in (@RegCtb))

if(@auxCd_Clt is not null and @auxCd_Clt != '')
begin
Set @SQL2_3 = 
	'
	select 
	v.RegCtb,
	isnull(v.Grdo,Case When isnull(v.Cd_Clt,'''')<>'''' Then  isnull(isnull(cl2.RSocial,''''),isnull(cl2.ApPat,'''')+'' ''+isnull(cl2.ApMat,'''')+'' ''+isnull(cl2.Nom,'''')) Else isnull(isnull(pv2.RSocial,''''),isnull(pv2.ApPat,'''')+'' ''+isnull(pv2.ApMat,'''')+'' ''+isnull(pv2.Nom,'''')) End) as Nombre,
	'''' as NroCta,
	v.CamMda as TipCmb,--habia una coma demas
	0.00 as TotalI, 
	0.00 as TotalS,
	''01'' as MdaReg,
	Case(isnull(v.NroChke,0)) when ''0'' then isnull(v.TipOper,'''') else isnull(v.TipOper,'''')+''    ''+isnull(v.NroChke,'''') end as Oper
	from Voucher v  
	left join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	left join Cliente2 as cl2 on v.Cd_Clt = cl2.Cd_Clt and v.RucE = cl2.RucE
	left join Proveedor2 as pv2 on v.Cd_Prv = pv2.Cd_Prv and v.RucE = pv2.RucE
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Cd_Fte=''LD'' and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RegCtb,/*v.Grdo,cl2.RSocial,cl2.ApPat,cl2.ApMat,cl2.Nom,v.NroChke,v.TipOper*/
	isnull(v.Grdo,Case When isnull(v.Cd_Clt,'''')<>'''' Then  isnull(isnull(cl2.RSocial,''''),isnull(cl2.ApPat,'''')+'' ''+isnull(cl2.ApMat,'''')+'' ''+isnull(cl2.Nom,'''')) Else isnull(isnull(pv2.RSocial,''''),isnull(pv2.ApPat,'''')+'' ''+isnull(pv2.ApMat,'''')+'' ''+isnull(pv2.Nom,'''')) End)
	,Case(isnull(v.NroChke,0)) when ''0'' then isnull(v.TipOper,'''') else isnull(v.TipOper,'''')+''    ''+isnull(v.NroChke,'''') end
	,v.CamMda'
end
else
begin
Set @SQL2_3 = 
	'
	select 
	v.RegCtb,
	isnull(v.Grdo,Case When isnull(v.Cd_Clt,'''')<>'''' Then  isnull(isnull(cl2.RSocial,''''),isnull(cl2.ApPat,'''')+'' ''+isnull(cl2.ApMat,'''')+'' ''+isnull(cl2.Nom,'''')) Else isnull(isnull(pv2.RSocial,''''),isnull(pv2.ApPat,'''')+'' ''+isnull(pv2.ApMat,'''')+'' ''+isnull(pv2.Nom,'''')) End) as Nombre,
	'''' as NroCta,
	v.CamMda as TipCmb,
	0.00 as TotalI, 
	0.00 as TotalS,
	''01'' as MdaReg,
	Case(isnull(v.NroChke,0)) when ''0'' then isnull(v.TipOper,'''') else isnull(v.TipOper,'''')+''    ''+isnull(v.NroChke,'''') end as Oper
	from Voucher v  
	left join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	left join Cliente2 as cl2 on v.Cd_Clt = cl2.Cd_Clt and v.RucE = cl2.RucE
	left join Proveedor2 as pv2 on v.Cd_Prv = pv2.Cd_Prv and v.RucE = pv2.RucE
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Cd_Fte=''LD'' and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RegCtb,/*v.Grdo,cl2.RSocial,cl2.ApPat,cl2.ApMat,cl2.Nom,v.NroChke,v.TipOper*/
	isnull(v.Grdo,Case When isnull(v.Cd_Clt,'''')<>'''' Then  isnull(isnull(cl2.RSocial,''''),isnull(cl2.ApPat,'''')+'' ''+isnull(cl2.ApMat,'''')+'' ''+isnull(cl2.Nom,'''')) Else isnull(isnull(pv2.RSocial,''''),isnull(pv2.ApPat,'''')+'' ''+isnull(pv2.ApMat,'''')+'' ''+isnull(pv2.Nom,'''')) End)
	,Case(isnull(v.NroChke,0)) when ''0'' then isnull(v.TipOper,'''') else isnull(v.TipOper,'''')+''    ''+isnull(v.NroChke,'''') end
	,v.CamMda'
end

/*GLOSA ***********************************************************************************/
Set @SQL3 = 
	'
	select v.RegCtb,v.Glosa from Voucher v 
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''
	      and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RegCtb,v.Glosa
	'
/*FECHA DOCUMENTO Y DE REGISTRO ***********************************************************/
/*Set @SQL4 = 
	'
	select v.RegCtb,Max(convert(varchar,v.FecED,103)) as FecDoc,Max(convert(varchar,v.FecMov,103)) as FecReg 
	       ,Max(Case(v.Cd_Fte) when ''CB'' then isnull(v.Grdo,isnull(a.RSocial,a.ApPAt+'' ''+a.ApMat+'' ''+a.Nom)) else '''' end) as NomAux
	from Voucher v 
	left join Auxiliar a On a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''
	      and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RegCtb--,convert(varchar,v.FecED,103),convert(varchar,v.FecReg,103)
	--having convert(varchar,v.FecED,103)  != ''NULL''
	'
*/
Set @SQL4 = 
	'
	select v.RegCtb,Max(convert(varchar,v.FecED,103)) as FecDoc,Max(convert(varchar,v.FecMov,103)) as FecReg 
	,Max(Case(v.Cd_Fte) when ''CB'' then 
		case(isnull(len(v.Grdo),0)) when 0 then 
			case(isnull(len(v.Cd_Clt),0)) when 0 then
				case(isnull(len(pv2.RSocial),0)) when 0 then 
					isnull(nullif(pv2.ApPat +'' ''+pv2.ApMat+'' ''+pv2.Nom,''''),''------- SIN NOMBRE ------'')
				else cl2.RSocial 
				end
			else
				case(isnull(len(cl2.RSocial),0)) when 0 then 
					isnull(nullif(cl2.ApPat +'' ''+cl2.ApMat+'' ''+cl2.Nom,''''),''------- SIN NOMBRE ------'')
				else cl2.RSocial 
				end
			end
		else v.Grdo end 
	else '''' end) as NomAux
	from Voucher v
	left join Cliente2 as cl2 on v.Cd_Clt = cl2.Cd_Clt and v.RucE = cl2.RucE
	left join Proveedor2 as pv2 on v.Cd_Prv = pv2.Cd_Prv and v.RucE = pv2.RucE
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RegCtb
	'
/************ DETALLE ***********/
/*Set @SQL5 = 
	'
	select
		v.RegCtb,v.NroCta,c.NomCta,v.Cd_Aux,a.NDoc as NroAux,
	 	v.Cd_TD,v.NroSre+''-''+v.NroDoc as Dcto,v.Cd_CC as CCos,v.Cd_SC as SCCos,v.Cd_SS as SSCCos,v.Glosa,
		v.Cd_MdRg,
		CASE(v.IB_Anulado) WHEN 1 THEN 0.00 ELSE Case(v.IC_CtrMd) when ''$'' then 0 else v.MtoD end end as DebeMN,
		CASE(v.IB_Anulado) WHEN 1 THEN 0.00 ELSE Case(v.IC_CtrMd) when ''$'' then 0 else v.MtoH end end as HaberMN,
		CASE(v.IB_Anulado) WHEN 1 THEN 0.00 ELSE Case(v.IC_CtrMd) when ''s'' then 0 else v.MtoD_ME end end as DebeME,
		CASE(v.IB_Anulado) WHEN 1 THEN 0.00 ELSE Case(v.IC_CtrMd) when ''s'' then 0 else v.MtoH_ME end end as HaberME
	from Voucher v
		left join PlanCtas c on v.RucE=c.RucE and v.NroCta=c.NroCta and c.Ejer=v.Ejer
		left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''
	      and v.RegCtb in ('''+@RegCtb+''')
	'
*/
Set @SQL5 = 
	'
	select v.RegCtb,v.NroCta,c.NomCta,v.Cd_Aux,
	case(isnull(len(v.Cd_Clt),0)) when 0 then
		pv2.NDoc
	else cl2.NDoc end as NroAux,
	v.Cd_TD,v.NroSre+''-''+v.NroDoc as Dcto,
	cc.Descrip as CCos,
	cs.Descrip as SCCos,
	ss.Descrip as SSCCos,
	--v.Cd_CC as CCos,
	--v.Cd_SC as SCCos,
	--v.Cd_SS as SSCCos,
	v.Glosa,
	v.Cd_MdRg,
	CASE(v.IB_Anulado) WHEN 1 THEN 0.00 ELSE Case(v.IC_CtrMd) when ''$'' then 0 else v.MtoD end end as DebeMN,
	CASE(v.IB_Anulado) WHEN 1 THEN 0.00 ELSE Case(v.IC_CtrMd) when ''$'' then 0 else v.MtoH end end as HaberMN,
	CASE(v.IB_Anulado) WHEN 1 THEN 0.00 ELSE Case(v.IC_CtrMd) when ''s'' then 0 else v.MtoD_ME end end as DebeME,
	CASE(v.IB_Anulado) WHEN 1 THEN 0.00 ELSE Case(v.IC_CtrMd) when ''s'' then 0 else v.MtoH_ME end end as HaberME,
	IsNull(v.IB_EsDes,0) as IB_EsDes -- agregado por JS
	from Voucher v
	left join PlanCtas c on v.RucE=c.RucE and v.NroCta=c.NroCta and c.Ejer=v.Ejer
	left join Cliente2 as cl2 on v.Cd_Clt = cl2.Cd_Clt and v.RucE = cl2.RucE
	left join Proveedor2 as pv2 on v.Cd_Prv = pv2.Cd_Prv and v.RucE = pv2.RucE
	left join CCostos cc on  cc.RucE=v.RucE and cc.Cd_CC=v.Cd_CC
	left join CCSub cs on    cs.RucE=v.RucE and cs.Cd_CC=v.Cd_CC and cs.Cd_SC=v.Cd_SC
	left join CCSubSub ss on ss.RucE=v.RucE and ss.Cd_CC=v.Cd_CC and ss.Cd_SC=v.Cd_SC and ss.Cd_SS=v.Cd_SS
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.RegCtb in ('''+@RegCtb+''')
	'
print @SQL1
print @SQL2_1
print @SQL2_2
print @SQL2_3
print @SQL3
print @SQL4
print @SQL5

Exec('('+@SQL1+')'+'Order by 1')
Exec('('+@SQL2_1+@SQL2_2+@SQL2_3+')'+'Order by 1')
Exec('('+@SQL3+')'+'Order by 1')
Exec('('+@SQL4+')'+'Order by 1')
Exec('('+@SQL5+')'+'Order by 1')


-- Leyenda --
-------------

-- DI : 05/10/2009 --> Creacion del procedimiento almacenado
-- DI : 19/10/2009 --> Se modifico en la FECHA DOCUMENTO Y DE REGISTRO que todos son diferente a NULL
-- DI : 19/10/2009 --> Se creo el procedimiento copiado del procedimiento Rpt_VoucherCons_F y se asigno la consulta en texto

-- DI : 11/02/2011 --> <Faclto agregar la columna IB_esDes>

--DEMO
/*
exec Rpt_VoucherCons_F2_RegCtb '11111111111', '2010', 'VTGE_RV05-00001', null
select * from Voucher where RucE = '11111111111' and Ejer = '2010' and RegCtb = 'VTGE_RV05-00001'
*/
--MP: JUE 23-09-2010 --> Se modifico las sentencias quitando las referencias a auxiliar y enlazandolas con Cliente2 
--y Proveedor2 dependiendo del caso
--CM: RA01
--Javier : <Modificado> --> Se modifico la cabecera se le agrego un campo mas llamado SumaDestino que tiene valor 0, con esto se soluciono el error de imprimir desde el explorador
--Diego 07/07/2011: <Modificado> --> Se agrego la realcion de CC, SC y SS en los INNER DE CCostos, CCSSub, CCSubSub






GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_VoucherCons]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb1 nvarchar(15),
@RegCtb2 nvarchar(15),
@msj varchar(10) output
AS

Declare @Rango nvarchar(200)
if(isnull(len(@RegCtb1),0)<>0 and isnull(len(@RegCtb1),0)<>0)
begin
	Set @Rango = ' and v.RegCtb between '''+@RegCtb1+''' and '''+@RegCtb2+''''
end
else	Set @Rango = ''

DECLARE @SQL1 nvarchar(4000)
DECLARE @SQL2_1 nvarchar(4000)
DECLARE @SQL2_2 nvarchar(4000)
DECLARE @SQL3 nvarchar(4000)
DECLARE @SQL4 nvarchar(4000)
DECLARE @SQL5 nvarchar(4000)
SET @SQL1 = '' SET @SQL2_1 = ''  SET @SQL2_2 = '' SET @SQL3 = '' SET @SQL4 = '' SET @SQL5 = ''

--=================================================================================--
--******** CABECERA PRINCIP ********--
--=================================================================================--
SET @SQL1 = 
	'
	select 
		v.RucE,e.RSocial,
		v.RegCtb,v.UsuCrea
	from  Voucher v, Empresa e
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''''+@Rango+' and v.RucE=e.Ruc
	Group by v.RucE,e.RSocial,v.RegCtb,v.UsuCrea
	'
--=================================================================================--
--******** CABECERA DETALLE ********--
			--//CAJA BANCO//--
--=================================================================================--
SET @SQL2_1 =
	'
	--1
	select 	
		v.RegCtb,v.Cd_Fte,v.Cd_Aux,
		Case(isnull(len(v.Grdo),0)) when ''0'' then Case(isnull(len(a.RSocial),0)) when ''0'' then a.ApPat+'' ''+a.ApMat+'' ''+a.Nom else a.RSocial end 
					    else v.Grdo 
		end NomAux,
		Case(v.Cd_MdRg) when ''01'' then ''S/.'' else ''US$.'' end Moneda,
		Sum(Case(v.Cd_MdRg) when ''01'' then case(v.MtoD) when 0 then CASE(v.IB_Anulado) when 1 then 0.00 else v.MtoH-v.MtoD end else CASE(v.IB_Anulado) when 1 then 0.00 else v.MtoD-v.MtoH end end
                	            else case(v.MtoD_ME) when 0 then CASE(v.IB_Anulado) when 1 then 0.00 else v.MtoH_ME-v.MtoD_ME end else CASE(v.IB_Anulado) when 1 then 0.00 else v.MtoD_ME-v.MtoH_ME end end end) Total,
		Min(v.Glosa) as Glosa,Max(p.NomCta) as NomCta,b.NCtaB,
				Case(isnull(v.NroChke,0)) when ''0'' then isnull(TipOper,'''') else isnull(v.TipOper,'''')+''    ''+isnull(v.NroChke,'''') end as NroChke,
		Convert(nvarchar,v.FecED,103) as FecDoc,Convert(nvarchar,v.FecMov,103) as FecReg,v.CamMda
	from Voucher v
		left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
		left join PlanCtas p on v.RucE=p.RucE and v.NroCta=p.NroCta and p.Ejer=v.Ejer
		left join Banco b on v.RucE=b.RucE and v.NroCta=b.NroCta
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Cd_Fte=''CB'''+@Rango+' and left(v.NroCta,2)=''10'' and
	      v.RegCtb in (select v1.RegCtb from Voucher v1 where v1.RucE='''+@RucE+''' and v1.Ejer='''+@Ejer+''' and v1.Cd_Fte=''CB'''+@Rango+' and left(v1.NroCta,2)=''10'' group by v1.RegCtb Having count(*) > 1) and v.MtoD=0
	Group by v.RegCtb,v.Cd_Fte,v.Cd_Aux,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.Cd_MdRg,/*v.Glosa,p.NomCta,*/b.NCtaB,v.NroChke,v.FecED,v.FecMov,v.CamMda,v.Grdo,v.TipOper
	
	UNION ALL

	--2
	select 	
		v.RegCtb,v.Cd_Fte,v.Cd_Aux,
		Case(isnull(len(v.Grdo),0)) when ''0'' then Case(isnull(len(a.RSocial),0)) when ''0'' then a.ApPat+'' ''+a.ApMat+'' ''+a.Nom else a.RSocial end 
					    else v.Grdo 
		end NomAux,
		Case(v.Cd_MdRg) when ''01'' then ''S/.'' else ''US$.'' end Moneda,
		Sum(Case(v.Cd_MdRg) when ''01'' then case(v.MtoD) when 0 then CASE(v.IB_Anulado) when 1 then 0.00 else v.MtoH-v.MtoD end else CASE(v.IB_Anulado) when 1 then 0.00 else v.MtoD-v.MtoH end end
                	            else case(v.MtoD_ME) when 0 then CASE(v.IB_Anulado) when 1 then 0.00 else v.MtoH_ME-v.MtoD_ME end else CASE(v.IB_Anulado) when 1 then 0.00 else v.MtoD_ME-v.MtoH_ME end end end) Total,
		Min(v.Glosa) as Glosa,Max(p.NomCta) as NomCta,b.NCtaB,
				Case(isnull(v.NroChke,0)) when ''0'' then isnull(TipOper,'''') else isnull(v.TipOper,'''')+''    ''+isnull(v.NroChke,'''') end as NroChke,
		Convert(nvarchar,v.FecED,103) as FecDoc,Convert(nvarchar,v.FecMov,103) as FecReg,v.CamMda
	from Voucher v
		left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
		left join PlanCtas p on v.RucE=p.RucE and v.NroCta=p.NroCta and p.Ejer=v.Ejer
		left join Banco b on v.RucE=b.RucE and v.NroCta=b.NroCta
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Cd_Fte=''CB'''+@Rango+' and left(v.NroCta,2)=''10'' and
	      v.RegCtb in (select v1.RegCtb from Voucher v1 where v1.RucE='''+@RucE+''' and v1.Ejer='''+@Ejer+''' and v1.Cd_Fte=''CB'''+@Rango+' and left(v1.NroCta,2)=''10'' group by v1.RegCtb Having count(*) < 2)
	Group by v.RegCtb,v.Cd_Fte,v.Cd_Aux,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.Cd_MdRg/*,v.Glosa,p.NomCta*/,b.NCtaB,v.NroChke,v.FecED,v.FecMov,v.CamMda,v.Grdo,v.TipOper
	
	UNION ALL
	'

SET @SQL2_2 =
	'
	--3
	select 	
		v.RegCtb,v.Cd_Fte,v.Cd_Aux,
		Case(isnull(len(v.Grdo),0)) when ''0'' then Case(isnull(len(a.RSocial),0)) when ''0'' then a.ApPat+'' ''+a.ApMat+'' ''+a.Nom else a.RSocial end 
					    else v.Grdo 
		end NomAux,
		Case(v.Cd_MdRg) when ''01'' then ''S/.'' else ''US$.'' end Moneda,
		Sum(Case(v.Cd_MdRg) when ''01'' then case(v.MtoD) when 0 then CASE(v.IB_Anulado) when 1 then 0.00 else v.MtoH-v.MtoD end else CASE(v.IB_Anulado) when 1 then 0.00 else v.MtoD-v.MtoH end end
                	            else case(v.MtoD_ME) when 0 then CASE(v.IB_Anulado) when 1 then 0.00 else v.MtoH_ME-v.MtoD_ME end else CASE(v.IB_Anulado) when 1 then 0.00 else v.MtoD_ME-v.MtoH_ME end end end) Total,
		Min(v.Glosa) as Glosa,Max(p.NomCta) as NomCta,b.NCtaB,
				Case(isnull(v.NroChke,0)) when ''0'' then isnull(TipOper,'''') else isnull(v.TipOper,'''')+''    ''+isnull(v.NroChke,'''') end as NroChke,
		Convert(nvarchar,v.FecED,103) as FecDoc,Convert(nvarchar,v.FecMov,103) as FecReg,v.CamMda
	from Voucher v
		left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
		left join PlanCtas p on v.RucE=p.RucE and v.NroCta=p.NroCta and p.Ejer=v.Ejer
		left join Banco b on v.RucE=b.RucE and v.NroCta=b.NroCta
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Cd_Fte=''CB'''+@Rango+' and left(v.NroCta,2)=''10'' and
	      v.RegCtb in (select v1.RegCtb from Voucher v1 where v1.RucE='''+@RucE+''' and v1.Ejer='''+@Ejer+''' and v1.Cd_Fte=''CB'''+@Rango+' and left(v1.NroCta,2)=''10'' group by v1.RegCtb Having count(*) > 1) and v.MtoH=0
	Group by v.RegCtb,v.Cd_Fte,v.Cd_Aux,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.Cd_MdRg/*,v.Glosa,p.NomCta*/,b.NCtaB,v.NroChke,v.FecED,v.FecMov,v.CamMda,v.Grdo,v.TipOper
	'
--==================================================
	--//LIBRO DIARIOS//--
--==================================================
SET @SQL3 =
	'
	UNION ALL
		select 	v.RegCtb,v.Cd_Fte,v.Cd_Aux,
		Case(isnull(len(v.Grdo),0)) when ''0'' then Case(isnull(len(a.RSocial),0)) when ''0'' then a.ApPat+'' ''+a.ApMat+'' ''+a.Nom else a.RSocial end 
					    else v.Grdo 
		end NomAux,
		''-'' as Moneda,
		0.00 as Total,
		v.Glosa,'''' as NomCta,b.NCtaB,v.NroChke,Convert(nvarchar,v.FecED,103) as FecDoc,Convert(nvarchar,v.FecMov,103) as FecReg,0.00 as CamMda
	from Voucher v
		left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
		left join PlanCtas p on v.RucE=p.RucE and v.NroCta=p.NroCta and p.Ejer=v.Ejer
		left join Banco b on v.RucE=b.RucE and v.NroCta=b.NroCta
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Cd_Fte=''LD'''+@Rango+' and 
	v.Cd_vou = (select min(v2.cd_vou) from voucher v2 where v2.RucE=v.RucE and v2.Ejer=v.Ejer and v2.RegCtb = v.RegCtb ) 
	Group by v.RegCtb,v.Cd_Fte,v.Cd_Aux,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.Cd_MdRg,v.Glosa,p.NomCta,b.NCtaB,v.NroChke,v.FecED,v.FecMov,v.Grdo
	'
--==================================================
	--//REGISTRO VENTA Y COMPRA//--
--==================================================
SET @SQL4 =
	'
	UNION ALL
	select 	v.RegCtb,v.Cd_Fte,v.Cd_Aux,Case(isnull(len(a.RSocial),0)) when ''0'' then a.ApPat+'' ''+a.ApMat+'' ''+a.Nom else a.RSocial end NomAux,
		Case(v.Cd_MdRg) when ''01'' then ''S/.'' else ''US$.'' end Moneda,
		Sum(Case(v.Cd_MdRg) when ''01'' then case(v.MtoD) when 0 then CASE(v.IB_Anulado) when 1 then 0.00 else v.MtoH-v.MtoD end else CASE(v.IB_Anulado) when 1 then 0.00 else v.MtoD-v.MtoH end end
                	            else case(v.MtoD_ME) when 0 then CASE(v.IB_Anulado) when 1 then 0.00 else v.MtoH_ME-v.MtoD_ME end else CASE(v.IB_Anulado) when 1 then 0.00 else v.MtoD_ME-v.MtoH_ME end end end) Total,
		v.Glosa,p.NomCta,b.NCtaB,v.RegCtb as NroChke,Convert(nvarchar,v.FecED,103) as FecDoc,Convert(nvarchar,v.FecMov,103) as FecReg,v.CamMda
	from Voucher v
		left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
		left join PlanCtas p on v.RucE=p.RucE and v.NroCta=p.NroCta and p.Ejer=v.Ejer
		left join Banco b on v.RucE=b.RucE and v.NroCta=b.NroCta
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Cd_Fte in (''RV'',''RC'')'+@Rango+' and p.IB_Aux=''1'' and (left(v.NroCta,2) in (''12'',''42'',''46''))
	Group by v.RegCtb,v.Cd_Fte,v.Cd_Aux,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.Cd_MdRg,v.Glosa,p.NomCta,b.NCtaB,v.NroChke,v.FecED,v.FecMov,v.CamMda
	'
--=================================================================================--
--******** CUPERO DETALLE ********--
--=================================================================================--
SET @SQL5 =
	'
	select
		v.Cd_Vou,v.RegCtb,v.NroCta,c.NomCta,v.Cd_Aux,Case(isnull(len(a.RSocial),0)) when ''0'' then a.ApPat+'' ''+a.ApMat+'' ''+a.Nom else a.RSocial end NomAux,
	 	v.Cd_TD,v.NroSre+''-''+v.NroDoc as Dcto,v.Cd_CC as CCos,v.Cd_SC as SCCos,v.Cd_SS as SSCCos,v.Glosa,
		v.Cd_MdRg,
		CASE(v.IB_Anulado) when 1 then 0.00 else Case(v.IC_CtrMd) when ''$'' then 0 else v.MtoD end end as DebeMN,
		CASE(v.IB_Anulado) when 1 then 0.00 else Case(v.IC_CtrMd) when ''$'' then 0 else v.MtoH end end as HaberMN,
		CASE(v.IB_Anulado) when 1 then 0.00 else Case(v.IC_CtrMd) when ''s'' then 0 else v.MtoD_ME end end as DebeME,
		CASE(v.IB_Anulado) when 1 then 0.00 else Case(v.IC_CtrMd) when ''s'' then 0 else v.MtoH_ME end end as HaberME
	from Voucher v
		left join PlanCtas c on v.RucE=c.RucE and v.NroCta=c.NroCta and c.Ejer=v.Ejer
		left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''''+@Rango+'
	'

Print @SQL1
Print @SQL2_1
Print @SQL2_2
Print @SQL3
Print @SQL4
Print @SQL5

EXEC(@SQL1)
EXEC(@SQL2_1+@SQL2_2+@SQL3+@SQL4+
          'Order by 1')
EXEC(@SQL5)
------CODIGO DE MODIFICACION--------
--CM=MG01
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_VoucherCons_F_RegCtb] --procedimiento final de la consulta de vouchers
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
		v.RucE,e.RSocial,v.RegCtb,''S/.'' as Mda1, ''US$.'' as Mda2,v.UsuCrea as Usuario
	from Voucher v, Empresa e
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and e.Ruc=v.RucE
	      and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RucE,e.RSocial,v.RegCtb,v.UsuCrea
	'		

/************ CEBECERA ***********/

/*CB*/

Set @SQL2_1 = 
	'
	select 
		v.RegCtb,p.NomCta as Nombre,b.NCtaB as NroCta,v.CamMda as TipCmb,
		v.MtoD+v.MtoH as MtoMN, v.MtoD_ME+v.MtoH_ME as MtoME,
		--v.MtoD-v.MtoH as MtoMN, v.MtoD_ME-v.MtoH_ME as MtoME,
		Case(isnull(v.NroChke,0)) when ''0'' then isnull(v.TipOper,'''') else isnull(v.TipOper,'''')+''    ''+isnull(v.NroChke,'''') end as Oper
	from Voucher v 
	left join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	left join Banco b on b.RucE=v.RucE and b.NroCta=v.NroCta and b.Ejer=v.Ejer 
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Cd_Fte=''CB'' and left(v.NroCta,2)=''10''
	      and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RegCtb,p.NomCta,NCtaB,v.CamMda,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME,v.NroChke,v.TipOper
	
	UNION ALL
	'

/*RV y RC*/

Set @SQL2_2 = 
	'
	select 
		v.RegCtb,isnull(a.RSocial,a.ApPat+'' ''+a.ApMat+'' ''+a.Nom)as Nombre,'''' as NroCta,v.CamMda as TipCmb,
		v.MtoD+v.MtoH as MtoMN, v.MtoD_ME+v.MtoH_ME as MtoME,
		--v.MtoD-v.MtoH as MtoMN, v.MtoD_ME-v.MtoH_ME as MtoME,
		v.RegCtb as Oper
	from Voucher v  
	left join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	left join Auxiliar a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Cd_Fte in (''RV'',''RC'') and left(v.NroCta,2) in (''12'',''42'',''46'')
	      and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RegCtb,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.CamMda,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME,v.RegCtb
	
	UNION ALL
	'

/*LD*/

Set @SQL2_3 = 
	'
	select 
		v.RegCtb,isnull(v.Grdo,isnull(a.RSocial,a.ApPat+'' ''+a.ApMat+'' ''+a.Nom))as Nombre,'''' as NroCta,v.CamMda as TipCmb,
		v.MtoD-v.MtoH as MtoMN, v.MtoD_ME-v.MtoH_ME as MtoME,
		Case(isnull(v.NroChke,0)) when ''0'' then isnull(v.TipOper,'''') else isnull(v.TipOper,'''')+''    ''+isnull(v.NroChke,'''') end as Oper
	from Voucher v  
	left join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and p.Ejer=v.Ejer
	left join Auxiliar a on a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Cd_Fte=''LD''
	      and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RegCtb,v.Grdo,a.RSocial,a.ApPat,a.ApMat,a.Nom,v.CamMda,v.MtoD,v.MtoH,v.MtoD_ME,v.MtoH_ME,v.NroChke,v.TipOper
	having isnull(v.Grdo,isnull(a.RSocial,a.ApPat+'' ''+a.ApMat+'' ''+a.Nom))!= ''NULL''
	'

/*GLOSA ***********************************************************************************/
Set @SQL3 = 
	'
	select v.RegCtb,v.Glosa from Voucher v 
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''
	      and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RegCtb,v.Glosa
	'
/*FECHA DOCUMENTO Y DE REGISTRO ***********************************************************/
Set @SQL4 = 
	'
	select v.RegCtb,Max(convert(varchar,v.FecED,103)) as FecDoc,Max(convert(varchar,v.FecMov,103)) as FecReg from Voucher v 
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''
	      and v.RegCtb in ('''+@RegCtb+''')
	Group by v.RegCtb--,convert(varchar,v.FecED,103),convert(varchar,v.FecReg,103)
	--having convert(varchar,v.FecED,103)  != ''NULL''
	'
/************ DETALLE ***********/
Set @SQL5 = 
	'
	select
		v.RegCtb,v.NroCta,c.NomCta,v.Cd_Aux,a.NDoc as NroAux,
	 	v.Cd_TD,v.NroSre+''-''+v.NroDoc as Dcto,v.Cd_CC as CCos,v.Cd_SC as SCCos,v.Cd_SS as SSCCos,v.Glosa,
		v.Cd_MdRg,
		Case(v.IC_CtrMd) when ''$'' then 0 else v.MtoD end DebeMN,
		Case(v.IC_CtrMd) when ''$'' then 0 else v.MtoH end as HaberMN,
		Case(v.IC_CtrMd) when ''s'' then 0 else v.MtoD_ME end as DebeME,
		Case(v.IC_CtrMd) when ''s'' then 0 else v.MtoH_ME end as HaberME
	from Voucher v
		left join PlanCtas c on v.RucE=c.RucE and v.NroCta=c.NroCta and c.Ejer=v.Ejer
		left join Auxiliar a on v.RucE=a.RucE and v.Cd_Aux=a.Cd_Aux
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''
	      and v.RegCtb in ('''+@RegCtb+''')
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

GO

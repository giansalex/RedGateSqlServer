SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ctb_ReporteFinancieroConsAnalisis_Rpt]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_REF nvarchar(5),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@EsCc bit,
@EsSc bit,
@EsSs bit,
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@CadenaCC varchar(8000),
@CadenaSC varchar(8000),
@CadenaSS varchar(8000),
@NroCta1 varchar(12),
@NroCta2 varchar(12),
@NroCta3 varchar(12),
@NroCta4 varchar(12),
@Cd_Rub varchar(10),

@msj varchar(100) output

AS

/*
DECLARE  
	@RucE nvarchar(11),
	@Ejer nvarchar(4),
	@Cd_REF nvarchar(5),
	@PrdoD nvarchar(2),
	@PrdoH nvarchar(2),
	@EsCc bit,
	@EsSc bit,
	@EsSs bit,
	@Cd_CC nvarchar(8),
	@Cd_SC nvarchar(8),
	@Cd_SS nvarchar(8),
	@CadenaCC varchar(8000),
	@CadenaSC varchar(8000),
	@CadenaSS varchar(8000),
	@NroCta1 varchar(12),
	@NroCta2 varchar(12),
	@NroCta3 varchar(12),
	@NroCta4 varchar(12),
	@Cd_Rub varchar(10),

Set @RucE='11111111111'
Set @Ejer='2012'
Set @Cd_REF='REF01'
Set @PrdoD='01'
Set @PrdoH='01'
Set @EsCc='1'
Set @EsSc='0'
Set @EsSs='0'
Set @Cd_CC='01010101'
Set @Cd_SC=''
Set @Cd_SS=''
Set @CadenaCC=''
Set @CadenaSC=''
Set @CadenaSS=''
Set @NroCta1='10'
Set @NroCta2='10.2'
Set @NroCta3='10.2.1'
Set @NroCta4='10.2.1.10'
Set @Cd_Rub=''
*/

--////////// CONDICION //////////
Declare @CondCC Varchar(8000) Set @CondCC=''
Declare @CondSC Varchar(8000) Set @CondSC=''
Declare @CondSS Varchar(8000) Set @CondSS=''

Declare @CondCta Varchar(100) Set @CondCta=''
if(ltrim(isnull(@NroCta1,''))<>'') Set @CondCta=' and left(v.NroCta,2)='''+@NroCta1+''''
else if(ltrim(isnull(@NroCta2,''))<>'') Set @CondCta=' and left(v.NroCta,4)='''+@NroCta2+''''
else if(ltrim(isnull(@NroCta3,''))<>'') Set @CondCta=' and left(v.NroCta,6)='''+@NroCta3+''''
else if(ltrim(isnull(@NroCta4,''))<>'') Set @CondCta=' and v.NroCta='''+@NroCta4+''''

Declare @CondRub Varchar(100) Set @CondRub=''
if(ltrim(isnull(@Cd_Rub,''))<>'') Set @CondRub=' and isnull(p.'+@Cd_REF+','''')='''+@Cd_Rub+''''
	
---------------------------------------------------------------------------
--> Centro de costos
------------------------------
If(@Cd_CC<>'') --> cantidad de cc = 1
	Set @CondCC = ' and v.Cd_CC='''+@Cd_CC+''''
Else
Begin
	If(@CadenaCC<>'') --> cantidad de cc > 1
		Set @CondCC = ' and v.Cd_CC in ('+@CadenaCC+')'
End
--> Sub Centro de costos
------------------------------
If(@Cd_SC<>'') --> cantidad de sc = 1
	Set @CondSC = ' and v.Cd_SC='''+@Cd_SC+''''
Else
Begin
	If(@CadenaSC<>'') --> cantidad de sc > 1
		Set @CondSC = ' and v.Cd_SC in ('+@CadenaSC+')'	
End
--> Sub Sub Centro de costos
------------------------------
If(@Cd_SS<>'') --> cantidad de ss = 1
	Set @CondSS = ' and v.Cd_SS='''+@Cd_SS+''''
Else
Begin
	If(@CadenaSS<>'') --> cantidad de ss > 1
		Set @CondSS = ' and v.Cd_SS in ('+@CadenaSS+')'	
End

Print @CondCC
Print @CondSC
Print @CondSS
---------------------------------------------------------------------------

Declare @TabDatos varchar(8000) Set @TabDatos=''
Declare @TabTotal1 varchar(8000) Set @TabTotal1=''
Declare @TabTotal2 varchar(8000) Set @TabTotal2=''


Set @TabDatos=
'
Select 
	v.Cd_Fte,
	v.RegCtb,
	v.Prdo,
	Convert(varchar,v.FecMov,103) As FecMov,
	v.NroCta,
	p.NomCta,
	v.Glosa,
	Case When isnull(v.Cd_Clt,'''')<>'''' Then c.NDoc Else d.NDoc End As RucAux,
	Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) Else isnull(d.RSocial,isnull(d.ApPat,'''')+'' ''+isnull(d.ApMat,'''')+'' ''+isnull(d.Nom,'''')) End As NomAux,
	t.NCorto As TipDoc,
	v.NroSre As Serie,v.NroDoc As Numero,
	v.MtoD as [Debe S/.],v.MtoH as [Haber S/.],
	v.MtoD_ME as [Debe US$.],v.MtoH_ME as [Haber US$.]
From 
	Voucher v
	Left Join ReporteFinancieroDet f On f.RucE=v.RucE and f.Ejer=v.Ejer and f.Cd_REF='''+@Cd_REF+'''
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.'+@Cd_REF+','''')=f.Cd_Rub
	
	Left Join Cliente2 c On c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
	Left Join Proveedor2 d On d.RucE=v.RucE and d.Cd_Prv=v.Cd_Prv
	Left Join TipDoc t On t.Cd_TD=v.Cd_TD
	Left Join PlanCtas p2 On p2.RucE=v.RucE and p2.Ejer=v.Ejer and p2.NroCta=v.NroCta
Where 
	v.RucE='''+@RucE+'''
	and v.Ejer='''+@Ejer+'''
	and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''
	and isnull(v.IB_Anulado,0)=0
	and isnull(p.'+@Cd_REF+','''')<>''''
	'+@CondRub+'
	'+@CondCta+'
	'+@CondCC+@CondSC+@CondSS+'
'

Set @TabTotal1=
'
Select 
	''--'' As Cd_Fte,
	''--------------'' As RegCtb,
	''--'' As Prdo,
	''----------'' As FecMov,
	''---------'' As NroCta,
	''R. Sumas ='' As NomCta,
	''----------'' As Glosa,
	''-------'' As RucAux,
	''-------'' As NomAux,
	''---'' As TipDoc,
	''---'' As Serie,
	''-------'' As Numero,
	Sum(v.MtoD) as [Debe S/.],Sum(v.MtoH) as [Haber S/.],
	Sum(v.MtoD_ME) as [Debe US$.],Sum(v.MtoH_ME) as [Haber US$.]
From 
	Voucher v
	Left Join ReporteFinancieroDet f On f.RucE=v.RucE and f.Ejer=v.Ejer and f.Cd_REF='''+@Cd_REF+'''
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.'+@Cd_REF+','''')=f.Cd_Rub
Where 
	v.RucE='''+@RucE+'''
	and v.Ejer='''+@Ejer+'''
	and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''
	and isnull(v.IB_Anulado,0)=0
	and isnull(p.'+@Cd_REF+','''')<>''''
	'+@CondRub+'
	'+@CondCta+'
	'+@CondCC+@CondSC+@CondSS+'
'

Set @TabTotal2=
'
	UNION ALL
	select 
		'''' as Cd_Fte,'''' as RegCtb,'''' as Prdo,'''' as FecMov,'''' as NroCta,''Saldo ='' as NomCta,
		''----------'' as Glosa,
		''-------'' As RucAux,
		''-------'' As NomAux,
		''---'' As TipDoc,
		''---'' As Serie,
		''-------'' As Numero,
		0.00 as [Debe S/.],0.00 as [Haber S/.],
		0.00 as [Debe US$.],0.00 as [Haber US$.]
	UNION ALL
	select 
		''--'' as Cd_Fte,''--------------'' as RegCtb,''--'' as Prdo,''----------'' as FecMov,''---------'' as NroCta,''S. Total ='' as NomCta,
		''----------'' as Glosa,
		''-------'' As RucAux,
		''-------'' As NomAux,
		''---'' As TipDoc,
		''---'' As Serie,
		''-------'' As Numero,
		0.00 as [Debe S/.],0.00 as [Haber S/.],
		0.00 as [Debe US$.],0.00 as [Haber US$.]
'


Print @TabDatos
Exec (@TabDatos)

Print @TabTotal1
Print @TabTotal2
Exec (@TabTotal1
	  +''+
	  @TabTotal2)

-- Leyenda --
-- DI : 09/10/2012 <Creacion del SP>

GO

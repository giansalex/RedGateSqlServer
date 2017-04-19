SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Tsr_FlujoCajaCons_Det]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@Moneda nvarchar(2),
@CtasI varchar(8000),
@CtasE varchar(8000),
@Nivel int,

@msj varchar(100) output

AS

/*
Declare @RucE nvarchar(11)
Declare @Ejer nvarchar(4)
Declare @PrdoIni nvarchar(2)
Declare @PrdoFin nvarchar(2)
Declare @Moneda nvarchar(2)
Declare @CtasI varchar(8000)
Declare @CtasE varchar(8000)
Declare @Nivel int 

Set @RucE = '11111111111'
Set @Ejer = '2010'
Set @PrdoIni = '03'
Set @PrdoFin = '03'
Set @Moneda = '01'
Set @CtasI = '''10'''
Set @CtasE = '''10'''
Set @Nivel = 1
*/

Declare @Periodos varchar(8000) Set @Periodos = ''
Declare @TitulosI varchar(8000) Set @TitulosI = ''
Declare @TitulosE varchar(8000) Set @TitulosE = ''
Declare @i int
Declare @f int
Set @i = Convert(int,@PrdoIni)
Set @f = Convert(int,@PrdoFin)
While (@i <= @f)
Begin

Set @Periodos = @Periodos + 
'
Select '''+right('00'+ltrim(@i),2)+''' As Tipo,''A'' As Posi,''0'' As Idx,''0'' As Nivel,'''+User123.DameFormPrdo(right('00'+ltrim(@i),2),'1','1')+''' As Prdo,'''' As NroCta,'''' As NomCta,'''' As RegCtb,'''' As Cd_Fte,'''' As FecMov,'''' As RucAux,'''' As NomAux,'''' As TipDoc,'''' As Serie,'''' As Numero,'''' As Glosa,NULL As MtoD,NULL As MtoH
UNION ALL'
Set @TitulosI = @TitulosI + 
'
Select '''+right('00'+ltrim(@i),2)+''' As Tipo,''B'' As Posi,''1'' As Idx,''0'' As Nivel,'''' As Prdo,''INGRESO'' As NroCta,'''' As NomCta,'''' As RegCtb,'''' As Cd_Fte,'''' As FecMov,'''' As RucAux,'''' As NomAux,'''' As TipDoc,'''' As Serie,'''' As Numero,'''' As Glosa,NULL As MtoD,NULL As MtoH
UNION ALL
'
Set @TitulosE = @TitulosE + 
'
Select '''+right('00'+ltrim(@i),2)+''' As Tipo,''C'' As Posi,''1'' As Idx,''0'' As Nivel,'''' As Prdo,''EGRESO'' As NroCta,'''' As NomCta,'''' As RegCtb,'''' As Cd_Fte,'''' As FecMov,'''' As RucAux,'''' As NomAux,'''' As TipDoc,'''' As Serie,'''' As Numero,'''' As Glosa,NULL As MtoD,NULL As MtoH
UNION ALL
'


Set @i = @i + 1

End
--Set @Periodos = left(@Periodos,len(@Periodos)-11)
Set @TitulosI = left(@TitulosI,len(@TitulosI)-11)
Set @TitulosE = left(@TitulosE,len(@TitulosE)-11)

/*
Print '('
Print @Periodos
Print 'UNION ALL'
Print @TitulosI
Print 'UNION ALL'
Print @TitulosE
Print ') Order by 1,2,3'

exec ( '('+
	@Periodos+
	@TitulosI+
	'UNION ALL'+
	@TitulosE+
	') Order by 1,2,3'
     )
*/
Declare @CondicionI nvarchar(4000) Set @CondicionI = ''
Declare @CondicionE nvarchar(4000) Set @CondicionE = ''

If(@Nivel = 1)
Begin	Set @CondicionI = ' and left(v.NroCta,2) in ('+@CtasI+')'
	Set @CondicionE = ' and left(v.NroCta,2) in ('+@CtasE+')'
End
Else If(@Nivel = 2)
Begin	Set @CondicionI = ' and left(v.NroCta,4) in ('+@CtasI+')'
	Set @CondicionE = ' and left(v.NroCta,4) in ('+@CtasE+')'
End
Else If(@Nivel = 3)
Begin	Set @CondicionI = ' and left(v.NroCta,6) in ('+@CtasI+')'
	Set @CondicionE = ' and left(v.NroCta,6) in ('+@CtasE+')'
End
Else If(@Nivel = 4)
Begin	Set @CondicionI = ' and v.NroCta in ('+@CtasI+')'
	Set @CondicionE = ' and v.NroCta in ('+@CtasE+')'
End

Print @CondicionI
Print @CondicionE


Declare @Mda nvarchar(3)
Set @Mda=''
If(@Moneda = '02') Set @Mda = '_ME'

DECLARE @SQL_I_T1 varchar(8000) SET @SQL_I_T1=''
DECLARE @SQL_I_T2 varchar(8000) SET @SQL_I_T2=''
DECLARE @SQL_I_T3 varchar(8000) SET @SQL_I_T3=''

DECLARE @SQL_E_T1 varchar(8000) SET @SQL_E_T1=''
DECLARE @SQL_E_T2 varchar(8000) SET @SQL_E_T2=''
DECLARE @SQL_E_T3 varchar(8000) SET @SQL_E_T3=''


DECLARE @SQL_I_P1 varchar(8000) SET @SQL_I_P1=''
DECLARE @SQL_I_P2 varchar(8000) SET @SQL_I_P2=''
DECLARE @SQL_I_P3 varchar(8000) SET @SQL_I_P3=''

DECLARE @SQL_E_P1 varchar(8000) SET @SQL_E_P1=''
DECLARE @SQL_E_P2 varchar(8000) SET @SQL_E_P2=''
DECLARE @SQL_E_P3 varchar(8000) SET @SQL_E_P3=''

DECLARE @SQL_G_P1 varchar(8000) SET @SQL_G_P1=''




SET @SQL_I_T1 =
	'
	Select Tipo,Posi,Idx,Nivel,Prdo,NroCta,Descrip,RegCtb,Cd_Fte,FecMov,RucAux,NomAux,TipDoc,Serie,Numero,Glosa,Sum(Debe) As Debe,Sum(Haber) As Haber from
	(
	Select  v.Prdo As Tipo,''B'' As Posi,''2'' As Idx,v.NroCta As Nivel,
		'''' As Prdo,
		v.NroCta As NroCta, 
		c.NomCta As Descrip,
		'''' As RegCtb,
		'''' As Cd_Fte,
		'''' As FecMov,
		'''' As RucAux,
		'''' As NomAux,
		'''' As TipDoc,
		'''' As Serie,'''' As Numero,'''' As Glosa,
		Sum(v.MtoD'+@Mda+') As Debe,
		Sum(v.MtoH'+@Mda+') As Haber
	From
		(
		Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
		Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and Cd_Fte=''CB'' and NroCta like ''10%''
		Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD)<>0
		) As RCTB
	
		Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
		Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta		
		Left Join TipDoc t On t.Cd_TD=v.Cd_TD
	Where	
		v.RucE='''+@RucE+'''
		and v.Ejer='''+@Ejer+'''
		and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
		and isnull(v.IB_EsDes,0)=0 
		--and v.MtoH<>0	
	'
SET @SQL_I_T2 =@CondicionI
SET @SQL_I_T3 =
	'
	Group by 
		v.Prdo,
		v.NroCta, 
		c.NomCta,
		v.MtoD'+@Mda+',
		v.MtoH'+@Mda+'
	Having (v.MtoD'+@Mda+') + (v.MtoH'+@Mda+') <> 0 and Case When left(v.NroCta,2)=''10'' Then v.MtoD'+@Mda+' Else v.MtoD'+@Mda+' End = 0
	) As RTAB
	Group by Tipo,Posi,Idx,Nivel,Prdo,NroCta,Descrip,RegCtb,Cd_Fte,FecMov,RucAux,NomAux,TipDoc,Serie,Numero,Glosa
	'


SET @SQL_E_T1 =
	'
	Select Tipo,Posi,Idx,Nivel,Prdo,NroCta,Descrip,RegCtb,Cd_Fte,FecMov,RucAux,NomAux,TipDoc,Serie,Numero,Glosa,Sum(Debe) As Debe,Sum(Haber) As Haber from
	(
	Select  v.Prdo As Tipo,''C'' As Posi,''2'' As Idx,v.NroCta As Nivel,
		'''' As Prdo,
		v.NroCta As NroCta, 
		c.NomCta As Descrip,
		'''' As RegCtb,
		'''' As Cd_Fte,
		'''' As FecMov,
		'''' As RucAux,
		'''' As NomAux,
		'''' As TipDoc,
		'''' As Serie,'''' As Numero,'''' As Glosa,
		Sum(v.MtoD'+@Mda+') As Debe,
		Sum(v.MtoH'+@Mda+') As Haber
	From
		(
		Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
		Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and Cd_Fte=''CB'' and NroCta like ''10%''
		Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH)<>0
		) As RCTB
	
		Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
		Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta		
		Left Join TipDoc t On t.Cd_TD=v.Cd_TD
	Where	
		v.RucE='''+@RucE+'''
		and v.Ejer='''+@Ejer+'''
		and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
		and isnull(v.IB_EsDes,0)=0 
		--and v.MtoH<>0	
	'
SET @SQL_E_T2 =@CondicionE
SET @SQL_E_T3 =
	'
	Group by 
		v.Prdo,
		v.NroCta, 
		c.NomCta,
		v.MtoD'+@Mda+',
		v.MtoH'+@Mda+'
	Having Sum(v.MtoD'+@Mda+') + Sum(v.MtoH'+@Mda+') <> 0 and Case When left(v.NroCta,2)=''10'' Then v.MtoH'+@Mda+' Else v.MtoH'+@Mda+' End = 0
	) As RTAB
	Group by Tipo,Posi,Idx,Nivel,Prdo,NroCta,Descrip,RegCtb,Cd_Fte,FecMov,RucAux,NomAux,TipDoc,Serie,Numero,Glosa
	'
/************************************************************************************************/
SET @SQL_I_P1 =
	'	
	Select  v.Prdo As Tipo,''B'' As Posi,''3'' As Idx,v.NroCta As Nivel,
		'''' As Prdo,
		v.NroCta As NroCta, 
		v.RegCtb As Descrip,
		v.RegCtb,
		v.Cd_Fte,
		Convert(nvarchar,v.FecMov,103) as FecMov,
		Case When isnull(v.Cd_Clt,'''')<>'''' Then a1.NDoc Else a2.NDoc End As RucAux,
		Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(a1.RSocial,isnull(a1.ApPat,'''')+'' ''+isnull(a1.ApMat,'''')+'' ''+isnull(a1.Nom,'''')) Else isnull(a2.RSocial,isnull(a2.ApPat,'''')+'' ''+isnull(a2.ApMat,'''')+'' ''+isnull(a2.Nom,'''')) End As NomAux,
		t.NCorto As TipDoc,
		v.NroSre As Serie,v.NroDoc As Numero,v.Glosa,
		v.MtoD'+@Mda+' As Debe,
		v.MtoH'+@Mda+' As Haber
	From
		(
		Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
		Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and Cd_Fte=''CB'' and NroCta like ''10%''
		Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD)<>0
		) As RCTB
	
		Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
		Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta		
		Left Join TipDoc t On t.Cd_TD=v.Cd_TD
		Left Join Cliente2 a1 On a1.RucE=v.RucE and a1.Cd_Clt=v.Cd_Clt
		Left Join Proveedor2 a2 On a2.RucE=v.RucE and a2.Cd_Prv=v.Cd_Prv
	Where	
		v.RucE='''+@RucE+'''
		and v.Ejer='''+@Ejer+'''
		and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
		and isnull(v.IB_EsDes,0)=0 
		--and v.MtoH<>0	
	'
SET @SQL_I_P2 =@CondicionI
SET @SQL_I_P3 =
	'
	Group by 
		v.RegCtb,v.Prdo,v.Cd_Fte,
		Convert(nvarchar,v.FecMov,103),
		v.Cd_Clt,a1.NDoc,a2.NDoc,
		a1.RSocial,a1.ApPat,a1.ApMat,a1.Nom,
		a2.RSocial,a2.ApPat,a2.ApMat,a2.Nom,
		t.NCorto,v.NroSre,v.NroDoc,v.Glosa,
		v.NroCta, 
		c.NomCta,
		v.MtoD'+@Mda+',
		v.MtoH'+@Mda+'
	Having v.MtoD'+@Mda+' + v.MtoH'+@Mda+' <> 0 and Case When left(v.NroCta,2)=''10'' Then v.MtoD'+@Mda+' Else v.MtoD'+@Mda+' End = 0
	'
SET @SQL_E_P1 =
	' 
	Select  v.Prdo As Tipo,''C'' As Posi,''3'' As Idx,v.NroCta As Nivel,
		'''' As Prdo,
		v.NroCta As NroCta, 
		v.RegCtb As Descrip,
		v.RegCtb,
		v.Cd_Fte,
		Convert(nvarchar,v.FecMov,103) as FecMov,
		Case When isnull(v.Cd_Clt,'''')<>'''' Then a1.NDoc Else a2.NDoc End As RucAux,
		Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(a1.RSocial,isnull(a1.ApPat,'''')+'' ''+isnull(a1.ApMat,'''')+'' ''+isnull(a1.Nom,'''')) Else isnull(a2.RSocial,isnull(a2.ApPat,'''')+'' ''+isnull(a2.ApMat,'''')+'' ''+isnull(a2.Nom,'''')) End As NomAux,
		t.NCorto As TipDoc,
		v.NroSre As Serie,v.NroDoc As Numero,v.Glosa,
		v.MtoD'+@Mda+' As Debe,
		v.MtoH'+@Mda+' As Haber
	From
		(
		Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
		Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and Cd_Fte=''CB'' and NroCta like ''10%''
		Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH)<>0
		) As RCTB
	
		Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
		Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta		
		Left Join TipDoc t On t.Cd_TD=v.Cd_TD
		Left Join Cliente2 a1 On a1.RucE=v.RucE and a1.Cd_Clt=v.Cd_Clt
		Left Join Proveedor2 a2 On a2.RucE=v.RucE and a2.Cd_Prv=v.Cd_Prv
	Where	
		v.RucE='''+@RucE+'''
		and v.Ejer='''+@Ejer+'''
		and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
		and isnull(v.IB_EsDes,0)=0 
		--and v.MtoH<>0	
	'
SET @SQL_E_P2 =@CondicionE
SET @SQL_E_P3 =
	'
	Group by 
		v.RegCtb,v.Prdo,v.Cd_Fte,
		Convert(nvarchar,v.FecMov,103),
		v.Cd_Clt,a1.NDoc,a2.NDoc,
		a1.RSocial,a1.ApPat,a1.ApMat,a1.Nom,
		a2.RSocial,a2.ApPat,a2.ApMat,a2.Nom,
		t.NCorto,v.NroSre,v.NroDoc,v.Glosa,
		v.NroCta, 
		c.NomCta,
		v.MtoD'+@Mda+',
		v.MtoH'+@Mda+'
	Having v.MtoD'+@Mda+' + v.MtoH'+@Mda+' <> 0 and Case When left(v.NroCta,2)=''10'' Then v.MtoH'+@Mda+' Else v.MtoH'+@Mda+' End = 0
	'


PRINT '('
PRINT @SQL_I_T1
PRINT @SQL_I_T2
PRINT @SQL_I_T3
PRINT ' UNION ALL '
PRINT @SQL_I_P1
PRINT @SQL_I_P2
PRINT @SQL_I_P3
PRINT ' UNION ALL '
PRINT @SQL_E_T1
PRINT @SQL_E_T2
PRINT @SQL_E_T3
PRINT ' UNION ALL '
PRINT @SQL_E_P1
PRINT @SQL_E_P2
PRINT @SQL_E_P3

PRINT ' UNION ALL '

PRINT @Periodos
PRINT @TitulosI
PRINT 'UNION ALL'
PRINT @TitulosE

PRINT ') Order by 1,2,3'


EXEC ('('+
	@SQL_I_T1+
	@SQL_I_T2+
	@SQL_I_T3+
	' UNION ALL '+
	@SQL_I_P1+
	@SQL_I_P2+
	@SQL_I_P3+
	' UNION ALL '+
	@SQL_E_T1+
	@SQL_E_T2+
	@SQL_E_T3+
	' UNION ALL '+
	@SQL_E_P1+
	@SQL_E_P2+
	@SQL_E_P3+
	'UNION ALL'+
	@Periodos+
	@TitulosI+
	'UNION ALL'+
	@TitulosE+
	') Order by 1,2,4,3')

-- Leyenda --
-- DI : 18/02/2011 <Creacion del procedimiento almacenado>

GO

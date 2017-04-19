SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Tsr_FlujoCajaCons3]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoD nvarchar(11),
@PrdoH nvarchar(11),
@Moneda nvarchar(2),
@N1 bit,
@N2 bit,
@N3 bit,
@N4 bit,

@msj varchar(100) output

AS
/*
Declare @RucE nvarchar(11)  Set @RucE='20101949461'
Declare @Ejer nvarchar(4)	Set @Ejer='2011'
Declare @PrdoD nvarchar(11) Set @PrdoD='01'
Declare @PrdoH nvarchar(11) Set @PrdoH='01'
Declare @Moneda nvarchar(2) Set @Moneda='01'
Declare @N1 bit Set @N1=1
Declare @N2 bit Set @N2=1
Declare @N3 bit Set @N3=1
Declare @N4 bit Set @N4=1
*/

Set @N1=1 -- SEMPRE VISUALIZA EL NIVEL Nº1


DECLARE @SQL_CA VARCHAR(8000) SET @SQL_CA=''

DECLARE @i INT SET @i=Convert(int,@PrdoD)
DECLARE @f INT SET @f=Convert(int,@PrdoH)

WHILE(@i<=@f)
BEGIN
	IF(@i>Convert(int,@PrdoD)) SET @SQL_CA=@SQL_CA+' UNION ALL '
	SET @SQL_CA=@SQL_CA+' SELECT '+''''+right('00'+ltrim(@i),2)+''''+' As Concepto,'+''''+user123.DameFormPrdo(right('00'+ltrim(@i),2),1,1)+''''+' As NCorto'
	SET @i=@i+1
END

PRINT @SQL_CA
EXEC (@SQL_CA)

Declare @Mda nvarchar(3) Set @Mda='' if(@Moneda='02') Set @Mda='_ME'
 
Declare @DCGan nvarchar(12) Set @DCGan=''
Declare @DCPer nvarchar(12) Set @DCPer=''
Select @DCGan=DCGan,@DCPer=DCPer From PlanCtasDef Where RucE='20101949461' and Ejer='2011'

DECLARE @SQL_N1_S VARCHAR(8000) SET @SQL_N1_S=''
DECLARE @SQL_N1_I1 VARCHAR(8000) SET @SQL_N1_I1=''
DECLARE @SQL_N1_I2 VARCHAR(8000) SET @SQL_N1_I2=''
DECLARE @SQL_N1_E1 VARCHAR(8000) SET @SQL_N1_E1=''
DECLARE @SQL_N1_E2 VARCHAR(8000) SET @SQL_N1_E2=''

DECLARE @SQL_N2_S VARCHAR(8000) SET @SQL_N1_S=''
DECLARE @SQL_N2_I1 VARCHAR(8000) SET @SQL_N2_I1=''
DECLARE @SQL_N2_I2 VARCHAR(8000) SET @SQL_N2_I2=''
DECLARE @SQL_N2_E1 VARCHAR(8000) SET @SQL_N2_E1=''
DECLARE @SQL_N2_E2 VARCHAR(8000) SET @SQL_N2_E2=''

DECLARE @SQL_N3_S VARCHAR(8000) SET @SQL_N1_S=''
DECLARE @SQL_N3_I1 VARCHAR(8000) SET @SQL_N3_I1=''
DECLARE @SQL_N3_I2 VARCHAR(8000) SET @SQL_N3_I2=''
DECLARE @SQL_N3_E1 VARCHAR(8000) SET @SQL_N3_E1=''
DECLARE @SQL_N3_E2 VARCHAR(8000) SET @SQL_N3_E2=''

DECLARE @SQL_N4_S VARCHAR(8000) SET @SQL_N1_S=''
DECLARE @SQL_N4_I1 VARCHAR(8000) SET @SQL_N4_I1=''
DECLARE @SQL_N4_I2 VARCHAR(8000) SET @SQL_N4_I2=''
DECLARE @SQL_N4_A VARCHAR(8000) SET @SQL_N4_A=''
DECLARE @SQL_N4_E1 VARCHAR(8000) SET @SQL_N4_E1=''
DECLARE @SQL_N4_E2 VARCHAR(8000) SET @SQL_N4_E2=''
DECLARE @SQL_N4_B VARCHAR(8000) SET @SQL_N4_B=''


--****************************************************** INGRESO
IF (@N1 = 1)
BEGIN

SET @SQL_N1_S=
	'
	Select  0 As Posi,1 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto
	From
	(	Select  RucE,Ejer,left(NroCta,2) As NroCta,''S'' As Tipo,Isnull(Sum(MtoD'+@Mda+'-MtoH'+@Mda+'),0.00) As Importe,Prdo As Concepto 
		From    VoucherFC Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo=''00'' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,left(NroCta,2),Prdo
	) As Tab
	  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
	'


SET @SQL_N1_I1=
	'
	
	UNION ALL
	
	Select  1 As Posi,1 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
	From
	(	Select 	
				v.RucE,v.Ejer,left(v.NroCta,2) As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe,v.Prdo As Concepto
		From	
				(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>Sum(MtoH'+@Mda+')) As Res
				Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
				Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
		Where	
				v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
				and v.NroCta not like ''10%''
				and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer
		Group by 
				v.RucE,v.Ejer,left(v.NroCta,2),v.Prdo
		Having 
				Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	) As Tab
	  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
	'
	  
SET @SQL_N1_I2=
	'	
	UNION ALL 

	Select  2 As Posi,1 As Nivel,''_ ''+left('''+@DCGan+''',2)+'' y _''+left('''+@DCPer+''',2) As NroCta,''DIFERENCIA DE CAMBIO'' As NomCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe, v.Prdo As Concepto 
	From	
			(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>Sum(MtoH'+@Mda+')) As Res
			Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
			Inner Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer and (d.DCGan=v.NroCta or d.DCPer=v.NroCta)-- AGREGADO POR PEDIDOS DE GUILLE
			Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	Where  	
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
	Group by 
			v.Prdo
	Having 
			Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	'
	--****************************************************** EGRESO

SET @SQL_N1_E1=
	'
	UNION ALL 
	
	Select  1 As Posi,1 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
	From
	(	Select 	
				v.RucE,v.Ejer,left(v.NroCta,2) As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe,v.Prdo As Concepto
		From	
				(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>Sum(MtoD'+@Mda+')) As Res
				Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
				Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
		Where	
				v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
				and v.NroCta not like ''10%'' 
				and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer
		Group by 
				v.RucE,v.Ejer,left(v.NroCta,2),v.Prdo
		Having 
				Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	) As Tab
	  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
	'
	  
SET @SQL_N1_E2=
	'
	UNION ALL 

	Select  2 As Posi,1 As Nivel,''_ ''+left('''+@DCGan+''',2)+'' y _''+left('''+@DCPer+''',2) As NroCta,''DIFERENCIA DE CAMBIO'' As NomCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe, v.Prdo As Concepto 
	From	
			(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>Sum(MtoD'+@Mda+')) As Res
			Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
			Inner Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer and (d.DCGan=v.NroCta or d.DCPer=v.NroCta)-- AGREGADO POR PEDIDOS DE GUILLE
			Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	Where  	
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
	Group by 
			v.Prdo,v.NroCta,p.NomCta
	Having 
			Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	'
	
	PRINT '('
	PRINT @SQL_N1_S
	PRINT @SQL_N1_I1
	PRINT @SQL_N1_I2
	PRINT @SQL_N1_E1
	PRINT @SQL_N1_E2
	PRINT ')Order by 5 Desc,1,3,7'
	
	EXEC ('('+@SQL_N1_S+
	  @SQL_N1_I1+
	  @SQL_N1_I2+
	  @SQL_N1_E1+
	  @SQL_N1_E2+')Order by 5 Desc,1,3,7')
	
END

IF (@N2 = 1)
BEGIN

SET @SQL_N2_S=
	'
	Select  0 As Posi,2 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto
	From
	(	Select  RucE,Ejer,left(NroCta,4) As NroCta,''S'' As Tipo,Isnull(Sum(MtoD'+@Mda+'-MtoH'+@Mda+'),0.00) As Importe,Prdo As Concepto 
		From    VoucherFC Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo=''00'' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,left(NroCta,4),Prdo
	) As Tab
	  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
	'

SET @SQL_N2_I1=
	'
	
	UNION ALL
	
	Select  1 As Posi,2 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
	From
	(	Select 	
				v.RucE,v.Ejer,left(v.NroCta,4) As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe,v.Prdo As Concepto
		From	
				(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>Sum(MtoH'+@Mda+')) As Res
				Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
				Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
		Where	
				v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
				and v.NroCta not like ''10%''
				and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer
		Group by 
				v.RucE,v.Ejer,left(v.NroCta,4),v.Prdo
		Having 
				Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	) As Tab
	  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
	'
	  
SET @SQL_N2_I2=
	'	
	UNION ALL 

	Select  2 As Posi,2 As Nivel,left(v.NroCta,4) As NroCta,p.NomCta As NomCta,''I'' As Tipo,Sum(v.MtoH-v.MtoD) As Importe, v.Prdo As Concepto 
	From	
			(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>Sum(MtoH'+@Mda+')) As Res
			Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
			Inner Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer and (d.DCGan=v.NroCta or d.DCPer=v.NroCta)-- AGREGADO POR PEDIDOS DE GUILLE
			Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	Where  	
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
	Group by 
			v.Prdo,left(v.NroCta,4),p.NomCta
	Having 
			Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	'
	
	--****************************************************** EGRESO

SET @SQL_N2_E1=
	'
	UNION ALL 
	
	Select  1 As Posi,2 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
	From
	(	Select 	
				v.RucE,v.Ejer,left(v.NroCta,4) As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe,v.Prdo As Concepto
		From	
				(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>Sum(MtoD'+@Mda+')) As Res
				Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
				Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
		Where	
				v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
				and v.NroCta not like ''10%'' 
				and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer
		Group by 
				v.RucE,v.Ejer,left(v.NroCta,4),v.Prdo
		Having 
				Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	) As Tab
	  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
	'
	  
SET @SQL_N2_E2=
	'
	UNION ALL 

	Select  2 As Posi,2 As Nivel,left(v.NroCta,4) As NroCta,p.NomCta As NomCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe, v.Prdo As Concepto 
	From	
			(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>Sum(MtoD'+@Mda+')) As Res
			Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
			Inner Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer and (d.DCGan=v.NroCta or d.DCPer=v.NroCta)-- AGREGADO POR PEDIDOS DE GUILLE
			Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	Where  	
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
	Group by 
			v.Prdo,left(v.NroCta,4),p.NomCta
	Having 
			Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	'
	
	PRINT '('
	PRINT @SQL_N2_S
	PRINT @SQL_N2_I1
	PRINT @SQL_N2_I2
	PRINT @SQL_N2_E1
	PRINT @SQL_N2_E2
	PRINT ')Order by 5 Desc,1,3,7'
	
	EXEC ('('+@SQL_N2_S+
	  @SQL_N2_I1+
	  @SQL_N2_I2+
	  @SQL_N2_E1+
	  @SQL_N2_E2+')Order by 5 Desc,1,3,7')
	
END

IF (@N3 = 1)
BEGIN

SET @SQL_N3_S=
	'
	Select  0 As Posi,3 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto
	From
	(	Select  RucE,Ejer,left(NroCta,6) As NroCta,''S'' As Tipo,Isnull(Sum(MtoD'+@Mda+'-MtoH'+@Mda+'),0.00) As Importe,Prdo As Concepto 
		From    VoucherFC Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo=''00'' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,left(NroCta,6),Prdo
	) As Tab
	  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
	'

SET @SQL_N3_I1=
	'
	
	UNION ALL
	
	Select  1 As Posi,3 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
	From
	(	Select 	
				v.RucE,v.Ejer,left(v.NroCta,6) As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe,v.Prdo As Concepto
		From	
				(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>Sum(MtoH'+@Mda+')) As Res
				Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
				Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
		Where	
				v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
				and v.NroCta not like ''10%''
				and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer
		Group by 
				v.RucE,v.Ejer,left(v.NroCta,6),v.Prdo
		Having 
				Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	) As Tab
	  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
	'
	  
SET @SQL_N3_I2=
	'	
	UNION ALL 

	Select  2 As Posi,3 As Nivel,left(v.NroCta,6) As NroCta,p.NomCta As NomCta,''I'' As Tipo,Sum(v.MtoH-v.MtoD) As Importe, v.Prdo As Concepto 
	From	
			(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>Sum(MtoH'+@Mda+')) As Res
			Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
			Inner Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer and (d.DCGan=v.NroCta or d.DCPer=v.NroCta)-- AGREGADO POR PEDIDOS DE GUILLE
			Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	Where  	
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
	Group by 
			v.Prdo,left(v.NroCta,6),p.NomCta
	Having 
			Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	'
	
	--****************************************************** EGRESO

SET @SQL_N3_E1=
	'
	UNION ALL 
	
	Select  1 As Posi,3 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
	From
	(	Select 	
				v.RucE,v.Ejer,left(v.NroCta,6) As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe,v.Prdo As Concepto
		From	
				(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>Sum(MtoD'+@Mda+')) As Res
				Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
				Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
		Where	
				v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
				and v.NroCta not like ''10%'' 
				and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer
		Group by 
				v.RucE,v.Ejer,left(v.NroCta,6),v.Prdo
		Having 
				Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	) As Tab
	  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
	'
	  
SET @SQL_N3_E2=
	'
	UNION ALL 

	Select  2 As Posi,3 As Nivel,left(v.NroCta,6) As NroCta,p.NomCta As NomCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe, v.Prdo As Concepto 
	From	
			(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>Sum(MtoD'+@Mda+')) As Res
			Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
			Inner Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer and (d.DCGan=v.NroCta or d.DCPer=v.NroCta)-- AGREGADO POR PEDIDOS DE GUILLE
			Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	Where  	
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
	Group by 
			v.Prdo,left(v.NroCta,6),p.NomCta
	Having 
			Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	'
	
	PRINT '('
	PRINT @SQL_N3_S
	PRINT @SQL_N3_I1
	PRINT @SQL_N3_I2
	PRINT @SQL_N3_E1
	PRINT @SQL_N3_E2
	PRINT ')Order by 5 Desc,1,3,7'
	
	EXEC ('('+@SQL_N3_S+
		  @SQL_N3_I1+
		  @SQL_N3_I2+
		  @SQL_N3_E1+
		  @SQL_N3_E2+')Order by 5 Desc,1,3,7')
	
END

IF (@N4 = 1)
BEGIN

SET @SQL_N4_S=
	'
	Select  0 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto
	From
	(	Select  RucE,Ejer,NroCta As NroCta,''S'' As Tipo,Isnull(Sum(MtoD'+@Mda+'-MtoH'+@Mda+'),0.00) As Importe,Prdo As Concepto 
		From    VoucherFC Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo=''00'' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,NroCta,Prdo
	) As Tab
	  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
	'

SET @SQL_N4_I1=
	'
	
	UNION ALL
	
	Select  1 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
	From
	(	Select 	
				v.RucE,v.Ejer,v.NroCta As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe,v.Prdo As Concepto
		From	
				(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>Sum(MtoH'+@Mda+')) As Res
				Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
				Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
		Where	
				v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
				and v.NroCta not like ''10%''
				and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer
		Group by 
				v.RucE,v.Ejer,v.NroCta,v.Prdo
		Having 
				Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	) As Tab
	  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
	'
	  
SET @SQL_N4_I2=
	'	
	UNION ALL 

	Select  2 As Posi,4 As Nivel,v.NroCta As NroCta,p.NomCta As NomCta,''I'' As Tipo,Sum(v.MtoH-v.MtoD) As Importe, v.Prdo As Concepto 
	From	
			(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>Sum(MtoH'+@Mda+')) As Res
			Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
			Inner Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer and (d.DCGan=v.NroCta or d.DCPer=v.NroCta)-- AGREGADO POR PEDIDOS DE GUILLE
			Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	Where  	
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
	Group by 
			v.Prdo,v.NroCta,p.NomCta
	Having 
			Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	'

SET @SQL_N4_A=
	'
	
	UNION ALL
	
	Select  5 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
	From
	(	Select 	
				v.RucE,v.Ejer,v.NroCta As NroCta,''I'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe,v.Prdo As Concepto
		From	
				(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>Sum(MtoH'+@Mda+')) As Res
				Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
				Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
		Where	
				v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
				and v.NroCta like ''10%''
				and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer
		Group by 
				v.RucE,v.Ejer,v.NroCta,v.Prdo
		Having 
				Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	) As Tab
	  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
	'
	
	--****************************************************** EGRESO

SET @SQL_N4_E1=
	'
	UNION ALL 
	
	Select  1 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
	From
	(	Select 	
				v.RucE,v.Ejer,v.NroCta As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe,v.Prdo As Concepto
		From	
				(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>Sum(MtoD'+@Mda+')) As Res
				Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
				Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
		Where	
				v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
				and v.NroCta not like ''10%'' 
				and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer
		Group by 
				v.RucE,v.Ejer,v.NroCta,v.Prdo
		Having 
				Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	) As Tab
	  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
	'
	  
SET @SQL_N4_E2=
	'
	UNION ALL 

	Select  2 As Posi,4 As Nivel,v.NroCta As NroCta,p.NomCta As NomCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe, v.Prdo As Concepto 
	From	
			(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>Sum(MtoD'+@Mda+')) As Res
			Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
			Inner Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer and (d.DCGan=v.NroCta or d.DCPer=v.NroCta)-- AGREGADO POR PEDIDOS DE GUILLE
			Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	Where  	
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
	Group by 
			v.Prdo,v.NroCta,p.NomCta
	Having 
			Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	'
	
SET @SQL_N4_B=
	'
	UNION ALL 
	
	Select  5 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
	From
	(	Select 	
				v.RucE,v.Ejer,v.NroCta As NroCta,''E'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe,v.Prdo As Concepto
		From	
				(Select RucE,Ejer,Prdo,RegCtb From Voucher Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and NroCta like ''10%'' and isnull(IB_Anulado,'''')=0 Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>Sum(MtoD'+@Mda+')) As Res
				Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
				Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
		Where	
				v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
				and v.NroCta like ''10%'' 
				and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer
		Group by 
				v.RucE,v.Ejer,v.NroCta,v.Prdo
		Having 
				Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+')<>0
	) As Tab
	  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
	'
	
	PRINT '('
	PRINT @SQL_N4_S
	PRINT @SQL_N4_I1
	PRINT @SQL_N4_I2
	PRINT @SQL_N4_E1
	PRINT @SQL_N4_E2
	PRINT ')Order by 5 Desc,1,3,7'
	
	
	EXEC ('('+@SQL_N4_S+
		  @SQL_N4_I1+
		  @SQL_N4_I2+
		  @SQL_N4_A+
		  @SQL_N4_E1+
		  @SQL_N4_E2+
		  @SQL_N4_B+')Order by 5 Desc,1,3,7')
END
	

-- Leyenda --
-- Di : 25/03/2011 <Creacion del procedimiento almacenado>
-- Di : 08/07/2011 <Se Cambio la estructura del codigo>
GO

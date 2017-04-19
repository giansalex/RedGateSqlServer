SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_EstadoGP_CC]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@Nivel1 bit,
@Nivel2 bit,
@Nivel3 bit,
@Nivel4 bit,
@Cd_Mda nvarchar(2),
@Opc varchar(1),
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),
@Cadena nvarchar(4000),
@CcAll bit,
@ScAll bit,
@SsAll bit,

@msj varchar(100) output

AS

/*
DECLARE @Cd_CC varchar(8)
DECLARE @Cd_SC varchar(8)
DECLARE @Cd_SS varchar(8)
DECLARE @Cadena nvarchar(4000)
DECLARE @CcAll bit
DECLARE @ScAll bit
DECLARE @SsAll bit

SET @Cd_CC='01010101'
SET @Cd_SC=''
SET @Cd_SS=''
SET @Cadena=''
SET @CcAll=''
SET @ScAll=''
SET @SsAll=''
*/

--************************* Armando la condicion *************************--

if (@Cd_CC is null) Set @Cd_CC = ''
if (@Cd_SC is null) Set @Cd_SC = ''
if (@Cd_SS is null) Set @Cd_SS = ''

Declare @Condicion nvarchar(4000), @esCC bit, @esSC bit, @esSS bit
Set @Condicion = '' 	-- Cadena de condicion
Set @esCC=0  		-- Mostrar CC
Set @esSC=0 		-- Mostrar SC
Set @esSS=0		-- Mostrar SS

If (isnull(@Cd_CC,'') <> '') -- Si cantidad CC = 1
Begin
	Set @Condicion = ' And v.Cd_CC='''+@Cd_CC+'''' -- Definiendo un CC a la condicion
	Set @esCC=1
	If (isnull(@Cd_SC,'') <> '') -- Si cantidad SC = 1
	Begin
		Set @Condicion = @Condicion + ' And v.Cd_SC='''+@Cd_SC+'''' -- Definiendo un SC a la condicion
		Set @esSC=1
		If (isnull(@Cd_SS,'') <> '') -- Si cantidad SS = 1
		Begin
			Set @Condicion = @Condicion + ' And v.Cd_SS='''+@Cd_SS+'''' -- Definiendo un SS a la condicion
			Set @esSS=1
		End
		Else Begin
			If (isnull(@Cadena,'') <> '') -- Si cantidad SC > 1
			Begin
				Set @Condicion = @Condicion + ' And v.Cd_SS in ('+@Cadena+')' -- Definiendo  mas de un SS a la condicion
				Set @esSS=1
			End
			Else Begin
				if(@SsAll=1)
					Set @esSS=1
			End
		End
	End
	Else Begin
		If (isnull(@Cadena,'') <> '') -- Si cantidad SC > 1
		Begin
			Set @Condicion = @Condicion + ' And v.Cd_SC in ('+@Cadena+')' -- Definiendo  mas de un SC a la condicion
			Set @esSC=1
			if(@SsAll=1)
				Set @esSS=1
		End
		Else Begin
			if(@ScAll=1)
			Begin
				Set @esSC=1
				if(@SsAll=1)
					Set @esSS=1
			End
		End
	End
End
Else Begin
	If (isnull(@Cadena,'') <> '') -- Si cantidad CC > 1
	Begin
		Set @Condicion = @Condicion + ' And v.Cd_CC in ('+@Cadena+')' -- Definiendo mas de un CC a la condicion	
		Set @esCC=1
		if(@ScAll=1)
		Begin
			Set @esSC=1
			if(@SsAll=1)
				Set @esSS=1
		End
	End
	Else Begin
		if(@CcAll=1)
		Begin	
			Set @esCC=1
			if(@ScAll=1)
			Begin
				Set @esSC=1
				if(@SsAll=1)
					Set @esSS=1
			End
		End
	End
End

Print 'Condicion : '+@Condicion
Print 'Estado CC : '+Convert(nvarchar,@esCC)
Print 'Estado SC : '+Convert(nvarchar,@esSC)
Print 'Estado SS : '+Convert(nvarchar,@esSS)

--************************************************************************--


DECLARE @MDA NVARCHAR(3) SET @MDA='' IF(@Cd_Mda = '02') SET @MDA='_ME'
DECLARE @CONCEPTO NVARCHAR(200) SET @CONCEPTO='' 
DECLARE @COSTOS NVARCHAR(200) SET @COSTOS=''

DECLARE @PART1 NVARCHAR(50) SET @PART1=''

IF(@esSS=1)
BEGIN	
	SET @CONCEPTO='v.Cd_CC+''_''+v.Cd_SC+''_''+v.Cd_SS'
	SET @PART1='c.NCorto+''_''+s.NCorto+''_''+'
	SET @COSTOS='CCSubSub v LEFT JOIN CCSub s On s.RucE=v.RucE  and s.Cd_CC=v.Cd_CC and s.Cd_SC=v.Cd_SC LEFT JOIN CCostos c On c.RucE=v.RucE and c.Cd_CC=v.Cd_CC'
END
ELSE IF(@esSC=1)
BEGIN	
	SET @CONCEPTO='v.Cd_CC+''_''+Cd_SC'
	SET @PART1='c.NCorto+''_''+'
	SET @COSTOS='CCSub v LEFT JOIN CCostos c On c.RucE=v.RucE and c.Cd_CC=v.Cd_CC'
END
ELSE IF(@esCC=1)
BEGIN	SET @CONCEPTO='v.Cd_CC'
	SET @COSTOS='CCostos v'
END

DECLARE @TIPORPT NVARCHAR(2) SET @TIPORPT='02' IF(@Opc='N') SET @TIPORPT='03'

DECLARE @SQL_CA varchar(8000) SET @SQL_CA=''

DECLARE @SQL_P1 varchar(8000) SET @SQL_P1=''
DECLARE @SQL_P2 varchar(8000) SET @SQL_P2=''
DECLARE @SQL_P3 varchar(8000) SET @SQL_P3=''
DECLARE @SQL_P4 varchar(8000) SET @SQL_P4=''


-- SIEMPRE SE ENVIA EL NIVEL 1 POR DEFECTO

SET @SQL_CA=
	'
SELECT 
 	'+@CONCEPTO+' As Concepto,'+@PART1+'v.NCorto As NCorto
FROM 
	'+@COSTOS+'
WHERE 
	v.RUCE='''+@RucE+'''
	'+@Condicion


SET @SQL_P1=
	'
SELECT left(TAB.NroCTa,2) AS NroCta,p.NomCta,TAB.Cd_Rb,SUM(TAB.Monto) AS Monto,TAB.Concepto FROM
(
SELECT  v.RucE, v.Ejer,
	v.NroCta As NroCta,
	r.Cd_Rb,
	--Sum(Case When p.Cd_EGP'+@Opc+'=r.Cd_Rb Then (Case When isnull(v.MtoH'+@MDA+',0)=0 Then v.MtoD'+@MDA+' Else v.MtoH'+@MDA+' End) Else 0.00 End) As Monto,
	Sum(Case When p.Cd_EGP'+@Opc+'=r.Cd_Rb Then (Case When left(r.Cd_Rb,1)=''E'' and isnull(v.MtoH'+@MDA+',0)<>0 Then v.MtoD'+@MDA+'-v.MtoH'+@MDA+' Else (Case When isnull(v.MtoH'+@MDA+',0)=0 Then v.MtoD'+@MDA+' Else v.MtoH'+@MDA+' End) End) Else 0.00 End) As Monto,
	'+@CONCEPTO+' As Concepto
FROM 
	Voucher v
	Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGP'+@Opc+' And r.Cd_TR='''+@TIPORPT+''' -- FUNCION
WHERE
	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''  and isnull(v.IB_Anulado,0)<>1
	'+@Condicion+'
GROUP BY
	v.RucE, v.Ejer,v.NroCta,r.Cd_Rb,'+@CONCEPTO+'
) AS TAB
	Inner Join PlanCtas p ON p.RucE=TAB.RucE and p.Ejer=TAB.Ejer and p.NroCta=left(TAB.NroCta,2)
GROUP BY 
	left(TAB.NroCTa,2),p.NomCta,TAB.Cd_Rb,TAB.Concepto
ORDER BY
	1,3
	'

If(@Nivel2 = 1)
BEGIN
	SET @SQL_P2=
		'
	SELECT left(TAB.NroCTa,4) AS NroCta,p.NomCta,TAB.Cd_Rb,SUM(TAB.Monto) AS Monto,TAB.Concepto FROM
	(
	SELECT  v.RucE, v.Ejer,
		v.NroCta As NroCta,
		r.Cd_Rb,
		--Sum(Case When p.Cd_EGP'+@Opc+'=r.Cd_Rb Then (Case When isnull(v.MtoH'+@MDA+',0)=0 Then v.MtoD'+@MDA+' Else v.MtoH'+@MDA+' End) Else 0.00 End) As Monto,
		Sum(Case When p.Cd_EGP'+@Opc+'=r.Cd_Rb Then (Case When left(r.Cd_Rb,1)=''E'' and isnull(v.MtoH'+@MDA+',0)<>0 Then v.MtoD'+@MDA+'-v.MtoH'+@MDA+' Else (Case When isnull(v.MtoH'+@MDA+',0)=0 Then v.MtoD'+@MDA+' Else v.MtoH'+@MDA+' End) End) Else 0.00 End) As Monto,
		'+@CONCEPTO+' As Concepto
	FROM 
		Voucher v
		Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
		Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGP'+@Opc+' And r.Cd_TR='''+@TIPORPT+''' -- FUNCION
	WHERE
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and isnull(v.IB_Anulado,0)<>1
		'+@Condicion+'
	GROUP BY
		v.RucE, v.Ejer,v.NroCta,r.Cd_Rb,'+@CONCEPTO+'
	) AS TAB
		Inner Join PlanCtas p ON p.RucE=TAB.RucE and p.Ejer=TAB.Ejer and p.NroCta=left(TAB.NroCta,4)
	GROUP BY 
		left(TAB.NroCTa,4),p.NomCta,TAB.Cd_Rb,TAB.Concepto
	ORDER BY
		1,3
		'
END

If(@Nivel3 = 1)
BEGIN
	SET @SQL_P3=
		'
	SELECT left(TAB.NroCTa,6) AS NroCta,p.NomCta,TAB.Cd_Rb,SUM(TAB.Monto) AS Monto,TAB.Concepto FROM
	(
	SELECT  v.RucE, v.Ejer,
		v.NroCta As NroCta,
		r.Cd_Rb,
		--Sum(Case When p.Cd_EGP'+@Opc+'=r.Cd_Rb Then (Case When isnull(v.MtoH'+@MDA+',0)=0 Then v.MtoD'+@MDA+' Else v.MtoH'+@MDA+' End) Else 0.00 End) As Monto,
		Sum(Case When p.Cd_EGP'+@Opc+'=r.Cd_Rb Then (Case When left(r.Cd_Rb,1)=''E'' and isnull(v.MtoH'+@MDA+',0)<>0 Then v.MtoD'+@MDA+'-v.MtoH'+@MDA+' Else (Case When isnull(v.MtoH'+@MDA+',0)=0 Then v.MtoD'+@MDA+' Else v.MtoH'+@MDA+' End) End) Else 0.00 End) As Monto,
		'+@CONCEPTO+' As Concepto
	FROM 
		Voucher v
		Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
		Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGP'+@Opc+' And r.Cd_TR='''+@TIPORPT+''' -- FUNCION
	WHERE
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and isnull(v.IB_Anulado,0)<>1
		'+@Condicion+'
	GROUP BY
		v.RucE, v.Ejer,v.NroCta,r.Cd_Rb,'+@CONCEPTO+'
	) AS TAB
		Inner Join PlanCtas p ON p.RucE=TAB.RucE and p.Ejer=TAB.Ejer and p.NroCta=left(TAB.NroCta,6)
	GROUP BY 
		left(TAB.NroCTa,6),p.NomCta,TAB.Cd_Rb,TAB.Concepto
	ORDER BY
		1,3
		'
END

If(@Nivel4 = 1)
BEGIN
	SET @SQL_P4=
		'
	SELECT TAB.NroCTa AS NroCta,p.NomCta,TAB.Cd_Rb,SUM(TAB.Monto) AS Monto,TAB.Concepto FROM
	(
	SELECT  v.RucE, v.Ejer,
		v.NroCta As NroCta,
		r.Cd_Rb,
		--Sum(Case When p.Cd_EGP'+@Opc+'=r.Cd_Rb Then (Case When isnull(v.MtoH'+@MDA+',0)=0 Then v.MtoD'+@MDA+' Else v.MtoH'+@MDA+' End) Else 0.00 End) As Monto,
		Sum(Case When p.Cd_EGP'+@Opc+'=r.Cd_Rb Then (Case When left(r.Cd_Rb,1)=''E'' and isnull(v.MtoH'+@MDA+',0)<>0 Then v.MtoD'+@MDA+'-v.MtoH'+@MDA+' Else (Case When isnull(v.MtoH'+@MDA+',0)=0 Then v.MtoD'+@MDA+' Else v.MtoH'+@MDA+' End) End) Else 0.00 End) As Monto,
		'+@CONCEPTO+' As Concepto
	FROM 
		Voucher v
		Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
		Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGP'+@Opc+' And r.Cd_TR='''+@TIPORPT+''' -- FUNCION
	WHERE
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and isnull(v.IB_Anulado,0)<>1
		'+@Condicion+'
	GROUP BY
		v.RucE, v.Ejer,v.NroCta,r.Cd_Rb,'+@CONCEPTO+'
	) AS TAB
		Inner Join PlanCtas p ON p.RucE=TAB.RucE and p.Ejer=TAB.Ejer and p.NroCta=TAB.NroCta
	GROUP BY 
		TAB.NroCTa,p.NomCta,TAB.Cd_Rb,TAB.Concepto
	ORDER BY
		1,3
		'
END

PRINT @SQL_CA
PRINT @SQL_P1
PRINT @SQL_P2
PRINT @SQL_P3
PRINT @SQL_P4

EXEC (@SQL_CA+@SQL_P1+@SQL_P2+@SQL_P3+@SQL_P4)

-- Leyenda --
-- DI : 16/12/2011 <Modificacion del SP , se corrgio los conceptos del reporte>
GO

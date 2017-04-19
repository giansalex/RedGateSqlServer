SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Rpt_Ingreso_Egreso3]

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
DECLARE @RucE nvarchar(11)
DECLARE @Ejer nvarchar(4)
DECLARE @PrdoIni nvarchar(2)
DECLARE @PrdoFin nvarchar(2)
DECLARE @Nivel1 bit
DECLARE @Nivel2 bit
DECLARE @Nivel3 bit
DECLARE @Nivel4 bit
DECLARE @Cd_Mda nvarchar(2)
DECLARE @Opc varchar(1)

DECLARE @Cd_CC varchar(8)
DECLARE @Cd_SC varchar(8)
DECLARE @Cd_SS varchar(8)
DECLARE @Cadena nvarchar(4000)
DECLARE @CcAll bit
DECLARE @ScAll bit
DECLARE @SsAll bit

Set @RucE = '11111111111'
Set @Ejer = '2011'
Set @PrdoIni = '01'
Set @PrdoFin = '06'
Set @Nivel1 = '1'
Set @Nivel2 = '1'
Set @Nivel3 = '1'
Set @Nivel4 = '1'
Set @Cd_Mda = '01'
Set @Opc = 'F'

SET @Cd_CC=''
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
	SET @CONCEPTO='Cd_SS'
	SET @PART1='c.NCorto+''_''+s.NCorto+''_''+'
	SET @COSTOS='CCSubSub v LEFT JOIN CCSub s On s.RucE=v.RucE  and s.Cd_CC=v.Cd_CC and s.Cd_SC=v.Cd_SC LEFT JOIN CCostos c On c.RucE=v.RucE and c.Cd_CC=v.Cd_CC'
END
ELSE IF(@esSC=1)
BEGIN	
	SET @CONCEPTO='Cd_SC'
	SET @PART1='c.NCorto+''_''+'
	SET @COSTOS='CCSub v LEFT JOIN CCostos c On c.RucE=v.RucE and c.Cd_CC=v.Cd_CC'
END
ELSE IF(@esCC=1)
BEGIN	
	SET @CONCEPTO='Cd_CC'
	SET @COSTOS='CCostos v'
END
ELSE
BEGIN	
	SET @CONCEPTO='Prdo'
END

DECLARE @SQL_CA varchar(8000) SET @SQL_CA=''

DECLARE @SQL_P1 varchar(8000) SET @SQL_P1=''
DECLARE @SQL_P2 varchar(8000) SET @SQL_P2=''
DECLARE @SQL_P3 varchar(8000) SET @SQL_P3=''
DECLARE @SQL_P4 varchar(8000) SET @SQL_P4=''

DECLARE @i INT SET @i=Convert(int,@PrdoIni)
DECLARE @f INT SET @f=Convert(int,@PrdoFin)

IF(@esSS=0 and @esSC=0 and @esCC=0)
BEGIN
	WHILE(@i<=@f)
	BEGIN
		IF(@i>Convert(int,@PrdoIni)) SET @SQL_CA=@SQL_CA+' UNION ALL '
		SET @SQL_CA=@SQL_CA+' SELECT '+''''+right('00'+ltrim(@i),2)+''''+' As Concepto,'+''''+user123.DameFormPrdo(right('00'+ltrim(@i),2),1,1)+''''+' As NCorto'
		SET @i=@i+1
	END
END
ELSE
BEGIN
	SET @SQL_CA=
		'
	SELECT 
 		v.'+@CONCEPTO+' As Concepto,'+@PART1+'v.NCorto As NCorto
	FROM 
		'+@COSTOS+'
	WHERE 
		v.RUCE='''+@RucE+'''
		'+@Condicion
END

SET @SQL_P1=
	'
SELECT left(TAB.NroCTa,2) AS NroCta,p.NomCta,TAB.Codigo,SUM(TAB.Monto) AS Monto,TAB.Concepto FROM
(
SELECT  v.RucE, v.Ejer,
	v.NroCta As NroCta,
	p.IC_IE'+@Opc+' As Codigo,--r.Cd_Rb,
	Sum(v.MtoH'+@MDA+' - v.MtoD'+@MDA+') As Monto,--Sum(Case When p.Cd_EGP'+@Opc+'=r.Cd_Rb Then (Case When isnull(v.MtoH'+@MDA+',0)=0 Then v.MtoD'+@MDA+' Else v.MtoH'+@MDA+' End) Else 0.00 End) As Monto,
	v.'+@CONCEPTO+' As Concepto
FROM 
	Voucher v
	Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IC_IE'+@Opc+','''') in (''I'',''E'')
WHERE
	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''  and isnull(v.IB_Anulado,0)<>1
	'+@Condicion+'
GROUP BY
	v.RucE, v.Ejer,v.NroCta,p.IC_IE'+@Opc+',v.'+@CONCEPTO+'
) AS TAB
	Inner Join PlanCtas p ON p.RucE=TAB.RucE and p.Ejer=TAB.Ejer and p.NroCta=left(TAB.NroCta,2)
GROUP BY 
	left(TAB.NroCTa,2),p.NomCta,TAB.Codigo,TAB.Concepto
ORDER BY
	3 DESC,1
	'

If(@Nivel2 = 1)
BEGIN
	SET @SQL_P2=
		'
	SELECT left(TAB.NroCTa,4) AS NroCta,p.NomCta,TAB.Codigo,SUM(TAB.Monto) AS Monto,TAB.Concepto FROM
	(
	SELECT  v.RucE, v.Ejer,v.NroCta As NroCta,p.IC_IE'+@Opc+' As Codigo,--r.Cd_Rb,
		Sum(v.MtoH'+@MDA+' - v.MtoD'+@MDA+') As Monto,
		v.'+@CONCEPTO+' As Concepto
	FROM 
		Voucher v
		Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IC_IE'+@Opc+','''') in (''I'',''E'')
	WHERE
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''  and isnull(v.IB_Anulado,0)<>1
		'+@Condicion+'
	GROUP BY
		v.RucE, v.Ejer,v.NroCta,p.IC_IE'+@Opc+',v.'+@CONCEPTO+'
	) AS TAB
		Inner Join PlanCtas p ON p.RucE=TAB.RucE and p.Ejer=TAB.Ejer and p.NroCta=left(TAB.NroCta,4)
	GROUP BY 
		left(TAB.NroCTa,4),p.NomCta,TAB.Codigo,TAB.Concepto
	ORDER BY
		3 DESC,1
		'
END

If(@Nivel3 = 1)
BEGIN
	SET @SQL_P3=
		'
	SELECT left(TAB.NroCTa,6) AS NroCta,p.NomCta,TAB.Codigo,SUM(TAB.Monto) AS Monto,TAB.Concepto FROM
	(
	SELECT  v.RucE, v.Ejer,v.NroCta As NroCta,p.IC_IE'+@Opc+' As Codigo,--r.Cd_Rb,
		Sum(v.MtoH'+@MDA+' - v.MtoD'+@MDA+') As Monto,
		v.'+@CONCEPTO+' As Concepto
	FROM 
		Voucher v
		Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IC_IE'+@Opc+','''') in (''I'',''E'')
	WHERE
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''  and isnull(v.IB_Anulado,0)<>1
		'+@Condicion+'
	GROUP BY
		v.RucE, v.Ejer,v.NroCta,p.IC_IE'+@Opc+',v.'+@CONCEPTO+'
	) AS TAB
		Inner Join PlanCtas p ON p.RucE=TAB.RucE and p.Ejer=TAB.Ejer and p.NroCta=left(TAB.NroCta,6)
	GROUP BY 
		left(TAB.NroCTa,6),p.NomCta,TAB.Codigo,TAB.Concepto
	ORDER BY
		3 DESC,1
		'
END

If(@Nivel4 = 1)
BEGIN
	SET @SQL_P4=
		'
	SELECT TAB.NroCTa AS NroCta,p.NomCta,TAB.Codigo,SUM(TAB.Monto) AS Monto,TAB.Concepto FROM
	(
	SELECT  v.RucE, v.Ejer,v.NroCta As NroCta,p.IC_IE'+@Opc+' As Codigo,--r.Cd_Rb,
		Sum(v.MtoH'+@MDA+' - v.MtoD'+@MDA+') As Monto,
		v.'+@CONCEPTO+' As Concepto
	FROM 
		Voucher v
		Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IC_IE'+@Opc+','''') in (''I'',''E'')
	WHERE
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''  and isnull(v.IB_Anulado,0)<>1
		'+@Condicion+'
	GROUP BY
		v.RucE, v.Ejer,v.NroCta,p.IC_IE'+@Opc+',v.'+@CONCEPTO+'
	) AS TAB
		Inner Join PlanCtas p ON p.RucE=TAB.RucE and p.Ejer=TAB.Ejer and p.NroCta=TAB.NroCta
	GROUP BY 
		TAB.NroCTa,p.NomCta,TAB.Codigo,TAB.Concepto
	ORDER BY
		3 DESC,1
		'
END

PRINT @SQL_CA
PRINT @SQL_P1
PRINT @SQL_P2
PRINT @SQL_P3
PRINT @SQL_P4

EXEC (@SQL_CA+@SQL_P1+@SQL_P2+@SQL_P3+@SQL_P4)


-- Leyenda --
-- DI : 20/10/2011 <Creacion del procedimiento almacenado>

GO

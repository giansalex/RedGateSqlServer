SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_EstadoGPPsp_CC]

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

DECLARE @CONCEPTO NVARCHAR(10) SET @CONCEPTO='' 
DECLARE @COSTOS NVARCHAR(10) SET @COSTOS=''
IF(@esSS=1)
BEGIN	SET @CONCEPTO='Cd_SS'
	SET @COSTOS='CCSubSub'
END
ELSE IF(@esSC=1)
BEGIN	SET @CONCEPTO='Cd_SC'
	SET @COSTOS='CCSub'
END
ELSE IF(@esCC=1)
BEGIN	SET @CONCEPTO='Cd_CC'
	SET @COSTOS='CCostos'
END


DECLARE @TIPORPT NVARCHAR(2) SET @TIPORPT='02' IF(@Opc='N') SET @TIPORPT='03'

Declare @periodos_col varchar(4000) Set @periodos_col=''
Declare @i int Set @i=Convert(int,@PrdoIni)
Declare @f int Set @f=Convert(int,@PrdoFin)

While(@i<=@f)
Begin
	Set @periodos_col=@periodos_col+'v.'+user123.DameFormPrdo(right('00'+ltrim(@i),2),0,1)+'+'
	Set @i=@i+1
End

Print @periodos_col
Set @periodos_col = left(@periodos_col,len(@periodos_col)-1)
Set @periodos_col = ',Sum(Case When p.Cd_EGPF=r.Cd_Rb Then '+@periodos_col+' Else 0.00 End) As Monto'
Print @periodos_col

--*******************************************************************

DECLARE @SQL_P1 varchar(8000) SET @SQL_P1=''
DECLARE @SQL_P2 varchar(8000) SET @SQL_P2=''
DECLARE @SQL_P3 varchar(8000) SET @SQL_P3=''
DECLARE @SQL_P4 varchar(8000) SET @SQL_P4=''


-- SIEMPRE SE ENVIA EL NIVEL 1 POR DEFECTO

SET @SQL_P1=
	'
SELECT p.NomCta,TAB.* FROM
(
SELECT  
	v.RucE,v.Ejer,
	left(v.NroCta,2) As NroCta,
	r.Cd_Rb,
	r.IN_Nivel As Nivel,
	v.'+@CONCEPTO+' As Concepto
	'+@periodos_col+'
FROM 
	Presupuesto v
	Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGPF And r.Cd_TR='''+@TIPORPT+''' -- FUNCION Y NATURALEZ
WHERE
	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''''+@Condicion+'
GROUP BY
	v.RucE,v.Ejer,left(v.NroCta,2),r.Cd_Rb,r.IN_Nivel,v.'+@CONCEPTO+'
) As TAB
  Left Join PlanCtas p ON p.RucE=TAB.RucE and p.Ejer=TAB.Ejer and p.NroCta=TAB.NroCta
ORDER BY 4,5
	'

If(@Nivel2 = 1)
BEGIN
	SET @SQL_P2=
		'
	SELECT p.NomCta,TAB.* FROM
	(
	SELECT  
		v.RucE,v.Ejer,
		left(v.NroCta,4) As NroCta,
		r.Cd_Rb,
		r.IN_Nivel As Nivel,
		v.'+@CONCEPTO+' As Concepto
		'+@periodos_col+'
	FROM 
		Presupuesto v
		Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
		Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGPF And r.Cd_TR='''+@TIPORPT+''' -- FUNCION Y NATURALEZ
	WHERE
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''''+@Condicion+'
	GROUP BY
		v.RucE,v.Ejer,left(v.NroCta,4),r.Cd_Rb,r.IN_Nivel,v.'+@CONCEPTO+'
	) As TAB
		Left Join PlanCtas p ON p.RucE=TAB.RucE and p.Ejer=TAB.Ejer and p.NroCta=TAB.NroCta
	ORDER BY 4,5
		'
END

If(@Nivel3 = 1)
BEGIN
	SET @SQL_P3=
		'
	SELECT p.NomCta,TAB.* FROM
	(
	SELECT  
		v.RucE,v.Ejer,
		left(v.NroCta,6) As NroCta,
		r.Cd_Rb,
		r.IN_Nivel As Nivel,
		v.'+@CONCEPTO+' As Concepto
		'+@periodos_col+'
	FROM 
		Presupuesto v
		Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
		Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGPF And r.Cd_TR='''+@TIPORPT+''' -- FUNCION Y NATURALEZ
	WHERE
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''''+@Condicion+'
	GROUP BY
		v.RucE,v.Ejer,left(v.NroCta,6),r.Cd_Rb,r.IN_Nivel,v.'+@CONCEPTO+'
	) As TAB
		Left Join PlanCtas p ON p.RucE=TAB.RucE and p.Ejer=TAB.Ejer and p.NroCta=TAB.NroCta
	ORDER BY 4,5
		'
END

If(@Nivel4 = 1)
BEGIN
	SET @SQL_P4=
		'
	SELECT p.NomCta,TAB.* FROM
	(
	SELECT  
		v.RucE,v.Ejer,
		v.NroCta As NroCta,
		r.Cd_Rb,
		r.IN_Nivel As Nivel,
		v.'+@CONCEPTO+' As Concepto
		'+@periodos_col+'
	FROM 
		Presupuesto v
		Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
		Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGPF And r.Cd_TR='''+@TIPORPT+''' -- FUNCION Y NATURALEZ
	WHERE
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''''+@Condicion+'
	GROUP BY
		v.RucE,v.Ejer,v.NroCta,r.Cd_Rb,r.IN_Nivel,v.'+@CONCEPTO+'
	) As TAB
		Left Join PlanCtas p ON p.RucE=TAB.RucE and p.Ejer=TAB.Ejer and p.NroCta=TAB.NroCta
	ORDER BY 4,5
		'
END

PRINT @SQL_P1
PRINT @SQL_P2
PRINT @SQL_P3
PRINT @SQL_P4

EXEC (@SQL_P1+@SQL_P2+@SQL_P3+@SQL_P4)

-- Leyenda --
-- DI : 03/08/2011 <Creacion del procedimiento almacenado>

GO

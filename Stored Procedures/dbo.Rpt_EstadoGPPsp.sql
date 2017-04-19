SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_EstadoGPPsp]

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
@msj varchar(100) output

AS


DECLARE @MDA NVARCHAR(3) SET @MDA='' IF(@Cd_Mda='02') SET @MDA='_ME'
DECLARE @TIPORPT NVARCHAR(2) SET @TIPORPT='02' IF(@Opc='N') SET @TIPORPT='03'

Declare @periodos_col varchar(4000) Set @periodos_col=''
Declare @i int Set @i=Convert(int,@PrdoIni)
Declare @f int Set @f=Convert(int,@PrdoFin)

While(@i<=@f)
Begin
	Set @periodos_col=@periodos_col+'
,Sum(Case When p.Cd_EGPF=r.Cd_Rb Then v.'+user123.DameFormPrdo(right('00'+ltrim(@i),2),0,1)+@MDA+' Else 0.00 End) As '+user123.DameFormPrdo(right('00'+ltrim(@i),2),1,1)
	Set @i=@i+1
End

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
	r.IN_Nivel As Nivel
	'+@periodos_col+'
FROM 
	Presupuesto v
	Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGPF And r.Cd_TR='''+@TIPORPT+''' -- FUNCION Y NATURALEZ
WHERE
	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''
GROUP BY
	v.RucE,v.Ejer,left(v.NroCta,2),r.Cd_Rb,r.IN_Nivel
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
		r.IN_Nivel As Nivel
		'+@periodos_col+'
	FROM 
		Presupuesto v
		Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
		Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGPF And r.Cd_TR='''+@TIPORPT+''' -- FUNCION Y NATURALEZ
	WHERE
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''
	GROUP BY
		v.RucE,v.Ejer,left(v.NroCta,4),r.Cd_Rb,r.IN_Nivel
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
		r.IN_Nivel As Nivel
		'+@periodos_col+'
	FROM 
		Presupuesto v
		Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
		Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGPF And r.Cd_TR='''+@TIPORPT+''' -- FUNCION Y NATURALEZ
	WHERE
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''
	GROUP BY
		v.RucE,v.Ejer,left(v.NroCta,6),r.Cd_Rb,r.IN_Nivel
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
		r.IN_Nivel As Nivel
		'+@periodos_col+'
	FROM 
		Presupuesto v
		Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
		Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGPF And r.Cd_TR='''+@TIPORPT+''' -- FUNCION Y NATURALEZ
	WHERE
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''
	GROUP BY
		v.RucE,v.Ejer,v.NroCta,r.Cd_Rb,r.IN_Nivel
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

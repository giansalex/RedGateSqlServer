SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_EstadoGP]

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


DECLARE @MDA NVARCHAR(3) SET @MDA='' IF(@Cd_Mda = '02') SET @MDA='_ME'
DECLARE @TIPORPT NVARCHAR(2) SET @TIPORPT='02' IF(@Opc='N') SET @TIPORPT='03'

DECLARE @TRP NVARCHAR(1) SET @TRP='F' IF(@TIPORPT='03') SET @TRP='N'

DECLARE @SQL_CA varchar(8000) SET @SQL_CA=''

DECLARE @SQL_P1 varchar(8000) SET @SQL_P1=''
DECLARE @SQL_P2 varchar(8000) SET @SQL_P2=''
DECLARE @SQL_P3 varchar(8000) SET @SQL_P3=''
DECLARE @SQL_P4 varchar(8000) SET @SQL_P4=''


-- SIEMPRE SE ENVIA EL NIVEL 1 POR DEFECTO

DECLARE @i INT SET @i=Convert(int,@PrdoIni)
DECLARE @f INT SET @f=Convert(int,@PrdoFin)

WHILE(@i<=@f)
BEGIN
	IF(@i>Convert(int,@PrdoIni)) SET @SQL_CA=@SQL_CA+' UNION ALL '
	SET @SQL_CA=@SQL_CA+' SELECT '+''''+right('00'+ltrim(@i),2)+''''+' As Concepto,'+''''+user123.DameFormPrdo(right('00'+ltrim(@i),2),1,1)+''''+' As NCorto'
	SET @i=@i+1
END


SET @SQL_P1=
	'
SELECT left(TAB.NroCTa,2) AS NroCta,p.NomCta,TAB.Cd_Rb,Case When left(TAB.Cd_Rb,1)=''E'' Then Sum(TAB.Monto)*-1 Else Sum(TAB.Monto) End AS Monto,TAB.Concepto FROM
(
SELECT  v.RucE, v.Ejer,
	v.NroCta,
	r.Cd_Rb,
	Sum(Case When p.Cd_EGP'+@TRP+'=r.Cd_Rb Then v.MtoH'+@MDA+'-v.MtoD'+@MDA+' Else 0.00 End) As Monto,
	--Sum(Case When p.Cd_EGP'+@TRP+'=r.Cd_Rb Then (Case When isnull(v.MtoH'+@MDA+',0)=0 Then v.MtoD'+@MDA+' Else v.MtoH'+@MDA+' End) Else 0.00 End) As Monto,
	v.Prdo As Concepto
FROM 
	Voucher v
	Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGP'+@TRP+' And r.Cd_TR='''+@TIPORPT+''' -- FUNCION Y NATURALEZ
WHERE
	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and isnull(v.IB_Anulado,0)<>1
GROUP BY
	v.RucE, v.Ejer,v.NroCta,r.Cd_Rb,v.Prdo
) AS TAB
	Inner Join PlanCtas p ON p.RucE=TAB.RucE and p.Ejer=TAB.Ejer and p.NroCta=left(TAB.NroCta,2)
GROUP BY 
	left(TAB.NroCTa,2),p.NomCta,TAB.Cd_Rb,TAB.Concepto
ORDER BY 1,3
	'

If(@Nivel2 = 1)
BEGIN
	SET @SQL_P2=
		'
	SELECT left(TAB.NroCTa,4) AS NroCta,p.NomCta,TAB.Cd_Rb,Case When left(TAB.Cd_Rb,1)=''E'' Then Sum(TAB.Monto)*-1 Else Sum(TAB.Monto) End AS Monto,TAB.Concepto FROM
	(
	SELECT  v.RucE, v.Ejer,
		v.NroCta,
		r.Cd_Rb,
		Sum(Case When p.Cd_EGP'+@TRP+'=r.Cd_Rb Then v.MtoH'+@MDA+'-v.MtoD'+@MDA+' Else 0.00 End) As Monto,
		--Sum(Case When p.Cd_EGP'+@TRP+'=r.Cd_Rb Then (Case When isnull(v.MtoH'+@MDA+',0)=0 Then v.MtoD'+@MDA+' Else v.MtoH'+@MDA+' End) Else 0.00 End) As Monto,
		v.Prdo As Concepto
	FROM 
		Voucher v
		Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
		Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGP'+@TRP+' And r.Cd_TR='''+@TIPORPT+''' -- FUNCION Y NATURALEZ
	WHERE
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and isnull(v.IB_Anulado,0)<>1
	GROUP BY
		v.RucE, v.Ejer,v.NroCta,r.Cd_Rb,v.Prdo
	) AS TAB
		Inner Join PlanCtas p ON p.RucE=TAB.RucE and p.Ejer=TAB.Ejer and p.NroCta=left(TAB.NroCta,4)
	GROUP BY 
		left(TAB.NroCTa,4),p.NomCta,TAB.Cd_Rb,TAB.Concepto
	ORDER BY 1,3
		'
END

If(@Nivel3 = 1)
BEGIN
	SET @SQL_P3=
		'
	SELECT left(TAB.NroCTa,6) AS NroCta,p.NomCta,TAB.Cd_Rb,Case When left(TAB.Cd_Rb,1)=''E'' Then Sum(TAB.Monto)*-1 Else Sum(TAB.Monto) End AS Monto,TAB.Concepto FROM
	(
	SELECT  v.RucE, v.Ejer,
		v.NroCta,
		r.Cd_Rb,
		Sum(Case When p.Cd_EGP'+@TRP+'=r.Cd_Rb Then v.MtoH'+@MDA+'-v.MtoD'+@MDA+' Else 0.00 End) As Monto,
		--Sum(Case When p.Cd_EGP'+@TRP+'=r.Cd_Rb Then (Case When isnull(v.MtoH'+@MDA+',0)=0 Then v.MtoD'+@MDA+' Else v.MtoH'+@MDA+' End) Else 0.00 End) As Monto,
		v.Prdo As Concepto
	FROM 
		Voucher v
		Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
		Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGP'+@TRP+' And r.Cd_TR='''+@TIPORPT+''' -- FUNCION Y NATURALEZ
	WHERE
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''  and isnull(v.IB_Anulado,0)<>1
	GROUP BY
		v.RucE, v.Ejer,v.NroCta,r.Cd_Rb,v.Prdo
	) AS TAB
		Inner Join PlanCtas p ON p.RucE=TAB.RucE and p.Ejer=TAB.Ejer and p.NroCta=left(TAB.NroCta,6)
	GROUP BY 
		left(TAB.NroCTa,6),p.NomCta,TAB.Cd_Rb,TAB.Concepto
	ORDER BY 1,3
		'
END

If(@Nivel4 = 1)
BEGIN
	SET @SQL_P4=
		'
	SELECT TAB.NroCTa AS NroCta,p.NomCta,TAB.Cd_Rb,Case When left(TAB.Cd_Rb,1)=''E'' Then Sum(TAB.Monto)*-1 Else Sum(TAB.Monto) End AS Monto,TAB.Concepto FROM
	(
	SELECT  v.RucE, v.Ejer,
		v.NroCta,
		r.Cd_Rb,
		Sum(Case When p.Cd_EGP'+@TRP+'=r.Cd_Rb Then v.MtoH'+@MDA+'-v.MtoD'+@MDA+' Else 0.00 End) As Monto,
		--Sum(Case When p.Cd_EGP'+@TRP+'=r.Cd_Rb Then (Case When isnull(v.MtoH'+@MDA+',0)=0 Then v.MtoD'+@MDA+' Else v.MtoH'+@MDA+' End) Else 0.00 End) As Monto,
		v.Prdo As Concepto
	FROM 
		Voucher v
		Inner Join PlanCtas p ON p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
		Inner Join RubrosRpt r ON r.Cd_Rb=p.Cd_EGP'+@TRP+' And r.Cd_TR='''+@TIPORPT+''' -- FUNCION Y NATURALEZ
	WHERE
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''  and isnull(v.IB_Anulado,0)<>1
	GROUP BY
		v.RucE, v.Ejer,v.NroCta,r.Cd_Rb,v.Prdo
	) AS TAB
		Inner Join PlanCtas p ON p.RucE=TAB.RucE and p.Ejer=TAB.Ejer and p.NroCta=TAB.NroCta
	GROUP BY 
		TAB.NroCTa,p.NomCta,TAB.Cd_Rb,TAB.Concepto
	ORDER BY 1,3
		'
END

PRINT @SQL_CA
PRINT @SQL_P1
PRINT @SQL_P2
PRINT @SQL_P3
PRINT @SQL_P4

EXEC (@SQL_CA+@SQL_P1+@SQL_P2+@SQL_P3+@SQL_P4)
GO

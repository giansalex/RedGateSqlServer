SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Rpt_BalanceGeneral2_CC]


@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@n1 bit,
@n2 bit,
@n3 bit,
@n4 bit,
@Cd_Mda nvarchar(2),
@Acumulado bit,
@NroCtaD nvarchar(12),
@NroCtaH nvarchar(12),

@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),
@Cadena nvarchar(4000),
@CcAll bit,
@ScAll bit,
@SsAll bit,

@msj varchar(100) output

AS

Set @Acumulado = 1

/*
Declare @RucE nvarchar(11)
Declare @Ejer nvarchar(4)
Declare @PrdoIni nvarchar(2)
Declare @PrdoFin nvarchar(2)
Declare @n1 bit
Declare @n2 bit
Declare @n3 bit
Declare @n4 bit
Declare @Cd_Mda nvarchar(2)
Declare @Acumulado bit
Declare @NroCtaD nvarchar(12)
Declare @NroCtaH nvarchar(12)
Declare @Cd_CC varchar(8)
Declare @Cd_SC varchar(8)
Declare @Cd_SS varchar(8)
Declare @Cadena nvarchar(4000)
Declare @CcAll bit
Declare @ScAll bit
Declare @SsAll bit

Set @RucE ='11111111111'
Set @Ejer ='2011'
Set @PrdoIni ='01'
Set @PrdoFin ='07'
Set @n1 ='1'
Set @n2 ='0'
Set @n3 ='0'
Set @n4 ='0'
Set @Cd_Mda ='01'
Set @Acumulado ='1'
Set @NroCtaD =''
Set @NroCtaH =''
Set @Cd_CC=''
Set @Cd_SC=''
Set @Cd_SS=''
Set @Cadena=''
Set @CcAll='1'
Set @ScAll='1'
Set @SsAll='1'
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
	SET @PART1='''''+c.NCorto+''_''+s.NCorto+''_''+'
	SET @COSTOS='CCSubSub v LEFT JOIN CCSub s On s.RucE=v.RucE  and s.Cd_CC=v.Cd_CC and s.Cd_SC=v.Cd_SC LEFT JOIN CCostos c On c.RucE=v.RucE and c.Cd_CC=v.Cd_CC'
END
ELSE IF(@esSC=1)
BEGIN	
	SET @CONCEPTO='Cd_SC'
	SET @PART1='''''+c.NCorto+''_''+'
	SET @COSTOS='CCSub v LEFT JOIN CCostos c On c.RucE=v.RucE and c.Cd_CC=v.Cd_CC'
END
ELSE IF(@esCC=1)
BEGIN	SET @CONCEPTO='Cd_CC'
	SET @COSTOS='CCostos v'
END

DECLARE @SQL_CACC varchar(8000) SET @SQL_CACC=''
DECLARE @SQL_CAMM varchar(8000) SET @SQL_CAMM=''

DECLARE @SQL_P1 varchar(8000) SET @SQL_P1=''
DECLARE @SQL_P2 varchar(8000) SET @SQL_P2=''
DECLARE @SQL_P3 varchar(8000) SET @SQL_P3=''
DECLARE @SQL_P4 varchar(8000) SET @SQL_P4=''

DECLARE @OpcMens varchar(100) SET @OpcMens=''
DECLARE @OpcGrou varchar(100) SET @OpcGrou=''

SET @SQL_CACC=
	'
SELECT 
 	v.'+@CONCEPTO+' As Concepto,'+@PART1+'v.NCorto As NCorto
FROM 
	'+@COSTOS+'
WHERE 
	v.RUCE='''+@RucE+'''
	'+@Condicion

PRINT @SQL_CACC
EXEC(@SQL_CACC)



IF(@Acumulado=1)
Begin
	SET @OpcMens=','''' As Periodo'
	SET @OpcGrou=''
	SELECT TOP 0 '' As Concepto, '' As NCorto
End
Else
Begin -- Es Mensualizado
	SET @OpcMens=',v.Prdo As Periodo'
	SET @OpcGrou=',v.Prdo'
	DECLARE @i INT SET @i=Convert(int,@PrdoIni)
	DECLARE @f INT SET @f=Convert(int,@PrdoFin)

	WHILE(@i<=@f)
	BEGIN
		IF(@i>Convert(int,@PrdoIni)) SET @SQL_CAMM=@SQL_CAMM+' UNION ALL '
		SET @SQL_CAMM=@SQL_CAMM+' SELECT '+''''+right('00'+ltrim(@i),2)+''''+' As Periodo,'+''''+user123.DameFormPrdo(right('00'+ltrim(@i),2),0,1)+''''+' As NCorto'
		SET @i=@i+1
	END
	
	PRINT @SQL_CAMM
	EXEC(@SQL_CAMM)
End

--if(@n1=1) --SIEMPRE SE ENVIA EL NIVEL 1
Begin
Set @SQL_P1=
	'
	Select 
		Res.Cd_Blc,Res.NroCta,p.NomCta,Res.Concepto,Res.Periodo,Sum(Res.Monto)*Case When left(Res.Cd_Blc,1)=''P'' Then -1 Else 1 End As Monto 
	From 
	(	Select 
			v.RucE,v.Ejer,left(v.NroCta,2) As NroCta,p.Cd_Blc,Sum(v.MtoD'+@MDA+'-v.MtoH'+@MDA+') As Monto
			,v.'+@CONCEPTO+' As Concepto
			'+@OpcMens+'
		From 
			Voucher v
			Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.Cd_Blc,'''') in (''A100'',''A200'',''P100'',''P200'',''PT10'')
		Where 
			v.RucE='''+@RucE+'''
			and v.Ejer='''+@Ejer+'''
			and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(v.IB_Anulado,0)=0
			'+@Condicion+'
		Group by
			v.RucE,v.Ejer,left(v.NroCta,2),v.Prdo,p.Cd_Blc,v.'+@CONCEPTO+''+@OpcGrou+'
		Having
			Sum(v.MtoD'+@MDA+'-v.MtoH'+@MDA+')<>0
	) As Res
		Left Join PlanCtas p On p.RucE=Res.RucE and p.Ejer=Res.Ejer and p.NroCta=Res.NroCta
	Group by
		Res.Cd_Blc,Res.NroCta,p.NomCta,Res.Concepto,Res.Periodo
	Order by
		1,2,4,5
	'
End

if(@n2=1)
Begin
Set @SQL_P2=
	'
	Select 
		Res.Cd_Blc,Res.NroCta,p.NomCta,Res.Concepto,Res.Periodo,Sum(Res.Monto)*Case When left(Res.Cd_Blc,1)=''P'' Then -1 Else 1 End As Monto 
	From 
	(	Select 
			v.RucE,v.Ejer,left(v.NroCta,4) As NroCta,p.Cd_Blc,Sum(v.MtoD'+@MDA+'-v.MtoH'+@MDA+') As Monto
			,v.'+@CONCEPTO+' As Concepto
			'+@OpcMens+'
		From 
			Voucher v
			Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.Cd_Blc,'''') in (''A100'',''A200'',''P100'',''P200'',''PT10'')
		Where 
			v.RucE='''+@RucE+'''
			and v.Ejer='''+@Ejer+'''
			and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(v.IB_Anulado,0)=0
			'+@Condicion+'
		Group by
			v.RucE,v.Ejer,left(v.NroCta,4),v.Prdo,p.Cd_Blc,v.'+@CONCEPTO+''+@OpcGrou+'
		Having
			Sum(v.MtoD'+@MDA+'-v.MtoH'+@MDA+')<>0
	) As Res
		Left Join PlanCtas p On p.RucE=Res.RucE and p.Ejer=Res.Ejer and p.NroCta=Res.NroCta
	Group by
		Res.Cd_Blc,Res.NroCta,p.NomCta,Res.Concepto,Res.Periodo
	Order by
		1,2,4,5
	'
End

if(@n3=1)
Begin
Set @SQL_P3=
	'
	Select 
		Res.Cd_Blc,Res.NroCta,p.NomCta,Res.Concepto,Res.Periodo,Sum(Res.Monto)*Case When left(Res.Cd_Blc,1)=''P'' Then -1 Else 1 End As Monto 
	From 
	(	Select 
			v.RucE,v.Ejer,left(v.NroCta,6) As NroCta,p.Cd_Blc,Sum(v.MtoD'+@MDA+'-v.MtoH'+@MDA+') As Monto
			,v.'+@CONCEPTO+' As Concepto
			'+@OpcMens+'
		From 
			Voucher v
			Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.Cd_Blc,'''') in (''A100'',''A200'',''P100'',''P200'',''PT10'')
		Where 
			v.RucE='''+@RucE+'''
			and v.Ejer='''+@Ejer+'''
			and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(v.IB_Anulado,0)=0
			'+@Condicion+'
		Group by
			v.RucE,v.Ejer,left(v.NroCta,6),v.Prdo,p.Cd_Blc,v.'+@CONCEPTO+''+@OpcGrou+'
		Having
			Sum(v.MtoD'+@MDA+'-v.MtoH'+@MDA+')<>0
	) As Res
		Left Join PlanCtas p On p.RucE=Res.RucE and p.Ejer=Res.Ejer and p.NroCta=Res.NroCta
	Group by
		Res.Cd_Blc,Res.NroCta,p.NomCta,Res.Concepto,Res.Periodo
	Order by
		1,2,4,5
	'
End

if(@n4=1)
Begin
Set @SQL_P4=
	'
	Select 
		Res.Cd_Blc,Res.NroCta,p.NomCta,Res.Concepto,Res.Periodo,Sum(Res.Monto)*Case When left(Res.Cd_Blc,1)=''P'' Then -1 Else 1 End As Monto 
	From 
	(	Select 
			v.RucE,v.Ejer,v.NroCta As NroCta,p.Cd_Blc,Sum(v.MtoD'+@MDA+'-v.MtoH'+@MDA+') As Monto
			,v.'+@CONCEPTO+' As Concepto
			'+@OpcMens+'
		From 
			Voucher v
			Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.Cd_Blc,'''') in (''A100'',''A200'',''P100'',''P200'',''PT10'')
		Where 
			v.RucE='''+@RucE+'''
			and v.Ejer='''+@Ejer+'''
			and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(v.IB_Anulado,0)=0
			'+@Condicion+'
		Group by
			v.RucE,v.Ejer,v.NroCta,v.Prdo,p.Cd_Blc,v.'+@CONCEPTO+''+@OpcGrou+'
		Having
			Sum(v.MtoD'+@MDA+'-v.MtoH'+@MDA+')<>0
	) As Res
		Left Join PlanCtas p On p.RucE=Res.RucE and p.Ejer=Res.Ejer and p.NroCta=Res.NroCta
	Group by
		Res.Cd_Blc,Res.NroCta,p.NomCta,Res.Concepto,Res.Periodo
	Order by
		1,2,4,5
	'
End


PRINT @SQL_P1
PRINT @SQL_P2
PRINT @SQL_P3
PRINT @SQL_P4

EXEC(@SQL_P1)
EXEC(@SQL_P2)
EXEC(@SQL_P3)
EXEC(@SQL_P4)

-- Leyenda --
-- DI : 08/08/2011 <Creacion del procedimiento almacenado>
GO

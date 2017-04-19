SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Tsr_FlujoCajaCons]

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
Declare @RucE nvarchar(11)
Declare @Ejer nvarchar(4)
Declare @PrdoD nvarchar(11)
Declare @PrdoH nvarchar(11)
Declare @Moneda nvarchar(2)
Declare @N1 bit
Declare @N2 bit
Declare @N3 bit
Declare @N4 bit

Set @RucE = '11111111111'
Set @Ejer = '2010'
Set @PrdoD = '01'
Set @PrdoH = '02'
Set @Moneda = '01'
Set @N1 = 0
Set @N2 = 0
Set @N3 = 0
Set @N4 = 1
*/
Declare @IC_Moneda nvarchar(3) Set @IC_Moneda=''
If (@Moneda = '02') Set @IC_Moneda='_ME'

Declare @i int  Set @i = Convert(int,@PrdoD)
Declare @Periodos nvarchar(4000) Set @Periodos = ''
Declare @ColumnasI nvarchar(4000) Set @ColumnasI = ''
Declare @ColumSumI nvarchar(4000) Set @ColumSumI = ''
Declare @ColumnasE nvarchar(4000) Set @ColumnasE = ''
Declare @ColumSumE nvarchar(4000) Set @ColumSumE = ''
Declare @ColSald nvarchar(4000) Set @ColSald = ''
Declare @TituCol nvarchar(4000) Set @TituCol = ''
Declare @ColSaldDet nvarchar(4000) Set @ColSaldDet = ''
Declare @SumPeriodos nvarchar(4000) Set @SumPeriodos = ''
Declare @ColSalPrdo nvarchar(4000) Set @ColSalPrdo = ''

While ( @i <= Convert(int,@PrdoH))
Begin
	Set @Periodos = @Periodos + ',Sum('+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+') As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')

	Set @ColumnasI = @ColumnasI + ',Sum(Case When v.Prdo='''+right('00'+ltrim(@i),2)+''' Then MtoH'+@IC_Moneda+'-MtoD'+@IC_Moneda+' Else 0.00 End) As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')
	Set @ColumSumI = @ColumSumI + 'Sum(Case When v.Prdo='''+right('00'+ltrim(@i),2)+''' Then MtoH'+@IC_Moneda+'-MtoD'+@IC_Moneda+' Else 0.00 End)+'

	Set @ColumnasE = @ColumnasE + ',Sum(Case When v.Prdo='''+right('00'+ltrim(@i),2)+''' Then MtoD'+@IC_Moneda+'-MtoH'+@IC_Moneda+' Else 0.00 End) As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')
	Set @ColumSumE = @ColumSumE + 'Sum(Case When v.Prdo='''+right('00'+ltrim(@i),2)+''' Then MtoD'+@IC_Moneda+'-MtoH'+@IC_Moneda+' Else 0.00 End)+'

	Set @ColSald = @ColSald + ',Isnull(Sum('+Case When @i=1 Then 'MtoD'+@IC_Moneda+'-MtoH'+@IC_Moneda Else '0.00' End + '),0.00) As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')
	Set @TituCol = @TituCol + ',NULL As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')

	Set @ColSaldDet = @ColSaldDet + ',Isnull(Sum( Case When Prdo<=Convert(int,'+right('00'+ltrim(@i-1),2)+') then MtoD'+@IC_Moneda+'-MtoH'+@IC_Moneda+' else 0.00 end ),0.00) As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')
	Set @SumPeriodos = @SumPeriodos + User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'+'
	
	Set @ColSalPrdo = @ColSalPrdo + ',Sum(Case When v.Prdo<='+right('00'+ltrim(@i),2)+' Then v.MtoD'+@IC_Moneda+'-v.MtoH'+@IC_Moneda+' else 0.00 End) As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')
	Set @i = @i + 1 
End

Set @ColumSumI = left(@ColumSumI,len(@ColumSumI)-1)
Set @ColumSumE = left(@ColumSumE,len(@ColumSumE)-1)
Set @SumPeriodos = 'Sum('+left(@SumPeriodos,len(@SumPeriodos)-1)+')'

Print 'Periodos       : '+@Periodos
Print 'Columnas     I : '+@ColumnasI
Print 'Columnas Sum I : '+@ColumSumI
Print 'Columnas     E : '+@ColumnasE
Print 'Columnas Sum E : '+@ColumSumE
Print 'Columnas Sal   : '+@ColSald
Print 'Titulo 		'+@TituCol
Print 'Detalle Saldo  : '+@ColSaldDet
Print 'Col Sald Prdo  : '+@ColSalPrdo


-- SALDO ANTERIOR
Declare @SQL_INI varchar(8000) Set @SQL_INI = ''

-- INGRESOS
Declare @SQL_IT varchar(8000) Set @SQL_IT = ''
Declare @SQL_ET varchar(8000) Set @SQL_ET = ''

Declare @SQL_IP1_N1 varchar(8000) Set @SQL_IP1_N1 = ''
Declare @SQL_IP2_N1 varchar(8000) Set @SQL_IP2_N1 = ''
Declare @SQL_IP3_N1 varchar(8000) Set @SQL_IP3_N1 = ''
Declare @SQL_IP4_N1 varchar(8000) Set @SQL_IP4_N1 = ''
Declare @SQL_IP5_N1 varchar(8000) Set @SQL_IP5_N1 = ''
Declare @SQL_IP6_N1 varchar(8000) Set @SQL_IP6_N1 = ''
Declare @SQL_IP7_N1 varchar(8000) Set @SQL_IP7_N1 = ''
Declare @SQL_IP8_N1 varchar(8000) Set @SQL_IP8_N1 = ''
Declare @SQL_IP9_N1 varchar(8000) Set @SQL_IP9_N1 = ''

Declare @SQL_IP1_N2 varchar(8000) Set @SQL_IP1_N2 = ''
Declare @SQL_IP2_N2 varchar(8000) Set @SQL_IP2_N2 = ''
Declare @SQL_IP3_N2 varchar(8000) Set @SQL_IP3_N2 = ''
Declare @SQL_IP4_N2 varchar(8000) Set @SQL_IP4_N2 = ''
Declare @SQL_IP5_N2 varchar(8000) Set @SQL_IP5_N2 = ''
Declare @SQL_IP6_N2 varchar(8000) Set @SQL_IP6_N2 = ''
Declare @SQL_IP7_N2 varchar(8000) Set @SQL_IP7_N2 = ''
Declare @SQL_IP8_N2 varchar(8000) Set @SQL_IP8_N2 = ''
Declare @SQL_IP9_N2 varchar(8000) Set @SQL_IP9_N2 = ''

Declare @SQL_IP1_N3 varchar(8000) Set @SQL_IP1_N3 = ''
Declare @SQL_IP2_N3 varchar(8000) Set @SQL_IP2_N3 = ''
Declare @SQL_IP3_N3 varchar(8000) Set @SQL_IP3_N3 = ''
Declare @SQL_IP4_N3 varchar(8000) Set @SQL_IP4_N3 = ''
Declare @SQL_IP5_N3 varchar(8000) Set @SQL_IP5_N3 = ''
Declare @SQL_IP6_N3 varchar(8000) Set @SQL_IP6_N3 = ''
Declare @SQL_IP7_N3 varchar(8000) Set @SQL_IP7_N3 = ''
Declare @SQL_IP8_N3 varchar(8000) Set @SQL_IP8_N3 = ''
Declare @SQL_IP9_N3 varchar(8000) Set @SQL_IP9_N3 = ''

Declare @SQL_IP1_N4 varchar(8000) Set @SQL_IP1_N4 = ''
Declare @SQL_IP2_N4 varchar(8000) Set @SQL_IP2_N4 = ''
Declare @SQL_IP3_N4 varchar(8000) Set @SQL_IP3_N4 = ''
Declare @SQL_IP4_N4 varchar(8000) Set @SQL_IP4_N4 = ''
Declare @SQL_IP5_N4 varchar(8000) Set @SQL_IP5_N4 = ''
Declare @SQL_IP6_N4 varchar(8000) Set @SQL_IP6_N4 = ''
Declare @SQL_IP7_N4 varchar(8000) Set @SQL_IP7_N4 = ''
Declare @SQL_IP8_N4 varchar(8000) Set @SQL_IP8_N4 = ''
Declare @SQL_IP9_N4 varchar(8000) Set @SQL_IP9_N4 = ''

-- EGRESOS
Declare @SQL_EP1_N1 varchar(8000) Set @SQL_EP1_N1 = ''
Declare @SQL_EP2_N1 varchar(8000) Set @SQL_EP2_N1 = ''
Declare @SQL_EP3_N1 varchar(8000) Set @SQL_EP3_N1 = ''
Declare @SQL_EP4_N1 varchar(8000) Set @SQL_EP4_N1 = ''
Declare @SQL_EP5_N1 varchar(8000) Set @SQL_EP5_N1 = ''
Declare @SQL_EP6_N1 varchar(8000) Set @SQL_EP6_N1 = ''
Declare @SQL_EP7_N1 varchar(8000) Set @SQL_EP7_N1 = ''
Declare @SQL_EP8_N1 varchar(8000) Set @SQL_EP8_N1 = ''
Declare @SQL_EP9_N1 varchar(8000) Set @SQL_EP9_N1 = ''

Declare @SQL_EP1_N2 varchar(8000) Set @SQL_EP1_N2 = ''
Declare @SQL_EP2_N2 varchar(8000) Set @SQL_EP2_N2 = ''
Declare @SQL_EP3_N2 varchar(8000) Set @SQL_EP3_N2 = ''
Declare @SQL_EP4_N2 varchar(8000) Set @SQL_EP4_N2 = ''
Declare @SQL_EP5_N2 varchar(8000) Set @SQL_EP5_N2 = ''
Declare @SQL_EP6_N2 varchar(8000) Set @SQL_EP6_N2 = ''
Declare @SQL_EP7_N2 varchar(8000) Set @SQL_EP7_N2 = ''
Declare @SQL_EP8_N2 varchar(8000) Set @SQL_EP8_N2 = ''
Declare @SQL_EP9_N2 varchar(8000) Set @SQL_EP9_N2 = ''

Declare @SQL_EP1_N3 varchar(8000) Set @SQL_EP1_N3 = ''
Declare @SQL_EP2_N3 varchar(8000) Set @SQL_EP2_N3 = ''
Declare @SQL_EP3_N3 varchar(8000) Set @SQL_EP3_N3 = ''
Declare @SQL_EP4_N3 varchar(8000) Set @SQL_EP4_N3 = ''
Declare @SQL_EP5_N3 varchar(8000) Set @SQL_EP5_N3 = ''
Declare @SQL_EP6_N3 varchar(8000) Set @SQL_EP6_N3 = ''
Declare @SQL_EP7_N3 varchar(8000) Set @SQL_EP7_N3 = ''
Declare @SQL_EP8_N3 varchar(8000) Set @SQL_EP8_N3 = ''
Declare @SQL_EP9_N3 varchar(8000) Set @SQL_EP9_N3 = ''

Declare @SQL_EP1_N4 varchar(8000) Set @SQL_EP1_N4 = ''
Declare @SQL_EP2_N4 varchar(8000) Set @SQL_EP2_N4 = ''
Declare @SQL_EP3_N4 varchar(8000) Set @SQL_EP3_N4 = ''
Declare @SQL_EP4_N4 varchar(8000) Set @SQL_EP4_N4 = ''
Declare @SQL_EP5_N4 varchar(8000) Set @SQL_EP5_N4 = ''
Declare @SQL_EP6_N4 varchar(8000) Set @SQL_EP6_N4 = ''
Declare @SQL_EP7_N4 varchar(8000) Set @SQL_EP7_N4 = ''
Declare @SQL_EP8_N4 varchar(8000) Set @SQL_EP8_N4 = ''
Declare @SQL_EP9_N4 varchar(8000) Set @SQL_EP9_N4 = ''

Declare @SQL_ADCI varchar(8000) Set @SQL_ADCI = ''

Declare @SQL_IDC1_N1 varchar(8000) Set @SQL_IDC1_N1=''
Declare @SQL_IDC2_N1 varchar(8000) Set @SQL_IDC2_N1=''
Declare @SQL_IDC3_N1 varchar(8000) Set @SQL_IDC3_N1=''
Declare @SQL_IDC1_N4 varchar(8000) Set @SQL_IDC1_N4=''
Declare @SQL_IDC2_N4 varchar(8000) Set @SQL_IDC2_N4=''
Declare @SQL_IDC3_N4 varchar(8000) Set @SQL_IDC3_N4=''

Declare @SQL_EDC1_N1 varchar(8000) Set @SQL_EDC1_N1=''
Declare @SQL_EDC2_N1 varchar(8000) Set @SQL_EDC2_N1=''
Declare @SQL_EDC3_N1 varchar(8000) Set @SQL_EDC3_N1=''
Declare @SQL_EDC1_N4 varchar(8000) Set @SQL_EDC1_N4=''
Declare @SQL_EDC2_N4 varchar(8000) Set @SQL_EDC2_N4=''
Declare @SQL_EDC3_N4 varchar(8000) Set @SQL_EDC3_N4=''


Declare @SQL_SD_P1 varchar(8000) Set @SQL_SD_P1=''
Declare @SQL_SD_P2 varchar(8000) Set @SQL_SD_P2=''
Declare @SQL_SD_P3 varchar(8000) Set @SQL_SD_P3=''

Declare @SQL_SP_D varchar(8000) Set @SQL_SP_D=''

/************************ Buscar Prdo Inicial *********************/
Set @SQL_INI=
	'
	Select  ''A'' As Tipo,''0'' As Posi,''0'' As Nivel,'''' As NroCta, ''SALDO ANTERIOR'' As Descrip
		'+@TituCol+'
	UNION ALL
	Select  ''A'' As Tipo,''1'' As Posi,''0'' As Nivel,''Val'' As NroCta, ''Saldos'' As Descrip
		'+@ColSald+'
	From VoucherFC Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo<'''+@PrdoD+''' and NroCta like ''10%''
	'

if(@N4=1)
Begin
	Set @SQL_SD_P1=
		'
		UNION ALL
		Select Tipo,Posi,Nivel,NroCta,Descrip'+@Periodos+'
		From
		(
		Select  ''A'' As Tipo,''2'' As Posi,''4'' As Nivel,v.NroCta, c.NomCta As Descrip
			'+@ColSaldDet+'
		From VoucherFC v
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta		
		Where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo<'''+@PrdoD+''' and v.NroCta like ''10%''
		Group by v.NroCta,c.NomCta
		'
	Set @SQL_SD_P2=
		'
		UNION ALL
		Select  ''A'' As Tipo,''2'' As Posi,''4'' As Nivel,v.NroCta, c.NomCta As Descrip
			'+@ColSaldDet+'
		from 	VoucherFC v
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta		
		Where 	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.Cd_Fte=''CB'' and v.NroCta like ''10%'' and v.MtoH=0 and v.MtoH+v.MtoD<>0
		Group by v.NroCta,c.NomCta
		'
	Set @SQL_SD_P3=
		'
		UNION ALL
		Select  ''A'' As Tipo,''2'' As Posi,''4'' As Nivel,v.NroCta, c.NomCta As Descrip
			'+@ColSaldDet+'
		from 	VoucherFC v
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta		
		Where 	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.Cd_Fte=''CB'' and v.NroCta like ''10%'' and v.MtoD=0 and v.MtoH+v.MtoD<>0
		Group by v.NroCta,c.NomCta
		) As RESULT
		Group by Tipo,Posi,Nivel,NroCta,Descrip
		Having '+@SumPeriodos+'<>0
		'
End

	
if(@N1=1 or @N2=1 or @N3=1)
Begin
	/*INGRESO*/
	Set @SQL_IP4_N1=
		'
		UNION ALL
		Select 	Tipo,Posi,Nivel,NroCta,Descrip'+@Periodos+' from
		(
		Select  ''B'' As Tipo,''1'' As Posi,''1'' As Nivel,left(p.DCGan,2) As NroCta, c.NomCta As Descrip
			'+@ColumnasI
	Set @SQL_IP5_N1=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Inner Join PlanCtasDef p On p.RucE=v.RucE and p.Ejer=v.Ejer
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,2)
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and left(v.NroCta,2) in (''10'') and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@IC_Moneda+'<>0
		Group by 
			left(p.DCGan,2),c.NomCta
		'
	Set @SQL_IP6_N1=
		'
		Having	'+@ColumSumI+' <> 0
		'
	Set @SQL_IDC1_N1=
		'
		UNION ALL
		Select  ''B'' As Tipo,''2'' As Posi,''1'' As Nivel,''67 y 77'' As NroCta,''DIFERENCIA DE CAMBIO'' As Descrip
			'+@ColumnasI
	Set @SQL_IDC2_N1=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%''
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
			and (d.DCGan=v.NroCta or d.DCPer=v.NroCta)
		'
	Set @SQL_IDC3_N1=
		'
		Having	'+@ColumSumI+' <> 0
		) As RESULT
		Group by Tipo,Posi,Nivel,NroCta,Descrip
		'
	/*EGRESO*/
	
	Set @SQL_EP4_N1=
		'
		UNION ALL
		Select 	Tipo,Posi,Nivel,NroCta,Descrip'+@Periodos+' from
		(
		Select  ''C'' As Tipo,''2'' As Posi,''1'' As Nivel,left(p.DCPer,2) As NroCta,c.NomCta As Descrip
			'+@ColumnasE
	Set @SQL_EP5_N1=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Inner Join PlanCtasDef p On p.RucE=v.RucE and p.Ejer=v.Ejer
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,2)			
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and left(v.NroCta,2) in (''10'') and isnull(v.IB_EsDes,0)=0 and v.MtoD'+@IC_Moneda+'<>0
		Group by 
			left(p.DCPer,2),c.NomCta
		'
	Set @SQL_EP6_N1=
		'
		Having	'+@ColumSumE+' <> 0
		'
	Set @SQL_EDC1_N1=
		'
		UNION ALL
		Select  ''C'' As Tipo,''2'' As Posi,''1'' As Nivel,''67 y 77'' As NroCta,''DIFERENCIA DE CAMBIO'' As Descrip
			'+@ColumnasE
	Set @SQL_EDC2_N1=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%''
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
			and (d.DCGan=v.NroCta or d.DCPer=v.NroCta)
		'
	Set @SQL_EDC3_N1=
		'
		Having	'+@ColumSumE+' <> 0
		) As RESULT
		Group by Tipo,Posi,Nivel,NroCta,Descrip
		'
End


If (@N1 = 1)
Begin
	/********************** Buscar CB contrapartida *******************/

	-- INGRESO *************************************************************************
	Set @SQL_IP1_N1=
		'
		UNION ALL
		Select 	Tipo,Posi,Nivel,NroCta,Descrip'+@Periodos+' from
		(
		Select  ''B'' As Tipo,''1'' As Posi,''1'' As Nivel,left(v.NroCta,2) As NroCta,c.NomCta As Descrip
			'+@ColumnasI
	Set @SQL_IP2_N1=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,2)		
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' /*and v.NroCta not like ''10%''*/ and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@IC_Moneda+'<>0
			and d.DCGan<>v.NroCta and d.DCPer<>v.NroCta -- AGREGADO POR PEDIDOS DE GUILLE
		Group by 
			left(v.NroCta,2),c.NomCta'
	Set @SQL_IP3_N1=
		'
		Having	'+@ColumSumI+' <> 0
		'
	-- buscando datos pendientes en el Debe
	Set @SQL_IP7_N1=
		'
		UNION ALL
		Select  ''B'' As Tipo,''1'' As Posi,''1'' As Nivel,left(v.NroCta,2) As NroCta,c.NomCta As Descrip
			'+@ColumnasI
	Set @SQL_IP8_N1=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,2)		
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.NroCta not like ''10%'' and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@IC_Moneda+'=0 and v.MtoD'+@IC_Moneda+'+v.MtoH'+@IC_Moneda+'<>0
			and d.DCGan<>v.NroCta and d.DCPer<>v.NroCta -- AGREGADO POR PEDIDOS DE GUILLE
		Group by 
			left(v.NroCta,2),c.NomCta'
	Set @SQL_IP9_N1=
		'
		Having	'+@ColumSumI+' <> 0
		'	

	-- EGRESO ***************************************************************************
	Set @SQL_EP1_N1=
		'
		UNION ALL
		Select  ''C'' As Tipo,''1'' As Posi,''1'' As Nivel,left(v.NroCta,2) As NroCta, c.NomCta As Descrip
			'+@ColumnasE
	Set @SQL_EP2_N1=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,2)			
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
		Where	
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''/*  and v.NroCta not like ''10%''*/ and isnull(v.IB_EsDes,0)=0 and MtoD'+@IC_Moneda+'<>0
			and d.DCGan<>v.NroCta and d.DCPer<>v.NroCta -- AGREGADO POR PEDIDOS DE GUILLE
		Group by 
			left(v.NroCta,2),c.NomCta'
	Set @SQL_EP3_N1=
		'
		Having	'+@ColumSumE+' <> 0
		'
	-- buscando datos pendientes en el Haber
	Set @SQL_EP7_N1=
		'
		UNION ALL
		Select  ''C'' As Tipo,''1'' As Posi,''1'' As Nivel,left(v.NroCta,2) As NroCta, c.NomCta As Descrip
			'+@ColumnasE
	Set @SQL_EP8_N1=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,2)			
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
		Where	
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''  and v.NroCta not like ''10%'' and isnull(v.IB_EsDes,0)=0 and MtoD'+@IC_Moneda+'=0 and MtoH'+@IC_Moneda+'+MtoD'+@IC_Moneda+'<>0
			and d.DCGan<>v.NroCta and d.DCPer<>v.NroCta -- AGREGADO POR PEDIDOS DE GUILLE
		Group by 
			left(v.NroCta,2),c.NomCta'
	Set @SQL_EP9_N1=
		'
		Having	'+@ColumSumE+' <> 0
		) As TAB
		Group by Tipo,Posi,Nivel,NroCta,Descrip
		'
End


If (@N2 = 1)
Begin
	/********************** Buscar CB contrapartida *******************/

	-- INGRESO *************************************************************************
	Set @SQL_IP1_N2=
		'
		UNION ALL
		Select 	Tipo,Posi,Nivel,NroCta,Descrip'+@Periodos+' from
		(
		Select  ''B'' As Tipo,''1'' As Posi,''2'' As Nivel,left(v.NroCta,4) As NroCta, c.NomCta As Descrip
			'+@ColumnasI
	Set @SQL_IP2_N2=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,4)
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''/* and v.NroCta not like ''10%''*/ and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@IC_Moneda+'<>0
			and d.DCGan<>v.NroCta and d.DCPer<>v.NroCta -- AGREGADO POR PEDIDOS DE GUILLE
		Group by 
			left(v.NroCta,4),c.NomCta'
	Set @SQL_IP3_N2=
		'
		Having	'+@ColumSumI+' <> 0
		'
	/*
	Set @SQL_IP4_N2=
		'
		UNION ALL
		Select  ''B'' As Tipo,''1'' As Posi,''2'' As Nivel,left(p.DCGan,4) As NroCta,c.NomCta As Descrip
			'+@ColumnasI
	Set @SQL_IP5_N2=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Inner Join PlanCtasDef p On p.RucE=v.RucE and p.Ejer=v.Ejer
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,4)
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and left(v.NroCta,2) in (''10'') and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@IC_Moneda+'<>0
		Group by 
			left(p.DCGan,4),c.NomCta
		'
	Set @SQL_IP6_N2=
		'
		Having	'+@ColumSumI+' <> 0
		'
	*/
	-- buscando datos pendientes en el Debe
	Set @SQL_IP7_N2=
		'
		UNION ALL
		Select  ''B'' As Tipo,''1'' As Posi,''2'' As Nivel,left(v.NroCta,4) As NroCta, c.NomCta As Descrip
			'+@ColumnasI
	Set @SQL_IP8_N2=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,4)
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.NroCta not like ''10%'' and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@IC_Moneda+'=0 and v.MtoD'+@IC_Moneda+'+v.MtoH'+@IC_Moneda+'<>0
			and d.DCGan<>v.NroCta and d.DCPer<>v.NroCta -- AGREGADO POR PEDIDOS DE GUILLE
		Group by 
			left(v.NroCta,4),c.NomCta'
	Set @SQL_IP9_N2=
		'
		Having	'+@ColumSumI+' <> 0
		'

	-- EGRESO ***************************************************************************
	Set @SQL_EP1_N2=
		'
		UNION ALL
		Select  ''C'' As Tipo,''1'' As Posi,''2'' As Nivel,left(v.NroCta,4) As NroCta,c.NomCta As Descrip
			'+@ColumnasE
	Set @SQL_EP2_N2=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,4)
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
		Where	
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''/*  and v.NroCta not like ''10%''*/ and isnull(v.IB_EsDes,0)=0 and MtoD'+@IC_Moneda+'<>0
			and d.DCGan<>v.NroCta and d.DCPer<>v.NroCta -- AGREGADO POR PEDIDOS DE GUILLE
		Group by 
			left(v.NroCta,4),c.NomCta'
	Set @SQL_EP3_N2=
		'
		Having	'+@ColumSumE+' <> 0
		'
	/*
	Set @SQL_EP4_N2=
		'
		UNION ALL
		Select  ''C'' As Tipo,''1'' As Posi,''2'' As Nivel,left(p.DCPer,4) As NroCta,c.NomCta As Descrip
			'+@ColumnasE
	Set @SQL_EP5_N2=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Inner Join PlanCtasDef p On p.RucE=v.RucE and p.Ejer=v.Ejer
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,4)
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and left(v.NroCta,2) in (''10'') and isnull(v.IB_EsDes,0)=0 and v.MtoD'+@IC_Moneda+'<>0
		Group by 
			left(p.DCPer,4),c.NomCta
		'
	Set @SQL_EP6_N2=
		'
		Having	'+@ColumSumE+' <> 0
		'
	*/
	-- buscando datos pendientes en el Haber
	Set @SQL_EP7_N2=
		'
		UNION ALL
		Select  ''C'' As Tipo,''1'' As Posi,''2'' As Nivel,left(v.NroCta,4) As NroCta,c.NomCta As Descrip
			'+@ColumnasE
	Set @SQL_EP8_N2=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,4)
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
		Where	
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''  and v.NroCta not like ''10%'' and isnull(v.IB_EsDes,0)=0 and MtoD'+@IC_Moneda+'=0 and MtoH'+@IC_Moneda+'+MtoD'+@IC_Moneda+'<>0
			and d.DCGan<>v.NroCta and d.DCPer<>v.NroCta -- AGREGADO POR PEDIDOS DE GUILLE
		Group by 
			left(v.NroCta,4),c.NomCta'
	Set @SQL_EP9_N2=
		'
		Having	'+@ColumSumE+' <> 0
		) As TAB
		Group by Tipo,Posi,Nivel,NroCta,Descrip
		'
End


If (@N3 = 1)
Begin
	/********************** Buscar CB contrapartida *******************/

	-- INGRESO *************************************************************************
	Set @SQL_IP1_N3=
		'
		UNION ALL
		Select 	Tipo,Posi,Nivel,NroCta,Descrip'+@Periodos+' from
		(
		Select  ''B'' As Tipo,''1'' As Posi,''3'' As Nivel,left(v.NroCta,6) As NroCta,c.NomCta As Descrip
			'+@ColumnasI
	Set @SQL_IP2_N3=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,6)
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''/* and v.NroCta not like ''10%''*/ and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@IC_Moneda+'<>0
			and d.DCGan<>v.NroCta and d.DCPer<>v.NroCta -- AGREGADO POR PEDIDOS DE GUILLE
		Group by 
			left(v.NroCta,6),c.NomCta'
	Set @SQL_IP3_N3=
		'
		Having	'+@ColumSumI+' <> 0
		'
	/*
	Set @SQL_IP4_N3=
		'
		UNION ALL
		Select  ''B'' As Tipo,''1'' As Posi,''3'' As Nivel,left(p.DCGan,6) As NroCta,c.NomCta As Descrip
			'+@ColumnasI
	Set @SQL_IP5_N3=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Inner Join PlanCtasDef p On p.RucE=v.RucE and p.Ejer=v.Ejer
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,6)
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and left(v.NroCta,2) in (''10'') and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@IC_Moneda+'<>0
		Group by 
			left(p.DCGan,6),c.NomCta
		'
	Set @SQL_IP6_N3=
		'
		Having	'+@ColumSumI+' <> 0
		'
	*/
	-- buscando datos pendientes en el Debe
	Set @SQL_IP7_N3=
		'
		UNION ALL
		Select  ''B'' As Tipo,''1'' As Posi,''3'' As Nivel,left(v.NroCta,6) As NroCta,c.NomCta As Descrip
			'+@ColumnasI
	Set @SQL_IP8_N3=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,6)
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.NroCta not like ''10%'' and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@IC_Moneda+'=0 and v.MtoD'+@IC_Moneda+'+v.MtoH'+@IC_Moneda+'<>0
			and d.DCGan<>v.NroCta and d.DCPer<>v.NroCta -- AGREGADO POR PEDIDOS DE GUILLE
		Group by 
			left(v.NroCta,6),c.NomCta'
	Set @SQL_IP9_N3=
		'
		Having	'+@ColumSumI+' <> 0
		'
	-- EGRESO ***************************************************************************
	Set @SQL_EP1_N3=
		'
		UNION ALL
		Select  ''C'' As Tipo,''1'' As Posi,''3'' As Nivel,left(v.NroCta,6) As NroCta,c.NomCta As Descrip
			'+@ColumnasE
	Set @SQL_EP2_N3=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,6)
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
		Where	
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''/*  and v.NroCta not like ''10%''*/ and isnull(v.IB_EsDes,0)=0 and MtoD'+@IC_Moneda+'<>0
			and d.DCGan<>v.NroCta and d.DCPer<>v.NroCta -- AGREGADO POR PEDIDOS DE GUILLE
		Group by 
			left(v.NroCta,6),c.NomCta'
	Set @SQL_EP3_N3=
		'
		Having	'+@ColumSumE+' <> 0
		'
	/*
	Set @SQL_EP4_N3=
		'
		UNION ALL
		Select  ''C'' As Tipo,''1'' As Posi,''3'' As Nivel,left(p.DCPer,6) As NroCta,c.NomCta As Descrip
			'+@ColumnasE
	Set @SQL_EP5_N3=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Inner Join PlanCtasDef p On p.RucE=v.RucE and p.Ejer=v.Ejer
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,6)
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and left(v.NroCta,2) in (''10'') and isnull(v.IB_EsDes,0)=0 and v.MtoD'+@IC_Moneda+'<>0
		Group by 
			left(p.DCPer,6),c.NomCta
		'
	Set @SQL_EP6_N3=
		'
		Having	'+@ColumSumE+' <> 0
		'
	*/
	-- buscando datos pendientes en el Haber
	Set @SQL_EP7_N3=
		'
		UNION ALL
		Select  ''C'' As Tipo,''1'' As Posi,''3'' As Nivel,left(v.NroCta,6) As NroCta,c.NomCta As Descrip
			'+@ColumnasE
	Set @SQL_EP8_N3=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=left(v.NroCta,6)
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
		Where	
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''  and v.NroCta not like ''10%'' and isnull(v.IB_EsDes,0)=0 and MtoD'+@IC_Moneda+'=0 and MtoH'+@IC_Moneda+'+MtoD'+@IC_Moneda+'<>0
			and d.DCGan<>v.NroCta and d.DCPer<>v.NroCta -- AGREGADO POR PEDIDOS DE GUILLE
		Group by 
			left(v.NroCta,6),c.NomCta'
	Set @SQL_EP9_N3=
		'
		Having	'+@ColumSumE+' <> 0
		) As TAB
		Group by Tipo,Posi,Nivel,NroCta,Descrip
		'
End


If (@N4 = 1)
Begin
	/********************** Buscar CB contrapartida *******************/

	-- INGRESO *************************************************************************
	Set @SQL_IP1_N4=
		'
		UNION ALL
		Select 	Tipo,Posi,Nivel,NroCta,Descrip'+@Periodos+' from
		(
		Select  ''B'' As Tipo,''1'' As Posi,''4'' As Nivel,v.NroCta,c.NomCta As Descrip
			'+@ColumnasI
	Set @SQL_IP2_N4=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''/* and v.NroCta not like ''10%''*/ and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@IC_Moneda+'<>0
			and d.DCGan<>v.NroCta and d.DCPer<>v.NroCta -- AGREGADO POR PEDIDOS DE GUILLE
		Group by 
			v.NroCta,c.NomCta'
	Set @SQL_IP3_N4=
		'
		Having	'+@ColumSumI+' <> 0
		'
	--************************************************************************************************
	Set @SQL_IP4_N4=
		'
		UNION ALL
		Select 	Tipo,Posi,Nivel,NroCta,Descrip'+@Periodos+' from
		(
		Select  ''B'' As Tipo,''2'' As Posi,''4'' As Nivel,p.DCGan As NroCta,c.NomCta As Descrip
			'+@ColumnasI
	Set @SQL_IP5_N4=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Inner Join PlanCtasDef p On p.RucE=v.RucE and p.Ejer=v.Ejer
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and left(v.NroCta,2) in (''10'') and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@IC_Moneda+'<>0
		Group by 
			p.DCGan,c.NomCta
		'
	Set @SQL_IP6_N4=
		'
		Having	'+@ColumSumI+' <> 0
		'
	Set @SQL_IDC1_N4=
		'
		UNION ALL
		Select  ''B'' As Tipo,''2'' As Posi,''4'' As Nivel,v.NroCta,c.NomCta As Descrip
			'+@ColumnasI
	Set @SQL_IDC2_N4=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%''
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
			and (d.DCGan=v.NroCta or d.DCPer=v.NroCta)
		Group by 
			v.NroCta,c.NomCta
		'
	Set @SQL_IDC3_N4=
		'
		Having	'+@ColumSumI+' <> 0
		) As RESULT
		Group by Tipo,Posi,Nivel,NroCta,Descrip
		'
	--************************************************************************************************
	
	-- buscando datos pendientes en el Debe
	Set @SQL_IP7_N4=
		'
		UNION ALL
		Select  ''B'' As Tipo,''1'' As Posi,''4'' As Nivel,v.NroCta,c.NomCta As Descrip
			'+@ColumnasI
	Set @SQL_IP8_N4=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.NroCta not like ''10%'' and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@IC_Moneda+'=0 and v.MtoD'+@IC_Moneda+'+v.MtoH'+@IC_Moneda+'<>0
			and d.DCGan<>v.NroCta and d.DCPer<>v.NroCta -- AGREGADO POR PEDIDOS DE GUILLE
		Group by 
			v.NroCta,c.NomCta'
	Set @SQL_IP9_N4=
		'
		Having	'+@ColumSumI+' <> 0
		'

	-- EGRESO ***************************************************************************
	Set @SQL_EP1_N4=
		'
		UNION ALL
		Select  ''C'' As Tipo,''1'' As Posi,''4'' As Nivel,v.NroCta,c.NomCta As Descrip
			'+@ColumnasE
	Set @SQL_EP2_N4=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
		Where	
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''/*  and v.NroCta not like ''10%''*/ and isnull(v.IB_EsDes,0)=0 and MtoD'+@IC_Moneda+'<>0
			and d.DCGan<>v.NroCta and d.DCPer<>v.NroCta -- AGREGADO POR PEDIDOS DE GUILLE
		Group by 
			v.NroCta,c.NomCta'
	Set @SQL_EP3_N4=
		'
		Having	'+@ColumSumE+' <> 0
		'
	--*************************************************************************************
	Set @SQL_EP4_N4=
		'
		UNION ALL
		Select 	Tipo,Posi,Nivel,NroCta,Descrip'+@Periodos+' from
		(
		Select  ''C'' As Tipo,''1'' As Posi,''4'' As Nivel,p.DCPer As NroCta,c.NomCta As Descrip
			'+@ColumnasE
	Set @SQL_EP5_N4=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Inner Join PlanCtasDef p On p.RucE=v.RucE and p.Ejer=v.Ejer
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and left(v.NroCta,2) in (''10'') and isnull(v.IB_EsDes,0)=0 and v.MtoD'+@IC_Moneda+'<>0
		Group by 
			p.DCPer,c.NomCta
		'
	Set @SQL_EP6_N4=
		'
		Having	'+@ColumSumE+' <> 0
		'
	Set @SQL_EDC1_N4=
		'
		UNION ALL
		Select  ''C'' As Tipo,''2'' As Posi,''4'' As Nivel,v.NroCta,c.NomCta As Descrip
			'+@ColumnasI
	Set @SQL_EDC2_N4=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%''
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
		Where
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
			and (d.DCGan=v.NroCta or d.DCPer=v.NroCta)
		Group by 
			v.NroCta,c.NomCta
		'
	Set @SQL_EDC3_N4=
		'
		Having	'+@ColumSumI+' <> 0
		) As RESULT
		Group by Tipo,Posi,Nivel,NroCta,Descrip
		'
	--*************************************************************************************

	-- buscando datos pendientes en el Haber
	Set @SQL_EP7_N4=
		'
		UNION ALL
		Select  ''C'' As Tipo,''1'' As Posi,''4'' As Nivel,v.NroCta,c.NomCta As Descrip
			'+@ColumnasE
	Set @SQL_EP8_N4=
		'
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@IC_Moneda+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta
			Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
		Where	
			v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''  and v.NroCta not like ''10%'' and isnull(v.IB_EsDes,0)=0 and MtoD'+@IC_Moneda+'=0 and MtoH'+@IC_Moneda+'+MtoD'+@IC_Moneda+'<>0
			and d.DCGan<>v.NroCta and d.DCPer<>v.NroCta -- AGREGADO POR PEDIDOS DE GUILLE
		Group by 
			v.NroCta,c.NomCta'
	Set @SQL_EP9_N4=
		'
		Having	'+@ColumSumE+' <> 0
		) As TAB
		Group by Tipo,Posi,Nivel,NroCta,Descrip
		'
End
If (@N1=1 or @N2=1 or @N3=1 or @N4=1)
Begin
	Set @SQL_IT=
		' UNION ALL
		Select  ''B'' As Tipo,''0'' As Posi,''0'' As Nivel,'''' As NroCta, ''INGRESO'' As Descrip
		'+@TituCol+
		' UNION ALL
		Select  ''B'' As Tipo,''3'' As Posi,''0'' As Nivel,'''' As NroCta, ''TOTAL INGRESO'' As Descrip
		'+@TituCol
	Set @SQL_ET=
		' UNION ALL
		Select  ''C'' As Tipo,''0'' As Posi,''0'' As Nivel,'''' As NroCta, ''EGRESO'' As Descrip
		'+@TituCol+
		' UNION ALL
		Select  ''C'' As Tipo,''3'' As Posi,''0'' As Nivel,'''' As NroCta, ''TOTAL EGRESO'' As Descrip
		'+@TituCol
		
End


If(@N4=1)
Begin
Set @SQL_ADCI =
	'
	UNION ALL
	Select  ''B'' As Tipo,''4'' As Posi,''4'' As Nivel,v.NroCta As NroCta,c.NomCta As Descrip
		'+@ColumnasE+'
	from 	VoucherFC v
		Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta		
	Where 	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.Cd_Fte=''CB'' and v.NroCta like ''10%'' and v.MtoH'+@IC_Moneda+'=0 and v.MtoH'+@IC_Moneda+'+v.MtoD'+@IC_Moneda+'<>0
	Group by v.NroCta,c.NomCta
	UNION ALL
	Select  ''C'' As Tipo,''4'' As Posi,''4'' As Nivel,v.NroCta As NroCta,c.NomCta As Descrip
		'+@ColumnasI+'
	from 	VoucherFC v
		Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta		
	Where 	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.Cd_Fte=''CB'' and v.NroCta like ''10%'' and v.MtoD'+@IC_Moneda+'=0 and v.MtoH'+@IC_Moneda+'+v.MtoD'+@IC_Moneda+'<>0
	Group by v.NroCta,c.NomCta
	'


	--INFORMACION DEL RTP PARA SALDOS DE PERIODO
Set @SQL_SP_D=
	'
	Select 	''B'' As Tipo,''2'' As Posi,''4'' As Nivel,v.NroCta,c.NomCta As Descrip
		'+@ColSalPrdo+'
		,NULL As Total
	from Voucher v
	    	left join PlanCtas c on v.RucE=c.RucE and v.NroCta=c.NroCta and c.Ejer=v.Ejer
	Where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and left(v.NroCta,2)=''10'' and v.Prdo between ''00'' and '''+@PrdoH+'''
	Group by v.RucE,v.Ejer,v.NroCta,c.NomCta
	'

End






PRINT @SQL_INI
PRINT @SQL_SD_P1
PRINT @SQL_SD_P2
PRINT @SQL_SD_P3
	 -- Nivel 1
PRINT @SQL_IP1_N1
PRINT @SQL_IP2_N1
PRINT @SQL_IP3_N1
PRINT @SQL_IP4_N1
PRINT @SQL_IP5_N1
PRINT @SQL_IP6_N1
	
PRINT @SQL_IDC1_N1
PRINT @SQL_IDC2_N1
PRINT @SQL_IDC3_N1
	
PRINT @SQL_IP7_N1
PRINT @SQL_IP8_N1
PRINT @SQL_IP9_N1
         
PRINT @SQL_EP1_N1
PRINT @SQL_EP2_N1
PRINT @SQL_EP3_N1
PRINT @SQL_EP4_N1
PRINT @SQL_EP5_N1
PRINT @SQL_EP6_N1
	
PRINT @SQL_EDC1_N1
PRINT @SQL_EDC2_N1
PRINT @SQL_EDC3_N1

PRINT @SQL_EP7_N1
PRINT @SQL_EP8_N1
PRINT @SQL_EP9_N1

	-- Nivel 2
PRINT @SQL_IP1_N2
PRINT @SQL_IP2_N2
PRINT @SQL_IP3_N2
PRINT @SQL_IP4_N2
PRINT @SQL_IP5_N2
PRINT @SQL_IP6_N2
PRINT @SQL_IP7_N2
PRINT @SQL_IP8_N2
PRINT @SQL_IP9_N2
         
PRINT @SQL_EP1_N2
PRINT @SQL_EP2_N2
PRINT @SQL_EP3_N2
PRINT @SQL_EP4_N2
PRINT @SQL_EP5_N2
PRINT @SQL_EP6_N2
PRINT @SQL_EP7_N2
PRINT @SQL_EP8_N2
PRINT @SQL_EP9_N2

	-- Nivel 3
PRINT @SQL_IP1_N3
PRINT @SQL_IP2_N3
PRINT @SQL_IP3_N3
PRINT @SQL_IP4_N3
PRINT @SQL_IP5_N3
PRINT @SQL_IP6_N3
PRINT @SQL_IP7_N3
PRINT @SQL_IP8_N3
PRINT @SQL_IP9_N3
         
PRINT @SQL_EP1_N3
PRINT @SQL_EP2_N3
PRINT @SQL_EP3_N3
PRINT @SQL_EP4_N3
PRINT @SQL_EP5_N3
PRINT @SQL_EP6_N3
PRINT @SQL_EP7_N3
PRINT @SQL_EP8_N3
PRINT @SQL_EP9_N3

	-- Nivel 4
PRINT @SQL_IP1_N4
PRINT @SQL_IP2_N4
PRINT @SQL_IP3_N4
PRINT @SQL_IP4_N4
PRINT @SQL_IP5_N4
PRINT @SQL_IP6_N4

PRINT @SQL_IDC1_N4
PRINT @SQL_IDC2_N4
PRINT @SQL_IDC3_N4

PRINT @SQL_IP7_N4
PRINT @SQL_IP8_N4
PRINT @SQL_IP9_N4
         
PRINT @SQL_EP1_N4
PRINT @SQL_EP2_N4
PRINT @SQL_EP3_N4
PRINT @SQL_EP4_N4
PRINT @SQL_EP5_N4
PRINT @SQL_EP6_N4

PRINT @SQL_EDC1_N4
PRINT @SQL_EDC2_N4
PRINT @SQL_EDC3_N4

PRINT @SQL_EP7_N4
PRINT @SQL_EP8_N4
PRINT @SQL_EP9_N4

PRINT @SQL_IT
PRINT @SQL_ET
PRINT @SQL_ADCI

PRINT @SQL_SP_D

Exec ('('+@SQL_INI
	 +@SQL_SD_P1
	 +@SQL_SD_P2
	 +@SQL_SD_P3

	 -- Nivel 1
	 +@SQL_IP1_N1
	 +@SQL_IP2_N1
	 +@SQL_IP3_N1
	 +@SQL_IP4_N1
  	 +@SQL_IP5_N1
	 +@SQL_IP6_N1
	
	 +@SQL_IDC1_N1
	 +@SQL_IDC2_N1
	 +@SQL_IDC3_N1
	
	 +@SQL_IP7_N1
  	 +@SQL_IP8_N1
	 +@SQL_IP9_N1
         
	 +@SQL_EP1_N1
	 +@SQL_EP2_N1
	 +@SQL_EP3_N1
	 +@SQL_EP4_N1
	 +@SQL_EP5_N1
	 +@SQL_EP6_N1
	
	 +@SQL_EDC1_N1
	 +@SQL_EDC2_N1
	 +@SQL_EDC3_N1

	 +@SQL_EP7_N1
  	 +@SQL_EP8_N1
	 +@SQL_EP9_N1

	-- Nivel 2
	 +@SQL_IP1_N2
	 +@SQL_IP2_N2
	 +@SQL_IP3_N2
	 +@SQL_IP4_N2
  	 +@SQL_IP5_N2
	 +@SQL_IP6_N2
	 +@SQL_IP7_N2
  	 +@SQL_IP8_N2
	 +@SQL_IP9_N2
         
	 +@SQL_EP1_N2
	 +@SQL_EP2_N2
	 +@SQL_EP3_N2
	 +@SQL_EP4_N2
	 +@SQL_EP5_N2
	 +@SQL_EP6_N2
	 +@SQL_EP7_N2
  	 +@SQL_EP8_N2
	 +@SQL_EP9_N2

	-- Nivel 3
	 +@SQL_IP1_N3
	 +@SQL_IP2_N3
	 +@SQL_IP3_N3
	 +@SQL_IP4_N3
  	 +@SQL_IP5_N3
	 +@SQL_IP6_N3
	 +@SQL_IP7_N3
  	 +@SQL_IP8_N3
	 +@SQL_IP9_N3
         
	 +@SQL_EP1_N3
	 +@SQL_EP2_N3
	 +@SQL_EP3_N3
	 +@SQL_EP4_N3
	 +@SQL_EP5_N3
	 +@SQL_EP6_N3
	 +@SQL_EP7_N3
  	 +@SQL_EP8_N3
	 +@SQL_EP9_N3

	-- Nivel 4
	 +@SQL_IP1_N4
	 +@SQL_IP2_N4
	 +@SQL_IP3_N4
	 +@SQL_IP4_N4
  	 +@SQL_IP5_N4
	 +@SQL_IP6_N4

	 +@SQL_IDC1_N4
	 +@SQL_IDC2_N4
	 +@SQL_IDC3_N4

	 +@SQL_IP7_N4
  	 +@SQL_IP8_N4
	 +@SQL_IP9_N4
         
	 +@SQL_EP1_N4
	 +@SQL_EP2_N4
	 +@SQL_EP3_N4
	 +@SQL_EP4_N4
	 +@SQL_EP5_N4
	 +@SQL_EP6_N4

	 +@SQL_EDC1_N4
	 +@SQL_EDC2_N4
	 +@SQL_EDC3_N4

	 +@SQL_EP7_N4
  	 +@SQL_EP8_N4
	 +@SQL_EP9_N4

	 +@SQL_IT
	 +@SQL_ET
	 +@SQL_ADCI

+') Order by 1,2,4')

if(len(@SQL_SP_D) > 0) Exec ('('+@SQL_SP_D+')Order by 1,2,4')

-- Leyenda --
-- Di : 21/01/2011 <Creacion del procedimiento almacenado>




GO

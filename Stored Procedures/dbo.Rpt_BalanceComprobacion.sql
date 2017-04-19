SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_BalanceComprobacion]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Prdo1 nvarchar(2),
@Prdo2 nvarchar(2),
@n1 bit,
@n2 bit,
@n3 bit,
@n4 bit,
@Cd_Mda nvarchar(2),
@Cd_CCD nvarchar(8),
@Cd_CCH nvarchar(8),
@Cd_SCD nvarchar(8),
@Cd_SCH nvarchar(8),
@Cd_SSD nvarchar(8),
@Cd_SSH nvarchar(8),
@NroCtaD nvarchar(10),
@NroCtaH nvarchar(10),
@msj varchar(100) output
as

Declare @i int, @RMeses nvarchar(20),@Mda nvarchar(3),@ColMda nvarchar(3)
Declare @PCero Nvarchar(1000),@PCero1 Nvarchar(100),@PCero2 Nvarchar(100)
Declare @RPrdoD nvarchar(200),@RPrdoH nvarchar(200)
Declare @RangoCC nvarchar(200)
Declare @RanNroCta nvarchar(100)
Declare @RangoD nvarchar(200)
Declare @RangoH nvarchar(200)
Declare @Cero nvarchar(100)
Declare @CRangoD nvarchar(100)
Declare @CRangoH nvarchar(100)

SET @PCero=''	--Union del Periodo Inicial Debe y Haber
Set @PCero1='0' --Muestra de Periodo Inicial Debe
Set @PCero2='0' --Muestra de Periodo Inicial Haber
Set @RPrdoD=''  --Muestra de Rango Periodo Desde, Hasta (Debe) excepto el Inicial
Set @RPrdoH=''  --Muestra de Rango Periodo Desde, Hasta (Haber) excepto el Inicial
Set @i=0	--Indicador para identificar el rando de los periodos Debe y Haber
Set @RMeses=''	--Indicador para identificar el rando de los meses excepto el 00
Set @Mda=''     --Indicador para identificar el tipo de moneda
Set @ColMda=''  --Indicador para identificar el tipo de columna de acuerdo al tipo de moneda ingresado
Set @RangoCC='' --Indicador para identificar el las condicionales para los valores a CC,SC,SS
Set @RanNroCta=''--Indicador para asignar los valores de busqueda de las cuentas
Set @RangoD=''
Set @RangoH=''
Set @Cero = ''
Set @CRangoD = ''
Set @CRangoH = ''

Set @i = (Case(@Prdo1) when '00' then Convert(int,@Prdo1)+1 else Convert(int,@Prdo1) end)
Set @RMeses = (Case(@Prdo1) when '00' then '01-'+@Prdo2 else @Prdo1+'-'+@Prdo2 end)
Set @Mda = (Case(@Cd_Mda) when '02' then 'D' else '' end)
Set @ColMda = (Case(@Cd_Mda) when '02' then 'ME' else '' end)

if(isnull(len(@NroCtaD),0) = 0) 
	set @NroCtaD = '0000000000'
else
Begin 
	if(len(@NroCtaD) = 2)	Set @RangoD = ' and left(s.NroCta,2)>='+@NroCtaD
	else if(len(@NroCtaD) = 4) Set @RangoD = ' and left(s.NroCta,4)>='+@NroCtaD
	else if(len(@NroCtaD) = 6) Set @RangoD = ' and left(s.NroCta,6)>='+@NroCtaD
	else Set @RangoD = ' and s.NroCta>='+@NroCtaD
End
if(isnull(len(@NroCtaH),0) = 0) 
	set @NroCtaH = '9999999999'
else
Begin 
	if(len(@NroCtaH) = 2)	Set @RangoH = ' and left(s.NroCta,2)<='+@NroCtaH
	else if(len(@NroCtaH) = 4) Set @RangoH = ' and left(s.NroCta,4)<='+@NroCtaH
	else if(len(@NroCtaH) = 6) Set @RangoH = ' and left(s.NroCta,6)<='+@NroCtaH
	else Set @RangoH = ' and s.NroCta<='+@NroCtaH
End

If(@Prdo1='00')
Begin
	Set @PCero1='s.D'+@ColMda+'00'
	Set @PCero2='s.H'+@ColMda+'00'
	Set @PCero='Sum(s.D'+@ColMda+'00) as [Debe(0)], Sum(s.H'+@ColMda+'00) as [Haber(0)],'		
	Set @Cero = '0.00 as [Debe(0)], 0.00 as [Haber(0)],'
End

While(@i<=@Prdo2)
Begin
	if(@i<10) 
	Begin
		Set @RPrdoD=@RPrdoD+'s.D'+@ColMda+'0'+Convert(varchar(2),@i)+'+'
		Set @RPrdoH=@RPrdoH+'s.H'+@ColMda+'0'+Convert(varchar(2),@i)+'+'
	end
	else
	Begin 	
		Set @RPrdoD=@RPrdoD+'s.D'+@ColMda+''+Convert(varchar(2),@i)+'+'
		Set @RPrdoH=@RPrdoH+'s.H'+@ColMda+''+Convert(varchar(2),@i)+'+'
	end
	Set @i=@i+1	
End

Declare @RPrdoDF nvarchar(200)
Declare @RPrdoHF nvarchar(200)
Set @RPrdoDF = '' Set @RPrdoHF = ''
If(Convert(int,@Prdo2)<1)
Begin
	Set @RPrdoD = '0'
	Set @RPrdoH = '0'
End
Else
Begin
	Set @RPrdoD=left(@RPrdoD,len(@RPrdoD)-1)
	Set @RPrdoH=left(@RPrdoH,len(@RPrdoH)-1)
	Set @RPrdoDF = 'Sum('+@RPrdoD+') as [Debe('+@RMeses+')],' 
	Set @RPrdoHF = 'Sum('+@RPrdoH+') as [Haber('+@RMeses+')],'
	Set @CRangoD = '0.00 as [Debe('+@RMeses+')],'
	Set @CRangoH = '0.00 as [Haber('+@RMeses+')],'
End

if(isnull(len(@Cd_CCD),0) <> 0 and isnull(len(@Cd_CCH),0) <> 0)
Begin
	Set @RangoCC = ' and s.Cd_CC between '''+@Cd_CCD+''' and '''+@Cd_CCH+''''
	if(isnull(len(@Cd_SCD),0) <> 0 and isnull(len(@Cd_SCH),0) <> 0)
	Begin
		Set @RangoCC = @RangoCC + ' and s.Cd_SC between '''+@Cd_SCD+''' and '''+@Cd_SCH+''''
		if(isnull(len(@Cd_SSD),0) <> 0 and isnull(len(@Cd_SSH),0) <> 0)
			Set @RangoCC = @RangoCC + ' and s.Cd_SS between '''+@Cd_SSD+''' and '''+@Cd_SSH+''''		
	End
End
else	Set @RangoCC = ''

if(isnull(len(@NroCtaD),0)<>0 and isnull(len(@NroCtaH),0)<>0)
	Set @RanNroCta = ' and Between '+@NroCtaD+' and '+@NroCtaH
else	Set @RanNroCta = ' and Between ''999999999999'' and ''999999999999'''


Print @RPrdoD + ' 1'
Print @RPrdoH + ' 2'
Print @RangoCC + ' 3'
Print @RangoD + ' 4'
Print @RangoH + ' 5'


Declare @SQL1 nvarchar(4000)
Declare @SQL2 nvarchar(4000)
Declare @SQL3 nvarchar(4000)
Declare @SQL4 nvarchar(4000)
Declare @SQL5 nvarchar(4000)
Declare @SQL6 nvarchar(4000)
Declare @TOTAL nvarchar(4000)
Set @SQL1 = ''
Set @SQL2 = ''
Set @SQL3 = ''
Set @SQL4 = ''
Set @SQL5 = ''
Set @SQL6 = ''
Set @TOTAL = ''



IF(@n1 = 1)
Begin
	Set @SQL1 = '
			(select 1 as Num,
				s.RucE,
				s.Ejer,s.NroCta,p.NomCta,
				'+@PCero+'
				'+@RPrdoDF+'
				'+@RPrdoHF+'
				Sum('+@PCero1+')+Sum('+@RPrdoD+') as [Sum Debe],
				Sum('+@PCero2+')+Sum('+@RPrdoH+') as [Sum Haber],
				Case(left(Convert(varchar,(Sum('+@PCero1+')+Sum('+@RPrdoD+'))-(Sum('+@PCero2+')+Sum('+@RPrdoH+'))),1)) when ''-'' then 0 else (Sum('+@PCero1+')+Sum('+@RPrdoD+'))-(Sum('+@PCero2+')+Sum('+@RPrdoH+')) end [Saldos Deudor],
				Case(left(Convert(varchar,(Sum('+@PCero1+')+Sum('+@RPrdoD+'))-(Sum('+@PCero2+')+Sum('+@RPrdoH+'))),1)) when ''-'' then ((Sum('+@PCero1+')+Sum('+@RPrdoD+'))-(Sum('+@PCero2+')+Sum('+@RPrdoH+')))*-1 else 0 end [Saldos Acreedor]
			from SUMAS_N1'+@Mda+' s--,PlanCtas p
			left join PlanCtas p On s.RucE=p.RucE and s.NroCta=p.NroCta and p.Ejer=s.Ejer
			where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''''+@RangoCC
			--+' and s.RucE=p.RucE and s.NroCta=p.NroCta'
			+@RangoD+@RangoH+'
			Group by s.RucE,s.Ejer,s.NroCta,s.NroCta,p.NomCta Having (Sum('+@PCero1+')+Sum('+@PCero2+')+Sum('+@RPrdoD+')+Sum('+@RPrdoH+'))<>0)
		     '
End
IF(@n2 = 1)
Begin
	IF(@n1 = 1) Set @SQL2=@SQL2+'UNION ALL'
	Set @SQL2=@SQL2+
			'
			(select 
				2 as Num,
				s.RucE,
				s.Ejer,s.NroCta,p.NomCta,
				'+@PCero+'
				'+@RPrdoDF+'
				'+@RPrdoHF+'
				Sum('+@PCero1+')+Sum('+@RPrdoD+') as [Sum Debe],
				Sum('+@PCero2+')+Sum('+@RPrdoH+') as [Sum Haber],
				Case(left(Convert(varchar,(Sum('+@PCero1+')+Sum('+@RPrdoD+'))-(Sum('+@PCero2+')+Sum('+@RPrdoH+'))),1)) when ''-'' then 0 else (Sum('+@PCero1+')+Sum('+@RPrdoD+'))-(Sum('+@PCero2+')+Sum('+@RPrdoH+')) end [Saldos Deudor],
				Case(left(Convert(varchar,(Sum('+@PCero1+')+Sum('+@RPrdoD+'))-(Sum('+@PCero2+')+Sum('+@RPrdoH+'))),1)) when ''-'' then ((Sum('+@PCero1+')+Sum('+@RPrdoD+'))-(Sum('+@PCero2+')+Sum('+@RPrdoH+')))*-1 else 0 end [Saldos Acreedor]
			from SUMAS_N2'+@Mda+' s--,PlanCtas p
			left join PlanCtas p On s.RucE=p.RucE and s.NroCta=p.NroCta and p.Ejer=s.Ejer
			where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''''+@RangoCC
			--+' and s.RucE=p.RucE and s.NroCta=p.NroCta'
			+@RangoD+@RangoH+'
			Group by s.RucE,s.Ejer,s.NroCta,s.NroCta,p.NomCta Having (Sum('+@PCero1+')+Sum('+@PCero2+')+Sum('+@RPrdoD+')+Sum('+@RPrdoH+'))<>0)
			'
End
IF(@n3 = 1)
Begin
	IF(@n1 = 1 or @n2 = 1) Set @SQL3=@SQL3+'UNION ALL'
	Set @SQL3=@SQL3+
			'
			(select 
				3 as Num,
				s.RucE,
				s.Ejer,s.NroCta,p.NomCta,
				'+@PCero+'
				'+@RPrdoDF+'
				'+@RPrdoHF+'
				Sum('+@PCero1+')+Sum('+@RPrdoD+') as [Sum Debe],
				Sum('+@PCero2+')+Sum('+@RPrdoH+') as [Sum Haber],
				Case(left(Convert(varchar,(Sum('+@PCero1+')+Sum('+@RPrdoD+'))-(Sum('+@PCero2+')+Sum('+@RPrdoH+'))),1)) when ''-'' then 0 else (Sum('+@PCero1+')+Sum('+@RPrdoD+'))-(Sum('+@PCero2+')+Sum('+@RPrdoH+')) end [Saldos Deudor],
				Case(left(Convert(varchar,(Sum('+@PCero1+')+Sum('+@RPrdoD+'))-(Sum('+@PCero2+')+Sum('+@RPrdoH+'))),1)) when ''-'' then ((Sum('+@PCero1+')+Sum('+@RPrdoD+'))-(Sum('+@PCero2+')+Sum('+@RPrdoH+')))*-1 else 0 end [Saldos Acreedor]
			from SUMAS_N3'+@Mda+' s--,PlanCtas p
			left join PlanCtas p On s.RucE=p.RucE and s.NroCta=p.NroCta and p.Ejer=s.Ejer
			where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''''+@RangoCC
			--+' and s.RucE=p.RucE and s.NroCta=p.NroCta'
			+@RangoD+@RangoH+'
			Group by s.RucE,s.Ejer,s.NroCta,s.NroCta,p.NomCta Having (Sum('+@PCero1+')+Sum('+@PCero2+')+Sum('+@RPrdoD+')+Sum('+@RPrdoH+'))<>0)
			'
End
IF(@n4 = 1)
Begin
	IF(@n1 = 1 or @n2 = 1 or @n3 = 1) Set @SQL4=@SQL4+'UNION ALL'
	Set @SQL4=@SQL4+
			'
			(select 
				4 as Num,
				s.RucE,
				s.Ejer,s.NroCta,p.NomCta,
				'+@PCero+'
				'+@RPrdoDF+'
				'+@RPrdoHF+'
				Sum('+@PCero1+')+Sum('+@RPrdoD+') as [Sum Debe],
				Sum('+@PCero2+')+Sum('+@RPrdoH+') as [Sum Haber],
				Case(left(Convert(varchar,(Sum('+@PCero1+')+Sum('+@RPrdoD+'))-(Sum('+@PCero2+')+Sum('+@RPrdoH+'))),1)) when ''-'' then 0 else (Sum('+@PCero1+')+Sum('+@RPrdoD+'))-(Sum('+@PCero2+')+Sum('+@RPrdoH+')) end [Saldos Deudor],
				Case(left(Convert(varchar,(Sum('+@PCero1+')+Sum('+@RPrdoD+'))-(Sum('+@PCero2+')+Sum('+@RPrdoH+'))),1)) when ''-'' then ((Sum('+@PCero1+')+Sum('+@RPrdoD+'))-(Sum('+@PCero2+')+Sum('+@RPrdoH+')))*-1 else 0 end [Saldos Acreedor]
			from SUMAS_N4'+@Mda+' s--,PlanCtas p
			left join PlanCtas p On s.RucE=p.RucE and s.NroCta=p.NroCta and s.Ejer=p.Ejer
			where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''''+@RangoCC
			--+' and s.RucE=p.RucE and s.NroCta=p.NroCta'
			+@RangoD+@RangoH+'
			Group by s.RucE,s.Ejer,s.NroCta,s.NroCta,p.NomCta Having (Sum('+@PCero1+')+Sum('+@PCero2+')+Sum('+@RPrdoD+')+Sum('+@RPrdoH+'))<>0)
			'
End


Set @TOTAL = '
		select 
			0 as Num,
			s.RucE,
			s.Ejer,''>>>>>'' as NroCta,''SUMAS >>>>>'' as NomCta,
			'+@PCero+'
			'+@RPrdoDF+'
			'+@RPrdoHF+'
			Sum('+@PCero1+'+'+@RPrdoD+') as [Sum Debe],
			Sum('+@PCero2+'+'+@RPrdoH+') as [Sum Haber],
			Sum(Case(left(Convert(varchar,('+@PCero1+'+'+@RPrdoD+')-('+@PCero2+'+'+@RPrdoH+')),1)) when ''-'' then 0 else ('+@PCero1+'+'+@RPrdoD+')-('+@PCero2+'+'+@RPrdoH+') end) [Saldos Deudor],
			Sum(Case(left(Convert(varchar,('+@PCero1+'+'+@RPrdoD+')-('+@PCero2+'+'+@RPrdoH+')),1)) when ''-'' then (('+@PCero1+'+'+@RPrdoD+')-('+@PCero2+'+'+@RPrdoH+'))*-1 else 0 end) [Saldos Acreedor]
		from SUMAS_N4'+@Mda+' s
		where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''''+@RangoCC+@RangoD+@RangoH+'
		Group by s.RucE,s.Ejer
	     '

PRINT @SQL1
PRINT @SQL2
PRINT @SQL3
PRINT @SQL4
PRINT @TOTAL
EXEC (@SQL1+@SQL2+@SQL3+@SQL4+
      'Order by 4,1')
EXEC (@TOTAL)

		--VALORES
Set @SQL5 = 'select 
		0 as Num,
		'''' as RucE,
		'''' as Ejer, '''' as NroCta, '''' as NomCta,
		'+@Cero+'
		'+@CRangoD+'
		'+@CRangoH+'
		0.00 as [Sum Debe],
		0.00 as [Sum Haber],
		0.00 as [Saldos Deudor],
		0.00 as [Saldos Acreedor],
		0.00 as [Inventario (Activo) ],
		0.00 as [Inventario (Pasivo) ],
		0.00 as [Por Naturaleza (Perdida) ],
		0.00 as [Por Naturaleza (Ganancia) ],
		0.00 as [Por Funcion  (Perdida) ],
		0.00 as [Por Funcion  (Ganancia) ]
		'
		--TOTALES
Set @SQL6 = 'select  
		0 as Num,
		'''' as RucE,
		'''' as Ejer, '''' as NroCta, '''' as NomCta,
		'+@Cero+'
		'+@CRangoD+'
		'+@CRangoH+'
		0.00 as [Sum Debe],
		0.00 as [Sum Haber],
		0.00 as [Saldos Deudor],
		0.00 as [Saldos Acreedor],
		0.00 as [Inventario (Activo) ],
		0.00 as [Inventario (Pasivo) ],
		0.00 as [Por Naturaleza (Perdida) ],
		0.00 as [Por Naturaleza (Ganancia) ],
		0.00 as [Por Funcion  (Perdida) ],
		0.00 as [Por Funcion  (Ganancia) ]
		'

PRINT @SQL5
PRINT @SQL6

EXEC(@SQL5)
EXEC(@SQL6)
GO

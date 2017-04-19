SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Pre_CCPresupFCCons_RptGEN]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@Moneda nvarchar(1),
@TipoRpt nvarchar(1),
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),
@NroCtas nvarchar(1000),

@msj varchar(100) output


As

/*
Declare @RucE nvarchar(11)
Declare @Ejer nvarchar(4)
Declare @PrdoD nvarchar(2)
Declare @PrdoH nvarchar(2)
Declare @Moneda nvarchar(1)
Declare @TipoRpt nvarchar(1)
Declare @Cd_CC varchar(8)
Declare @Cd_SC varchar(8)
Declare @Cd_SS varchar(8)
Declare @NroCtas nvarchar(1000)

Set @RucE = '11111111111'
Set @Ejer = '2010'
Set @PrdoD = '01'
Set @PrdoH = '04'
Set @Moneda = 's'
Set @TipoRpt = 'c'
Set @Cd_CC = '0003'
Set @Cd_SC = ''
Set @Cd_SS = ''
Set @NroCtas = ''
*/


if(@Cd_CC is null) Set @Cd_CC=''
if(@Cd_SC is null) Set @Cd_SC=''
if(@Cd_SS is null) Set @Cd_SS=''

Declare @Condicion nvarchar(1200) Set @Condicion = ''
if(isnull(@NroCtas,'') <> '') Set @Condicion = ' and NroCta in ('+@NroCtas+')'

Declare @SQL_P1 nvarchar(4000) Set @SQL_P1 = ''
Declare @SQL_P2 nvarchar(4000) Set @SQL_P2 = ''

If(@TipoRpt = 'm') -- Mensualizado
Begin
	Set @SQL_P1=
		'
		Select 
			''Psp'' As Tipo, Prdo,isnull(Case When '''+@Moneda+'''=''s'' Then Sum(Mto) Else Sum(Mto_ME) End,0.00) As Monto 
		from 
			PresupFCTot 
		Where 
			RucE='''+@RucE+'''
			and Ejer='''+@Ejer+'''
			and Case When isnull('''+@Cd_CC+''','''')='''' Then '''' Else Cd_CC End = isnull('''+@Cd_CC+''','''')
			and Case When isnull('''+@Cd_SC+''','''')='''' Then '''' Else Cd_SC End = isnull('''+@Cd_SC+''','''')
			and Case When isnull('''+@Cd_SS+''','''')='''' Then '''' Else Cd_SS End = isnull('''+@Cd_SS+''','''')
			'+@Condicion+'
			and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' 
		Group by Prdo
		'
	Set @SQL_P2=
		'
		UNION ALL
		Select 
			''Eje'' As Tipo,Prdo,isnull(Case When '''+@Moneda+'''=''s'' Then Sum(MtoD-MtoH) Else Sum(MtoD_ME-MtoH_ME) End,0.00) As Monto 
		from 
			Voucher 
		Where 
			RucE='''+@RucE+'''
			and Ejer='''+@Ejer+'''
			and Case When isnull('''+@Cd_CC+''','''')='''' Then '''' Else Cd_CC End = isnull('''+@Cd_CC+''','''')
			and Case When isnull('''+@Cd_SC+''','''')='''' Then '''' Else Cd_SC End = isnull('''+@Cd_SC+''','''')
			and Case When isnull('''+@Cd_SS+''','''')='''' Then '''' Else Cd_SS End = isnull('''+@Cd_SS+''','''')
			and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' 
		      	and NroCta in (	Select NroCta 
					from PresupFC
					Where 	RucE='''+@RucE+'''
						and Ejer='''+@Ejer+'''
						and Case When isnull('''+@Cd_CC+''','''')='''' Then '''' Else Cd_CC End = isnull('''+@Cd_CC+''','''')
						and Case When isnull('''+@Cd_SC+''','''')='''' Then '''' Else Cd_SC End = isnull('''+@Cd_SC+''','''')
						and Case When isnull('''+@Cd_SS+''','''')='''' Then '''' Else Cd_SS End = isnull('''+@Cd_SS+''','''')
						'+@Condicion+'
					Group By NroCta
				       ) Group by Prdo
		'
End
Else If(@TipoRpt = 't') -- Totalizado
Begin
	Set @SQL_P1=
		'
		Select 
			''Psp'' As Tipo,''TotalPsp'' As Prdo,isnull(Case When '''+@Moneda+'''=''s'' Then Sum(Mto) Else Sum(Mto_ME) End,0.00) As Monto 
		from 
			PresupFCTot 
		Where 
			RucE='''+@RucE+'''
			and Ejer='''+@Ejer+'''
			and Case When isnull('''+@Cd_CC+''','''')='''' Then '''' Else Cd_CC End = isnull('''+@Cd_CC+''','''')
			and Case When isnull('''+@Cd_SC+''','''')='''' Then '''' Else Cd_SC End = isnull('''+@Cd_SC+''','''')
			and Case When isnull('''+@Cd_SS+''','''')='''' Then '''' Else Cd_SS End = isnull('''+@Cd_SS+''','''')
			'+@Condicion+'
			and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' 
		'
	Set @SQL_P2=
		'
		UNION ALL
		Select 
			''Eje'' As Tipo,''TotalEje'' As Prdo,isnull(Case When '''+@Moneda+'''=''s'' Then Sum(MtoD-MtoH) Else Sum(MtoD_ME-MtoH_ME) End,0.00) As Monto 
		from 
			Voucher 
		Where 
			RucE='''+@RucE+'''
			and Ejer='''+@Ejer+'''
			and Case When isnull('''+@Cd_CC+''','''')='''' Then '''' Else Cd_CC End = isnull('''+@Cd_CC+''','''')
			and Case When isnull('''+@Cd_SC+''','''')='''' Then '''' Else Cd_SC End = isnull('''+@Cd_SC+''','''')
			and Case When isnull('''+@Cd_SS+''','''')='''' Then '''' Else Cd_SS End = isnull('''+@Cd_SS+''','''')
			and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' 
		      	and NroCta in (	Select NroCta 
					from PresupFC 
					Where 	RucE='''+@RucE+'''
						and Ejer='''+@Ejer+'''
						and Case When isnull('''+@Cd_CC+''','''')='''' Then '''' Else Cd_CC End = isnull('''+@Cd_CC+''','''')
						and Case When isnull('''+@Cd_SC+''','''')='''' Then '''' Else Cd_SC End = isnull('''+@Cd_SC+''','''')
						and Case When isnull('''+@Cd_SS+''','''')='''' Then '''' Else Cd_SS End = isnull('''+@Cd_SS+''','''')
						'+@Condicion+'
					Group By NroCta
				       )
		'
End
Else If(@TipoRpt = 'c') -- Por Cuenta
Begin
	Set @SQL_P1=
		'
		Select 
			''Psp'' As Tipo,NroCta As Prdo,isnull(Case When '''+@Moneda+'''=''s'' Then Sum(Mto) Else Sum(Mto_ME) End,0.00) As Monto 
		from 
			PresupFCoTot 
		Where 
			RucE='''+@RucE+'''
			and Ejer='''+@Ejer+'''
			and Case When isnull('''+@Cd_CC+''','''')='''' Then '''' Else Cd_CC End = isnull('''+@Cd_CC+''','''')
			and Case When isnull('''+@Cd_SC+''','''')='''' Then '''' Else Cd_SC End = isnull('''+@Cd_SC+''','''')
			and Case When isnull('''+@Cd_SS+''','''')='''' Then '''' Else Cd_SS End = isnull('''+@Cd_SS+''','''')
			'+@Condicion+'
			and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' 
		Group by NroCta
		'
	Set @SQL_P2=
		'
		UNION ALL
		Select 
			''Eje'' As Tipo,NroCta As Prdo,isnull(Case When '''+@Moneda+'''=''s'' Then Sum(MtoD-MtoH) Else Sum(MtoD_ME-MtoH_ME) End,0.00) As Monto 
		from 
			Voucher 
		Where 
			RucE='''+@RucE+'''
			and Ejer='''+@Ejer+'''
			and Case When isnull('''+@Cd_CC+''','''')='''' Then '''' Else Cd_CC End = isnull('''+@Cd_CC+''','''')
			and Case When isnull('''+@Cd_SC+''','''')='''' Then '''' Else Cd_SC End = isnull('''+@Cd_SC+''','''')
			and Case When isnull('''+@Cd_SS+''','''')='''' Then '''' Else Cd_SS End = isnull('''+@Cd_SS+''','''')
			and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' 
		      	and NroCta in (	Select NroCta 
					from PresupFC 
					Where 	RucE='''+@RucE+'''
						and Ejer='''+@Ejer+'''
						and Case When isnull('''+@Cd_CC+''','''')='''' Then '''' Else Cd_CC End = isnull('''+@Cd_CC+''','''')
						and Case When isnull('''+@Cd_SC+''','''')='''' Then '''' Else Cd_SC End = isnull('''+@Cd_SC+''','''')
						and Case When isnull('''+@Cd_SS+''','''')='''' Then '''' Else Cd_SS End = isnull('''+@Cd_SS+''','''')
						'+@Condicion+'
					Group By NroCta
				       )Group By NroCta
		'
End

Print @SQL_P1 + @SQL_P2

Exec (@SQL_P1 + @SQL_P2)


-- Leyenda --
-- Di : 25/01/2011 <Creacion del procedimiento almacenado>
GO

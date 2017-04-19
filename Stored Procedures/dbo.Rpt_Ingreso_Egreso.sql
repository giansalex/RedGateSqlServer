SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Ingreso_Egreso]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@Nivel1 bit,
@Nivel2 bit,
@Nivel3 bit,
@Nivel4 bit,
@Cd_Mda nvarchar(2),
@Opc varchar(1), -- 'F':Funcion, 'N':Naturaleza 
@msj varchar(100) output

as

/*
Declare @RucE nvarchar(11)
Declare @Ejer nvarchar(4)
Declare @PrdoIni nvarchar(2)
Declare @PrdoFin nvarchar(2)
Declare @Nivel1 bit
Declare @Nivel2 bit
Declare @Nivel3 bit
Declare @Nivel4 bit
Declare @Cd_Mda nvarchar(2)
Declare @Opc varchar(1)
--Declare @Cd_CC nvarchar


Set @RucE='11111111111' Set @Ejer='2009'
Set @PrdoIni='00' Set @PrdoFin='12'
Set @Nivel1='1' Set @Nivel2='1' Set @Nivel3='1' Set @Nivel4='1'
Set @Cd_Mda='01'
Set @Opc = 'N'
*/

/**************************************************************************************/




Declare @NomCol nvarchar(4000), @SumCol nvarchar(4000), @SumTCol nvarchar(4000)
Declare @i int,@f int

Set @NomCol='' Set @SumCol='' Set @SumTCol=''
Set @i = Convert(int,@PrdoIni)
Set @f = Convert(int,@PrdoFin)

while(@i <= @f)
begin
	Set @NomCol = @NomCol + 'isnull(a.Saldo'+right('00'+ltrim(@i),2)+',0)*-1 as '+user123.DameFormPrdo(right('00'+ltrim(@i),2),1,1)+','
	Set @SumCol = @SumCol + 'isnull(a.Saldo'+right('00'+ltrim(@i),2)+',0)*-1+'
	Set @SumTCol = @SumTCol + 'isnull(Sum(a.Saldo'+right('00'+ltrim(@i),2)+'),0)*-1 as '+user123.DameFormPrdo(right('00'+ltrim(@i),2),1,1)+','
	Set @i = @i + 1
end

Set @NomCol = left(@NomCol,len(@NomCol)-1)
Set @SumCol = left(@SumCol,len(@SumCol)-1)
Set @SumTCol = left(@SumTCol,len(@SumTCol)-1)

/**************************************************************************************/

	Declare @N_Min nvarchar(1) --Nivel minimo de cta consultado (por el cual se debe respetar las sumas) --PV
	if @Nivel4=1
	   set @N_Min='9'
	else if @Nivel3=1
	   set @N_Min='6'
	else if @Nivel2=1
	   set @N_Min='4'
	else 
	   set @N_Min='2'
	
	print 'Nivel minimo: ' + @N_Min --PV

/**************************************************************************************/

Declare @Mda  nvarchar(5)
Set @Mda = ''
if(@Cd_Mda <> '01')
	Set @Mda = '_D'

/**************************************************************************************/
--                 MUESTRAS           --

print @NomCol
print @SumCol
print @SumTCol
print @Mda

/**************************************************************************************/

Declare @SQL1_1 nvarchar(4000),@SQL2_1 nvarchar(4000),@SQL3_1 nvarchar(4000),@SQL4_1 nvarchar(4000)
Declare @SQL1_2 nvarchar(4000),@SQL2_2 nvarchar(4000),@SQL3_2 nvarchar(4000),@SQL4_2 nvarchar(4000)
Declare @SQLT_1 nvarchar(4000),@SQLT_2 nvarchar(4000)
Set @SQL1_1 = '' Set @SQL2_1 = '' Set @SQL3_1 = '' Set @SQL4_1 = ''
Set @SQL1_2 = '' Set @SQL2_2 = '' Set @SQL3_2 = '' Set @SQL4_2 = ''
Set @SQLT_1 = '' Set @SQLT_2 = ''

if(@Nivel1 = 1)
begin
	Set @SQL1_1 = 
		   'Select 1 as ind,a.NroCtaN1 as NroCta,b.NomCta,'+@NomCol+','+@SumCol+' as TOTAL
		    from SaldosXPrdoN1'+@Mda+' a
 		    left join PlanCtas b on a.RucE=b.RucE and a.NroCtaN1=b.NroCta and b.Ejer=a.Ejer
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Ejer+''' and left(a.NroCtaN1,2) in (select p.NroCta from PlanCtas p where p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and p.IC_IE'+@opc+'=''I'' Group by p.NroCta)
		   '
	Set @SQL1_2 = 
		   'Select 1 as ind,a.NroCtaN1 as NroCta,b.NomCta,'+@NomCol+','+@SumCol+' as TOTAL
		    from SaldosXPrdoN1'+@Mda+' a
 		    left join PlanCtas b on a.RucE=b.RucE and a.NroCtaN1=b.NroCta and b.Ejer=a.Ejer
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Ejer+''' and left(a.NroCtaN1,2) in (select p.NroCta from PlanCtas p where p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and p.IC_IE'+@opc+'=''E'' Group by p.NroCta)
		   '
end
if(@Nivel2 = 1)
begin
	if(@Nivel1 = 1)begin  Set @SQL2_1 = @SQL2_1 + 'UNION ALL ' Set @SQL2_2 = @SQL2_2 + 'UNION ALL ' end
	Set @SQL2_1 = @SQL2_1 +
		   'Select 2 as ind,a.NroCtaN2 as NroCta,b.NomCta,'+@NomCol+','+@SumCol+' as TOTAL
		    from SaldosXPrdoN2'+@Mda+' a
     		    left join PlanCtas b on a.RucE=b.RucE and a.NroCtaN2=b.NroCta and b.Ejer=a.Ejer
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Ejer+''' and left(a.NroCtaN2,4) in (select p.NroCta from PlanCtas p where p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and p.IC_IE'+@opc+'=''I'' Group by p.NroCta)
		   '
	Set @SQL2_2 = @SQL2_2 +
		   'Select 2 as ind,a.NroCtaN2 as NroCta,b.NomCta,'+@NomCol+','+@SumCol+' as TOTAL
		    from SaldosXPrdoN2'+@Mda+' a
     		    left join PlanCtas b on a.RucE=b.RucE and a.NroCtaN2=b.NroCta and b.Ejer=a.Ejer
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Ejer+''' and left(a.NroCtaN2,4) in (select p.NroCta from PlanCtas p where p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and p.IC_IE'+@opc+'=''E'' Group by p.NroCta)
		   '
end
if(@Nivel3 = 1)
begin
	if(@Nivel1 = 1 or @Nivel2 = 1)begin Set @SQL3_1 = @SQL3_1 + 'UNION ALL ' Set @SQL3_2 = @SQL3_2 + 'UNION ALL ' end
	Set @SQL3_1 = @SQL3_1 +
		   'Select 3 as ind,a.NroCtaN3 as NroCta,b.NomCta,'+@NomCol+','+@SumCol+' as TOTAL
		    from SaldosXPrdoN3'+@Mda+' a
     		    left join PlanCtas b on a.RucE=b.RucE and a.NroCtaN3=b.NroCta and b.Ejer=a.Ejer
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Ejer+''' and left(a.NroCtaN3,6) in (select p.NroCta from PlanCtas p where p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and p.IC_IE'+@opc+'=''I'' Group by p.NroCta)
		   '
	Set @SQL3_2 = @SQL3_2 +
		   'Select 3 as ind,a.NroCtaN3 as NroCta,b.NomCta,'+@NomCol+','+@SumCol+' as TOTAL
		    from SaldosXPrdoN3'+@Mda+' a
     		    left join PlanCtas b on a.RucE=b.RucE and a.NroCtaN3=b.NroCta and b.Ejer=a.Ejer
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Ejer+''' and left(a.NroCtaN3,6) in (select p.NroCta from PlanCtas p where p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and p.IC_IE'+@opc+'=''E'' Group by p.NroCta)
		   '
end
if(@Nivel4 = 1)
begin
	if(@Nivel1 = 1 or @Nivel2 = 1 or @Nivel3 = 1)begin Set @SQL4_1 = @SQL4_1 + 'UNION ALL ' Set @SQL4_2 = @SQL4_2 + 'UNION ALL ' end
	Set @SQL4_1 = @SQL4_1 + 
		   'Select 4 as ind,a.NroCtaN4 as NroCta,b.NomCta,'+@NomCol+','+@SumCol+' as TOTAL
		    from SaldosXPrdoN4'+@Mda+' a
     		    left join PlanCtas b on a.RucE=b.RucE and a.NroCtaN4=b.NroCta and b.Ejer=a.Ejer
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Ejer+''' and left(a.NroCtaN4,9) in (select p.NroCta from PlanCtas p where p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and p.IC_IE'+@opc+'=''I'' Group by p.NroCta)
		   '
	Set @SQL4_2 = @SQL4_2 + 
		   'Select 4 as ind,a.NroCtaN4 as NroCta,b.NomCta,'+@NomCol+','+@SumCol+' as TOTAL
		    from SaldosXPrdoN4'+@Mda+' a
     		    left join PlanCtas b on a.RucE=b.RucE and a.NroCtaN4=b.NroCta and b.Ejer=a.Ejer
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Ejer+''' and left(a.NroCtaN4,9) in (select p.NroCta from PlanCtas p where p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and p.IC_IE'+@opc+'=''E'' Group by p.NroCta)
		   '
end

/**************************************************************************************/


--TOTALES INGRESO/EGRESO:
--PROBLEMA1: SOLO TOTALIZA SI ES QUE ESTA MARCADO EL NIVEL 1 (CTA 2 DIGITOS)
--Solucion aparente: al registrar una cuenta con I/E en el plan de cuentas tb se modificaran sus padres, abuelos y bisabuelos

if(@Nivel1 = 1 or @Nivel2 = 1 or @Nivel3 = 1 or @Nivel4 = 1)
begin
	Set @SQLT_1 = 
		   'UNION ALL 
		    Select 5 as ind,''RESULTADO'' as NroCta,''TOTAL DE INGRESO'' as NomCta,'+@SumTCol+',isnull(Sum('+@SumCol+'),0) as TOTAL
		    from SaldosXPrdoN4'+@Mda+' a
     		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Ejer+''' and left(a.NroCtaN4,'+@N_Min+') in (select p.NroCta from PlanCtas p where p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and p.IC_IE'+@opc+'=''I'' Group by p.NroCta)
		   '
	Set @SQLT_2 = 
		   'UNION ALL 
		    Select 5 as ind,''RESULTADO'' as NroCta,''TOTAL DE EGRESO'' as NomCta,'+@SumTCol+',isnull(Sum('+@SumCol+'),0) as TOTAL
		    from SaldosXPrdoN4'+@Mda+' a
     		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Ejer+''' and left(a.NroCtaN4,'+@N_Min+') in (select p.NroCta from PlanCtas p where p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and p.IC_IE'+@opc+'=''E'' Group by p.NroCta)
		   '
end

/**************************************************************************************/

Print '('+@SQL1_1+@SQL2_1+@SQL3_1+@SQL4_1+@SQLT_1+ ') Order by 2,1'
Print '('+@SQL1_2+@SQL2_2+@SQL3_2+@SQL4_2+@SQLT_2+ ') Order by 2,1'

Exec ( '('+@SQL1_1+@SQL2_1+@SQL3_1+@SQL4_1+@SQLT_1+ ') Order by 2,1' )
Exec ( '('+@SQL1_2+@SQL2_2+@SQL3_2+@SQL4_2+@SQLT_2+ ') Order by 2,1' )


/*
PRUEBAS PV:

exec Rpt_Ingreso_Egreso '11111111111','2010','06','06',1,0,0,1,'01','N',null
exec Rpt_Ingreso_Egreso '11111111111','2010','06','06',1,0,0,1,'01','F',null

exec Rpt_Ingreso_Egreso '20101949461','2010','00','04',1,0,0,1,'01','N',null

*/


-- Leyenda --

-- DI 14/12/09 : Creacion del procedimiento almacenado
-- DI 21/12/09 : Modificacion del procedimiento almacenado (se altero la condicion de consulta)
-- PV 24/06/10 : Mdf: Consulta no obedecia al nivel de cuenta marcado con I/E solo si estaba marcado la cuenta de nivel 1 (cta 2 digitos)
		 --Documentacion: registro de "PROBLEMA1"
-- DI 24/01/2011 : Mdf: se agrego año a los plan de cuentas
GO

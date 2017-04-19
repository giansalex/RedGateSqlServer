SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_SaldosCons_x_Prdo_CC]
@RucE nvarchar(11),
@Eje nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@Cd_CCD nvarchar(8),
@Cd_CCH nvarchar(8),
@Nivel1 bit,
@Nivel2 bit,
@Nivel3 bit,
@Nivel4 bit,
@MdaReg nvarchar(2),
@RangoD nvarchar(10), 
@RangoH nvarchar(10),
@msj varchar(100) output
as

if(@PrdoIni > @PrdoFin) 
begin
	Set @msj = 'Rango de periodo no es el adecuado'
	print @msj
	return
end

Declare @Mda  nvarchar(5)
if(@MdaReg = '01') Set @Mda=''
else Set @Mda='_D'

Declare @RangoC nvarchar(200)
Set @RangoC = ''
if(isnull(len(@Cd_CCD),0) = 0 and isnull(len(@Cd_CCH),0) = 0)
Begin
	set @RangoC = ''
End
else	Set @RangoC = ' and a.Cd_CC between '''+@Cd_CCD+''' and '''+@Cd_CCH+''''

if(isnull(len(@RangoD),0) = 0 and isnull(len(@RangoH),0) = 0)
Begin
	set @RangoD = '0000000000'
	set @RangoH = '9999999999'
End

Declare @i int
Declare @Mes nvarchar(10)
Declare @Colum varchar(500), @ColumT varchar(500), @Suma varchar(500), @SumaT varchar(500)
Set @Colum = '' Set @ColumT = '' Set @Suma = '' Set @SumaT = '' Set @i = 0 Set @Mes = ''
Set @i = Convert(int,@PrdoIni)
Set @PrdoFin = Convert(int,@PrdoFin)
while(@i <= @PrdoFin and @i < 10)
begin
	if(@i = 0) Set @Mes = 'INICIAL'
	if(@i = 1) Set @Mes = 'ENE'
	if(@i = 2) Set @Mes = 'FEB'
	if(@i = 3) Set @Mes = 'MAR'
	if(@i = 4) Set @Mes = 'ABR'
	if(@i = 5) Set @Mes = 'MAY'
	if(@i = 6) Set @Mes = 'JUN'
	if(@i = 7) Set @Mes = 'JUL'
	if(@i = 8) Set @Mes = 'AGO'
	if(@i = 9) Set @Mes = 'SEP'
	Set @Colum = @Colum + 'a.Saldo0'+convert(varchar,@i)+' as '+@Mes+','
	Set @Suma = @Suma + 'a.Saldo0'+convert(varchar,@i)+'+'
	Set @ColumT = @ColumT + 'Sum(a.Saldo0'+convert(varchar,@i)+') as '+@Mes+','
	Set @i = @i + 1 	
end
while(@i <= @PrdoFin and @PrdoFin >= 10)
begin
	if(@i = 10) Set @Mes = 'OCT'
	if(@i = 11) Set @Mes = 'NOV'
	if(@i = 12) Set @Mes = 'DIC'
	if(@i = 13) Set @Mes = 'AJUSTE'
	if(@i = 14) Set @Mes = 'CIERRE'
	Set @Colum = @Colum + 'a.Saldo'+convert(varchar,@i)+' as '+@Mes+','
	Set @Suma = @Suma + 'a.Saldo'+convert(varchar,@i)+'+'
	Set @ColumT = @ColumT + 'Sum(a.Saldo'+convert(varchar,@i)+') as '+@Mes+','
	Set @i = @i + 1 
end
Set @Colum = left(@Colum,(len(@Colum)-1))
Set @Suma = left(@Suma,(len(@Suma)-1))
Set @ColumT = left(@ColumT,(len(@ColumT)-1))
Set @SumaT = 'Sum('+@Suma+')'

print '-----RESULTADOS------'
print @Colum
print @Suma
print @ColumT
print @SumaT
print '---------------------'

DECLARE @SQL1 nvarchar(4000)
DECLARE @SQL2 nvarchar(4000)
Set @SQL1 = ''
Set @SQL2 = ''

--SALDOS**********************************************************************************************************************
--*********************************************************************************************************************************

Declare @a int
Set @a = 0
if(@Nivel1=1) Set @a = 1
if(@Nivel2=1) Set @a = 2
if(@Nivel3=1) Set @a = 3
if(@Nivel4=1) Set @a = 4
if(@a = 0) 
Begin
	Set @a = 4
	Set @Nivel1 = 1
	Set @Nivel2 = 1
	Set @Nivel3 = 1
	Set @Nivel4 = 1
End

if(@Nivel1 = 1)
begin
	Set @SQL1 = 
		   'Select a.RucE,a.Ejer,a.NroCtaN1 as NroCta,b.NomCta,'+@Colum+','+@Suma+' as Total, b.Cd_Blc,b.Cd_EGPN,b.Cd_EGPF
		    from SaldosXPrdoN1_conSS'+@Mda+' a 
 		    left join PlanCtas b on a.RucE=b.RucE and a.NroCtaN1=b.NroCta and a.Ejer=b.Ejer
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+''' and a.NroCtaN1 between '''+@RangoD+''' and '''+@RangoH+''''+@RangoC+'
		   '
end
if(@Nivel2 = 1)
begin
	if(@Nivel1 = 1) Set @SQL1 = @SQL1 + 'UNION ALL '
	Set @SQL1 = @SQL1 +
		   'Select a.RucE,a.Ejer,a.NroCtaN2 as NroCta,b.NomCta,'+@Colum+','+@Suma+' as Total, b.Cd_Blc,b.Cd_EGPN,b.Cd_EGPF
		    from SaldosXPrdoN2_conSS'+@Mda+' a
 		    left join PlanCtas b on a.RucE=b.RucE and a.NroCtaN2=b.NroCta and a.Ejer=b.Ejer
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+''' and a.NroCtaN2 between '''+@RangoD+''' and '''+@RangoH+''''+@RangoC+'
		   '
end
if(@Nivel3 = 1)
begin
	if(@Nivel1 = 1 or @Nivel2 = 1) Set @SQL1 = @SQL1 + 'UNION ALL '
	Set @SQL1 = @SQL1 +
		   'Select a.RucE,a.Ejer,a.NroCtaN3 as NroCta,b.NomCta,'+@Colum+','+@Suma+' as Total, b.Cd_Blc,b.Cd_EGPN,b.Cd_EGPF
		    from SaldosXPrdoN3_conSS'+@Mda+' a
 		    left join PlanCtas b on a.RucE=b.RucE and a.NroCtaN3=b.NroCta and a.Ejer=b.Ejer
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+''' and a.NroCtaN3 between '''+@RangoD+''' and '''+@RangoH+''''+@RangoC+'
		   '
end
if(@Nivel4 = 1)
begin
	if(@Nivel1 = 1 or @Nivel2 = 1 or @Nivel3 = 1) Set @SQL1 = @SQL1 + 'UNION ALL '
	Set @SQL1 = @SQL1 + 
		   'Select a.RucE,a.Ejer,a.NroCtaN4 as NroCta,b.NomCta,'+@Colum+','+@Suma+' as Total, b.Cd_Blc,b.Cd_EGPN,b.Cd_EGPF
		    from SaldosXPrdoN4_conSS'+@Mda+' a
 		    left join PlanCtas b on a.RucE=b.RucE and a.NroCtaN4=b.NroCta and a.Ejer=b.Ejer
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+''' and a.NroCtaN4 between '''+@RangoD+''' and '''+@RangoH+''''+@RangoC+'
		   '
end
Set @SQL1 = @SQL1 + ' Order by a.NroCta'
print @SQL1



--TOTALES**********************************************************************************************************************
--***********************************************************************************************************************************
if(len(@RangoD) = 2 or len(@RangoH) = 2) Set @a = 1
if(len(@RangoD) = 4 or len(@RangoH) = 4) Set @a = 2
if(len(@RangoD) = 6 or len(@RangoH) = 6) Set @a = 3
if(len(@RangoD) = 9 or len(@RangoH) = 9) Set @a = 4

Set @SQL2 = 
	   'Select a.RucE,a.Ejer,''TOTALES'' as NroCta, ''=========================>'' as NomCta, '+@ColumT+','+@SumaT+' as Total, '''' as Cd_Blc,'''' as Cd_EGPN,'''' as Cd_EGPF
	    from SaldosXPrdoN'+Convert(varchar,@a)+'_conSS'+@Mda+' a
	    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+'''  and a.NroCtaN'+Convert(varchar,@a)+' between '''+@RangoD+''' and '''+@RangoH+''''+@RangoC+'
	    Group by a.RucE,a.Ejer
	   '    
print @SQL2


EXEC sp_executesql @SQL1
EXEC sp_executesql @SQL2

----------------------PRUEBA------------------------
--

------CODIGO DE MODIFICACION--------
--CM=RE01

----------------------LEYENDA----------------------
--FL: 17/09/2010 <se agrego ejercicio>
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_SaldosCons_x_Prdo2]

@RucE nvarchar(11),
@Eje nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@Nivel1 bit,
@Nivel2 bit,
@Nivel3 bit,
@Nivel4 bit,
@MdaReg nvarchar(2),
@RangoD nvarchar(10),
@RangoH nvarchar(10),
@CtaHml int, -- 0 = nada / 1 = Cta1 / 2 = Cta2

@IB_VerSaldados bit,

@msj varchar(100) output

as
	
	Declare @CtaHomo nvarchar(30),@NomHomo nvarchar(30)
	Declare @CtaHomoG nvarchar(30),@NomHomoG nvarchar(30)
	Declare @CtaHomoT nvarchar(30),@NomHomoT nvarchar(30)
	
	Set @CtaHomo = '' Set @CtaHomoT = '' Set @CtaHomoG = ''
	Set @NomHomo = '' Set @NomHomoT = '' Set @NomHomoG = ''
	
	If(@CtaHml = 1) 
	Begin 
		Set @CtaHomo = ',b.NroCtaH1 As NroCtaH'
		Set @NomHomo = ',b.NomCtaH1 As NomCtaH'
		Set @CtaHomoG = ',b.NroCtaH1'
		Set @NomHomoG = ',b.NomCtaH1'
		Set @CtaHomoT = ','''' As NroCtaH'
		Set @NomHomoT = ','''' As NomCtaH'
	End 
	Else If(@CtaHml = 2) 
	Begin 
		Set @CtaHomo = ',b.NroCtaH2 As NroCtaH'
		Set @NomHomo = ',b.NomCtaH2 As NomCtaH'
		Set @CtaHomoG = ',b.NroCtaH2'
		Set @NomHomoG = ',b.NomCtaH2'
		Set @CtaHomoT = ','''' As NroCtaH'
		Set @NomHomoT = ','''' As NomCtaH'
	End 

if(@PrdoIni > @PrdoFin) 
begin
	Set @msj = 'Rango de periodo no es el adecuado'
	print @msj
	return
end

Declare @Mda  nvarchar(5)
if(@MdaReg = '01') Set @Mda=''
else Set @Mda='_D'
print @Mda

if(isnull(len(@RangoD),0) = 0 and isnull(len(@RangoH),0) = 0)
Begin
	set @RangoD = '0000000000'
	set @RangoH = '9999999999'
End

Declare @Extra varchar(1000) Set @Extra=''
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
	Set @Extra = @Extra + 'Case When a.Saldo0'+convert(varchar,@i)+'<0 Then a.Saldo0'+convert(varchar,@i)+'*-1 Else a.Saldo0'+convert(varchar,@i)+' End+'
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
	Set @Extra = @Extra + 'Case When a.Saldo'+convert(varchar,@i)+'<0 Then a.Saldo'+convert(varchar,@i)+'*-1 Else a.Saldo'+convert(varchar,@i)+' End+'
	Set @i = @i + 1 
end
Set @Colum = left(@Colum,(len(@Colum)-1))
Set @Suma = left(@Suma,(len(@Suma)-1))
Set @ColumT = left(@ColumT,(len(@ColumT)-1))
Set @SumaT = 'Sum('+@Suma+')'
Set @Extra = ' and '+left(@Extra,len(@Extra)-1)+'<>0'

print '-----RESULTADOS------'
print @Colum
print @Suma
print @ColumT
print @SumaT

If(@IB_VerSaldados = 1) Set @Extra=''
Print @Extra
print '---------------------'


DECLARE @SQL1 varchar(8000)
DECLARE @SQL2 varchar(8000)
SET @SQL1 = ''
SET @SQL2 = ''

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
		   'Select 1 as ind,/*a.RucE,a.Ejer,*/a.NroCtaN1 as NroCta,b.NomCta'+@CtaHomo+@NomHomo+','+@Colum+','+@Suma+' as Total
		    from SaldosXPrdoN1'+@Mda+' a
 		    left join PlanCtas b on a.RucE=b.RucE and a.NroCtaN1=b.NroCta and b.Ejer=a.Ejer 
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+''' and a.NroCtaN1 between '''+@RangoD+''' and '''+@RangoH+'''
		    '+@Extra+'
		   '
end
if(@Nivel2 = 1)
begin
	if(@Nivel1 = 1) Set @SQL1 = @SQL1 + 'UNION ALL '
	Set @SQL1 = @SQL1 +
		   'Select 2 as ind,/*a.RucE,a.Ejer,*/a.NroCtaN2 as NroCta,b.NomCta'+@CtaHomo+@NomHomo+','+@Colum+','+@Suma+' as Total
		    from SaldosXPrdoN2'+@Mda+' a
     		    left join PlanCtas b on a.RucE=b.RucE and a.NroCtaN2=b.NroCta and b.Ejer=a.Ejer 
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+''' and a.NroCtaN2 between '''+@RangoD+''' and '''+@RangoH+'''
		    '+@Extra+'
		   '
end
if(@Nivel3 = 1)
begin
	if(@Nivel1 = 1 or @Nivel2 = 1) Set @SQL1 = @SQL1 + 'UNION ALL '
	Set @SQL1 = @SQL1 +
		   'Select 3 as ind,/*a.RucE,a.Ejer,*/a.NroCtaN3 as NroCta,b.NomCta'+@CtaHomo+@NomHomo+','+@Colum+','+@Suma+' as Total
		    from SaldosXPrdoN3'+@Mda+' a
     		    left join PlanCtas b on a.RucE=b.RucE and a.NroCtaN3=b.NroCta and b.Ejer=a.Ejer
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+''' and a.NroCtaN3 between '''+@RangoD+''' and '''+@RangoH+'''
		    '+@Extra+'
		   '
end
if(@Nivel4 = 1)
begin
	if(@Nivel1 = 1 or @Nivel2 = 1 or @Nivel3 = 1) Set @SQL1 = @SQL1 + 'UNION ALL '
	Set @SQL1 = @SQL1 + 
		   'Select 4 as ind,/*a.RucE,a.Ejer,*/a.NroCtaN4 as NroCta,b.NomCta'+@CtaHomo+@NomHomo+','+@Colum+','+@Suma+' as Total
		    from SaldosXPrdoN4'+@Mda+' a
     		    left join PlanCtas b on a.RucE=b.RucE and a.NroCtaN4=b.NroCta and b.Ejer=a.Ejer
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+''' and a.NroCtaN4 between '''+@RangoD+''' and '''+@RangoH+'''
		    '+@Extra+'
		   '
end
Set @SQL1 = @SQL1 + ' Order by NroCta'
print @SQL1



--TOTALES**********************************************************************************************************************
--*********************************************************************************************************************************
if(len(@RangoD) = 2 or len(@RangoH) = 2) Set @a = 1
if(len(@RangoD) = 4 or len(@RangoH) = 4) Set @a = 2
if(len(@RangoD) = 6 or len(@RangoH) = 6) Set @a = 3
if(len(@RangoD) = 9 or len(@RangoH) = 9) Set @a = 4

Set @SQL2 = 
	   'Select 0 as ind,/*a.RucE,a.Ejer,*/''TOTALES'' as NroCta, ''=========================>'' as NomCta, '+@ColumT+','+@SumaT+' as Total
	    from SaldosXPrdoN'+Convert(varchar,@a)+''+@Mda+' a
	    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+''' and a.NroCtaN'+Convert(varchar,@a)+' between '''+@RangoD+''' and '''+@RangoH+'''
	    Group by a.RucE,a.Ejer
	   '    	
print @SQL2

EXEC (@SQL1)
EXEC (@SQL2)
--EXEC sp_executesql @SQL2

----------------------PRUEBA------------------------
--exec Ctb_SaldosCons_x_Prdo '11111111111','2009','05','06','1','0','0','1','01','01/01/2008','30/07/2010',null

------CODIGO DE MODIFICACION--------
--CM=RE01

----------------------LEYENDA----------------------
--FL: 17/09/2010 <se agrego ejercicio>
--DI: 14/05/2012 <Se bloqueo el codigo de RucE y Ejer>
GO

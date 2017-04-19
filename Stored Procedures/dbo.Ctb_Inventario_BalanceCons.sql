SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_Inventario_BalanceCons]
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
@msj varchar(100) output
as

if(@PrdoIni > @PrdoFin) 
begin
	Set @msj = 'Rango de periodo no es el adecuado'
	print @msj
	return
end

Declare @Mda  nvarchar(5), @Mn nvarchar(4), @Ex nvarchar(4)
if(@MdaReg = '01')
begin 	
	Set @Mda=''
	Set @Ex=''
	Set @Mn=''
end
else if (@MdaReg = '02')
Begin
	Set @Mda='_D'
	Set @Ex='_ME'
	Set @Mn=''
End
else
Begin
	Set @Mda='_SD'
	Set @Ex='_ME'
	Set @Mn='_MN'
End
print @Mda



Declare @RangoN1 nvarchar(150)
Declare @RangoN2 nvarchar(150)
Declare @RangoN3 nvarchar(150)
Declare @RangoN4 nvarchar(150)
Declare @RangoN nvarchar(150)
Set @RangoN1 = '' Set @RangoN2 = '' Set @RangoN3 = '' Set @RangoN4 = ''
Set @RangoN = ''
----------------------------------------------------
-- Cadena Rango de cuentas
if(isnull(len(@RangoD),0) <> 0 and isnull(len(@RangoH),0) = 0)
begin
	if(len(@RangoD) = 2)
	begin
		Set @RangoN1 = ' and a.NroCtaN1 >= '''+@RangoD+''''
		Set @RangoN2 = ' and left(a.NroCtaN2,2) >= '''+@RangoD+''''
		Set @RangoN3 = ' and left(a.NroCtaN3,2) >= '''+@RangoD+''''
		Set @RangoN4 = ' and left(a.NroCtaN4,2) >= '''+@RangoD+''''
		Set @RangoN  = ' and left(a.NroCta,2) >= '''+@RangoD+''''
	end
	if(len(@RangoD) = 4)
	begin
		Set @RangoN1 = ' and a.NroCtaN1 >= left('''+@RangoD+''',2)'
		Set @RangoN2 = ' and a.NroCtaN2 >= '''+@RangoD+''''
		Set @RangoN3 = ' and left(a.NroCtaN3,4) >= '''+@RangoD+''''
		Set @RangoN4 = ' and left(a.NroCtaN4,4) >= '''+@RangoD+''''
		Set @RangoN  = ' and left(a.NroCta,4) >= '''+@RangoD+''''
	end
	if(len(@RangoD) = 6)
	begin
		Set @RangoN1 = ' and a.NroCtaN1 >= left('''+@RangoD+''',2)'
		Set @RangoN2 = ' and a.NroCtaN2 >= left('''+@RangoD+''',4)'
		Set @RangoN3 = ' and a.NroCtaN3 >= '''+@RangoD+''''
		Set @RangoN4 = ' and left(a.NroCtaN4,6) >= '''+@RangoD+''''
		Set @RangoN  = ' and left(a.NroCta,6) >= '''+@RangoD+''''
	end
	if(len(@RangoD) > 6)
	begin
		Set @RangoN1 = ' and a.NroCtaN1 >= left('''+@RangoD+''',2)'
		Set @RangoN2 = ' and a.NroCtaN2 >= left('''+@RangoD+''',4)'
		Set @RangoN3 = ' and a.NroCtaN3 >= left('''+@RangoD+''',6)'
		Set @RangoN4 = ' and a.NroCtaN4 >= '''+@RangoD+''''
		Set @RangoN  = ' and a.NroCta >= '''+@RangoD+''''
	end
end
else if(isnull(len(@RangoD),0) = 0 and isnull(len(@RangoH),0) <> 0)
begin
	if(len(@RangoH) = 2)
	begin
		Set @RangoN1 = ' and a.NroCtaN1 <= '''+@RangoH+''''
		Set @RangoN2 = ' and left(a.NroCtaN2,2) <= '''+@RangoH+''''
		Set @RangoN3 = ' and left(a.NroCtaN3,2) <= '''+@RangoH+''''
		Set @RangoN4 = ' and left(a.NroCtaN4,2) <= '''+@RangoH+''''
		Set @RangoN  = ' and left(a.NroCta,2) <= '''+@RangoH+''''
	end
	if(len(@RangoH) = 4)
	begin
		Set @RangoN1 = ' and a.NroCtaN1 <= left('''+@RangoH+''',2)'
		Set @RangoN2 = ' and a.NroCtaN2 <= '''+@RangoH+''''
		Set @RangoN3 = ' and left(a.NroCtaN3,4) <= '''+@RangoH+''''
		Set @RangoN4 = ' and left(a.NroCtaN4,4) <= '''+@RangoH+''''
		Set @RangoN  = ' and left(a.NroCta,4) <= '''+@RangoH+''''
	end
	if(len(@RangoH) = 6)
	begin
		Set @RangoN1 = ' and a.NroCtaN1 <= left('''+@RangoH+''',2)'
		Set @RangoN2 = ' and a.NroCtaN2 <= left('''+@RangoH+''',4)'
		Set @RangoN3 = ' and a.NroCtaN3 <= '''+@RangoH+''''
		Set @RangoN4 = ' and left(a.NroCtaN4,6) <= '''+@RangoH+''''
		Set @RangoN  = ' and left(a.NroCta,6) <= '''+@RangoH+''''
	end
	if(len(@RangoH) > 6)
	begin
		Set @RangoN1 = ' and a.NroCtaN1 <= left('''+@RangoH+''',2)'
		Set @RangoN2 = ' and a.NroCtaN2 <= left('''+@RangoH+''',4)'
		Set @RangoN3 = ' and a.NroCtaN3 <= left('''+@RangoH+''',6)'
		Set @RangoN4 = ' and a.NroCtaN4 <= '''+@RangoH+''''
		Set @RangoN  = ' and a.NroCta <= '''+@RangoH+''''
	end
end
else if(isnull(len(@RangoD),0) <> 0 and isnull(len(@RangoH),0) <> 0)
begin
	if(len(@RangoD) = 2)
	begin
		if(len(@RangoH) = 2)
		begin
			Set @RangoN1 = ' and a.NroCtaN1 >= '''+@RangoD+''' and a.NroCtaN1 <= '''+@RangoH+''''
			Set @RangoN2 = ' and left(a.NroCtaN2,2) >= '''+@RangoD+''' and left(a.NroCtaN2,2) <= '''+@RangoH+''''
			Set @RangoN3 = ' and left(a.NroCtaN3,2) >= '''+@RangoD+''' and left(a.NroCtaN3,2) <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(a.NroCtaN4,2) >= '''+@RangoD+''' and left(a.NroCtaN4,2) <= '''+@RangoH+''''
			Set @RangoN  = ' and left(a.NroCta,2) >= '''+@RangoD+''' and left(a.NroCta,2) <= '''+@RangoH+''''
		end
		if(len(@RangoH) = 4)
		begin
			Set @RangoN1 = ' and a.NroCtaN1 >= '''+@RangoD+''' and a.NroCtaN1 <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and left(a.NroCtaN2,2) >= '''+@RangoD+''' and a.NroCtaN2 <= '''+@RangoH+''''
			Set @RangoN3 = ' and left(a.NroCtaN3,2) >= '''+@RangoD+''' and left(a.NroCtaN3,4) <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(a.NroCtaN4,2) >= '''+@RangoD+''' and left(a.NroCtaN4,4) <= '''+@RangoH+''''
			Set @RangoN  = ' and left(a.NroCta,2) >= '''+@RangoD+''' and left(a.NroCta,4) <= '''+@RangoH+''''
		end
		if(len(@RangoH) = 6)
		begin
			Set @RangoN1 = ' and a.NroCtaN1 >= '''+@RangoD+''' and a.NroCtaN1 <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and left(a.NroCtaN2,2) >= '''+@RangoD+''' and a.NroCtaN2 <= left('''+@RangoH+''',4)'
			Set @RangoN3 = ' and left(a.NroCtaN3,2) >= '''+@RangoD+''' and a.NroCtaN3 <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(a.NroCtaN4,2) >= '''+@RangoD+''' and left(a.NroCtaN4,6) <= '''+@RangoH+''''
			Set @RangoN  = ' and left(a.NroCta,2) >= '''+@RangoD+''' and left(a.NroCta,6) <= '''+@RangoH+''''
		end
		if(len(@RangoH) > 6)
		begin
			Set @RangoN1 = ' and a.NroCtaN1 >= '''+@RangoD+''' and a.NroCtaN1 <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and left(a.NroCtaN2,2) >= '''+@RangoD+''' and a.NroCtaN2 <= left('''+@RangoH+''',4)'
			Set @RangoN3 = ' and left(a.NroCtaN3,2) >= '''+@RangoD+''' and a.NroCtaN3 <= left('''+@RangoH+''',6)'
			Set @RangoN4 = ' and left(a.NroCtaN4,2) >= '''+@RangoD+''' and a.NroCtaN4 <= '''+@RangoH+''''
			Set @RangoN  = ' and left(a.NroCta,2) >= '''+@RangoD+''' and a.NroCta <= '''+@RangoH+''''
		end
	end
	if(len(@RangoD) = 4)
	begin
		if(len(@RangoH) = 2)
		begin
			Set @RangoN1 = ' and a.NroCtaN1 >= left('''+@RangoD+''',2) and a.NroCtaN1 <= '''+@RangoH+''''
			Set @RangoN2 = ' and a.NroCtaN2 >= '''+@RangoD+''' and left(a.NroCtaN2,2) <= '''+@RangoH+''''
			Set @RangoN3 = ' and left(a.NroCtaN3,4) >= '''+@RangoD+''' and left(a.NroCtaN3,2) <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(a.NroCtaN4,4) >= '''+@RangoD+''' and left(a.NroCtaN4,2) <= '''+@RangoH+''''
			Set @RangoN  = ' and left(a.NroCta,4) >= '''+@RangoD+''' and left(a.NroCta,2) <= '''+@RangoH+''''
		end
		if(len(@RangoH) = 4)
		begin
			Set @RangoN1 = ' and a.NroCtaN1 >= left('''+@RangoD+''',2) and a.NroCtaN1 <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and a.NroCtaN2 >= '''+@RangoD+''' and a.NroCtaN2 <= '''+@RangoH+''''
			Set @RangoN3 = ' and left(a.NroCtaN3,4) >= '''+@RangoD+''' and left(a.NroCtaN3,4) <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(a.NroCtaN4,4) >= '''+@RangoD+''' and left(a.NroCtaN4,4) <= '''+@RangoH+''''
			Set @RangoN  = ' and left(a.NroCta,4) >= '''+@RangoD+''' and left(a.NroCta,4) <= '''+@RangoH+''''
		end
		if(len(@RangoH) = 6)
		begin
			Set @RangoN1 = ' and a.NroCtaN1 >= left('''+@RangoD+''',2) and a.NroCtaN1 <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and a.NroCtaN2 >= '''+@RangoD+''' and a.NroCtaN2 <= left('''+@RangoH+''',4)'
			Set @RangoN3 = ' and left(a.NroCtaN3,4) >= '''+@RangoD+''' and a.NroCtaN3 <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(a.NroCtaN4,4) >= '''+@RangoD+''' and left(a.NroCtaN4,6) <= '''+@RangoH+''''
			Set @RangoN  = ' and left(a.NroCta,4) >= '''+@RangoD+''' and left(a.NroCta,6) <= '''+@RangoH+''''
		end
		if(len(@RangoH) > 6)
		begin
			Set @RangoN1 = ' and a.NroCtaN1 >= left('''+@RangoD+''',2) and a.NroCtaN1 <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and a.NroCtaN2 >= '''+@RangoD+''' and a.NroCtaN2 <= left('''+@RangoH+''',4)'
			Set @RangoN3 = ' and left(a.NroCtaN3,4) >= '''+@RangoD+''' and a.NroCtaN3 <= left('''+@RangoH+''',6)'
			Set @RangoN4 = ' and left(a.NroCtaN4,4) >= '''+@RangoD+''' and a.NroCtaN4 <= '''+@RangoH+''''
			Set @RangoN  = ' and left(a.NroCta,4) >= '''+@RangoD+''' and a.NroCta <= '''+@RangoH+''''
		end
	end
	if(len(@RangoD) = 6)
	begin
		if(len(@RangoH) = 2)
		begin
			Set @RangoN1 = ' and a.NroCtaN1 >= left('''+@RangoD+''',2) and a.NroCtaN1 <= '''+@RangoH+''''
			Set @RangoN2 = ' and a.NroCtaN2 >= left('''+@RangoD+''',4) and left(a.NroCtaN2,2) <= '''+@RangoH+''''
			Set @RangoN3 = ' and a.NroCtaN3 >= '''+@RangoD+''' and left(a.NroCtaN3,2) <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(a.NroCtaN4,6) >= '''+@RangoD+''' and left(a.NroCtaN4,2) <= '''+@RangoH+''''
			Set @RangoN  = ' and left(a.NroCta,6) >= '''+@RangoD+''' and left(a.NroCta,2) <= '''+@RangoH+''''
		end
		if(len(@RangoH) = 4)
		begin
			Set @RangoN1 = ' and a.NroCtaN1 >= left('''+@RangoD+''',2) and a.NroCtaN1 <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and a.NroCtaN2 >= left('''+@RangoD+''',4) and a.NroCtaN2 <= '''+@RangoH+''''
			Set @RangoN3 = ' and a.NroCtaN3 >= '''+@RangoD+''' and left(a.NroCtaN3,4) <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(a.NroCtaN4,6) >= '''+@RangoD+''' and left(a.NroCtaN4,4) <= '''+@RangoH+''''
			Set @RangoN  = ' and left(a.NroCta,6) >= '''+@RangoD+''' and left(a.NroCta,4) <= '''+@RangoH+''''
		end
		if(len(@RangoH) = 6)
		begin
			Set @RangoN1 = ' and a.NroCtaN1 >= left('''+@RangoD+''',2) and a.NroCtaN1 <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and a.NroCtaN2 >= left('''+@RangoD+''',4) and a.NroCtaN2 <= left('''+@RangoH+''',4)'
			Set @RangoN3 = ' and a.NroCtaN3 >= '''+@RangoD+''' and a.NroCtaN3 <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(a.NroCtaN4,6) >= '''+@RangoD+''' and left(a.NroCtaN4,6) <= '''+@RangoH+''''
			Set @RangoN  = ' and left(a.NroCta,6) >= '''+@RangoD+''' and left(a.NroCta,6) <= '''+@RangoH+''''
		end
		if(len(@RangoH) > 6)
		begin
			Set @RangoN1 = ' and a.NroCtaN1 >= left('''+@RangoD+''',2) and a.NroCtaN1 <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and a.NroCtaN2 >= left('''+@RangoD+''',4) and a.NroCtaN2 <= left('''+@RangoH+''',4)'
			Set @RangoN3 = ' and a.NroCtaN3 >= '''+@RangoD+''' and a.NroCtaN3 <= left('''+@RangoH+''',6)'
			Set @RangoN4 = ' and left(a.NroCtaN4,6) >= '''+@RangoD+''' and a.NroCtaN4 <= '''+@RangoH+''''
			Set @RangoN  = ' and left(a.NroCta,6) >= '''+@RangoD+''' and a.NroCta <= '''+@RangoH+''''
		end
	end
	if(len(@RangoD) > 6)
	begin
		if(len(@RangoH) = 2)
		begin
			Set @RangoN1 = ' and a.NroCtaN1 >= left('''+@RangoD+''',2) and a.NroCtaN1 <= '''+@RangoH+''''
			Set @RangoN2 = ' and a.NroCtaN2 >= left('''+@RangoD+''',4) and left(a.NroCtaN2,2) <= '''+@RangoH+''''
			Set @RangoN3 = ' and a.NroCtaN3 >= left('''+@RangoD+''',6) and left(a.NroCtaN3,2) <= '''+@RangoH+''''
			Set @RangoN4 = ' and a.NroCtaN4 >= '''+@RangoD+''' and left(a.NroCtaN4,2) <= '''+@RangoH+''''
			Set @RangoN  = ' and a.NroCta >= '''+@RangoD+''' and left(a.NroCta,2) <= '''+@RangoH+''''
		end
		if(len(@RangoH) = 4)
		begin
			Set @RangoN1 = ' and a.NroCtaN1 >= left('''+@RangoD+''',2) and a.NroCtaN1 <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and a.NroCtaN2 >= left('''+@RangoD+''',4) and a.NroCtaN2 <= '''+@RangoH+''''
			Set @RangoN3 = ' and a.NroCtaN3 >= left('''+@RangoD+''',6) and left(a.NroCtaN3,4) <= '''+@RangoH+''''
			Set @RangoN4 = ' and a.NroCtaN4 >= '''+@RangoD+''' and left(a.NroCtaN4,4) <= '''+@RangoH+''''
			Set @RangoN  = ' and a.NroCta >= '''+@RangoD+''' and left(a.NroCta,4) <= '''+@RangoH+''''
		end
		if(len(@RangoH) = 6)
		begin
			Set @RangoN1 = ' and a.NroCtaN1 >= left('''+@RangoD+''',2) and a.NroCtaN1 <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and a.NroCtaN2 >= left('''+@RangoD+''',4) and a.NroCtaN2 <= left('''+@RangoH+''',4)'
			Set @RangoN3 = ' and a.NroCtaN3 >= left('''+@RangoD+''',6) and a.NroCtaN3 <= '''+@RangoH+''''
			Set @RangoN4 = ' and a.NroCtaN4 >= '''+@RangoD+''' and left(a.NroCtaN4,6) <= '''+@RangoH+''''
			Set @RangoN  = ' and a.NroCta >= '''+@RangoD+''' and left(a.NroCta,6) <= '''+@RangoH+''''
		end
		if(len(@RangoH) > 6)
		begin
			Set @RangoN1 = ' and a.NroCtaN1 >= left('''+@RangoD+''',2) and a.NroCtaN1 <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and a.NroCtaN2 >= left('''+@RangoD+''',4) and a.NroCtaN2 <= left('''+@RangoH+''',4)'
			Set @RangoN3 = ' and a.NroCtaN3 >= left('''+@RangoD+''',6) and a.NroCtaN3 <= left('''+@RangoH+''',6)'
			Set @RangoN4 = ' and a.NroCtaN4 >= '''+@RangoD+''' and a.NroCtaN4 <= '''+@RangoH+''''
			Set @RangoN  = ' and a.NroCta >= '''+@RangoD+''' and a.NroCta <= '''+@RangoH+''''
		end
	end
end
----------------------------------------------------

/*if(isnull(len(@RangoD),0) = 0 and isnull(len(@RangoH),0) = 0)
Begin
	set @RangoD = '0000000'
	set @RangoH = '9999999'
End*/

Declare @i int
Declare @Mes nvarchar(10)
Declare @Colum varchar(500), @ColumT varchar(500), @Suma varchar(500), @SumaT varchar(500)
Declare @Colum_ME varchar(500), @ColumT_ME varchar(500), @Suma_ME varchar(500), @SumaT_ME varchar(500)

Set @i = 0 Set @Mes = ''
Set @Colum = '' Set @ColumT = '' Set @Suma = '' Set @SumaT = ''
Set @Colum_ME = '' Set @ColumT_ME = '' Set @Suma_ME = '' Set @SumaT_ME = ''


while(@i <= @PrdoFin and @i < 10)
begin
	Set @Colum = @Colum + 'a.Saldo0'+convert(varchar,@i)+' as '+@Mes+','    --Moneda Nacional
	Set @Colum_ME = @Colum_ME + 'a.Saldo_ME0'+convert(varchar,@i)+' as '+@Mes+','	--Moneda Extranjera

	Set @Suma = @Suma + 'a.Saldo0'+convert(varchar,@i)+'+'	--Moneda Nacional
	Set @Suma_ME = @Suma_ME + 'a.Saldo_ME0'+convert(varchar,@i)+'+'	--Moneda Extranjera

	Set @ColumT = @ColumT + 'Sum(a.Saldo0'+convert(varchar,@i)+') as '+@Mes+','	--Moneda Nacional
	Set @ColumT_ME = @ColumT_ME + 'Sum(a.Saldo_ME0'+convert(varchar,@i)+') as '+@Mes+','	--Moneda Extranjera

	Set @i = @i + 1 	
end
while(@i <= @PrdoFin and @PrdoFin >= 10)
begin
	Set @Colum = @Colum + 'a.Saldo'+convert(varchar,@i)+' as '+@Mes+','
	Set @Colum_ME = @Colum_ME + 'a.Saldo_ME'+convert(varchar,@i)+' as '+@Mes+','	--Moneda Extranjera

	Set @Suma = @Suma + 'a.Saldo'+convert(varchar,@i)+'+'
	Set @Suma_ME = @Suma_ME + 'a.Saldo_ME'+convert(varchar,@i)+'+'	--Moneda Extranjera

	Set @ColumT = @ColumT + 'Sum(a.Saldo'+convert(varchar,@i)+') as '+@Mes+','
	Set @ColumT_ME = @ColumT_ME + 'Sum(a.Saldo_ME'+convert(varchar,@i)+') as '+@Mes+','	--Moneda Extranjera
	
	Set @i = @i + 1 
end
Set @Colum = left(@Colum,(len(@Colum)-1))
Set @Colum_ME = left(@Colum_ME,(len(@Colum_ME)-1))

Set @Suma = left(@Suma,(len(@Suma)-1))
Set @Suma_ME = left(@Suma_ME,(len(@Suma_ME)-1))

Set @ColumT = left(@ColumT,(len(@ColumT)-1))
Set @ColumT_ME = left(@ColumT_ME,(len(@ColumT_ME)-1))

Set @SumaT = 'Sum('+@Suma+')'
Set @SumaT_ME = 'Sum('+@Suma_ME+')'

print '-----RESULTADOS------'
print @Colum
print @Colum_ME

print @Suma
print @Suma_ME

print @ColumT
print @ColumT_ME

print @SumaT
print @SumaT_ME
print '---------------------'

DECLARE @SQL1 nvarchar(4000)
DECLARE @SQL2 nvarchar(4000)
DECLARE @SQL3 nvarchar(4000)
DECLARE @SQL4 nvarchar(4000)
DECLARE @SQL5_1 nvarchar(4000)
DECLARE @SQL5_2 nvarchar(4000)
SET @SQL1 = ''
SET @SQL2 = ''
SET @SQL3 = ''
SET @SQL4 = ''
SET @SQL5_1 = ''
SET @SQL5_2 = ''

--SALDOS**********************************************************************************************************************
--*********************************************************************************************************************************

Declare @a int
Declare @tn1 nvarchar(100), @tn2 nvarchar(100), @tn3 nvarchar(100), @tn4 nvarchar(100)
Declare @cn1_ME nvarchar(4000), @cn2_ME nvarchar(4000), @cn3_ME nvarchar(4000), @cn4_ME nvarchar(4000)
Declare @vouT nvarchar(500)
Declare @vouT_SD nvarchar(500)
Declare @Saldo nvarchar(100)
Declare @Having nvarchar(100)
Set @tn1 ='' Set @tn2 ='' Set @tn3 ='' Set @tn4 =''
Set @cn1_ME ='' Set @cn2_ME ='' Set @cn3_ME ='' Set @cn4_ME =''
Set @vouT = ''
Set @vouT_SD = ''
Set @Saldo = ''

Set @a = 0
Set @Having=''

if(@MdaReg='01' or @MdaReg='02')	-- SOLES o DOLARES
begin
	if(@Nivel1=1)Begin Set @a = @a + 1 Set @tn1=','''' as Total1' end else Set @tn1=''
	if(@Nivel2=1)Begin Set @a = @a + 1 Set @tn2=','''' as Total2' end else Set @tn2=''
	if(@Nivel3=1)Begin Set @a = @a + 1 Set @tn3=','''' as Total3' end else Set @tn3=''
	if(@Nivel4=1)Begin Set @a = @a + 1 Set @tn4=','''' as Total4' end else Set @tn4=''

	Set @vouT = 'Convert(varchar,sum(a.MtoD'+@Ex+'-a.MtoH'+@Ex+')) as Saldo'
	Set @Saldo = ''''' as Saldo'
	Set @Having= ' having sum(a.MtoD'+@Ex+'-a.MtoH'+@Ex+') <> 0'
end	
else	-- SOLES y DOLARES
begin
	if(@Nivel1=1)Begin Set @a = @a + 1 Set @tn1=','''' as Total1_MN,'''' as Total1_ME' 
		     Set @cn1_ME =',Case(left(Convert(nvarchar,('+@Suma_ME+')),1)) when ''-'' then ''(''+Convert(nvarchar,(('+@Suma_ME+')*-1))+'')'' else Case(('+@Suma_ME+')) when ''0'' then '''' else Convert(nvarchar,('+@Suma_ME+')) end end as Total1_ME'
		     end else begin Set @tn1='' Set @cn1_ME ='' end
	if(@Nivel2=1)Begin Set @a = @a + 1 Set @tn2=','''' as Total2_MN,'''' as Total2_ME' 
		     Set @cn2_ME =',Case(left(Convert(nvarchar,('+@Suma_ME+')),1)) when ''-'' then ''(''+Convert(nvarchar,(('+@Suma_ME+')*-1))+'')'' else Case(('+@Suma_ME+')) when ''0'' then '''' else Convert(nvarchar,('+@Suma_ME+')) end end as Total2_ME'
		     end else begin Set @tn2='' Set @cn2_ME = '' end
	if(@Nivel3=1)Begin Set @a = @a + 1 Set @tn3=','''' as Total3_MN,'''' as Total3_ME' 
		     Set @cn3_ME =',Case(left(Convert(nvarchar,('+@Suma_ME+')),1)) when ''-'' then ''(''+Convert(nvarchar,(('+@Suma_ME+')*-1))+'')'' else Case(('+@Suma_ME+')) when ''0'' then '''' else Convert(nvarchar,('+@Suma_ME+')) end end as Total3_ME'
		     end else begin Set @tn3='' Set @cn3_ME ='' end
	if(@Nivel4=1)Begin Set @a = @a + 1 Set @tn4=','''' as Total4_MN,'''' as Total4_ME' 
		     Set @cn4_ME =',Case(left(Convert(nvarchar,('+@Suma_ME+')),1)) when ''-'' then ''(''+Convert(nvarchar,(('+@Suma_ME+')*-1))+'')'' else Case(('+@Suma_ME+')) when ''0'' then '''' else Convert(nvarchar,('+@Suma_ME+')) end end as Total4_ME'
		     end else begin Set @tn4='' Set @cn4_ME ='' end

	Set @vouT_SD = '
		       Convert(varchar,sum(a.MtoD-a.MtoH)) as Saldo_MN,
		       Convert(varchar,sum(a.MtoD_ME-a.MtoH_ME)) as Saldo_ME
		       '
	Set @Saldo = ''''' as Saldo_MN,'''' as Saldo_ME'
	Set @Having= ' having sum(a.MtoD-a.MtoH) + sum(a.MtoD_ME-a.MtoH_ME)<> 0'
end
if(@a = 0) 
Begin
	Set @a = 4
	Set @Nivel1 = 1
	Set @Nivel2 = 1
	Set @Nivel3 = 1
	Set @Nivel4 = 1
End

print @tn1
print @tn2
print @tn3
print @tn4

if(@Nivel1 = 1)
begin
	Set @SQL1 = 
		'
		(Select 1 as Num,a.RucE,a.Ejer,a.NroCtaN1 as NroCta ,b.NomCta,'''' as Cd_Aux,'''' As Cd_TDI,'''' As NDocAux ,'''' as NomAux,'''' as Cd_TD,'''' as NroSre,'''' as NroDoc,'+@Saldo+'
			'+@tn4+@tn3+@tn2+',
		        Case(left(Convert(nvarchar,('+@Suma+')),1)) when ''-'' then ''(''+Convert(nvarchar,(('+@Suma+')*-1))+'')'' else Case(('+@Suma+')) when ''0'' then '''' else Convert(nvarchar,('+@Suma+')) end end as Total1'+@Mn+'
			'+@cn1_ME+'
		from SaldosXPrdoN1'+@Mda+' a, PlanCtas b 
		where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+''' and a.RucE=b.RucE and a.Ejer=b.Ejer and a.NroCtaN1=b.NroCta'+@RangoN1+')'
end
if(@Nivel2 = 1)
begin
	if(@Nivel1 = 1) Set @SQL2 = @SQL2 + 'UNION ALL '
	Set @SQL2 = @SQL2 +
		   '
		   (Select 2 as Num,a.RucE,a.Ejer,a.NroCtaN2 as NroCta,b.NomCta,'''' as Cd_Aux,'''' As Cd_TDI,'''' As NDocAux,'''' as NomAux,'''' as Cd_TD,'''' as NroSre,'''' as NroDoc,'+@Saldo+'
			 '+@tn4+@tn3+',
		  	 Case(left(Convert(nvarchar,('+@Suma+')),1)) when ''-'' then ''(''+Convert(nvarchar,(('+@Suma+')*-1))+'')'' else Case(('+@Suma+')) when ''0'' then '''' else Convert(nvarchar,('+@Suma+')) end end as Total2'+@Mn+'
			 '+@cn2_ME+' 
			 '+@tn1+'
		    from SaldosXPrdoN2'+@Mda+' a, PlanCtas b 
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+''' and a.RucE=b.RucE and a.Ejer=b.Ejer and a.NroCtaN2=b.NroCta'+@RangoN2+')'

end
if(@Nivel3 = 1)
begin
	if(@Nivel1 = 1 or @Nivel2 = 1) Set @SQL3 = @SQL3 + 'UNION ALL '
	Set @SQL3 = @SQL3 +
		   '
		   (Select 3 as Num,a.RucE,a.Ejer,a.NroCtaN3 as NroCta,b.NomCta,'''' as Cd_Aux,'''' As Cd_TDI,'''' As NDocAux,'''' as NomAux,'''' as Cd_TD,'''' as NroSre,'''' as NroDoc,'+@Saldo+'
			 '+@tn4+',
			 Case(left(Convert(nvarchar,('+@Suma+')),1)) when ''-'' then ''(''+Convert(nvarchar,(('+@Suma+')*-1))+'')'' else Case(('+@Suma+')) when ''0'' then '''' else Convert(nvarchar,('+@Suma+')) end end as Total3'+@Mn+'
			 '+@cn3_ME+'
			 '+@tn2+@tn1+'
		    from SaldosXPrdoN3'+@Mda+' a, PlanCtas b 
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+''' and a.RucE=b.RucE and a.Ejer=b.Ejer and a.NroCtaN3=b.NroCta'+@RangoN3+')'

end
if(@Nivel4 = 1)
begin
	if(@Nivel1 = 1 or @Nivel2 = 1 or @Nivel3 = 1) Set @SQL4 = @SQL4 + 'UNION ALL '
	Set @SQL4 = @SQL4 + 
		    '
		    (select 4 as Num,a.RucE,a.Ejer,a.NroCtaN4 as NroCta,b.NomCta,'''' as Cd_Aux,'''' As Cd_TDI,'''' As NDocAux,'''' as NomAux,'''' as Cd_TD,'''' as NroSre,'''' as NroDoc,'+@Saldo+'
			 ,Case(left(Convert(nvarchar,('+@Suma+')),1)) when ''-'' then ''(''+Convert(nvarchar,(('+@Suma+')*-1))+'')'' else Case(('+@Suma+')) when ''0'' then '''' else Convert(nvarchar,('+@Suma+')) end end as Total4'+@Mn+'
			 '+@cn4_ME+'
			 '+@tn3+@tn2+@tn1+'
	            from SaldosXPrdoN4'+@Mda+' a, PlanCtas b 
		    Where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+''' and a.RucE=b.RucE and a.Ejer=b.Ejer /*and b.IB_Aux<>0 */and a.NroCtaN4=b.NroCta'+@RangoN4+' and ('+@Suma+')<>0)
		    '
	Set @SQL5_1 =
		    '
		    UNION ALL
		    (Select 5 as Num,
			 a.RucE,
			 a.Ejer,
			 a.NroCta as NroCta,
			 b.NomCta,
			 case(isnull(len(a.Cd_Clt),0)) when 0 then p.Cd_Prv else c.Cd_Clt end as Cd_Aux,
			 case(isnull(len(a.Cd_Clt),0)) when 0 then p.Cd_TDI else c.Cd_TDI end As Cd_TDI,
			 case(isnull(len(a.Cd_Clt),0)) when 0 then p.NDoc else c.NDoc end As NDocAux,
			 case(isnull(len(a.Cd_Clt),0)) when 0 then case(isnull(len(p.RSocial),0)) 
                	 when 0 then isnull(nullif(p.ApPat +'' ''+p.ApMat+'', ''+p.Nom,''''),''------- SIN NOMBRE ------'')
                	 else p.RSocial  end  else case(isnull(len(c.RSocial),0)) 
               		 when 0 then isnull(nullif(c.ApPat +'' ''+c.ApMat+'', ''+c.Nom,''''),''------- SIN NOMBRE ------'')
                	 else c.RSocial end end as NomAux,
			 isnull(a.Cd_TD,'''') as Cd_TD,
			 --case(isnull(len(a.Cd_Clt),0)) when 0 then p.Cd_TDI else c.Cd_TDI end as Cd_TD,
			 isnull(a.NroSre,'''') as NroSre,
			 isnull(a.NroDoc,'''') as NroDoc,
			 --case(isnull(len(a.Cd_Clt),0)) when 0 then P.NDoc else  a.NroDoc end as NroDoc,
			'+@vouT+'
			'+@vouT_SD+'
		    '
	Set @SQL5_2 =
		    '
		    '+@tn4+@tn3+@tn2+@tn1+'
		    from voucher a inner join PlanCtas b On b.RucE=a.RucE and a.Ejer=b.Ejer and b.NroCta=a.NroCta and a.Ejer=b.Ejer
			left join proveedor2 p on p.RucE=a.RucE and p.Cd_Prv=a.Cd_Prv
			left join Cliente2 c on c.RucE=a.RucE and a.Cd_Clt=c.Cd_Clt
		    where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+''' /*and b.IB_Aux<>0 */ and a.IB_Anulado=0 and a.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+@RangoN+'
		    group by a.RucE,a.Ejer,a.NroCta,b.NomCta,p.Cd_TDI,a.Cd_Clt,c.Cd_TDI,
			isnull(c.NDoc,''''),isnull(p.NDoc,''''),c.RSocial,c.ApPat,c.ApMat,c.Nom,p.RSocial,p.ApPat,p.ApMat,p.Nom,
			isnull(a.Cd_TD,''''),isnull(a.NroSre,''''),p.NDoc,c.NDoc,p.Cd_Prv,c.Cd_Clt,
			isnull(a.NroDoc,'''') '+@Having+')
		    '
/*Set @SQL5_1 = '
		    UNION ALL
		    (Select 5 as Num,
			a.RucE,
			a.Ejer,
			a.NroCta as NroCta,
			b.NomCta,
			isnull(u.NDoc,'''')  as Cd_Aux,
			case(isnull(len(u.RSocial),0)) when ''0'' then isnull(u.ApPat,'''')+'' ''+isnull(u.ApMat,'''')+'' ''+isnull(u.Nom,'''') else isnull(u.RSocial,'''') end as NomAux,
			isnull(a.Cd_TD,'''') as Cd_TD, 
			isnull(a.NroSre,'''') as NroSre,
			isnull(a.NroDoc,'''') as NroDoc,
			'+@vouT+'
			'+@vouT_SD+'
		    '
	Set @SQL5_2 =
		    '
		    '+@tn4+@tn3+@tn2+@tn1+'
		    from Voucher a
			   inner join PlanCtas b On b.RucE=a.RucE and b.NroCta=a.NroCta and b.Ejer=@Ejer
			   left join Auxiliar u On u.RucE=a.RucE and u.Cd_Aux=a.Cd_Aux
		    where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+''' and b.IB_Aux<>0 and a.IB_Anulado=0 and a.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+@RangoN+'
		    group by a.RucE,a.Ejer,a.NroCta,b.NomCta,isnull(u.NDoc,''''),
			 u.RSocial,u.ApPat,u.ApMat,u.Nom,
			 isnull(a.Cd_TD,''''),isnull(a.NroSre,''''),isnull(a.NroDoc,'''') '+@Having+')
		    '*/
end

/*
		   (Select 5 as Num,a.RucE,a.Ejer,a.NroCtaN4 as NroCta,b.NomCta,isnull(u.NDoc,'''')  as Cd_Aux,case(isnull(len(u.RSocial),0)) when ''0'' then isnull(u.ApPat,'''')+'' ''+isnull(u.ApMat,'''')+'' ''+isnull(u.Nom,'''') else isnull(u.RSocial,'''') end as NomAux,isnull(v.Cd_TD,'''') as Cd_TD, isnull(v.NroSre,'''') as NroSre,isnull(v.NroDoc,'''') as NroDoc,Convert(varchar,sum(v.MtoD'+@Ex+'-v.MtoH'+@Ex+')) as Saldo
			'+@tn4+@tn3+@tn2+@tn1+'
		    from SaldosXPrdoN4'+@Mda+' a
			   inner join PlanCtas b On a.RucE=b.RucE and a.NroCtaN4=b.NroCta
			   left join Voucher v On a.RucE=v.RucE and a.Ejer=v.Ejer and a.NroCtaN4=v.NroCta
			   left join Auxiliar u On v.RucE=u.RucE and v.Cd_Aux=u.Cd_Aux
		    where a.RucE='''+@RucE+''' and a.Ejer='''+@Eje+''' and b.IB_Aux<>0
		    group by a.RucE,a.Ejer,a.NroCtaN4,b.NomCta,u.NDoc,u.RSocial,u.ApPat,u.ApMat,u.Nom,v.Cd_TD, v.NroSre, v.NroDoc,a.Total Having sum(v.MtoD-v.MtoH)<>0)
*/
--exec Ctb_Inventario_BalanceCons1 '11111111111','2010','00','14',0,0,0,1,'01','01/01/2010','31/12/2010',null
print @SQL1 + @SQL2 + @SQL3 + @SQL4
print @SQL5_1+ @SQL5_2
      --' Order by 4,1,6'

EXEC (@SQL1+@SQL2+@SQL3+@SQL4+@SQL5_1+@SQL5_2+
      ' Order by 4,1,6')

----------------------PRUEBA------------------------
--exec Ctb_Inventario_BalanceCons '11111111111','2010','00','14',0,0,0,1,'01',null,null,null

------CODIGO DE MODIFICACION--------
--CM=RE01

----------------------LEYENDA----------------------
-- DI 09/10/2009 : Se agregaron columas si el usuario selecciona ambas monedas debe mostrar las 2
-- DI 22/10/2009 : Se modifico la cadena del Rando de Cuenta
-- JJ 16/09/2010 : Se modifico las Cadenas sql5_1,sql5_2
-- FL: 17/09/2010 <se agrego ejercicio>
-- DI: 20/03/2011 <Se agrego los ejercicios en el plan de cuentas>
-- DI: 25/07/2011 <Se agrego Cd_TDI y NDocAux.>

GO

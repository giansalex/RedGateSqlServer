SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_MovimientosCons]

@RucE nvarchar(11),	--Ruc de la empresa
@Ejer nvarchar(4),	--Ejercicio de la empresa
@RPrdo1 nvarchar(4),	--Rango inicial del periodo
@RPrdo2 nvarchar(4),	--Rango final del periodo
@RangoD nvarchar(4),	--cuenta inicial de consulta
@RangoH nvarchar(4),	--cuenta final de consulta
@Cd_Mda nvarchar(2),	--codigo de moneda
@CCD nvarchar(8),	--Codigo centro de costos desde
@CCH nvarchar(8),	--codigo centro de costos hasta
@SCD nvarchar(8),	--codigo sub centro de costos desde
@SCH nvarchar(8),	--codigo sub centro de costos hasta
@SSD nvarchar(8),	--codigo sub sub centro de costos desde
@SSH nvarchar(8),	--codigo sub sub centro de costos hasta
@N1 bit,		--nivel1
@N2 bit,		--nivel2
@N3 bit,		--nivel3
@N4 bit,		--nivel4
@msj varchar(100) output

as
/*
Set @RucE = '11111111111'
Set @Ejer = '2009'
Set @RPrdo1 = '02'
Set @RPrdo2 = '06'
Set @RangoD = ''
Set @RangoH = ''
Set @Cd_Mda = '01'
Set @CCD = ''
Set @CCH = ''
Set @SCD = ''
Set @SCH = ''
Set @SSD = ''
Set @SSH = ''
Set @N1 = '1'
Set @N2 = '0'
Set @N3 = '0'
Set @N4 = '1'
*/

Declare @SDebeAc nvarchar(200)
Declare @SHaberAc nvarchar(200)
Declare @SDebeAn nvarchar(200)
Declare @SHaberAn nvarchar(200)
Set @SDebeAc = '0.00' Set @SHaberAc = '0.00'
Set @SDebeAn = '0.00' Set @SHaberAn = '0.00'

Declare @TituloAc nvarchar(30)
Declare @TituloAn nvarchar(30)
Declare @TitAcumu nvarchar(30)
Set @TituloAc = '' Set @TituloAn = '''Saldo_Ant Null-Null''' Set @TitAcumu = '''Saldo_Acu 00-'+@RPrdo2+''''

Declare @TitDebeAc nvarchar(30)
Declare @TitHaberAc nvarchar(30)
Set @TitDebeAc = '' Set @TitHaberAc = ''

Declare @i int
Declare @j int
Set @i = convert(int,@RPrdo1)
Set @j = 0

Declare @Mda nvarchar(2)
Declare @TMda nvarchar(2)
Set @Mda = '' Set @TMda = ''

Declare @RangoN1 nvarchar(150)
Declare @RangoN2 nvarchar(150)
Declare @RangoN3 nvarchar(150)
Declare @RangoN4 nvarchar(150)
Set @RangoN1 = '' Set @RangoN2 = '' Set @RangoN3 = '' Set @RangoN4 = ''

Declare @CadenaCC nvarchar(100)
Declare @CadenaSC nvarchar(100)
Declare @CadenaSS nvarchar(100)
Set @CadenaCC = '' Set @CadenaSC = '' Set @CadenaSS = ''


-- Cadena Centro de costos
if(isnull(len(@CCD),0) <> 0 and isnull(len(@SCD),0) = 0 and isnull(len(@SSD),0) = 0)
begin
	Set @CadenaCC = ' and s.Cd_CC >= '''+@CCD+''' and s.Cd_CC <= '''+@CCH+''''
	Set @CadenaSC = '' 
	Set @CadenaSS = ''
end
if(isnull(len(@CCD),0) <> 0 and isnull(len(@SCD),0) <> 0 and isnull(len(@SSD),0) = 0)
begin
	Set @CadenaCC = ' and s.Cd_CC >= '''+@CCD+''' and s.Cd_CC <= '''+@CCH+''''
	Set @CadenaSC = ' and s.Cd_SC >= '''+@SCD+''' and s.Cd_SC <= '''+@SCH+'''' 
	Set @CadenaSS = ''
end
if(isnull(len(@CCD),0) <> 0 and isnull(len(@SCD),0) <> 0 and isnull(len(@SSD),0) <> 0)
begin
	Set @CadenaCC = ' and s.Cd_CC >= '''+@CCD+''' and s.Cd_CC <= '''+@CCH+''''
	Set @CadenaSC = ' and s.Cd_SC >= '''+@SCD+''' and s.Cd_SC <= '''+@SCH+'''' 
	Set @CadenaSS = ' and s.Cd_SS >= '''+@SSD+''' and s.Cd_SS <= '''+@SSH+''''
end

-- Cadena Rango de cuentas
if(isnull(len(@RangoD),0) <> 0 and isnull(len(@RangoH),0) = 0)
begin
	if(len(@RangoD) = 2)
	begin
		Set @RangoN1 = ' and s.NroCta >= '''+@RangoD+''''
		Set @RangoN2 = ' and left(s.NroCta,2) >= '''+@RangoD+''''
		Set @RangoN3 = ' and left(s.NroCta,2) >= '''+@RangoD+''''
		Set @RangoN4 = ' and left(s.NroCta,2) >= '''+@RangoD+''''
	end
	if(len(@RangoD) = 4)
	begin
		Set @RangoN1 = ' and s.NroCta >= left('''+@RangoD+''',2)'
		Set @RangoN2 = ' and s.NroCta >= '''+@RangoD+''''
		Set @RangoN3 = ' and left(s.NroCta,4) >= '''+@RangoD+''''
		Set @RangoN4 = ' and left(s.NroCta,4) >= '''+@RangoD+''''
	end
	if(len(@RangoD) = 6)
	begin
		Set @RangoN1 = ' and s.NroCta >= left('''+@RangoD+''',2)'
		Set @RangoN2 = ' and s.NroCta >= left('''+@RangoD+''',4)'
		Set @RangoN3 = ' and s.NroCta >= '''+@RangoD+''''
		Set @RangoN4 = ' and left(s.NroCta,6) >= '''+@RangoD+''''
	end
	if(len(@RangoD) > 6)
	begin
		Set @RangoN1 = ' and s.NroCta >= left('''+@RangoD+''',2)'
		Set @RangoN2 = ' and s.NroCta >= left('''+@RangoD+''',4)'
		Set @RangoN3 = ' and s.NroCta >= left('''+@RangoD+''',6)'
		Set @RangoN4 = ' and s.NroCta >= '''+@RangoD+''''
	end
end
else if(isnull(len(@RangoD),0) = 0 and isnull(len(@RangoH),0) <> 0)
begin
	if(len(@RangoH) = 2)
	begin
		Set @RangoN1 = ' and s.NroCta <= '''+@RangoH+''''
		Set @RangoN2 = ' and left(s.NroCta,2) <= '''+@RangoH+''''
		Set @RangoN3 = ' and left(s.NroCta,2) <= '''+@RangoH+''''
		Set @RangoN4 = ' and left(s.NroCta,2) <= '''+@RangoH+''''
	end
	if(len(@RangoH) = 4)
	begin
		Set @RangoN1 = ' and s.NroCta <= left('''+@RangoH+''',2)'
		Set @RangoN2 = ' and s.NroCta <= '''+@RangoH+''''
		Set @RangoN3 = ' and left(s.NroCta,4) <= '''+@RangoH+''''
		Set @RangoN4 = ' and left(s.NroCta,4) <= '''+@RangoH+''''
	end
	if(len(@RangoH) = 6)
	begin
		Set @RangoN1 = ' and s.NroCta <= left('''+@RangoH+''',2)'
		Set @RangoN2 = ' and s.NroCta <= left('''+@RangoH+''',4)'
		Set @RangoN3 = ' and s.NroCta <= '''+@RangoH+''''
		Set @RangoN4 = ' and left(s.NroCta,6) <= '''+@RangoH+''''
	end
	if(len(@RangoH) > 6)
	begin
		Set @RangoN1 = ' and s.NroCta <= left('''+@RangoH+''',2)'
		Set @RangoN2 = ' and s.NroCta <= left('''+@RangoH+''',4)'
		Set @RangoN3 = ' and s.NroCta <= left('''+@RangoH+''',6)'
		Set @RangoN4 = ' and s.NroCta <= '''+@RangoH+''''
	end
end
else if(isnull(len(@RangoD),0) <> 0 and isnull(len(@RangoH),0) <> 0)
begin
	if(len(@RangoD) = 2)
	begin
		if(len(@RangoH) = 2)
		begin
			Set @RangoN1 = ' and s.NroCta >= '''+@RangoD+''' and s.NroCta <= '''+@RangoH+''''
			Set @RangoN2 = ' and left(s.NroCta,2) >= '''+@RangoD+''' and left(s.NroCta,2) <= '''+@RangoH+''''
			Set @RangoN3 = ' and left(s.NroCta,2) >= '''+@RangoD+''' and left(s.NroCta,2) <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(s.NroCta,2) >= '''+@RangoD+''' and left(s.NroCta,2) <= '''+@RangoH+''''
		end
		if(len(@RangoH) = 4)
		begin
			Set @RangoN1 = ' and s.NroCta >= '''+@RangoD+''' and s.NroCta <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and left(s.NroCta,2) >= '''+@RangoD+''' and s.NroCta <= '''+@RangoH+''''
			Set @RangoN3 = ' and left(s.NroCta,2) >= '''+@RangoD+''' and left(s.NroCta,4) <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(s.NroCta,2) >= '''+@RangoD+''' and left(s.NroCta,4) <= '''+@RangoH+''''
		end
		if(len(@RangoH) = 6)
		begin
			Set @RangoN1 = ' and s.NroCta >= '''+@RangoD+''' and s.NroCta <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and left(s.NroCta,2) >= '''+@RangoD+''' and s.NroCta <= left('''+@RangoH+''',4)'
			Set @RangoN3 = ' and left(s.NroCta,2) >= '''+@RangoD+''' and s.NroCta <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(s.NroCta,2) >= '''+@RangoD+''' and left(s.NroCta,6) <= '''+@RangoH+''''
		end
		if(len(@RangoH) > 6)
		begin
			Set @RangoN1 = ' and s.NroCta >= '''+@RangoD+''' and s.NroCta <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and left(s.NroCta,2) >= '''+@RangoD+''' and s.NroCta <= left('''+@RangoH+''',4)'
			Set @RangoN3 = ' and left(s.NroCta,2) >= '''+@RangoD+''' and s.NroCta <= left('''+@RangoH+''',6)'
			Set @RangoN4 = ' and left(s.NroCta,2) >= '''+@RangoD+''' and s.NroCta <= '''+@RangoH+''''
		end
	end
	if(len(@RangoD) = 4)
	begin
		if(len(@RangoH) = 2)
		begin
			Set @RangoN1 = ' and s.NroCta >= left('''+@RangoD+''',2) and s.NroCta <= '''+@RangoH+''''
			Set @RangoN2 = ' and s.NroCta >= '''+@RangoD+''' and left(s.NroCta,2) <= '''+@RangoH+''''
			Set @RangoN3 = ' and left(s.NroCta,4) >= '''+@RangoD+''' and left(s.NroCta,2) <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(s.NroCta,4) >= '''+@RangoD+''' and left(s.NroCta,2) <= '''+@RangoH+''''
		end
		if(len(@RangoH) = 4)
		begin
			Set @RangoN1 = ' and s.NroCta >= left('''+@RangoD+''',2) and s.NroCta <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and s.NroCta >= '''+@RangoD+''' and s.NroCta <= '''+@RangoH+''''
			Set @RangoN3 = ' and left(s.NroCta,4) >= '''+@RangoD+''' and left(s.NroCta,4) <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(s.NroCta,4) >= '''+@RangoD+''' and left(s.NroCta,4) <= '''+@RangoH+''''
		end
		if(len(@RangoH) = 6)
		begin
			Set @RangoN1 = ' and s.NroCta >= left('''+@RangoD+''',2) and s.NroCta <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and s.NroCta >= '''+@RangoD+''' and s.NroCta <= left('''+@RangoH+''',4)'
			Set @RangoN3 = ' and left(s.NroCta,4) >= '''+@RangoD+''' and s.NroCta <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(s.NroCta,4) >= '''+@RangoD+''' and left(s.NroCta,6) <= '''+@RangoH+''''
		end
		if(len(@RangoH) > 6)
		begin
			Set @RangoN1 = ' and s.NroCta >= left('''+@RangoD+''',2) and s.NroCta <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and s.NroCta >= '''+@RangoD+''' and s.NroCta <= left('''+@RangoH+''',4)'
			Set @RangoN3 = ' and left(s.NroCta,4) >= '''+@RangoD+''' and s.NroCta <= left('''+@RangoH+''',6)'
			Set @RangoN4 = ' and left(s.NroCta,4) >= '''+@RangoD+''' and s.NroCta <= '''+@RangoH+''''
		end
	end
	if(len(@RangoD) = 6)
	begin
		if(len(@RangoH) = 2)
		begin
			Set @RangoN1 = ' and s.NroCta >= left('''+@RangoD+''',2) and s.NroCta <= '''+@RangoH+''''
			Set @RangoN2 = ' and s.NroCta >= left('''+@RangoD+''',4) and left(s.NroCta,2) <= '''+@RangoH+''''
			Set @RangoN3 = ' and s.NroCta >= '''+@RangoD+''' and left(s.NroCta,2) <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(s.NroCta,6) >= '''+@RangoD+''' and left(s.NroCta,2) <= '''+@RangoH+''''
		end
		if(len(@RangoH) = 4)
		begin
			Set @RangoN1 = ' and s.NroCta >= left('''+@RangoD+''',2) and s.NroCta <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and s.NroCta >= left('''+@RangoD+''',4) and s.NroCta <= '''+@RangoH+''''
			Set @RangoN3 = ' and s.NroCta >= '''+@RangoD+''' and left(s.NroCta,4) <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(s.NroCta,6) >= '''+@RangoD+''' and left(s.NroCta,4) <= '''+@RangoH+''''
		end
		if(len(@RangoH) = 6)
		begin
			Set @RangoN1 = ' and s.NroCta >= left('''+@RangoD+''',2) and s.NroCta <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and s.NroCta >= left('''+@RangoD+''',4) and s.NroCta <= left('''+@RangoH+''',4)'
			Set @RangoN3 = ' and s.NroCta >= '''+@RangoD+''' and s.NroCta <= '''+@RangoH+''''
			Set @RangoN4 = ' and left(s.NroCta,6) >= '''+@RangoD+''' and left(s.NroCta,6) <= '''+@RangoH+''''
		end
		if(len(@RangoH) > 6)
		begin
			Set @RangoN1 = ' and s.NroCta >= left('''+@RangoD+''',2) and s.NroCta <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and s.NroCta >= left('''+@RangoD+''',4) and s.NroCta <= left('''+@RangoH+''',4)'
			Set @RangoN3 = ' and s.NroCta >= '''+@RangoD+''' and s.NroCta <= left('''+@RangoH+''',6)'
			Set @RangoN4 = ' and left(s.NroCta,6) >= '''+@RangoD+''' and s.NroCta <= '''+@RangoH+''''
		end
	end
	if(len(@RangoD) > 6)
	begin
		if(len(@RangoH) = 2)
		begin
			Set @RangoN1 = ' and s.NroCta >= left('''+@RangoD+''',2) and s.NroCta <= '''+@RangoH+''''
			Set @RangoN2 = ' and s.NroCta >= left('''+@RangoD+''',4) and left(s.NroCta,2) <= '''+@RangoH+''''
			Set @RangoN3 = ' and s.NroCta >= left('''+@RangoD+''',6) and left(s.NroCta,2) <= '''+@RangoH+''''
			Set @RangoN4 = ' and s.NroCta >= '''+@RangoD+''' and left(s.NroCta,2) <= '''+@RangoH+''''
		end
		if(len(@RangoH) = 4)
		begin
			Set @RangoN1 = ' and s.NroCta >= left('''+@RangoD+''',2) and s.NroCta <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and s.NroCta >= left('''+@RangoD+''',4) and s.NroCta <= '''+@RangoH+''''
			Set @RangoN3 = ' and s.NroCta >= left('''+@RangoD+''',6) and left(s.NroCta,4) <= '''+@RangoH+''''
			Set @RangoN4 = ' and s.NroCta >= '''+@RangoD+''' and left(s.NroCta,4) <= '''+@RangoH+''''
		end
		if(len(@RangoH) = 6)
		begin
			Set @RangoN1 = ' and s.NroCta >= left('''+@RangoD+''',2) and s.NroCta <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and s.NroCta >= left('''+@RangoD+''',4) and s.NroCta <= left('''+@RangoH+''',4)'
			Set @RangoN3 = ' and s.NroCta >= left('''+@RangoD+''',6) and s.NroCta <= '''+@RangoH+''''
			Set @RangoN4 = ' and s.NroCta >= '''+@RangoD+''' and left(s.NroCta,6) <= '''+@RangoH+''''
		end
		if(len(@RangoH) > 6)
		begin
			Set @RangoN1 = ' and s.NroCta >= left('''+@RangoD+''',2) and s.NroCta <= left('''+@RangoH+''',2)'
			Set @RangoN2 = ' and s.NroCta >= left('''+@RangoD+''',4) and s.NroCta <= left('''+@RangoH+''',4)'
			Set @RangoN3 = ' and s.NroCta >= left('''+@RangoD+''',6) and s.NroCta <= left('''+@RangoH+''',6)'
			Set @RangoN4 = ' and s.NroCta >= '''+@RangoD+''' and s.NroCta <= '''+@RangoH+''''
		end
	end
end

if(@Cd_Mda = '02')
begin
	Set @Mda = 'ME' Set @TMda = 'D'
end

-- Cadena del rango del periodo actual --
while(@i <= convert(int,@RPrdo2))
begin
	if(@i = convert(int,@Rprdo1))begin Set @SDebeAc = '' Set @SHaberAc = '' end

	if(@i < 10)
	begin
		Set @SDebeAc = @SDebeAc + 's.D'+@Mda+'0'+Convert(varchar,@i)+'+'
		Set @SHaberAc = @SHaberAc + 's.H'+@Mda+'0'+Convert(varchar,@i)+'+'
	end
	else
	begin
		Set @SDebeAc = @SDebeAc + 's.D'+@Mda+Convert(varchar,@i)+'+'
		Set @SHaberAc = @SHaberAc + 's.H'+@Mda+Convert(varchar,@i)+'+'
	end

	Set @TituloAc = '''Saldo_Act '+@RPrdo1+'-'+@RPrdo2+''''
	Set @TitDebeAc = '''Debe_Act '+@RPrdo1+'-'+@RPrdo2+''''
	Set @TitHaberAc = '''Haber_Act '+@RPrdo1+'-'+@RPrdo2+''''

	Set @i = @i + 1
end

-- Cadena del rango del periodo anterior --
while(@j < convert(int,@RPrdo1))
begin
	if(@j = 0)begin Set @SDebeAn = '' Set @SHaberAn = '' end

	if(@j < 10)
	begin
		Set @SDebeAn = @SDebeAn + 's.D'+@Mda+'0'+Convert(varchar,@j)+'+'
		Set @SHaberAn = @SHaberAn + 's.H'+@Mda+'0'+Convert(varchar,@j)+'+'
		
		Set @TituloAn = '''Saldo_Ant 00-0'+Convert(varchar,@j)+''''
	end
	else
	begin
		Set @SDebeAn = @SDebeAn + 's.D'+@Mda+Convert(varchar,@j)+'+'
		Set @SHaberAn = @SHaberAn + 's.H'+@Mda+Convert(varchar,@j)+'+'

		Set @TituloAn = '''Saldo_Ant 00-'+Convert(varchar,@j)+''''
	end

	Set @j = @j + 1
end



-- Descartando a ultima letra de la cadena --
if(convert(int,@RPrdo1)<= 14)
begin
	Set @SDebeAc = left(@SDebeAc,len(@SDebeAc)-1)
	Set @SHaberAc = left(@SHaberAc,len(@SHaberAc)-1)
end
if(convert(int,@RPrdo1)> 0)
begin
	Set @SDebeAn = left(@SDebeAn,len(@SDebeAn)-1)
	Set @SHaberAn = left(@SHaberAn,len(@SHaberAn)-1)
end

-- Mostrar Resultado acumulado --
print 'p1 =  ' +@SDebeAc
print 'p2 =  ' +@SHaberAc

print 'p3 =  ' +@SDebeAn
print 'p4 =  ' +@SHaberAn

print 'p5 =  ' +@TituloAc
print 'p6 =  ' +@TitDebeAc
print 'p7 =  ' +@TitHaberAc
print 'p8 =  ' +@TituloAn

print 'p9 =  ' +@RangoN1
print 'p10 =  ' +@RangoN2
print 'p11 =  ' +@RangoN3
print 'p12 =  ' +@RangoN4

print 'p13 =  ' +@CadenaCC 
print 'p14 =  ' +@CadenaSC
print 'p15 =  ' +@CadenaSS

Declare @SQL1 nvarchar(4000)
Declare @SQL2 nvarchar(4000)
Declare @SQL3 nvarchar(4000)
Declare @SQL4 nvarchar(4000)
Set @SQL1 = ''
Set @SQL2 = ''
Set @SQL3 = ''
Set @SQL4 = ''


if(@n1 = 1)
begin
	Set @SQL1 = 
		'
		select  1 as Nivel,
			s.NroCta,p.NomCta,
			case('+@RPrdo1+') when ''00'' then 0.00 else sum('+@SDebeAn+')-sum('+@SHaberAn+') end '+@TituloAn+',
			sum('+@SDebeAc+') as '+@TitDebeAc+', sum('+@SHaberAc+') as '+@TitHaberAc+',
			sum('+@SDebeAc+') - sum('+@SHaberAc+') as '+@TituloAc+',
			case('+@RPrdo1+') when ''00'' then 0.00 else sum('+@SDebeAn+')-sum('+@SHaberAn+') end + (sum('+@SDebeAc+') - sum('+@SHaberAc+')) as '+@TitAcumu+'
		from SUMAS_N1'+@TMda+' s 
		left join PlanCtas p On p.RucE=s.RucE and p.NroCta=s.NroCta and p.Ejer=s.Ejer
		where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''''+@RangoN1+@CadenaCC+@CadenaSC+@CadenaSS+'
		group by s.NroCta,p.NomCta
		'
end

if(@n2 = 1)
begin
	if(@n1 = 1) Set @SQL2 = @SQL2 + ' UNION ALL '
	Set @SQL2 = @SQL2 +
		'
		select  2 as Nivel,
			s.NroCta,p.NomCta,
			case('+@RPrdo1+') when ''00'' then 0.00 else sum('+@SDebeAn+')-sum('+@SHaberAn+') end '+@TituloAn+',
			sum('+@SDebeAc+') as '+@TitDebeAc+', sum('+@SHaberAc+') as '+@TitHaberAc+',
			sum('+@SDebeAc+') - sum('+@SHaberAc+') as '+@TituloAc+',
			case('+@RPrdo1+') when ''00'' then 0.00 else sum('+@SDebeAn+')-sum('+@SHaberAn+') end + (sum('+@SDebeAc+') - sum('+@SHaberAc+')) as '+@TitAcumu+'
		from SUMAS_N2'+@TMda+' s 
		left join PlanCtas p On p.RucE=s.RucE and p.NroCta=s.NroCta and p.Ejer=s.Ejer
		where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''''+@RangoN2+@CadenaCC+@CadenaSC+@CadenaSS+'
		group by s.NroCta,p.NomCta
		'
end

if(@n3 = 1)
begin
	if(@n1 = 1 or @n2 = 1) Set @SQL3 = @SQL3 + ' UNION ALL '
	Set @SQL3 = @SQL3 +
		'
		select  3 as Nivel,
			s.NroCta,p.NomCta,
			case('+@RPrdo1+') when ''00'' then 0.00 else sum('+@SDebeAn+')-sum('+@SHaberAn+') end '+@TituloAn+',
			sum('+@SDebeAc+') as '+@TitDebeAc+', sum('+@SHaberAc+') as '+@TitHaberAc+',
			sum('+@SDebeAc+') - sum('+@SHaberAc+') as '+@TituloAc+',
			case('+@RPrdo1+') when ''00'' then 0.00 else sum('+@SDebeAn+')-sum('+@SHaberAn+') end + (sum('+@SDebeAc+') - sum('+@SHaberAc+')) as '+@TitAcumu+'
		from SUMAS_N3'+@TMda+' s 
		left join PlanCtas p On p.RucE=s.RucE and p.NroCta=s.NroCta and p.Ejer=s.Ejer
		where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''''+@RangoN3+@CadenaCC+@CadenaSC+@CadenaSS+'
		group by s.NroCta,p.NomCta
		'
end

if(@n4 = 1)
begin
	if(@n1 = 1 or @n2 = 1 or @n3 = 1) Set @SQL4 = @SQL4 + ' UNION ALL '
	Set @SQL4 = @SQL4 +
		'
		select  4 as Nivel,
			s.NroCta,p.NomCta,
			case('+@RPrdo1+') when ''00'' then 0.00 else sum('+@SDebeAn+')-sum('+@SHaberAn+') end '+@TituloAn+',
			sum('+@SDebeAc+') as '+@TitDebeAc+', sum('+@SHaberAc+') as '+@TitHaberAc+',
			sum('+@SDebeAc+') - sum('+@SHaberAc+') as '+@TituloAc+',
			case('+@RPrdo1+') when ''00'' then 0.00 else sum('+@SDebeAn+')-sum('+@SHaberAn+') end + (sum('+@SDebeAc+') - sum('+@SHaberAc+')) as '+@TitAcumu+'
		from SUMAS_N4'+@TMda+' s 
		left join PlanCtas p On p.RucE=s.RucE and p.NroCta=s.NroCta and p.Ejer=s.Ejer
		where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''''+@RangoN4+@CadenaCC+@CadenaSC+@CadenaSS+'
		group by s.NroCta,p.NomCta
		'
end

print @SQL1
print @SQL2
print @SQL3
print @SQL4

Exec('('+@SQL1+@SQL2+@SQL3+@SQL4+')'+'Order by 2,1')

----------------------PRUEBA------------------------
--exec Ctb_MovimientosCons '11111111111','2009','05','07','10.4','10.4','01','01010101','01010101','01010101','01010101','','','0','0','0','1',null

------CODIGO DE MODIFICACION--------
--CM=RE01

----------------------LEYENDA----------------------
-- DI->(15/10/2009) : Creacion del procedimiento almacenado
--FL: 17/09/2010 <se agrego ejercicio>
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Ctb_SaldosCons_x_Prdo_CC2]
@RucE nvarchar(11),
@Ejer  nvarchar(4),
@Prdo1  nvarchar(2),
@Prdo2  nvarchar(2),
@Datos  nvarchar(4000),
@Nivel1 bit,
@Nivel2 bit,
@Nivel3 bit,
@Nivel4 bit,
@MdaReg nvarchar(2),
@RangoD nvarchar(10),  --Rango de Cta Desde (PV)
@RangoH nvarchar(10),  --Rango de Cta Hasta (PV)
@msj varchar(100) output

as

/* Descomentar para probar  --PV
if(@Datos='xx')
--	set @Datos = '''01010101''' --Funciona
	set @Datos = '''01010101'',''0002''' --Funciona
	--01010101 | 0002 

print @Datos
*/


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
		Set @RangoN1 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''''
		Set @RangoN2 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''''
		Set @RangoN3 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''''
		Set @RangoN4 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''''
		Set @RangoN  = ' and left(v.NroCta,2) >= '''''+@RangoD+''''''
	end
	if(len(@RangoD) = 4)
	begin
		Set @RangoN1 = ' and left(v.NroCta,4) >= left('''''+@RangoD+''''',2)'
		Set @RangoN2 = ' and left(v.NroCta,4) >= '''''+@RangoD+''''''
		Set @RangoN3 = ' and left(v.NroCta,4) >= '''''+@RangoD+''''''
		Set @RangoN4 = ' and left(v.NroCta,4) >= '''''+@RangoD+''''''
		Set @RangoN  = ' and left(a.NroCta,4) >= '''''+@RangoD+''''''
	end
	if(len(@RangoD) = 6)
	begin
		Set @RangoN1 = ' and left(v.NroCta,6) >= left('''''+@RangoD+''''',2)'
		Set @RangoN2 = ' and left(v.NroCta,6) >= left('''''+@RangoD+''''',4)'
		Set @RangoN3 = ' and left(v.NroCta,6) >= '''''+@RangoD+''''''
		Set @RangoN4 = ' and left(v.NroCta,6) >= '''''+@RangoD+''''''
		Set @RangoN  = ' and left(a.NroCta,6) >= '''''+@RangoD+''''''
	end
	if(len(@RangoD) > 6)
	begin
		Set @RangoN1 = ' and v.NroCta >= left('''''+@RangoD+''''',2)'
		Set @RangoN2 = ' and v.NroCta >= left('''''+@RangoD+''''',4)'
		Set @RangoN3 = ' and v.NroCta >= left('''''+@RangoD+''''',6)'
		Set @RangoN4 = ' and v.NroCta >= '''''+@RangoD+''''''
		Set @RangoN  = ' and a.NroCta >= '''''+@RangoD+''''''
	end
end
else if(isnull(len(@RangoD),0) = 0 and isnull(len(@RangoH),0) <> 0)
begin
	if(len(@RangoH) = 2)
	begin
		Set @RangoN1 = ' and left(v.NroCta,2) <= '''''+@RangoH+''''''
		Set @RangoN2 = ' and left(v.NroCta,2) <= '''''+@RangoH+''''''
		Set @RangoN3 = ' and left(v.NroCta,2) <= '''''+@RangoH+''''''
		Set @RangoN4 = ' and left(v.NroCta,2) <= '''''+@RangoH+''''''
		Set @RangoN  = ' and left(a.NroCta,2) <= '''''+@RangoH+''''''
	end
	if(len(@RangoH) = 4)
	begin
		Set @RangoN1 = ' and left(v.NroCta,4) <= left('''''+@RangoH+''''',2)'
		Set @RangoN2 = ' and left(v.NroCta,4) <= '''''+@RangoH+''''''
		Set @RangoN3 = ' and left(v.NroCta,4) <= '''''+@RangoH+''''''
		Set @RangoN4 = ' and left(v.NroCta,4) <= '''''+@RangoH+''''''
		Set @RangoN  = ' and left(a.NroCta,4) <= '''''+@RangoH+''''''
	end
	if(len(@RangoH) = 6)
	begin
		Set @RangoN1 = ' and left(v.NroCta,6) <= left('''''+@RangoH+''''',2)'
		Set @RangoN2 = ' and left(v.NroCta,6) <= left('''''+@RangoH+''''',4)'
		Set @RangoN3 = ' and left(v.NroCta,6) <= '''''+@RangoH+''''''
		Set @RangoN4 = ' and left(v.NroCta,6) <= '''''+@RangoH+''''''
		Set @RangoN  = ' and left(a.NroCta,6) <= '''''+@RangoH+''''''
	end
	if(len(@RangoH) > 6)
	begin
		Set @RangoN1 = ' and v.NroCta <= left('''''+@RangoH+''''',2)'
		Set @RangoN2 = ' and v.NroCta <= left('''''+@RangoH+''''',4)'
		Set @RangoN3 = ' and v.NroCta <= left('''''+@RangoH+''''',6)'
		Set @RangoN4 = ' and v.NroCta <= '''''+@RangoH+''''''
		Set @RangoN  = ' and a.NroCta <= '''''+@RangoH+''''''
	end
end
else if(isnull(len(@RangoD),0) <> 0 and isnull(len(@RangoH),0) <> 0)
begin
	if(len(@RangoD) = 2)
	begin
		if(len(@RangoH) = 2)
		begin
			Set @RangoN1 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''' and left(v.NroCta,2) <= '''''+@RangoH+''''''
			Set @RangoN2 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''' and left(v.NroCta,2) <= '''''+@RangoH+''''''
			Set @RangoN3 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''' and left(v.NroCta,2) <= '''''+@RangoH+''''''
			Set @RangoN4 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''' and left(v.NroCta,2) <= '''''+@RangoH+''''''
			Set @RangoN  = ' and left(a.NroCta,2) >= '''''+@RangoD+''''' and left(a.NroCta,2) <= '''''+@RangoH+''''''
		end
		if(len(@RangoH) = 4)
		begin
			Set @RangoN1 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''' and left(v.NroCta,4) <= left('''''+@RangoH+''''',2)'
			Set @RangoN2 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''' and left(v.NroCta,4) <= '''''+@RangoH+''''''
			Set @RangoN3 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''' and left(v.NroCta,4) <= '''''+@RangoH+''''''
			Set @RangoN4 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''' and left(v.NroCta,4) <= '''''+@RangoH+''''''
			Set @RangoN  = ' and left(a.NroCta,2) >= '''''+@RangoD+''''' and left(a.NroCta,4) <= '''''+@RangoH+''''''
		end
		if(len(@RangoH) = 6)
		begin
			Set @RangoN1 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''' and left(v.NroCta,6) <= left('''''+@RangoH+''''',2)'
			Set @RangoN2 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''' and left(v.NroCta,6) <= left('''''+@RangoH+''''',4)'
			Set @RangoN3 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''' and left(v.NroCta,6) <= '''''+@RangoH+''''''
			Set @RangoN4 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''' and left(v.NroCta,6) <= '''''+@RangoH+''''''
			Set @RangoN  = ' and left(a.NroCta,2) >= '''''+@RangoD+''''' and left(a.NroCta,6) <= '''''+@RangoH+''''''
		end
		if(len(@RangoH) > 6)
		begin
			Set @RangoN1 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''' and v.NroCta <= left('''''+@RangoH+''''',2)'
			Set @RangoN2 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''' and v.NroCta <= left('''''+@RangoH+''''',4)'
			Set @RangoN3 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''' and v.NroCta <= left('''''+@RangoH+''''',6)'
			Set @RangoN4 = ' and left(v.NroCta,2) >= '''''+@RangoD+''''' and v.NroCta <= '''''+@RangoH+''''''
			Set @RangoN  = ' and left(a.NroCta,2) >= '''''+@RangoD+''''' and a.NroCta <= '''''+@RangoH+''''''
		end
	end
	if(len(@RangoD) = 4)
	begin
		if(len(@RangoH) = 2)
		begin
			Set @RangoN1 = ' and left(v.NroCta,4) >= left('''''+@RangoD+''''',2) and left(v.NroCta,2) <= '''''+@RangoH+''''''
			Set @RangoN2 = ' and left(v.NroCta,4) >= '''''+@RangoD+''''' and left(v.NroCta,2) <= '''''+@RangoH+''''''
			Set @RangoN3 = ' and left(v.NroCta,4) >= '''''+@RangoD+''''' and left(v.NroCta,2) <= '''''+@RangoH+''''''
			Set @RangoN4 = ' and left(v.NroCta,4) >= '''''+@RangoD+''''' and left(v.NroCta,2) <= '''''+@RangoH+''''''
			Set @RangoN  = ' and left(a.NroCta,4) >= '''''+@RangoD+''''' and left(a.NroCta,2) <= '''''+@RangoH+''''''
		end
		if(len(@RangoH) = 4)
		begin
			Set @RangoN1 = ' left(v.NroCta,4) >= left('''''+@RangoD+''''',2) and left(v.NroCta,4) <= left('''''+@RangoH+''''',2)'
			Set @RangoN2 = ' left(v.NroCta,4) >= '''''+@RangoD+''''' and left(v.NroCta,4) <= '''+@RangoH+''''''
			Set @RangoN3 = ' and left(v.NroCta,4) >= '''''+@RangoD+''''' and left(v.NroCta,4) <= '''''+@RangoH+''''''
			Set @RangoN4 = ' and left(v.NroCta,4) >= '''''+@RangoD+''''' and left(v.NroCta,4) <= '''''+@RangoH+''''''
			Set @RangoN  = ' and left(a.NroCta,4) >= '''''+@RangoD+''''' and left(a.NroCta,4) <= '''''+@RangoH+''''''
		end
		if(len(@RangoH) = 6)
		begin
			Set @RangoN1 = ' left(v.NroCta,4) >= left('''''+@RangoD+''''',2) and left(v.NroCta,6) <= left('''''+@RangoH+''''',2)'
			Set @RangoN2 = ' left(v.NroCta,4) >= '''''+@RangoD+''''' and left(v.NroCta,6) <= left('''''+@RangoH+''''',4)'
			Set @RangoN3 = ' and left(v.NroCta,4) >= '''''+@RangoD+''''' and left(v.NroCta,6) <= '''''+@RangoH+''''''
			Set @RangoN4 = ' and left(v.NroCta,4) >= '''''+@RangoD+''''' and left(v.NroCta,6) <= '''''+@RangoH+''''''
			Set @RangoN  = ' and left(a.NroCta,4) >= '''''+@RangoD+''''' and left(a.NroCta,6) <= '''''+@RangoH+''''''
		end
		if(len(@RangoH) > 6)
		begin
			Set @RangoN1 = ' and left(v.NroCta,4) >= left('''''+@RangoD+''''',2) and v.NroCta <= left('''''+@RangoH+''''',2)'
			Set @RangoN2 = ' and left(v.NroCta,4) >= '''''+@RangoD+''''' and v.NroCta <= left('''''+@RangoH+''''',4)'
			Set @RangoN3 = ' and left(v.NroCta,4) >= '''''+@RangoD+''''' and v.NroCta <= left('''''+@RangoH+''''',6)'
			Set @RangoN4 = ' and left(v.NroCta,4) >= '''''+@RangoD+''''' and v.NroCta <= '''''+@RangoH+''''''
			Set @RangoN  = ' and left(a.NroCta,4) >= '''''+@RangoD+''''' and a.NroCta <= '''''+@RangoH+''''''
		end
	end
	if(len(@RangoD) = 6)
	begin
		if(len(@RangoH) = 2)
		begin
			Set @RangoN1 = ' and left(v.NroCta,6) >= left('''''+@RangoD+''''',2) and left(v.NroCta,2) <= '''''+@RangoH+''''''
			Set @RangoN2 = ' and left(v.NroCta,6) >= left('''''+@RangoD+''''',4) and left(v.NroCta,2) <= '''''+@RangoH+''''''
			Set @RangoN3 = ' and left(v.NroCta,6) >= '''''+@RangoD+''''' and left(v.NroCta,2) <= '''''+@RangoH+''''''
			Set @RangoN4 = ' and left(v.NroCta,6) >= '''''+@RangoD+''''' and left(v.NroCta,2) <= '''''+@RangoH+''''''
			Set @RangoN  = ' and left(a.NroCta,6) >= '''''+@RangoD+''''' and left(a.NroCta,2) <= '''''+@RangoH+''''''
		end
		if(len(@RangoH) = 4)
		begin
			Set @RangoN1 = ' and left(v.NroCta,6) >= left('''''+@RangoD+''''',2) and left(v.NroCta,4) <= left('''''+@RangoH+''''',2)'
			Set @RangoN2 = ' and left(v.NroCta,6) >= left('''''+@RangoD+''''',4) and left(v.NroCta,4) <= '''''+@RangoH+''''''
			Set @RangoN3 = ' and left(v.NroCta,6) >= '''''+@RangoD+''''' and left(v.NroCta,4) <= '''''+@RangoH+''''''
			Set @RangoN4 = ' and left(v.NroCta,6) >= '''''+@RangoD+''''' and left(v.NroCta,4) <= '''''+@RangoH+''''''
			Set @RangoN  = ' and left(a.NroCta,6) >= '''''+@RangoD+''''' and left(a.NroCta,4) <= '''''+@RangoH+''''''
		end
		if(len(@RangoH) = 6)
		begin
			Set @RangoN1 = ' and left(v.NroCta,6) >= left('''''+@RangoD+''''',2) and left(v.NroCta,6) <= left('''''+@RangoH+''''',2)'
			Set @RangoN2 = ' and left(v.NroCta,6) >= left('''''+@RangoD+''''',4) and left(v.NroCta,6) <= left('''''+@RangoH+''''',4)'
			Set @RangoN3 = ' and left(v.NroCta,6) >= '''''+@RangoD+''''' and v.NroCta <= '''''+@RangoH+''''''
			Set @RangoN4 = ' and left(v.NroCta,6) >= '''''+@RangoD+''''' and left(v.NroCta,6) <= '''''+@RangoH+''''''
			Set @RangoN  = ' and left(a.NroCta,6) >= '''''+@RangoD+''''' and left(a.NroCta,6) <= '''''+@RangoH+''''''
		end
		if(len(@RangoH) > 6)
		begin
			Set @RangoN1 = ' and left(v.NroCta,6) >= left('''''+@RangoD+''''',2) and v.NroCta <= left('''''+@RangoH+''''',2)'
			Set @RangoN2 = ' and left(v.NroCta,6) >= left('''''+@RangoD+''''',4) and v.NroCta <= left('''''+@RangoH+''''',4)'
			Set @RangoN3 = ' and left(v.NroCta,6) >= '''''+@RangoD+''''' and v.NroCta <= left('''''+@RangoH+''''',6)'
			Set @RangoN4 = ' and left(v.NroCta,6) >= '''''+@RangoD+''''' and v.NroCta <= '''''+@RangoH+''''''
			Set @RangoN  = ' and left(a.NroCta,6) >= '''''+@RangoD+''''' and a.NroCta <= '''''+@RangoH+''''''
		end
	end
	if(len(@RangoD) > 6)
	begin
		if(len(@RangoH) = 2)
		begin
			Set @RangoN1 = ' and v.NroCta >= left('''''+@RangoD+''''',2) and left(v.NroCta,2) <= '''''+@RangoH+''''''
			Set @RangoN2 = ' and v.NroCta >= left('''''+@RangoD+''''',4) and left(v.NroCta,2) <= '''''+@RangoH+''''''
			Set @RangoN3 = ' and v.NroCta >= left('''''+@RangoD+''''',6) and left(v.NroCta,2) <= '''''+@RangoH+''''''
			Set @RangoN4 = ' and v.NroCta >= '''''+@RangoD+''''' and left(v.NroCta,2) <= '''''+@RangoH+''''''
			Set @RangoN  = ' and a.NroCta >= '''''+@RangoD+''''' and left(a.NroCta,2) <= '''''+@RangoH+''''''
		end
		if(len(@RangoH) = 4)
		begin
			Set @RangoN1 = ' and v.NroCta >= left('''''+@RangoD+''''',2) and left(v.NroCta,4) <= left('''''+@RangoH+''''',2)'
			Set @RangoN2 = ' and v.NroCta >= left('''''+@RangoD+''''',4) and left(v.NroCta,4) <= '''''+@RangoH+''''''
			Set @RangoN3 = ' and v.NroCta >= left('''''+@RangoD+''''',6) and left(v.NroCta,4) <= '''''+@RangoH+''''''
			Set @RangoN4 = ' and v.NroCta >= '''''+@RangoD+''''' and left(v.NroCta,4) <= '''''+@RangoH+''''''
			Set @RangoN  = ' and a.NroCta >= '''''+@RangoD+''''' and left(a.NroCta,4) <= '''''+@RangoH+''''''
		end
		if(len(@RangoH) = 6)
		begin
			Set @RangoN1 = ' and v.NroCta >= left('''''+@RangoD+''''',2) and left(v.NroCta,6) <= left('''''+@RangoH+''''',2)'
			Set @RangoN2 = ' and v.NroCta >= left('''''+@RangoD+''''',4) and left(v.NroCta,6) <= left('''''+@RangoH+''''',4)'
			Set @RangoN3 = ' and v.NroCta >= left('''''+@RangoD+''''',6) and left(v.NroCta,6) <= '''''+@RangoH+''''''
			Set @RangoN4 = ' and v.NroCta >= '''''+@RangoD+''''' and left(v.NroCta,6) <= '''''+@RangoH+''''''
			Set @RangoN  = ' and a.NroCta >= '''''+@RangoD+''''' and left(a.NroCta,6) <= '''''+@RangoH+''''''
		end
		if(len(@RangoH) > 6)
		begin
			Set @RangoN1 = ' and v.NroCta >= left('''''+@RangoD+''''',2) and v.NroCta <= left('''''+@RangoH+''''',2)'
			Set @RangoN2 = ' and v.NroCta >= left('''''+@RangoD+''''',4) and v.NroCta <= left('''''+@RangoH+''''',4)'
			Set @RangoN3 = ' and v.NroCta >= left('''''+@RangoD+''''',6) and v.NroCta <= left('''''+@RangoH+''''',6)'
			Set @RangoN4 = ' and v.NroCta >= '''''+@RangoD+''''' and v.NroCta <= '''''+@RangoH+''''''
			Set @RangoN  = ' and a.NroCta >= '''''+@RangoD+''''' and a.NroCta <= '''''+@RangoH+''''''
		end
	end
end
----------------------------------------------------Declare @RangoN1 nvarchar(150)
Declare @SQL1 varchar(8000)
Declare @SQL2 varchar(8000)
Declare @SQL3 varchar(8000)
Declare @SQL4 varchar(8000)
Declare @SQL5 varchar(8000)
Declare @SQL6 varchar(8000)
Declare @SQL7 varchar(8000)
Set @SQL1 = '' Set @SQL2 = '' Set @SQL3 = '' Set @SQL4 = '' Set @SQL5 = '' Set @SQL6 = '' Set @SQL7 = ''


Set @SQL1 = 
	'
	Declare @RucE nvarchar(11), @Ejer nvarchar(4)
	Declare @Prdo1 nvarchar(2), @Prdo2 nvarchar(2)
	
	Set @RucE='''+@RucE+''' Set @Ejer='''+@Ejer+'''
	Set @Prdo1='''+@Prdo1+''' Set @Prdo2='''+@Prdo2+'''

	Declare @N1 nvarchar(1)
	Declare @N2 nvarchar(1)
	Declare @N3 nvarchar(1)
	Declare @N4 nvarchar(1)
	Set @N1='''+convert(nvarchar,@Nivel1)+''' 
	Set @N2='''+convert(nvarchar,@Nivel2)+''' 
	Set @N3='''+convert(nvarchar,@Nivel3)+''' 
	Set @N4='''+convert(nvarchar,@Nivel4)+'''


	Declare @Mda nvarchar(2), @Desde nvarchar(10), @Hasta nvarchar(10)
	Set @Mda='''+@MdaReg+''' Set @Desde='''+@RangoD+''' Set @Hasta='''+@RangoH+'''

	Declare @TMda nvarchar(3)
	if(@Mda = ''02'')  Set @TMda = ''_ME''
	else Set @TMda = ''''
	
	Declare _cursor Cursor 
		For Select Cd_CC,NCorto From CCostos Where RucE=@RucE and Cd_CC in ('+@Datos+')
	
	Declare @Cd_CC nvarchar(10)
	Declare @NCorto nvarchar(10)
	Declare @Cadena nvarchar(4000)
	Set @Cadena = ''''
	'

Set @SQL2 =
	'
	Open _cursor
		Fetch Next From _cursor Into @Cd_CC,@NCorto
		While @@Fetch_Status = 0
			Begin
				Set @Cadena = @Cadena+''
			,Sum(Case(v.Cd_CC)when ''''''+@Cd_CC+'''''' then v.MtoD''+@TMda+''-v.MtoH''+@TMda+'' else 0.00 end) as ''''''+@NCorto+''''''''
				Print @Cadena
				Fetch Next From _cursor Into @Cd_CC,@NCorto
			End
	Close _cursor
	Deallocate _cursor
	'


Set @SQL3 =
	'
	Declare @Part1_N1 nvarchar(4000)
	Declare @Part2_N1 nvarchar(4000)
	Set @Part1_N1=''''	Set @Part2_N1=''''
	Declare @Part1_N2 nvarchar(4000)
	Declare @Part2_N2 nvarchar(4000)
	Set @Part1_N2=''''	Set @Part2_N2=''''
	Declare @Part1_N3 nvarchar(4000)
	Declare @Part2_N3 nvarchar(4000)
	Set @Part1_N3=''''	Set @Part2_N3=''''
	Declare @Part1_N4 nvarchar(4000)
	Declare @Part2_N4 nvarchar(4000)
	Set @Part1_N4=''''	Set @Part2_N4=''''
	
	Declare @Cadena_N1 nvarchar(4000)
	Declare @Cadena_N2 nvarchar(4000)
	Declare @Cadena_N3 nvarchar(4000)
	Declare @Cadena_N4 nvarchar(4000)
	Set @Cadena_N1='''' Set @Cadena_N2='''' Set @Cadena_N3='''' Set @Cadena_N4='''' 

	Declare @Tot_P1 nvarchar(4000)
	Declare @Tot_P2 nvarchar(4000)
	Declare @Cadena_T nvarchar(4000)
	Set @Tot_P1 = '''' Set @Tot_P2 = '''' Set @Cadena_T = '''' 

	if(@N1 = ''1'')
	begin
		Set @Part1_N1 = '' Select 1 as ind, left(v.NroCta,2) as NroCta,p.NomCta''
		Set @Part2_N1 = ''	,'''''''' as Total
					From Voucher v 
				left join PlanCtas p On p.RucE=v.RucE and p.NroCta=left(v.NroCta,2) and v.Ejer=p.Ejer
				where v.RucE=''''''+@RucE+'''''' and v.Ejer=''''''+@Ejer+'''''' and v.IB_Anulado=0 and v.Prdo between ''''''+@Prdo1+'''''' and ''''''+@Prdo2+'''''''+@RangoN1+'
			      	Group by left(v.NroCta,2),p.NomCta
			      	''
	end
	'
Set @SQL4 =
	'
	if(@N2 = ''1'')
	begin
		if(@N1 = ''1'')
		begin	
			Set @Part1_N2 = ''UNION ALL''
		end 
		Set @Part1_N2 = @Part1_N2+'' Select 2 as ind,left(v.NroCta,4) as NroCTa,p.NomCta''
		Set @Part2_N2 = '' ,'''''''' as Total
				    From Voucher v 
			left join PlanCtas p On p.RucE=v.RucE and p.NroCta=left(v.NroCta,4) and v.Ejer=p.Ejer
			where v.RucE=''''''+@RucE+'''''' and v.Ejer=''''''+@Ejer+'''''' and v.IB_Anulado=0 and v.Prdo between ''''''+@Prdo1+'''''' and ''''''+@Prdo2+'''''''+@RangoN2+'
			Group by left(v.NroCta,4),p.NomCta
			''
	end

	if(@N3 = ''1'')
	begin
		if(@N1 = ''1'' or @N2 = ''1'')
		begin	
			Set @Part1_N3 = ''UNION ALL''
		end 
		Set @Part1_N3 = @Part1_N3+'' Select 3 as ind,left(v.NroCta,6) as NroCTa,p.NomCta''
		Set @Part2_N3 = '' ,'''''''' as Total
				     From Voucher v 
			left join PlanCtas p On p.RucE=v.RucE and p.NroCta=left(v.NroCta,6) and v.Ejer=p.Ejer
			where v.RucE=''''''+@RucE+'''''' and v.Ejer=''''''+@Ejer+'''''' and v.IB_Anulado=0 and v.Prdo between ''''''+@Prdo1+'''''' and ''''''+@Prdo2+'''''''+@RangoN3+'
			Group by left(v.NroCta,6),p.NomCta
			''
	end
	'
Set @SQL5 = 
	'
	if(@N4 = ''1'')
	begin
		if(@N1 = ''1'' or @N2 = ''1'' or @N3 = ''1'')
		begin	
			Set @Part1_N4 = ''UNION ALL''
		end 
		Set @Part1_N4 = @Part1_N4 +'' Select 4 as ind,v.NroCta,p.NomCta''
		Set @Part2_N4 = '' ,'''''''' as Total
				     From Voucher v 
			left join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and v.Ejer=p.Ejer
			where v.RucE=''''''+@RucE+'''''' and v.Ejer=''''''+@Ejer+'''''' and v.IB_Anulado=0 and v.Prdo between ''''''+@Prdo1+'''''' and ''''''+@Prdo2+'''''''+@RangoN4+'
			Group by v.NroCta,p.NomCta
			''
	end

	if(@N1 = ''1'')	Set @Cadena_N1 = left(@Cadena,len(@Cadena))
	if(@N2 = ''1'')	Set @Cadena_N2 = left(@Cadena,len(@Cadena))
	if(@N3 = ''1'')	Set @Cadena_N3 = left(@Cadena,len(@Cadena))
	if(@N4 = ''1'')	Set @Cadena_N4 = left(@Cadena,len(@Cadena))
	'

Set @SQL6 = 
	'
	Set @Tot_P1 = '' Select 0 as ind,''''TOTAL'''' as NroCta,''''********************'''' as NomCta''
	Set @Tot_P2 = '' ,'''''''' as Total
			   From Voucher v 
			where v.RucE=''''''+@RucE+'''''' and v.Ejer=''''''+@Ejer+'''''' and v.IB_Anulado=0 and v.Prdo between ''''''+@Prdo1+'''''' and ''''''+@Prdo2+'''''''+@RangoN4+'
			''
	Set @Cadena_T = left(@Cadena,len(@Cadena))
	'

Set @SQL7 =
	'
	Print (''(''+@Part1_N1
		+@Cadena_N1+''
	''+@Part2_N1

	      +@Part1_N2
		+@Cadena_N2+''
	''+@Part2_N2
	
	      +@Part1_N3
		+@Cadena_N3+''
	''+@Part2_N3
	
	      +@Part1_N4
		+@Cadena_N4+''
	''+@Part2_N4+'')Order by 2,1'')

	
	
	Exec (''(''+@Part1_N1
		+@Cadena_N1+''
	''+@Part2_N1

	      +@Part1_N2
		+@Cadena_N2+''
	''+@Part2_N2
	
	      +@Part1_N3
		+@Cadena_N3+''
	''+@Part2_N3
	
	      +@Part1_N4
		+@Cadena_N4+''
	''+@Part2_N4+'')Order by 2,1'')


	Print (@Tot_P1
			+@Cadena_T+''
		''+@Tot_P2)

	Exec  (@Tot_P1
			+@Cadena_T+''
		''+@Tot_P2)
	'


PRINT @SQL1+@SQL2+@SQL3+@SQL4+@SQL5+@SQL6+@SQL7

EXEC(@SQL1+@SQL2+@SQL3+@SQL4+@SQL5+@SQL6+@SQL7)

----------------------PRUEBA------------------------
--no se podia ejecutar
--exec Ctb_SaldosCons_x_Prdo '11111111111','2009','05','06','1','0','0','1','01','01/01/2008','30/07/2010',null
--exec Ctb_SaldosCons_x_Prdo_CC2 '11111111111', '2010', '03','03','xx',1,0,0,1,'01','','',null

------CODIGO DE MODIFICACION--------
--CM=RE01

----------------------LEYENDA----------------------
-- DI : 06/11/2009 Creacion del procedimiento almacenado
-- DI : 09/11/2009 Modificacion del procedimiento almacenado a un txt
-- PV : 20/08/2010 se hicieron pruebas y agregaron comentarios
-- FL : 17/09/2010 <se agrego ejercicio>
GO

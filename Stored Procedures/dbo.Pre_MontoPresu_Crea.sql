SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Pre_MontoPresu_Crea]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@NroCta nvarchar(10),
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Prdo nvarchar(6),
@MtoN nvarchar(20),
@MtoA nvarchar(20),
@Moneda nvarchar(2),
@msj varchar(100) output
as

/*
Declare @RucE nvarchar(11)
Declare @Ejer nvarchar(4)
Declare @NroCta nvarchar(10)
Declare @Cd_CC nvarchar(8)
Declare @Cd_SC nvarchar(8)
Declare @Cd_SS nvarchar(8)
Declare @Prdo nvarchar(6)
Declare @MtoN nvarchar(20)
Declare @MtoA nvarchar(20)
Declare @Moneda nvarchar(2)

Set @RucE='11111111111' Set @Ejer='2009' Set @NroCta='999999999'
Set @Cd_CC='A' Set @Cd_SC='A1' Set @Cd_SS=''
Set @Prdo='ENE'
Set @MtoN='110'
Set @MtoA='100'
Set @Moneda = '01'
*/

Declare @Mda nvarchar(3)
Set @Mda = ''
if(@Moneda = '02') Set @Mda='_ME'
if(@Cd_SS is not null)
	select @Cd_SS = Cd_SS from CCSubSub where RucE = @RucE and Cd_CC = @Cd_CC and Cd_SC = @Cd_SC and NCorto = @Cd_SS
else
begin
	if(@Cd_SC is not null)
		select @Cd_SC = Cd_SC from CCSub where RucE = @RucE and Cd_CC = @Cd_CC and NCorto = @Cd_SC
	else
		select @Cd_CC = Cd_CC from CCostos where RucE = @RucE and NCorto = @Cd_CC
end
-- VERFICANDO EXISTENCIA DE CUENTA, CC, SC, SS en Presupuesto para modificar --

exec Pre_Cc_X_PrdoCrea @RucE,@Ejer,@NroCta,@Cd_CC,@Cd_SC,@Cd_SS,@msj output

Declare @CadCC nvarchar(1000)
Declare @CadSC nvarchar(1000)
Declare @CadSS nvarchar(1000)
Set @CadCC=''
Set @CadSC=''
Set @CadSS=''

if(isnull(len(@Cd_CC),0) = 0)
	Set @Cd_CC='*'
else	Set @CadCC = ' and isnull(Cd_CC,''*'')='''+@Cd_CC+''''
if(isnull(len(@Cd_SC),0) = 0) 
	Set @Cd_SC='*'
else	Set @CadSC = ' and isnull(Cd_SC,''*'')='''+@Cd_SC+''''

if(isnull(len(@Cd_SS),0) = 0) 
	Set @Cd_SS='*'
else	Set @CadSS = ' and isnull(Cd_SS,''*'')='''+@Cd_SS+''''


-- COLOCANDO LAS DEMAS INFORMACION EN CERO --

	Print ('
		Update Presupuesto Set '+@Prdo+@Mda+'=0.00 where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+''' 
		'+@CadCC+@CadSC+@CadSS+'
	     ')
	Exec ('
		Update Presupuesto Set '+@Prdo+@Mda+'=0.00 where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+''' 
		'+@CadCC+@CadSC+@CadSS+'
	     ')

-- ACTUALIZANDO INFORMACION --

if(@Cd_CC <> '*' and @Cd_SC <> '*' and @Cd_SS <> '*')
begin
	print '1'

	--SS
	Exec ('
		Update Presupuesto Set '+@Prdo+@Mda+'='+@MtoN+' where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+''' 
		and isnull(Cd_CC,''*'')='''+@Cd_CC+''' and isnull(Cd_SC,''*'')='''+@Cd_SC+''' and isnull(Cd_SS,''*'')='''+@Cd_SS+'''
	     ')
	--SC
	Exec (' Declare @Valor nvarchar(20)
		Set @Valor = ''0''
		Set @Valor = (
				select Sum(isnull('+@Prdo+@Mda+',0)) from Presupuesto where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+'''
				and isnull(Cd_CC,''*'')='''+@Cd_CC+''' and isnull(Cd_SC,''*'')='''+@Cd_SC+'''
			     	and Cd_Psp not in (
						   select Cd_Psp from Presupuesto where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+'''
						   and isnull(Cd_CC,''*'')='''+@Cd_CC+''' and isnull(Cd_SC,''*'')='''+@Cd_SC+''' and isnull(Cd_SS,''*'')=''*''
					          )
			     )
		Update Presupuesto Set '+@Prdo+@Mda+'=@Valor where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+''' 
		and isnull(Cd_CC,''*'')='''+@Cd_CC+''' and isnull(Cd_SC,''*'')='''+@Cd_SC+''' and isnull(Cd_SS,''*'')=''*''
	     ')
	--CC
	Exec ('
		Declare @Valor nvarchar(20)
		Set @Valor = ''0''
		
		Set @Valor = (
				select Convert(nvarchar,Sum(isnull('+@Prdo+@Mda+',0))) from Presupuesto where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+'''
				and isnull(Cd_CC,''*'')='''+@Cd_CC+''' and isnull(Cd_SS,''*'')=''*''
				and Cd_Psp not in (
						   select Cd_Psp from Presupuesto where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+'''
						   and isnull(Cd_CC,''*'')='''+@Cd_CC+''' and isnull(Cd_SC,''*'')=''*'' and isnull(Cd_SS,''*'')=''*''
					          )
			      )

		Update Presupuesto Set '+@Prdo+@Mda+'=@Valor where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+''' 
		and isnull(Cd_CC,''*'')='''+@Cd_CC+''' and isnull(Cd_SC,''*'')=''*'' and isnull(Cd_SS,''*'')=''*''
	     ')

	--CUENTA
	Exec ('Declare @Valor nvarchar(20)
		Set @Valor =''0''

		Set @Valor = (
				select Convert(nvarchar,Sum(isnull('+@Prdo+@Mda+',0))) from Presupuesto where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+'''
						and isnull(Cd_SC,''*'')=''*'' and isnull(Cd_SS,''*'')=''*''
						and Cd_Psp not in (
								   select Cd_Psp from Presupuesto where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+''' 
								   and isnull(Cd_CC,''*'')=''*'' and isnull(Cd_SC,''*'')=''*'' and isnull(Cd_SS,''*'')=''*''
							          )
			      )

		Update Presupuesto Set '+@Prdo+@Mda+'=@Valor where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+''' 
		and isnull(Cd_CC,''*'')=''*'' and isnull(Cd_SC,''*'')=''*'' and isnull(Cd_SS,''*'')=''*''
	     ')
end

if(@Cd_CC <> '*' and @Cd_SC <> '*' and @Cd_SS = '*')
begin
	print '2'
	
	--SC
	Exec ('
		Update Presupuesto Set '+@Prdo+@Mda+'='+@MtoN+' where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+''' 
		and isnull(Cd_CC,''*'')='''+@Cd_CC+''' and isnull(Cd_SC,''*'')='''+@Cd_SC+''' and isnull(Cd_SS,''*'')=''*''
	     ')

	--CC
	Exec ('
		Declare @Valor nvarchar(20)
		Set @Valor = ''0''
		
		Set @Valor = (
				select Convert(nvarchar,Sum(isnull('+@Prdo+@Mda+',0))) from Presupuesto where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+'''
				and isnull(Cd_CC,''*'')='''+@Cd_CC+''' and isnull(Cd_SS,''*'')=''*''
				and Cd_Psp not in (
						   select Cd_Psp from Presupuesto where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+'''
						   and isnull(Cd_CC,''*'')='''+@Cd_CC+''' and isnull(Cd_SC,''*'')=''*'' and isnull(Cd_SS,''*'')=''*''
					          )
			      )

		Update Presupuesto Set '+@Prdo+@Mda+'=@Valor where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+''' 
		and isnull(Cd_CC,''*'')='''+@Cd_CC+''' and isnull(Cd_SC,''*'')=''*'' and isnull(Cd_SS,''*'')=''*''
	     ')

	--CUENTA
	Exec ('Declare @Valor nvarchar(20)
		Set @Valor =''0''


		Set @Valor = (
				select Convert(nvarchar,Sum(isnull('+@Prdo+@Mda+',0))) from Presupuesto where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+'''
						and isnull(Cd_SC,''*'')=''*'' and isnull(Cd_SS,''*'')=''*''
						and Cd_Psp not in (
								   select Cd_Psp from Presupuesto where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+''' 
								   and isnull(Cd_CC,''*'')=''*'' and isnull(Cd_SC,''*'')=''*'' and isnull(Cd_SS,''*'')=''*''
							          )
			      )

		Update Presupuesto Set '+@Prdo+@Mda+'=@Valor where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+''' 
		and isnull(Cd_CC,''*'')=''*'' and isnull(Cd_SC,''*'')=''*'' and isnull(Cd_SS,''*'')=''*''
	     ')
end

if(@Cd_CC <> '*' and @Cd_SC = '*' and @Cd_SS = '*')
begin
	print '3'

	--CC
	Exec ('
		Update Presupuesto Set '+@Prdo+@Mda+'='+@MtoN+' where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+''' 
		and isnull(Cd_CC,''*'')='''+@Cd_CC+''' and isnull(Cd_SC,''*'')=''*'' and isnull(Cd_SS,''*'')=''*''
	     ')
	--CUENTA
	Exec ('Declare @Valor nvarchar(20)
		Set @Valor =''0''


		Set @Valor = (
				select Convert(nvarchar,Sum(isnull('+@Prdo+@Mda+',0))) from Presupuesto where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+'''
						and isnull(Cd_SC,''*'')=''*'' and isnull(Cd_SS,''*'')=''*''
						and Cd_Psp not in (
								   select Cd_Psp from Presupuesto where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+''' 
								   and isnull(Cd_CC,''*'')=''*'' and isnull(Cd_SC,''*'')=''*'' and isnull(Cd_SS,''*'')=''*''
							          )
			      )

		Update Presupuesto Set '+@Prdo+@Mda+'=@Valor where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+''' 
		and isnull(Cd_CC,''*'')=''*'' and isnull(Cd_SC,''*'')=''*'' and isnull(Cd_SS,''*'')=''*''
	     ')
end

if(@Cd_CC = '*' and @Cd_SC = '*' and @Cd_SS = '*')
begin
	print '4'
	
	--CUENTA
	Exec ('
		Update Presupuesto Set '+@Prdo+@Mda+'='+@MtoN+' where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and NroCta='''+@NroCta+''' 
		and isnull(Cd_CC,''*'')=''*'' and isnull(Cd_SC,''*'')=''*'' and isnull(Cd_SS,''*'')=''*''
	     ')
end	

-- Leyenda --
-- DI : 08/01/10 <Creacion del procedimiento almacenado>
GO

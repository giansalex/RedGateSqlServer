SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Pre_Formato_Cons]
@RucE nvarchar(11),
@ckcc bit,
@cksc bit,
@ckss bit,
@msj varchar(100) output

as
/*
declare @RucE nvarchar(11)
declare @ckcc bit, @cksc bit, @ckss bit

set @RucE='11111111111'
set @ckcc='1' set @cksc='0' set @ckss='0'
*/
Declare @Cd_CC nvarchar(10)
Declare @Ds_CC nvarchar(100)
Declare @CadCC1 nvarchar(4000)
Declare @CadCC2 nvarchar(4000)
Declare @CadNom1 nvarchar(4000)
Declare @CadNom2 nvarchar(4000)
Set @CadCC1 = ''
Set @CadCC2 = ''
Set @CadNom1 = ''
Set @CadNom2 = ''

Declare @Cd_SC nvarchar(10)
Declare @Ds_SC nvarchar(100)
Declare @Cd_SS nvarchar(10)
Declare @Ds_SS nvarchar(100)

if(@ckcc = 1)
begin

Declare _cc Cursor For Select Cd_CC,Case(isnull(len(NCorto),0)) when 0 then Cd_CC else NCorto end From CCostos Where RucE=@RucE
Open _cc
Fetch Next From _cc Into @Cd_CC,@Ds_CC
While @@Fetch_Status = 0
	Begin

		-----------------------------------------
		if(@cksc = 1)
		begin
		
		Declare _sc Cursor For Select Cd_SC,Case(isnull(len(NCorto),0)) when 0 then Cd_SC else NCorto end From CCSub Where RucE=@RucE and Cd_CC=@Cd_CC
		Open _sc
		Fetch Next From _sc Into @Cd_SC,@Ds_SC
		While @@Fetch_Status = 0
			Begin
				
				---------------------------------------------------------------
				if(@ckss = 1)
				begin

				Declare _ss Cursor For Select Cd_SS,Case(isnull(len(NCorto),0)) when 0 then Cd_SS else NCorto end From CCSubSub Where RucE=@RucE and Cd_CC=@Cd_CC and Cd_SC=@Cd_SC
				Open _ss
				Fetch Next From _ss Into @Cd_SS,@Ds_SS
				While @@Fetch_Status = 0
					Begin
						if(len(@CadCC1)<3940)
							Set @CadCC1 = @CadCC1 + ', '''' as ' + '[SS_' + @Cd_SS + ']'
						else	Set @CadCC2 = @CadCC2 + ', '''' as ' + '[SS_' + @Cd_SS + ']'
						if(len(@CadNom1)<3940)
							Set @CadNom1 = @CadNom1 + ', '''+'SS_'+@Ds_SS+''' as ' + '[SS_' + @Cd_SS + ']'
						else Set @CadNom2 = @CadNom2 + ', '''+'SS_'+@Ds_SS+''' as ' + '[SS_' + @Cd_SS + ']'
						print @Cd_SS
						Fetch Next From _ss Into @Cd_SS,@Ds_SS
					End
				Close _ss
				Deallocate _ss
				
				end
				---------------------------------------------------------------
				if(len(@CadCC1)<3940)
					Set @CadCC1 = @CadCC1 + ', '''' as ' + '[SC_' + @Cd_SC + ']'
				else 	Set @CadCC2 = @CadCC2 + ', '''' as ' + '[SC_' + @Cd_SC + ']'
				if(len(@CadNom1)<3940)
					Set @CadNom1 = @CadNom1 + ', '''+'SC_'+@Ds_SC+''' as ' + '[SC_' + @Cd_SC + ']'
				else	Set @CadNom2 = @CadNom2 + ', '''+'SC_'+@Ds_SC+''' as ' + '[SC_' + @Cd_SC + ']'
				print @Cd_SC
				Fetch Next From _sc Into @Cd_SC,@Ds_SC
			End
		Close _sc
		Deallocate _sc
		
		end
		-----------------------------------------
		if(len(@CadCC1)<3940)
			Set @CadCC1 = @CadCC1 + ', '''' as ' + '[CC_' + @Cd_CC + ']'
		else	Set @CadCC2 = @CadCC2 + ', '''' as ' + '[CC_' + @Cd_CC + ']'
		if(len(@CadNom1)<3940)
			Set @CadNom1 = @CadNom1 + ', '''+'CC_'+@Ds_CC+''' as ' + '[CC_' + @Cd_CC + ']'
		else	Set @CadNom2 = @CadNom2 + ', '''+'CC_'+@Ds_CC+''' as ' + '[CC_' + @Cd_CC + ']'
		print @Cd_CC
		Fetch Next From _cc Into @Cd_CC,@Ds_CC
	End
Close _cc
Deallocate _cc

print @CadCC1
print @CadCC2
print len(@CadCC1)
print len(@CadCC2)
print '****************'
print @CadNom1
print @CadNom2
print len(@CadNom1)
print len(@CadNom2)

end

print 'select ''01-ENE'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
     	' UNION ALL '+
     'select ''02-FEB'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''03-MAR'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''04-ABR'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''05-MAY'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''06-JUN'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''07-JUL'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''08-AGO'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''09-SEP'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''10-OCT'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''11-NOV'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''12-DIC'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''TOTAL'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'
    

exec(
     'select ''01-ENE'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
     	' UNION ALL '+
     'select ''02-FEB'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''03-MAR'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''04-ABR'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''05-MAY'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''06-JUN'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''07-JUL'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''08-AGO'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''09-SEP'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''10-OCT'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''11-NOV'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''12-DIC'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'+
	' UNION ALL '+
     'select ''TOTAL'' as Periodo'+@CadCC1+@CadCC2+', '''' as TOTAL'
    )

Print ('select ''00-INI'' as Periodo'+@CadNom1+@CadNom2+', '''' as TOTAL')

Exec ('select ''00-INI'' as Periodo'+@CadNom1+@CadNom2+', '''' as TOTAL')

-- Leyenda --

-- DI : 05/01/10 : Creacion del procedimiento almacenado
-- DI : 08/01/10 : Actulizacion del procedimiento almacenado <Se agreso una segunda consulta de la descripcion de los centro de costos>
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Ingreso_Egreso_CC]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@Nivel1 bit,
@Nivel2 bit,
@Nivel3 bit,
@Nivel4 bit,
@Cd_Mda nvarchar(2),
@Opc varchar(1),
@Datos nvarchar(4000),
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
Declare @Datos nvarchar(4000)

Set @RucE='11111111111' Set @Ejer='2009'
Set @PrdoIni='00' Set @PrdoFin='12'
Set @Nivel1='1' Set @Nivel2='0' Set @Nivel3='0' Set @Nivel4='1'
Set @Cd_Mda='01'
Set @Opc = 'N'
Set @Datos = '''01010101'''
*/

--*********************************************************

Declare @SQL1 nvarchar(4000)
Declare @SQL2_1 nvarchar(4000), @SQL2_2 nvarchar(4000), @SQL2_3 nvarchar(4000)
Declare @SQL3_1 nvarchar(4000), @SQL3_2 nvarchar(4000)
Declare @SQL4_1 nvarchar(4000), @SQL4_2 nvarchar(4000)
Declare @SQL5_1 nvarchar(4000), @SQL5_2 nvarchar(4000), @SQL5_3 nvarchar(4000), @SQL5_4 nvarchar(4000)
Declare @SQL6 nvarchar(4000)
Declare @SQL7_1 nvarchar(4000), @SQL7_2 nvarchar(4000), @SQL7_3 nvarchar(4000), @SQL7_4 nvarchar(4000)
Set @SQL1 = '' 
Set @SQL2_1 = '' Set @SQL2_2 = '' Set @SQL2_3 = '' 
Set @SQL3_1 = '' Set @SQL3_2 = '' Set @SQL4_1 = '' Set @SQL4_2 = '' 
Set @SQL5_1 = '' Set @SQL5_2 = '' Set @SQL5_3 = '' Set @SQL5_4 = '' 
Set @SQL6 = '' 
Set @SQL7_1 = '' Set @SQL7_2 = '' Set @SQL7_3 = '' Set @SQL7_4 = ''

Set @SQL1 = 
	'
	Declare @RucE nvarchar(11), @Ejer nvarchar(4)
	Declare @Prdo1 nvarchar(2), @Prdo2 nvarchar(2)
	
	Set @RucE='''+@RucE+''' Set @Ejer='''+@Ejer+'''
	Set @Prdo1='''+@PrdoIni+''' Set @Prdo2='''+@PrdoFin+'''

	Declare @N1 nvarchar(1)
	Declare @N2 nvarchar(1)
	Declare @N3 nvarchar(1)
	Declare @N4 nvarchar(1)
	Set @N1='''+convert(nvarchar,@Nivel1)+''' 
	Set @N2='''+convert(nvarchar,@Nivel2)+''' 
	Set @N3='''+convert(nvarchar,@Nivel3)+''' 
	Set @N4='''+convert(nvarchar,@Nivel4)+'''


	Declare @N_Min nvarchar(1) --Nivel minimo de cta consultado (por el cual se debe respetar las sumas) --PV
	if @N4=''1''
	   set @N_Min=''9''
	else if @N3=''1''
	   set @N_Min=''6''
	else if @N2=''1''
	   set @N_Min=''4''
	else 
	   set @N_Min=''2''

	print ''Nivel minimo: '' + @N_Min --PV


	Declare @Mda nvarchar(2)
	Set @Mda='''+@Cd_Mda+'''

	Declare @TMda nvarchar(3)
	if(@Mda = ''02'')  Set @TMda = ''_ME''
	else Set @TMda = ''''
	
	Declare _cursor Cursor 
		For Select Cd_CC,NCorto From CCostos Where RucE=@RucE and Cd_CC in ('+@Datos+')
	
	Declare @Cd_CC nvarchar(10)
	Declare @NCorto nvarchar(10)
	Declare @Cadena_P1 nvarchar(4000),@Cadena_P2 nvarchar(4000),@Cadena_P3 nvarchar(4000),@Cadena_P4 nvarchar(4000),@Cadena_P5 nvarchar(4000)
	Set @Cadena_P1 = '''' Set @Cadena_P2 = '''' Set @Cadena_P3 = '''' Set @Cadena_P4 = '''' Set @Cadena_P5 = ''''
	Declare @i int Set @i=0
	'

Set @SQL2_1 =
	'
	Open _cursor
		Fetch Next From _cursor Into @Cd_CC,@NCorto
		While @@Fetch_Status = 0
			Begin
				Set @i=@i+1
				If(@i<= 25)
				Begin	Set @Cadena_P1 = @Cadena_P1+''
					,Sum(Case(v.Cd_CC)when ''''''+@Cd_CC+'''''' then (v.MtoD''+@TMda+''-v.MtoH''+@TMda+'')*-1 else 0.00 end) as ''''''+@NCorto+''''''''
				End
	'
Set @SQL2_2 =
	'			If(@i> 25 and @i<= 50)
				Begin	Set @Cadena_P2 = @Cadena_P2+''
					,Sum(Case(v.Cd_CC)when ''''''+@Cd_CC+'''''' then (v.MtoD''+@TMda+''-v.MtoH''+@TMda+'')*-1 else 0.00 end) as ''''''+@NCorto+''''''''
				End
				If(@i> 50 and @i<= 75)
				Begin	Set @Cadena_P3 = @Cadena_P3+''
					,Sum(Case(v.Cd_CC)when ''''''+@Cd_CC+'''''' then (v.MtoD''+@TMda+''-v.MtoH''+@TMda+'')*-1 else 0.00 end) as ''''''+@NCorto+''''''''
				End
				If(@i> 75 and @i<= 100)
				Begin	Set @Cadena_P4 = @Cadena_P4+''
					,Sum(Case(v.Cd_CC)when ''''''+@Cd_CC+'''''' then (v.MtoD''+@TMda+''-v.MtoH''+@TMda+'')*-1 else 0.00 end) as ''''''+@NCorto+''''''''
				End
				If(@i> 100)
				Begin	Set @Cadena_P5 = @Cadena_P5+''
					,Sum(Case(v.Cd_CC)when ''''''+@Cd_CC+'''''' then (v.MtoD''+@TMda+''-v.MtoH''+@TMda+'')*-1 else 0.00 end) as ''''''+@NCorto+''''''''
				End
	'
Set @SQL2_3 =
	'
				Fetch Next From _cursor Into @Cd_CC,@NCorto
			End
	Close _cursor
	Deallocate _cursor

	print ''Finalizo Cursor: ''
	Print @Cadena_P1
	Print @Cadena_P2
	Print @Cadena_P3
	Print @Cadena_P4
	Print @Cadena_P5
	print ''---- FIN Cadena Cursor ----PV''
	Print ''''
	Print ''''
	'


Set @SQL3_1 =
	'
	Declare @Part1_N1 nvarchar(4000), @Part11_N1 nvarchar(4000)
	Declare @Part2_N1 nvarchar(4000), @Part21_N1 nvarchar(4000)
	Set @Part1_N1='''' Set @Part2_N1='''' Set @Part11_N1='''' Set @Part21_N1=''''
	Declare @Part1_N2 nvarchar(4000), @Part11_N2 nvarchar(4000)
	Declare @Part2_N2 nvarchar(4000), @Part21_N2 nvarchar(4000)
	Set @Part1_N2='''' Set @Part2_N2='''' Set @Part11_N2='''' Set @Part21_N2=''''
	Declare @Part1_N3 nvarchar(4000), @Part11_N3 nvarchar(4000)
	Declare @Part2_N3 nvarchar(4000), @Part21_N3 nvarchar(4000)
	Set @Part1_N3='''' Set @Part2_N3='''' Set @Part11_N3='''' Set @Part21_N3=''''
	Declare @Part1_N4 nvarchar(4000), @Part11_N4 nvarchar(4000)
	Declare @Part2_N4 nvarchar(4000), @Part21_N4 nvarchar(4000)
	Set @Part1_N4='''' Set @Part2_N4='''' Set @Part11_N4='''' Set @Part21_N4=''''
	
	Declare @Cadena_N1_P1 nvarchar(4000),@Cadena_N1_P2 nvarchar(4000),@Cadena_N1_P3 nvarchar(4000),@Cadena_N1_P4 nvarchar(4000),@Cadena_N1_P5 nvarchar(4000)
	Declare @Cadena_N2_P1 nvarchar(4000),@Cadena_N2_P2 nvarchar(4000),@Cadena_N2_P3 nvarchar(4000),@Cadena_N2_P4 nvarchar(4000),@Cadena_N2_P5 nvarchar(4000)
	Declare @Cadena_N3_P1 nvarchar(4000),@Cadena_N3_P2 nvarchar(4000),@Cadena_N3_P3 nvarchar(4000),@Cadena_N3_P4 nvarchar(4000),@Cadena_N3_P5 nvarchar(4000)
	Declare @Cadena_N4_P1 nvarchar(4000),@Cadena_N4_P2 nvarchar(4000),@Cadena_N4_P3 nvarchar(4000),@Cadena_N4_P4 nvarchar(4000),@Cadena_N4_P5 nvarchar(4000)
	Set @Cadena_N1_P1='''' Set @Cadena_N1_P2='''' Set @Cadena_N1_P3='''' Set @Cadena_N1_P4='''' Set @Cadena_N1_P5='''' 
	Set @Cadena_N2_P1='''' Set @Cadena_N2_P2='''' Set @Cadena_N2_P3='''' Set @Cadena_N2_P4='''' Set @Cadena_N2_P5='''' 
	Set @Cadena_N3_P1='''' Set @Cadena_N3_P2='''' Set @Cadena_N3_P3='''' Set @Cadena_N3_P4='''' Set @Cadena_N3_P5='''' 
	Set @Cadena_N4_P1='''' Set @Cadena_N4_P2='''' Set @Cadena_N4_P3='''' Set @Cadena_N4_P4='''' Set @Cadena_N4_P5='''' 

	Declare @Tot_P1 nvarchar(4000), @Tot1_P1 nvarchar(4000)
	Declare @Tot_P2 nvarchar(4000), @Tot1_P2 nvarchar(4000)
	Declare @Cadena_T1 nvarchar(4000),@Cadena_T2 nvarchar(4000),@Cadena_T3 nvarchar(4000),@Cadena_T4 nvarchar(4000),@Cadena_T5 nvarchar(4000)
	Set @Tot_P1 = '''' Set @Tot_P2 = '''' Set @Tot1_P1 = '''' Set @Tot1_P2 = '''' 
	Set @Cadena_T1 = '''' Set @Cadena_T2 = '''' Set @Cadena_T3 = '''' Set @Cadena_T4 = '''' Set @Cadena_T5 = '''' 
	'

Set @SQL3_2 =
	'
	if(@N1 = ''1'')
	begin
		Set @Part11_N1 = '' Select 1 as ind, left(v.NroCta,2) as NroCta,p.NomCta''
		Set @Part21_N1 = ''	,'''''''' as Total
					From Voucher v 
				left join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=left(v.NroCta,2)
				where v.RucE=''''''+@RucE+'''''' and v.Ejer=''''''+@Ejer+'''''' and v.IB_Anulado=0 and left(v.nroCta,''+@N_Min+'') in (select p.NroCta from PlanCtas p where p.RucE=''''''+@RucE+'''''' and p.Ejer=''''''+@Ejer+'''''' and p.IC_IE'+@opc+'=''''I'''' Group by p.NroCta)
				and v.Prdo between ''''''+@Prdo1+'''''' and ''''''+@Prdo2+''''''
			      	Group by left(v.NroCta,2),p.NomCta
			      	''		

		Set @Part1_N1 = '' Select 1 as ind, left(v.NroCta,2) as NroCta,p.NomCta''
		Set @Part2_N1 = ''	,'''''''' as Total
					From Voucher v 
				left join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=left(v.NroCta,2)
				where v.RucE=''''''+@RucE+'''''' and v.Ejer=''''''+@Ejer+'''''' and v.IB_Anulado=0 and left(v.nroCta,''+@N_Min+'') in (select p.NroCta from PlanCtas p where p.RucE=''''''+@RucE+'''''' and p.Ejer=''''''+@Ejer+'''''' and p.IC_IE'+@opc+'=''''E'''' Group by p.NroCta)
				and v.Prdo between ''''''+@Prdo1+'''''' and ''''''+@Prdo2+''''''
			      	Group by left(v.NroCta,2),p.NomCta
			      	''
	end
	'
Set @SQL4_1 =
	'
	if(@N2 = ''1'')
	begin
		if(@N1 = ''1'')
		begin	
			Set @Part11_N2 = ''UNION ALL''
			Set @Part1_N2 = ''UNION ALL''
		end 

		Set @Part11_N2 = @Part11_N2+'' Select 2 as ind,left(v.NroCta,4) as NroCTa,p.NomCta''
		Set @Part21_N2 = '' ,'''''''' as Total
				    From Voucher v 
			left join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=left(v.NroCta,4)
			where v.RucE=''''''+@RucE+'''''' and v.Ejer=''''''+@Ejer+'''''' and v.IB_Anulado=0 and left(v.nroCta,''+@N_Min+'') in (select p.NroCta from PlanCtas p where p.RucE=''''''+@RucE+'''''' and p.Ejer=''''''+@Ejer+'''''' and p.IC_IE'+@opc+'=''''I'''' Group by p.NroCta)
			and v.Prdo between ''''''+@Prdo1+'''''' and ''''''+@Prdo2+''''''
			Group by left(v.NroCta,4),p.NomCta
			''

		Set @Part1_N2 = @Part1_N2+'' Select 2 as ind,left(v.NroCta,4) as NroCTa,p.NomCta''
		Set @Part2_N2 = '' ,'''''''' as Total
				    From Voucher v 
			left join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=left(v.NroCta,4)
			where v.RucE=''''''+@RucE+'''''' and v.Ejer=''''''+@Ejer+'''''' and v.IB_Anulado=0 and left(v.nroCta,''+@N_Min+'') in (select p.NroCta from PlanCtas p where p.RucE=''''''+@RucE+'''''' and p.Ejer=''''''+@Ejer+'''''' and p.IC_IE'+@opc+'=''''E'''' Group by p.NroCta)
			and v.Prdo between ''''''+@Prdo1+'''''' and ''''''+@Prdo2+''''''
			Group by left(v.NroCta,4),p.NomCta
			''
	end
	'

Set @SQL4_2 =
	'
	if(@N3 = ''1'')
	begin
		if(@N1 = ''1'' or @N2 = ''1'')
		begin	
			Set @Part11_N3 = ''UNION ALL''
			Set @Part1_N3 = ''UNION ALL''
		end
		
		Set @Part11_N3 = @Part11_N3+'' Select 3 as ind,left(v.NroCta,6) as NroCTa,p.NomCta''
		Set @Part21_N3 = '' ,'''''''' as Total
				     From Voucher v 
			left join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=left(v.NroCta,6)
			where v.RucE=''''''+@RucE+'''''' and v.Ejer=''''''+@Ejer+'''''' and v.IB_Anulado=0 and left(v.nroCta,''+@N_Min+'') in (select p.NroCta from PlanCtas p where p.RucE=''''''+@RucE+'''''' and p.Ejer=''''''+@Ejer+'''''' and p.IC_IE'+@opc+'=''''I'''' Group by p.NroCta)
			and v.Prdo between ''''''+@Prdo1+'''''' and ''''''+@Prdo2+''''''
			Group by left(v.NroCta,6),p.NomCta
			''
 
		Set @Part1_N3 = @Part1_N3+'' Select 3 as ind,left(v.NroCta,6) as NroCTa,p.NomCta''
		Set @Part2_N3 = '' ,'''''''' as Total
				     From Voucher v 
			left join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=left(v.NroCta,6)
			where v.RucE=''''''+@RucE+'''''' and v.Ejer=''''''+@Ejer+'''''' and v.IB_Anulado=0 and left(v.nroCta,''+@N_Min+'') in (select p.NroCta from PlanCtas p where p.RucE=''''''+@RucE+'''''' and p.Ejer=''''''+@Ejer+'''''' and p.IC_IE'+@opc+'=''''E'''' Group by p.NroCta)
			and v.Prdo between ''''''+@Prdo1+'''''' and ''''''+@Prdo2+''''''
			Group by left(v.NroCta,6),p.NomCta
			''
	end
	'

Set @SQL5_1 = 
	'
	if(@N4 = ''1'')
	begin
		if(@N1 = ''1'' or @N2 = ''1'' or @N3 = ''1'')
		begin	
			Set @Part11_N4 = ''UNION ALL''
			Set @Part1_N4 = ''UNION ALL''
		end 

		Set @Part11_N4 = @Part11_N4 +'' Select 4 as ind,v.NroCta,p.NomCta''
		Set @Part21_N4 = '' ,'''''''' as Total
				     From Voucher v 
			left join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
			where v.RucE=''''''+@RucE+'''''' and v.Ejer=''''''+@Ejer+'''''' and v.IB_Anulado=0 and left(v.nroCta,9) in (select p.NroCta from PlanCtas p where p.RucE=''''''+@RucE+'''''' and p.Ejer=''''''+@Ejer+'''''' and p.IC_IE'+@opc+'=''''I'''' Group by p.NroCta)
			and v.Prdo between ''''''+@Prdo1+'''''' and ''''''+@Prdo2+''''''
			Group by v.NroCta,p.NomCta
			''
	'

Set @SQL5_2 =
	'
		Set @Part1_N4 = @Part1_N4 +'' Select 4 as ind,v.NroCta,p.NomCta''
		Set @Part2_N4 = '' ,'''''''' as Total
				     From Voucher v 
			left join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
			where v.RucE=''''''+@RucE+'''''' and v.Ejer=''''''+@Ejer+'''''' and v.IB_Anulado=0 and left(v.nroCta,9) in (select p.NroCta from PlanCtas p where p.RucE=''''''+@RucE+'''''' and p.Ejer=''''''+@Ejer+'''''' and p.IC_IE'+@opc+'=''''E'''' Group by p.NroCta)
			and v.Prdo between ''''''+@Prdo1+'''''' and ''''''+@Prdo2+''''''
			Group by v.NroCta,p.NomCta
			''
	end
	'
Set @SQL5_3 =
	'
	if(@N1 = ''1'')
	Begin
		Set @Cadena_N1_P1 = left(@Cadena_P1,len(@Cadena_P1))
		Set @Cadena_N1_P2 = left(@Cadena_P2,len(@Cadena_P2))
		Set @Cadena_N1_P3 = left(@Cadena_P3,len(@Cadena_P3))
		Set @Cadena_N1_P4 = left(@Cadena_P4,len(@Cadena_P4))
		Set @Cadena_N1_P5 = left(@Cadena_P5,len(@Cadena_P5))
	End
	if(@N2 = ''1'')
	Begin
		Set @Cadena_N2_P1 = left(@Cadena_P1,len(@Cadena_P1))
		Set @Cadena_N2_P2 = left(@Cadena_P2,len(@Cadena_P2))
		Set @Cadena_N2_P3 = left(@Cadena_P3,len(@Cadena_P3))
		Set @Cadena_N2_P4 = left(@Cadena_P4,len(@Cadena_P4))
		Set @Cadena_N2_P5 = left(@Cadena_P5,len(@Cadena_P5))
	End
	'
Set @SQL5_4 =
	'
	if(@N3 = ''1'')
	Begin
		Set @Cadena_N3_P1 = left(@Cadena_P1,len(@Cadena_P1))
		Set @Cadena_N3_P2 = left(@Cadena_P2,len(@Cadena_P2))
		Set @Cadena_N3_P3 = left(@Cadena_P3,len(@Cadena_P3))
		Set @Cadena_N3_P4 = left(@Cadena_P4,len(@Cadena_P4))
		Set @Cadena_N3_P5 = left(@Cadena_P5,len(@Cadena_P5))
	End
	if(@N4 = ''1'')
	Begin
		Set @Cadena_N4_P1 = left(@Cadena_P1,len(@Cadena_P1))
		Set @Cadena_N4_P2 = left(@Cadena_P2,len(@Cadena_P2))
		Set @Cadena_N4_P3 = left(@Cadena_P3,len(@Cadena_P3))
		Set @Cadena_N4_P4 = left(@Cadena_P4,len(@Cadena_P4))
		Set @Cadena_N4_P5 = left(@Cadena_P5,len(@Cadena_P5))
	End
	'

Set @SQL6 = 
	'
	Set @Tot1_P1 = '' UNION ALL 
			Select 5 as ind,''''RESULTADO'''' as NroCta,''''TOTAL DE INGRESO'''' as NomCta''
	Set @Tot1_P2 = '' ,'''''''' as Total
			   From Voucher v 
			where v.RucE=''''''+@RucE+'''''' and v.Ejer=''''''+@Ejer+'''''' and v.IB_Anulado=0 and left(v.nroCta,''+@N_Min+'') in (select p.NroCta from PlanCtas p where p.RucE=''''''+@RucE+'''''' and p.Ejer=''''''+@Ejer+'''''' and p.IC_IE'+@opc+'=''''I'''' Group by p.NroCta)
			and v.Prdo between ''''''+@Prdo1+'''''' and ''''''+@Prdo2+''''''
			''

	Set @Tot_P1 = '' UNION ALL 
			Select 5 as ind,''''RESULTADO'''' as NroCta,''''TOTAL DE EGRESO'''' as NomCta''
	Set @Tot_P2 = '' ,'''''''' as Total
			   From Voucher v 
			where v.RucE=''''''+@RucE+'''''' and v.Ejer=''''''+@Ejer+'''''' and v.IB_Anulado=0 and left(v.nroCta,''+@N_Min+'') in (select p.NroCta from PlanCtas p where p.RucE=''''''+@RucE+'''''' and p.Ejer=''''''+@Ejer+'''''' and p.IC_IE'+@opc+'=''''E'''' Group by p.NroCta)
			and v.Prdo between ''''''+@Prdo1+'''''' and ''''''+@Prdo2+''''''
			''
	Set @Cadena_T1 = left(@Cadena_P1,len(@Cadena_P1))
	Set @Cadena_T2 = left(@Cadena_P2,len(@Cadena_P2))
	Set @Cadena_T3 = left(@Cadena_P3,len(@Cadena_P3))
	Set @Cadena_T4 = left(@Cadena_P4,len(@Cadena_P4))
	Set @Cadena_T5 = left(@Cadena_P5,len(@Cadena_P5))
	'

Set @SQL7_1 =
	'
	Print ''---- Imprimimos parte 1 (INGRESOS) a ejecutar -----PV''
	Print ''''

	Print ''(''
	Print @Part11_N1
	Print @Cadena_N1_P1
	Print @Cadena_N1_P2
	Print @Cadena_N1_P3
	Print @Cadena_N1_P4
	Print @Cadena_N1_P5
	Print @Part21_N1
	Print @Part11_N2
	Print @Cadena_N2_P1
	Print @Cadena_N2_P2
	Print @Cadena_N2_P3
	Print @Cadena_N2_P4
	Print @Cadena_N2_P5
	Print @Part21_N2
	Print @Part11_N3
	Print @Cadena_N3_P1
	Print @Cadena_N3_P2
	Print @Cadena_N3_P3
	Print @Cadena_N3_P4
	Print @Cadena_N3_P5
	Print @Part21_N3
	Print @Part11_N4
	Print @Cadena_N4_P1
	Print @Cadena_N4_P2
	Print @Cadena_N4_P3
	Print @Cadena_N4_P4
	Print @Cadena_N4_P5
	Print @Part21_N4
	Print @Tot1_P1
	Print @Cadena_T1
	Print @Cadena_T2
	Print @Cadena_T3
	Print @Cadena_T4
	Print @Cadena_T5
	Print @Tot1_P2
	Print '') Order by 2,1''
	'
Set @SQL7_2 =
	'
	Print ''---- Ejecutamos parte 1 (INGRESOS) -----PV''
	Print ''''
	
	Exec (''(''+@Part11_N1
		+@Cadena_N1_P1+@Cadena_N1_P2+@Cadena_N1_P3+@Cadena_N1_P4+@Cadena_N1_P5+''
	''+@Part21_N1
	      +@Part11_N2
		+@Cadena_N2_P1+@Cadena_N2_P2+@Cadena_N2_P3+@Cadena_N2_P4+@Cadena_N2_P5+''
	''+@Part21_N2
	      +@Part11_N3
		+@Cadena_N3_P1+@Cadena_N3_P2+@Cadena_N3_P3+@Cadena_N3_P4+@Cadena_N3_P5+''
	''+@Part21_N3
	      +@Part11_N4
		+@Cadena_N4_P1+@Cadena_N4_P2+@Cadena_N4_P3+@Cadena_N4_P4+@Cadena_N4_P5+''
	''+@Part21_N4+''
		''+@Tot1_P1
			+@Cadena_T1+@Cadena_T2+@Cadena_T3+@Cadena_T4+@Cadena_T5+''
		''+@Tot1_P2+'') Order by 2,1'')

	Print ''''
	Print ''''
	'
Set @SQL7_3 =
	'
	Print ''---- Imprimimos parte 2 (EGRESOS) a ejecutar -----PV''
	Print ''''

	Print ''(''
	Print @Part1_N1
	Print @Cadena_N1_P1
	Print @Cadena_N1_P2
	Print @Cadena_N1_P3
	Print @Cadena_N1_P4
	Print @Cadena_N1_P5
	Print @Part2_N1
	Print @Part1_N2
	Print @Cadena_N2_P1
	Print @Cadena_N2_P2
	Print @Cadena_N2_P3
	Print @Cadena_N2_P4
	Print @Cadena_N2_P5
	Print @Part2_N2
	Print @Part1_N3
	Print @Cadena_N3_P1
	Print @Cadena_N3_P2
	Print @Cadena_N3_P3
	Print @Cadena_N3_P4
	Print @Cadena_N3_P5
	Print @Part2_N3
	Print @Part1_N4
	Print @Cadena_N4_P1
	Print @Cadena_N4_P2
	Print @Cadena_N4_P3
	Print @Cadena_N4_P4
	Print @Cadena_N4_P5
	Print @Part2_N4
	Print @Tot_P1
	Print @Cadena_T1
	Print @Cadena_T2
	Print @Cadena_T3
	Print @Cadena_T4
	Print @Cadena_T5
	Print @Tot_P2
	Print '') Order by 2,1''
	'
Set @SQL7_4 =
	'
	Print ''---- Ejecutamos parte 2 (EGRESOS) -----PV''
	Print ''''

	Exec (''(''+@Part1_N1
		+@Cadena_N1_P1+@Cadena_N1_P2+@Cadena_N1_P3+@Cadena_N1_P4+@Cadena_N1_P5+''
	''+@Part2_N1
	      +@Part1_N2
		+@Cadena_N2_P1+@Cadena_N2_P2+@Cadena_N2_P3+@Cadena_N2_P4+@Cadena_N2_P5+''
	''+@Part2_N2
	      +@Part1_N3
		+@Cadena_N3_P1+@Cadena_N3_P2+@Cadena_N3_P3+@Cadena_N3_P4+@Cadena_N3_P5+''
	''+@Part2_N3
	      +@Part1_N4
		+@Cadena_N4_P1+@Cadena_N4_P2+@Cadena_N4_P3+@Cadena_N4_P4+@Cadena_N4_P5+''
	''+@Part2_N4+''
		''+@Tot_P1
			+@Cadena_T1+@Cadena_T2+@Cadena_T3+@Cadena_T4+@Cadena_T5+''
		''+@Tot_P2+'') Order by 2,1'')
	'


PRINT @SQL1
PRINT @SQL2_1
PRINT @SQL2_2
PRINT @SQL2_3
PRINT @SQL3_1
PRINT @SQL3_2
PRINT @SQL4_1
PRINT @SQL4_2
PRINT @SQL5_1
PRINT @SQL5_2
PRINT @SQL5_3
PRINT @SQL5_4
PRINT @SQL6
PRINT @SQL7_1
PRINT @SQL7_2
PRINT @SQL7_3
PRINT @SQL7_4


PRINT '-------------- EJECUTAMOS VARIABLES - SP -------------- PV' --pv
PRINT ''
PRINT ''
PRINT ''

EXEC(@SQL1+@SQL2_1+@SQL2_2+@SQL2_3+@SQL3_1+@SQL3_2+@SQL4_1+@SQL4_2+@SQL5_1+@SQL5_2+@SQL5_3+@SQL5_4+@SQL6+@SQL7_1+@SQL7_2+@SQL7_3+@SQL7_4)

--Salida emergencia --PV - 10:30PM  :(
exec('Select Cd_CC,NCorto,Descrip From CCostos Where RucE='''+@RucE+''' and Cd_CC in ('+@Datos+')')

/*
--PRUEBAS PV
select * from CCostos where ruce ='11111111111'
select * from CCSub where ruce ='11111111111' and Cd_CC='A'
01010101
select * from PlanCtas where RucE='20101949461' and NroCta='91.1.1.10'
select * from PlanCtas where RucE='20101949461' and NroCta='91.1'
select * from PlanCtas where RucE='20101949461' and NroCta='91'

exec Rpt_Ingreso_Egreso_CC '11111111111','2010','06','06',1,0,0,1,'01','N','''0001''',null
exec Rpt_Ingreso_Egreso_CC '11111111111','2010','06','06',1,0,0,1,'01','N','''01010101''',null
exec Rpt_Ingreso_Egreso_CC '11111111111','2010','06','06',1,0,0,1,'01','N','''A''',null
exec Rpt_Ingreso_Egreso_CC '11111111111','2010','06','06',1,0,0,1,'01','N','''A'',''A01''',null

exec Rpt_Ingreso_Egreso_SC '11111111111','2010','06','06',1,0,0,1,'01','N','A','''01010101''',null
exec Rpt_Ingreso_Egreso_SC '11111111111','2010','06','06',1,0,0,1,'01','N','A','''A1''',null
exec Rpt_Ingreso_Egreso_SC '11111111111','2010','06','06',1,0,0,1,'01','N','A','''A1'',''01010101''',null

*/




/*
-- PRUEBAS EN OSIRIS
select * from Empresa where Ruc='20101949461'
select * from PlanCtas where RucE='20101949461' and NroCta='91'
select * from PlanCtas where RucE='20101949461' and NroCta='91.3'
select * from PlanCtas where RucE='20101949461' and NroCta='91.1.1.10'

select * from PlanCtas where RucE='20101949461' and NroCta='70'

update PlanCtas set IC_IEN='I' where RucE='20101949461' and NroCta='70'
update PlanCtas set IC_IEN='E' where RucE='20101949461' and NroCta='91.1.1.10'
update PlanCtas set IC_IEN='E' where RucE='20101949461' and NroCta='91.3'
update PlanCtas set IC_IEN='E' where RucE='20101949461' and NroCta='91.1'
update PlanCtas set IC_IEN='E' where RucE='20101949461' and NroCta='91.4'
update PlanCtas set IC_IEN='E' where RucE='20101949461' and NroCta='91.5'

update PlanCtas set IC_IEN=null where RucE='20101949461' and NroCta='70'
update PlanCtas set IC_IEN=null where RucE='20101949461' and NroCta='91.1.1.10'
update PlanCtas set IC_IEN=null where RucE='20101949461' and NroCta='91.3'
update PlanCtas set IC_IEN=null where RucE='20101949461' and NroCta='91.1'

update PlanCtas set IC_IEN=null where RucE='20101949461' and NroCta='91.1.1.10'

select * from CCostos where ruce ='20101949461'
select * from CCSub where ruce ='20101949461' and Cd_CC='13'

exec Rpt_Ingreso_Egreso_CC '20101949461','2010','00','04',1,0,0,1,'01','N','''13''',null

*/




-- Leyenda --

-- DI 14/12/09 : Creacion del procedimiento almacenado
-- PV 28/06/10 : Mdf:  No sacaba bien el saldo (Debe-Haber)*-1
-- PV 06/07/10 : Mdf:  Sumatorias Totales no sumaban bien, No se tenia en cuenta IC_IEN , se agrego @N_Min, Comentarios
-- PV 20/08/2010 : Mdf: se agrego exec('Select Cd_CC,NCorto From CCostos Where RucE='''+@RucE+''' and Cd_CC in ('+@Datos+')') (para obtener el orden de los CC) -- Emergencia
-- DI 24/01/2011 : Mdf: se agrego año a los plan de cuentas
GO

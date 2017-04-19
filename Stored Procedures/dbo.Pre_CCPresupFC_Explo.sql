SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Pre_CCPresupFC_Explo]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),
@Cadena nvarchar(2000),
@Moneda nvarchar(1),
@EsXCta bit,
@CcAll bit,
@ScAll bit,
@SsAll bit,

@msj varchar(100) output

AS

/*
Declare @RucE nvarchar(11)
Declare @Ejer nvarchar(4)
Declare @PrdoD nvarchar(2)
Declare @PrdoH nvarchar(2)
Declare @Cd_CC varchar(8)
Declare @Cd_SC varchar(8)
Declare @Cd_SS varchar(8)
Declare @Cadena nvarchar(2000)
Declare @Moneda nvarchar(1)
Declare @EsXCta bit
Declare @CcAll bit
Declare @ScAll bit
Declare @SsAll bit

Set @RucE='11111111111'
Set @Ejer='2010'
Set @PrdoD='01'
Set @PrdoH='03'
Set @Cd_CC='0003'
Set @Cd_SC=null
Set @Cd_SS=null
Set @Cadena=''
Set @Moneda='s'
Set @EsXCta='1'
Set @CcAll='0'
Set @ScAll='0'
Set @SsAll='0'
*/

--Select * from Voucher where RucE='11111111111' and Ejer='2010' and Prdo between '01' and '03' and Cd_CC='0003' and NroCta in ('63.0.0.01')


--************************* Armando la condicion *************************--

if (@Cd_CC is null) Set @Cd_CC = ''
if (@Cd_SC is null) Set @Cd_SC = ''
if (@Cd_SS is null) Set @Cd_SS = ''

Declare @Condicion nvarchar(4000), @esCC bit, @esSC bit, @esSS bit
Set @Condicion = '' 	-- Cadena de condicion
Set @esCC=0  		-- Mostrar CC
Set @esSC=0 		-- Mostrar SC
Set @esSS=0		-- Mostrar SS

If (isnull(@Cd_CC,'') <> '') -- Si cantidad CC = 1
Begin
	Set @Condicion = ' And p.Cd_CC='''+@Cd_CC+'''' -- Definiendo un CC a la condicion
	Set @esCC=1
	If (isnull(@Cd_SC,'') <> '') -- Si cantidad SC = 1
	Begin
		Set @Condicion = @Condicion + ' And p.Cd_SC='''+@Cd_SC+'''' -- Definiendo un SC a la condicion
		Set @esSC=1
		If (isnull(@Cd_SS,'') <> '') -- Si cantidad SS = 1
		Begin
			Set @Condicion = @Condicion + ' And p.Cd_SS='''+@Cd_SS+'''' -- Definiendo un SS a la condicion
			Set @esSS=1
		End
		Else Begin
			If (isnull(@Cadena,'') <> '') -- Si cantidad SC > 1
			Begin
				Set @Condicion = @Condicion + ' And p.Cd_SS in ('+@Cadena+')' -- Definiendo  mas de un SS a la condicion
				Set @esSS=1
			End
			Else Begin
				if(@SsAll=1)
					Set @esSS=1
			End
		End
	End
	Else Begin
		If (isnull(@Cadena,'') <> '') -- Si cantidad SC > 1
		Begin
			Set @Condicion = @Condicion + ' And p.Cd_SC in ('+@Cadena+')' -- Definiendo  mas de un SC a la condicion
			Set @esSC=1
			if(@SsAll=1)
				Set @esSS=1
		End
		Else Begin
			if(@ScAll=1)
			Begin
				Set @esSC=1
				if(@SsAll=1)
					Set @esSS=1
			End
		End
	End
End
Else Begin
	If (isnull(@Cadena,'') <> '') -- Si cantidad CC > 1
	Begin
		Set @Condicion = @Condicion + ' And p.Cd_CC in ('+@Cadena+')' -- Definiendo mas de un CC a la condicion	
		Set @esCC=1
		if(@ScAll=1)
		Begin
			Set @esSC=1
			if(@SsAll=1)
				Set @esSS=1
		End
	End
	Else Begin
		if(@CcAll=1)
		Begin	
			Set @esCC=1
			if(@ScAll=1)
			Begin
				Set @esSC=1
				if(@SsAll=1)
					Set @esSS=1
			End
		End
	End
End

Print 'Condicion : '+@Condicion
Print 'Estado CC : '+Convert(nvarchar,@esCC)
Print 'Estado SC : '+Convert(nvarchar,@esSC)
Print 'Estado SS : '+Convert(nvarchar,@esSS)

--************************************************************************--

--************************* Armando las columnas *************************--
Declare @Mda nvarchar(3)
Set @Mda = Case when @Moneda='d' then '_ME' else '' end

Declare @ColumnasP nvarchar(4000),@ColumnasE nvarchar(4000),@ColumnasPT nvarchar(4000),@ColumnasET nvarchar(4000), @i int, @n int
Declare @SelectP nvarchar(4000), @SelectE nvarchar(4000),@SelectD nvarchar(4000),@SelectPT nvarchar(4000), @SelectET nvarchar(4000), @SelectDT nvarchar(4000), @GroupColum nvarchar(4000), @GroupColumT nvarchar(4000)

Set @ColumnasP='' 
Set @ColumnasE='' 
Set @SelectP='' 
Set @SelectE='' 
Set @SelectD='' 
Set @GroupColum=''

Set @ColumnasPT='' 
Set @ColumnasET=''
Set @SelectPT='' 
Set @SelectET='' 
Set @SelectDT='' 
Set @GroupColumT=''

Set @i=Convert(int,@PrdoD)
Set @n=Convert(int,@PrdoH)

--Para obtener los meses --> User123.DameFormPrdo(periodo,Con_mayuscula,En_abreviado)
while(@i <= @n)
Begin
	/*Columnas Presupuestadas*/
	Set @ColumnasP = @ColumnasP +',p.'+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+@Mda+' As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_P'
	/*Seleccion de Columnas Presupuestado*/
	Set @SelectP = @SelectP +',Sum('+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_P) As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_P'
	/*Columnas Ejecutadas*/
	Set @ColumnasE = @ColumnasE +',Sum(Case When e.Prdo='''+right('00'+ltrim(@i),2)+''' Then e.MtoD'+@Mda+'-e.MtoH'+@Mda+' Else 0.00 End ) As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_E'
	/*Seleccion de Columnas Ejecutadas*/
	Set @SelectE = @SelectE + +',Sum('+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_E) As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_E'
	/*Diferencia (Presupuestado - Ejecutado)*/
	Set @SelectD = @SelectD +',Sum('+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_P)-Case When Sum('+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_E) > 0 Then Sum('+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_E) Else Sum('+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_E)*-1 End As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_D'
	/*Columnas para el group by*/
	Set @GroupColum = @GroupColum + ',p.'+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+@Mda


	/*Total Columnas Presupuestadas*/
	Set @ColumnasPT = @ColumnasPT +'p.'+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+@Mda+'+'
	/*Total Columnas Ejecutadas*/
	Set @ColumnasET = @ColumnasET +'Case When e.Prdo='''+right('00'+ltrim(@i),2)+''' Then e.MtoD'+@Mda+'-e.MtoH'+@Mda+' Else 0.00 End +'
	/*Total Columnas para el group by*/
	Set @GroupColumT = @GroupColumT + 'p.'+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+@Mda+'+'

	Set @i=@i+1
End
Set @ColumnasPT = ','+left(@ColumnasPT,len(@ColumnasPT)-1)+' As Total_P'
Set @ColumnasET = ',Sum('+left(@ColumnasET,len(@ColumnasET)-1)+') As Total_E'
Set @SelectDT =  ',Sum(Total_P)- Case When Sum(Total_E)>0 Then Sum(Total_E) Else Sum(Total_E)*-1 End As Total_D'
Set @SelectPT =  ',Sum(Total_P) As Total_P'
Set @SelectET =  ',Sum(Total_E) As Total_E'
Set @GroupColumT = ','+left(@GroupColumT,len(@GroupColumT)-1)

Print 'Columnas Presupuestadas : '+@ColumnasP
Print 'Seleccion Prespuestadas : '+@SelectP
Print 'Columnas Ejecutadas : '+@ColumnasE
Print 'Seleccion Ejecutadas : '+@SelectE
Print 'Columnas Diferencia : '+@SelectD
Print 'Columnas Group By: '+@GroupColum

Print 'Total Presupuestadas : '+@ColumnasPT
Print 'Total Seleccion Pre  : '+@SelectPT
Print 'Total Columnas Ejecu : '+@ColumnasET
Print 'Total Seleccion Ejec : '+@SelectET
Print 'Total Columnas Difer : '+@SelectDT
Print 'Total Columnas Group : '+@GroupColumT

--************************************************************************--


Declare @P1_SQL_CC nvarchar(4000), @P2_SQL_CC nvarchar(4000), @P3_SQL_CC nvarchar(4000), @P4_SQL_CC nvarchar(4000), @P5_SQL_CC nvarchar(4000)
Declare @P1_SQL_CC_Cta nvarchar(4000), @P2_SQL_CC_Cta nvarchar(4000), @P3_SQL_CC_Cta nvarchar(4000), @P4_SQL_CC_Cta nvarchar(4000), @P5_SQL_CC_Cta nvarchar(4000)
Declare @P1_SQL_SC nvarchar(4000), @P2_SQL_SC nvarchar(4000), @P3_SQL_SC nvarchar(4000), @P4_SQL_SC nvarchar(4000), @P5_SQL_SC nvarchar(4000)
Declare @P1_SQL_SC_Cta nvarchar(4000), @P2_SQL_SC_Cta nvarchar(4000), @P3_SQL_SC_Cta nvarchar(4000), @P4_SQL_SC_Cta nvarchar(4000), @P5_SQL_SC_Cta nvarchar(4000)
Declare @P1_SQL_SS nvarchar(4000), @P2_SQL_SS nvarchar(4000), @P3_SQL_SS nvarchar(4000), @P4_SQL_SS nvarchar(4000), @P5_SQL_SS nvarchar(4000)
Declare @P1_SQL_SS_Cta nvarchar(4000), @P2_SQL_SS_Cta nvarchar(4000), @P3_SQL_SS_Cta nvarchar(4000), @P4_SQL_SS_Cta nvarchar(4000), @P5_SQL_SS_Cta nvarchar(4000)
Set @P1_SQL_CC='' Set @P2_SQL_CC='' Set @P3_SQL_CC='' Set @P4_SQL_CC='' Set @P5_SQL_CC='' 	-- Sintaxis para CC
Set @P1_SQL_SC='' Set @P2_SQL_SC='' Set @P3_SQL_SC='' Set @P4_SQL_SC='' Set @P5_SQL_SC='' 	-- Sintaxis para SC
Set @P1_SQL_SS='' Set @P2_SQL_SS='' Set @P3_SQL_SS='' Set @P4_SQL_SS='' Set @P5_SQL_SS=''	-- Sintaxis para SS
Set @P1_SQL_CC_Cta='' Set @P2_SQL_CC_Cta='' Set @P3_SQL_CC_Cta='' Set @P4_SQL_CC_Cta='' Set @P5_SQL_CC_Cta=''		-- Sintaxis para CC con Cta
Set @P1_SQL_SC_Cta='' Set @P2_SQL_SC_Cta='' Set @P3_SQL_SC_Cta='' Set @P4_SQL_SC_Cta='' Set @P5_SQL_SC_Cta=''		-- Sintaxis para SC con Cta
Set @P1_SQL_SS_Cta='' Set @P2_SQL_SS_Cta='' Set @P3_SQL_SS_Cta='' Set @P4_SQL_SS_Cta='' Set @P5_SQL_SS_Cta=''		-- Sintaxis para SS con Cta


If (@esCC=1)
Begin
	Set @P1_SQL_CC = 
		'
		Select Cd_CC,Cd_SC,Cd_SS,NroCta,Codigo,Descrip'+@SelectP+@SelectE
	Set @P2_SQL_CC = @SelectD+@SelectPT+@SelectET+@SelectDT
	Set @P3_SQL_CC = 
		' from
		(Select	p.Cd_CC,'''' As Cd_SC,'''' As Cd_SS,'''' As NroCta,
			isnull(p.Cd_CC,'''') As Codigo,c.Descrip As Descrip
		'
	Set @P4_SQL_CC = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
	Set @P5_SQL_CC = 
		'
		From 	PresupFC p
			Inner Join CCostos c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC
			Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer 
			and case when isnull('''+@Cd_CC+''','''')='''' then '''' else e.Cd_CC end =isnull('''+@Cd_CC+''','''') 
			and case when isnull('''+@Cd_SC+''','''')='''' then '''' else e.Cd_SC end =isnull('''+@Cd_SC+''','''')
			and case when isnull('''+@Cd_SS+''','''')='''' then '''' else e.Cd_SS end =isnull('''+@Cd_SS+''','''')
			and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
		Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
			Group by p.Cd_CC,p.Cd_SC,p.Cd_SS,c.Descrip,p.NroCta'+@GroupColum+@GroupColumT+'
		) As TablaCC
		Group by Cd_CC,Cd_SC,Cd_SS,NroCta,Codigo,Descrip
		'
	If (@EsXCta=1 and @esSC=0 and @esSS=0) -- Si es con cuenta y no es SC,SS
	Begin
		
		Set @P1_SQL_CC_Cta = 
			'
			UNION ALL 
			Select Cd_CC,Cd_SC,Cd_SS,NroCta,Codigo,Descrip'+@SelectP+@SelectE
		Set @P2_SQL_CC_Cta = @SelectD+@SelectPT+@SelectET+@SelectDT
		Set @P3_SQL_CC_Cta = 
			' from
			(Select	isnull(p.Cd_CC,'''') As Cd_CC,'''' As Cd_SC,'''' As Cd_SS,p.NroCta,
				p.NroCta As Codigo,r.NomCta As Descrip
			'
		Set @P4_SQL_CC_Cta = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
		Set @P5_SQL_CC_Cta = 
			'
			From 	PresupFC p
				--Inner Join CCostos c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC
				Inner Join PlanCtas r On r.RucE=p.RucE and r.Ejer=p.Ejer and r.NroCta=p.NroCta
				Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer
				and case when isnull('''+@Cd_CC+''','''')='''' then '''' else e.Cd_CC end =isnull('''+@Cd_CC+''','''') 
				and case when isnull('''+@Cd_SC+''','''')='''' then '''' else e.Cd_SC end =isnull('''+@Cd_SC+''','''')
				and case when isnull('''+@Cd_SS+''','''')='''' then '''' else e.Cd_SS end =isnull('''+@Cd_SS+''','''')
				and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
			Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
				Group by p.Cd_CC,p.Cd_SC,p.Cd_SS,p.NroCta,r.NomCta'+@GroupColum+@GroupColumT+'
			) As TablaCC_Cta
			Group by Cd_CC,Cd_SC,Cd_SS,NroCta,Codigo,Descrip
			'
	End

	Print @P1_SQL_CC
	Print @P2_SQL_CC
	Print @P3_SQL_CC
	Print @P4_SQL_CC
	Print @P5_SQL_CC
	
	Print @P1_SQL_CC_Cta
	Print @P2_SQL_CC_Cta
	Print @P3_SQL_CC_Cta
	Print @P4_SQL_CC_Cta
	Print @P5_SQL_CC_Cta
End

If (@esSC=1)
Begin
	Set @P1_SQL_SC = ' UNION  ALL '+
		'
		Select Cd_CC,Cd_SC,Cd_SS,NroCta,Codigo,Descrip'+@SelectP+@SelectE
	Set @P2_SQL_SC = @SelectD+@SelectPT+@SelectET+@SelectDT
	Set @P3_SQL_SC = 
		' from
		(Select	p.Cd_CC,p.Cd_SC,'''' As Cd_SS,'''' As NroCta,
			isnull(p.Cd_SC,'''') As Codigo,c.Descrip As Descrip
		'
	Set @P4_SQL_SC = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
	Set @P5_SQL_SC = 
		'
		From 	PresupFC p
			Inner Join CCSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC
			Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer 
			and case when isnull('''+@Cd_CC+''','''')='''' then '''' else e.Cd_CC end =isnull('''+@Cd_CC+''','''') 
			and case when isnull('''+@Cd_SC+''','''')='''' then '''' else e.Cd_SC end =isnull('''+@Cd_SC+''','''')
			and case when isnull('''+@Cd_SS+''','''')='''' then '''' else e.Cd_SS end =isnull('''+@Cd_SS+''','''')
			and e.Cd_SC=p.Cd_SC and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
		Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
			Group by p.Cd_CC,p.Cd_SC,p.Cd_SS,c.Descrip,p.NroCta'+@GroupColum+@GroupColumT+'
		) As TablaSC
		Group by Cd_CC,Cd_SC,Cd_SS,NroCta,Codigo,Descrip
		'
	If (@EsXCta=1 and @esSS=0) -- Si es con cuenta y no es SS
	Begin
	
		Set @P1_SQL_SC_Cta = 
			' 
			UNION ALL
			Select Cd_CC,Cd_SC,Cd_SS,NroCta,Codigo,Descrip'+@SelectP+@SelectE
		Set @P2_SQL_SC_Cta = @SelectD+@SelectPT+@SelectET+@SelectDT
		Set @P3_SQL_SC_Cta = 
			' from
			(Select	isnull(p.Cd_CC,'''') As Cd_CC,isnull(p.Cd_SC,'''') As Cd_SC,'''' As Cd_SS,p.NroCta,
				p.NroCta As Codigo, r.NomCta As Descrip
			'
		Set @P4_SQL_SC_Cta = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
		Set @P5_SQL_SC_Cta = 
			'
			From 	PresupFC p
				--Inner Join CCSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC
				Inner Join PlanCtas r On r.RucE=p.RucE and r.Ejer=p.Ejer and r.NroCta=p.NroCta
				Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer
				and case when isnull('''+@Cd_CC+''','''')='''' then '''' else e.Cd_CC end =isnull('''+@Cd_CC+''','''') 
				and case when isnull('''+@Cd_SC+''','''')='''' then '''' else e.Cd_SC end =isnull('''+@Cd_SC+''','''')
				and case when isnull('''+@Cd_SS+''','''')='''' then '''' else e.Cd_SS end =isnull('''+@Cd_SS+''','''')
				and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
			Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
			Group by p.Cd_CC,p.Cd_SC,p.Cd_SS,p.NroCta,r.NomCta'+@GroupColum+@GroupColumT+'
			) As TablaSC_Cta
			Group by Cd_CC,Cd_SC,Cd_SS,NroCta,Codigo,Descrip
			'
	End

	Print @P1_SQL_SC
	Print @P2_SQL_SC
	Print @P3_SQL_SC
	Print @P4_SQL_SC
	Print @P5_SQL_SC
	
	Print @P1_SQL_SC_Cta
	Print @P2_SQL_SC_Cta
	Print @P3_SQL_SC_Cta
	Print @P4_SQL_SC_Cta
	Print @P5_SQL_SC_Cta
End


If (@esSS=1)
Begin
	Set @P1_SQL_SS = ' UNION  ALL '+
		'Select Cd_CC,Cd_SC,Cd_SS,NroCta,Codigo,Descrip'+@SelectP+@SelectE
	Set @P2_SQL_SS = @SelectD+@SelectPT+@SelectET+@SelectDT
	Set @P3_SQL_SS = 
		' from
		(Select	p.Cd_CC,p.Cd_SC,p.Cd_SS,'''' As NroCta,
			isnull(p.Cd_SS,'''') As Codigo, c.Descrip As Descrip	
		'
	Set @P4_SQL_SS = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
	Set @P5_SQL_SS = 
		'
		From 	PresupFC p
			Inner Join CCSubSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC and c.Cd_SS=p.Cd_SS
			Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer
			and case when isnull('''+@Cd_CC+''','''')='''' then '''' else e.Cd_CC end =isnull('''+@Cd_CC+''','''') 
			and case when isnull('''+@Cd_SC+''','''')='''' then '''' else e.Cd_SC end =isnull('''+@Cd_SC+''','''')
			and case when isnull('''+@Cd_SS+''','''')='''' then '''' else e.Cd_SS end =isnull('''+@Cd_SS+''','''')
			and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
		Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
		Group by p.Cd_CC,p.Cd_SC,p.Cd_SS,c.Descrip,p.NroCta'+@GroupColum+@GroupColumT+'
		) As TablaSS
		Group by Cd_CC,Cd_SC,Cd_SS,NroCta,Codigo,Descrip
		'
	If (@EsXCta=1) -- Si es con cuenta
	Begin
	
		Set @P1_SQL_SS_Cta = 
			' UNION ALL
			Select Cd_CC,Cd_SC,Cd_SS,NroCta,Codigo,Descrip'+@SelectP+@SelectE
		Set @P2_SQL_SS_Cta = @SelectD+@SelectPT+@SelectET+@SelectDT
		Set @P3_SQL_SS_Cta = 
			' from
			(Select	isnull(p.Cd_CC,'''') As Cd_CC,isnull(p.Cd_SC,'''') As Cd_SC,isnull(p.Cd_SS,'''') As Cd_SS,p.NroCta,
				p.NroCta As Codigo,r.NomCta As Descrip
			'
		Set @P4_SQL_SS_Cta = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
		Set @P5_SQL_SS_Cta =
			'
			From 	PresupFC p
				--Inner Join CCSubSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC and c.Cd_SS=p.Cd_SS
				Inner Join PlanCtas r On r.RucE=p.RucE and r.Ejer=p.Ejer and r.NroCta=p.NroCta
				Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer
				and case when isnull('''+@Cd_CC+''','''')='''' then '''' else e.Cd_CC end =isnull('''+@Cd_CC+''','''') 
				and case when isnull('''+@Cd_SC+''','''')='''' then '''' else e.Cd_SC end =isnull('''+@Cd_SC+''','''')
				and case when isnull('''+@Cd_SS+''','''')='''' then '''' else e.Cd_SS end =isnull('''+@Cd_SS+''','''')
				and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
			Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
			Group by p.Cd_CC,p.Cd_SC,p.Cd_SS,p.NroCta,r.NomCta'+@GroupColum+@GroupColumT+'
			) As TablaSS_Cta
			Group by Cd_CC,Cd_SC,Cd_SS,NroCta,Codigo,Descrip
			'
	End

	Print @P1_SQL_SS
	Print @P2_SQL_SS
	Print @P3_SQL_SS
	Print @P4_SQL_SS
	Print @P5_SQL_SS
	
	Print @P1_SQL_SS_Cta
	Print @P2_SQL_SS_Cta
	Print @P3_SQL_SS_Cta
	Print @P4_SQL_SS_Cta
	Print @P5_SQL_SS_Cta
End

if(@P1_SQL_CC+@P1_SQL_SC+@P1_SQL_SS <> '')
Begin

Exec('('+
/*PARA CC*/
@P1_SQL_CC+
@P2_SQL_CC+
@P3_SQL_CC+
@P4_SQL_CC+
@P5_SQL_CC+
@P1_SQL_CC_Cta+
@P2_SQL_CC_Cta+
@P3_SQL_CC_Cta+
@P4_SQL_CC_Cta+
@P5_SQL_CC_Cta+
/*PARA SC*/
@P1_SQL_SC+
@P2_SQL_SC+
@P3_SQL_SC+
@P4_SQL_SC+
@P5_SQL_SC+
@P1_SQL_SC_Cta+
@P2_SQL_SC_Cta+
@P3_SQL_SC_Cta+
@P4_SQL_SC_Cta+
@P5_SQL_SC_Cta+
/*PARA SS*/
@P1_SQL_SS+
@P2_SQL_SS+
@P3_SQL_SS+
@P4_SQL_SS+
@P5_SQL_SS+
@P1_SQL_SS_Cta+
@P2_SQL_SS_Cta+
@P3_SQL_SS_Cta+
@P4_SQL_SS_Cta+
@P5_SQL_SS_Cta
+') Order By 1,2,3,4')
End



-- Leyenda --
--Di : 25/01/2011 <Creacion del procedimiento almacenado>




GO

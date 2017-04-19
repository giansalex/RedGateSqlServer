SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Pre_CCPresupuestados_Explo_IE_1]

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

@TipRpt char(1),

@Nivel1 bit,
@Nivel2 bit,
@Nivel3 bit,
@Nivel4 bit,

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
Declare @Nivel1 bit
Declare @Nivel2 bit
Declare @Nivel3 bit
Declare @Nivel4 bit

Declare @TipRpt char(1)

Set @RucE='11111111111'
Set @Ejer='2011'
Set @PrdoD='01'
Set @PrdoH='01'
Set @Cd_CC=null
Set @Cd_SC=null
Set @Cd_SS=null
Set @Cadena=''
Set @Moneda='s'
Set @EsXCta='1'
Set @CcAll='1'
Set @ScAll='1'
Set @SsAll='1'
Set @Nivel1=1
Set @Nivel2=0
Set @Nivel3=0
Set @Nivel4=1
Set @TipRpt='F'
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

Declare @RptIngCC varchar(500)
Declare @RptEgrCC varchar(500)
Declare @RptIngCC_Cta1 varchar(500)
Declare @RptEgrCC_Cta1 varchar(500)
Declare @RptIngCC_Cta2 varchar(500)
Declare @RptEgrCC_Cta2 varchar(500)
Declare @RptIngCC_Cta3 varchar(500)
Declare @RptEgrCC_Cta3 varchar(500)
Declare @RptIngCC_Cta4 varchar(500)
Declare @RptEgrCC_Cta4 varchar(500)


Declare @RptIngSC varchar(500)
Declare @RptEgrSC varchar(500)
Declare @RptIngSC_Cta1 varchar(500)
Declare @RptEgrSC_Cta1 varchar(500)
Declare @RptIngSC_Cta2 varchar(500)
Declare @RptEgrSC_Cta2 varchar(500)
Declare @RptIngSC_Cta3 varchar(500)
Declare @RptEgrSC_Cta3 varchar(500)
Declare @RptIngSC_Cta4 varchar(500)
Declare @RptEgrSC_Cta4 varchar(500)

Declare @RptIngSS varchar(500)
Declare @RptEgrSS varchar(500)
Declare @RptIngSS_Cta1 varchar(500)
Declare @RptEgrSS_Cta1 varchar(500)
Declare @RptIngSS_Cta2 varchar(500)
Declare @RptEgrSS_Cta2 varchar(500)
Declare @RptIngSS_Cta3 varchar(500)
Declare @RptEgrSS_Cta3 varchar(500)
Declare @RptIngSS_Cta4 varchar(500)
Declare @RptEgrSS_Cta4 varchar(500)

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

Set @RptIngCC=''
Set @RptEgrCC=''
Set @RptIngCC_Cta1='' Set @RptIngCC_Cta2='' Set @RptIngCC_Cta3='' Set @RptIngCC_Cta4=''
Set @RptEgrCC_Cta1='' Set @RptEgrCC_Cta2='' Set @RptEgrCC_Cta3='' Set @RptEgrCC_Cta4=''

Set @RptIngSC=''
Set @RptEgrSC=''
Set @RptIngSC_Cta1=''  Set @RptIngSC_Cta2=''  Set @RptIngSC_Cta3=''  Set @RptIngSC_Cta4=''
Set @RptEgrSC_Cta1=''  Set @RptEgrSC_Cta2=''  Set @RptEgrSC_Cta3=''  Set @RptEgrSC_Cta4=''

Set @RptIngSS=''
Set @RptEgrSS=''
Set @RptIngSS_Cta1=''  Set @RptIngSS_Cta2=''  Set @RptIngSS_Cta3=''  Set @RptIngSS_Cta4=''
Set @RptEgrSS_Cta1=''  Set @RptEgrSS_Cta2=''  Set @RptEgrSS_Cta3=''  Set @RptEgrSS_Cta4=''

Set @i=Convert(int,@PrdoD)
Set @n=Convert(int,@PrdoH)

--Para obtener los meses --> User123.DameFormPrdo(periodo,Con_mayuscula,En_abreviado)
while(@i <= @n)
Begin
	/*Columnas Presupuestadas*/
	Set @ColumnasP = @ColumnasP +',isnull(p.'+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+@Mda+',0.00) As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_P'
	/*Seleccion de Columnas Presupuestado*/
	Set @SelectP = @SelectP +',Sum('+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_P) As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_P'
	/*Columnas Ejecutadas*/
	Set @ColumnasE = @ColumnasE +',Sum(Case When e.Prdo='''+right('00'+ltrim(@i),2)+''' Then e.MtoH'+@Mda+'-e.MtoD'+@Mda+' Else 0.00 End ) As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_E'
	/*Seleccion de Columnas Ejecutadas*/
	Set @SelectE = @SelectE + +',Sum('+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_E) As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_E'
	/*Diferencia (Presupuestado - Ejecutado)*/
	Set @SelectD = @SelectD +',(Sum('+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_E) - Sum('+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_P))* Case When Sum('+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_P)<0 Then 1 Else 1 end As '+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+'_D'
	/*Columnas para el group by*/
	Set @GroupColum = @GroupColum + ',p.'+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+@Mda


	/*Total Columnas Presupuestadas*/
	Set @ColumnasPT = @ColumnasPT +'p.'+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+@Mda+'+'
	/*Total Columnas Ejecutadas*/
	Set @ColumnasET = @ColumnasET +'Case When e.Prdo='''+right('00'+ltrim(@i),2)+''' Then e.MtoH'+@Mda+'-e.MtoD'+@Mda+' Else 0.00 End +'
	/*Total Columnas para el group by*/
	Set @GroupColumT = @GroupColumT + 'p.'+User123.DameFormPrdo(right('00'+ltrim(@i),2),'0','1')+@Mda+'+'
	
	Set @i=@i+1
End
Set @ColumnasPT = ',isnull('+left(@ColumnasPT,len(@ColumnasPT)-1)+',0.00) As Total_P'
Set @ColumnasET = ',Sum('+left(@ColumnasET,len(@ColumnasET)-1)+') As Total_E'
Set @SelectDT =  ',(Sum(Total_E)-Sum(Total_P)) * Case WHen Sum(Total_P)<0 Then 1 Else 1 End As Total_D'
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
Declare @P1_SQL_SC nvarchar(4000), @P2_SQL_SC nvarchar(4000), @P3_SQL_SC nvarchar(4000), @P4_SQL_SC nvarchar(4000), @P5_SQL_SC nvarchar(4000)
Declare @P1_SQL_SS nvarchar(4000), @P2_SQL_SS nvarchar(4000), @P3_SQL_SS nvarchar(4000), @P4_SQL_SS nvarchar(4000), @P5_SQL_SS nvarchar(4000)

Declare @P1_SQL_CC_Cta1 nvarchar(4000), @P2_SQL_CC_Cta1 nvarchar(4000), @P3_SQL_CC_Cta1 nvarchar(4000), @P4_SQL_CC_Cta1 nvarchar(4000), @P5_SQL_CC_Cta1 nvarchar(4000)
Declare @P1_SQL_CC_Cta2 nvarchar(4000), @P2_SQL_CC_Cta2 nvarchar(4000), @P3_SQL_CC_Cta2 nvarchar(4000), @P4_SQL_CC_Cta2 nvarchar(4000), @P5_SQL_CC_Cta2 nvarchar(4000)
Declare @P1_SQL_CC_Cta3 nvarchar(4000), @P2_SQL_CC_Cta3 nvarchar(4000), @P3_SQL_CC_Cta3 nvarchar(4000), @P4_SQL_CC_Cta3 nvarchar(4000), @P5_SQL_CC_Cta3 nvarchar(4000)
Declare @P1_SQL_CC_Cta4 nvarchar(4000), @P2_SQL_CC_Cta4 nvarchar(4000), @P3_SQL_CC_Cta4 nvarchar(4000), @P4_SQL_CC_Cta4 nvarchar(4000), @P5_SQL_CC_Cta4 nvarchar(4000)

Declare @P1_SQL_SC_Cta1 nvarchar(4000), @P2_SQL_SC_Cta1 nvarchar(4000), @P3_SQL_SC_Cta1 nvarchar(4000), @P4_SQL_SC_Cta1 nvarchar(4000), @P5_SQL_SC_Cta1 nvarchar(4000)
Declare @P1_SQL_SC_Cta2 nvarchar(4000), @P2_SQL_SC_Cta2 nvarchar(4000), @P3_SQL_SC_Cta2 nvarchar(4000), @P4_SQL_SC_Cta2 nvarchar(4000), @P5_SQL_SC_Cta2 nvarchar(4000)
Declare @P1_SQL_SC_Cta3 nvarchar(4000), @P2_SQL_SC_Cta3 nvarchar(4000), @P3_SQL_SC_Cta3 nvarchar(4000), @P4_SQL_SC_Cta3 nvarchar(4000), @P5_SQL_SC_Cta3 nvarchar(4000)
Declare @P1_SQL_SC_Cta4 nvarchar(4000), @P2_SQL_SC_Cta4 nvarchar(4000), @P3_SQL_SC_Cta4 nvarchar(4000), @P4_SQL_SC_Cta4 nvarchar(4000), @P5_SQL_SC_Cta4 nvarchar(4000)

Declare @P1_SQL_SS_Cta1 nvarchar(4000), @P2_SQL_SS_Cta1 nvarchar(4000), @P3_SQL_SS_Cta1 nvarchar(4000), @P4_SQL_SS_Cta1 nvarchar(4000), @P5_SQL_SS_Cta1 nvarchar(4000)
Declare @P1_SQL_SS_Cta2 nvarchar(4000), @P2_SQL_SS_Cta2 nvarchar(4000), @P3_SQL_SS_Cta2 nvarchar(4000), @P4_SQL_SS_Cta2 nvarchar(4000), @P5_SQL_SS_Cta2 nvarchar(4000)
Declare @P1_SQL_SS_Cta3 nvarchar(4000), @P2_SQL_SS_Cta3 nvarchar(4000), @P3_SQL_SS_Cta3 nvarchar(4000), @P4_SQL_SS_Cta3 nvarchar(4000), @P5_SQL_SS_Cta3 nvarchar(4000)
Declare @P1_SQL_SS_Cta4 nvarchar(4000), @P2_SQL_SS_Cta4 nvarchar(4000), @P3_SQL_SS_Cta4 nvarchar(4000), @P4_SQL_SS_Cta4 nvarchar(4000), @P5_SQL_SS_Cta4 nvarchar(4000)

Set @P1_SQL_CC='' Set @P2_SQL_CC='' Set @P3_SQL_CC='' Set @P4_SQL_CC='' Set @P5_SQL_CC='' 	-- Sintaxis para CC
Set @P1_SQL_SC='' Set @P2_SQL_SC='' Set @P3_SQL_SC='' Set @P4_SQL_SC='' Set @P5_SQL_SC='' 	-- Sintaxis para SC
Set @P1_SQL_SS='' Set @P2_SQL_SS='' Set @P3_SQL_SS='' Set @P4_SQL_SS='' Set @P5_SQL_SS=''	-- Sintaxis para SS

Set @P1_SQL_CC_Cta1='' Set @P2_SQL_CC_Cta1='' Set @P3_SQL_CC_Cta1='' Set @P4_SQL_CC_Cta1='' Set @P5_SQL_CC_Cta1=''		-- Sintaxis para CC con Cta
Set @P1_SQL_CC_Cta2='' Set @P2_SQL_CC_Cta2='' Set @P3_SQL_CC_Cta2='' Set @P4_SQL_CC_Cta2='' Set @P5_SQL_CC_Cta2=''		-- Sintaxis para CC con Cta
Set @P1_SQL_CC_Cta3='' Set @P2_SQL_CC_Cta3='' Set @P3_SQL_CC_Cta3='' Set @P4_SQL_CC_Cta3='' Set @P5_SQL_CC_Cta3=''		-- Sintaxis para CC con Cta
Set @P1_SQL_CC_Cta4='' Set @P2_SQL_CC_Cta4='' Set @P3_SQL_CC_Cta4='' Set @P4_SQL_CC_Cta4='' Set @P5_SQL_CC_Cta4=''		-- Sintaxis para CC con Cta

Set @P1_SQL_SC_Cta1='' Set @P2_SQL_SC_Cta1='' Set @P3_SQL_SC_Cta1='' Set @P4_SQL_SC_Cta1='' Set @P5_SQL_SC_Cta1=''		-- Sintaxis para SC con Cta
Set @P1_SQL_SC_Cta2='' Set @P2_SQL_SC_Cta2='' Set @P3_SQL_SC_Cta2='' Set @P4_SQL_SC_Cta2='' Set @P5_SQL_SC_Cta2=''		-- Sintaxis para SC con Cta
Set @P1_SQL_SC_Cta3='' Set @P2_SQL_SC_Cta3='' Set @P3_SQL_SC_Cta3='' Set @P4_SQL_SC_Cta3='' Set @P5_SQL_SC_Cta3=''		-- Sintaxis para SC con Cta
Set @P1_SQL_SC_Cta4='' Set @P2_SQL_SC_Cta4='' Set @P3_SQL_SC_Cta4='' Set @P4_SQL_SC_Cta4='' Set @P5_SQL_SC_Cta4=''		-- Sintaxis para SC con Cta

Set @P1_SQL_SS_Cta1='' Set @P2_SQL_SS_Cta1='' Set @P3_SQL_SS_Cta1='' Set @P4_SQL_SS_Cta1='' Set @P5_SQL_SS_Cta1=''		-- Sintaxis para SS con Cta
Set @P1_SQL_SS_Cta2='' Set @P2_SQL_SS_Cta2='' Set @P3_SQL_SS_Cta2='' Set @P4_SQL_SS_Cta2='' Set @P5_SQL_SS_Cta2=''		-- Sintaxis para SS con Cta
Set @P1_SQL_SS_Cta3='' Set @P2_SQL_SS_Cta3='' Set @P3_SQL_SS_Cta3='' Set @P4_SQL_SS_Cta3='' Set @P5_SQL_SS_Cta3=''		-- Sintaxis para SS con Cta
Set @P1_SQL_SS_Cta4='' Set @P2_SQL_SS_Cta4='' Set @P3_SQL_SS_Cta4='' Set @P4_SQL_SS_Cta4='' Set @P5_SQL_SS_Cta4=''		-- Sintaxis para SS con Cta

Declare @cod_x_cta1 nvarchar(500) Set @cod_x_cta1=''
Declare @cod_x_cta2 nvarchar(500) Set @cod_x_cta2=''
Declare @cod_x_cta3 nvarchar(500) Set @cod_x_cta3=''
Declare @cod_x_cta4 nvarchar(500) Set @cod_x_cta4=''

Set @cod_x_cta1='left(p.NroCta,2)'
Set @cod_x_cta2='left(p.NroCta,4)'
Set @cod_x_cta3='left(p.NroCta,6)'
Set @cod_x_cta4='p.NroCta'

If (@esCC=1)
Begin

	Set @RptIngCC = '		
						From 	Presupuesto p
						Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''I'''
	Set @RptEgrCC = ' 	
						From 	Presupuesto p
						Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''E''' 
						
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
	Set @P5_SQL_CC = -- ACA VIENE LA CONDICION DE INGRESO Y EGRESO
		'	Inner Join CCostos c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC
			Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer and isnull(e.IB_Anulado,0)<>1
			and case when isnull(p.Cd_CC,'''')='''' then '''' else e.Cd_CC end =isnull(p.Cd_CC,'''') 
			and case when isnull(p.Cd_SC,'''')='''' then '''' else e.Cd_SC end =isnull(p.Cd_SC,'''')
			and case when isnull(p.Cd_SS,'''')='''' then '''' else e.Cd_SS end =isnull(p.Cd_SS,'''')
			and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
		Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
			Group by p.Cd_CC,p.Cd_SC,p.Cd_SS,c.Descrip,p.NroCta'+@GroupColum+@GroupColumT+'
		) As TablaCC
		Group by Cd_CC,Cd_SC,Cd_SS,NroCta,Codigo,Descrip
		'
	If (@EsXCta=1 and @esSC=0 and @esSS=0) -- Si es con cuenta y no es SC,SS
	Begin
			
		if(@Nivel1=1)
		Begin
			Set @RptIngCC_Cta1 = '		
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''I'''
			Set @RptEgrCC_Cta1 = ' 	
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''E''' 
		
			Set @P1_SQL_CC_Cta1 = 
				'
				UNION ALL 
				Select Cd_CC,Cd_SC,Cd_SS,TablaCC_Cta.NroCta,Codigo,r.NomCta As Descrip'+@SelectP+@SelectE
			Set @P2_SQL_CC_Cta1 = @SelectD+@SelectPT+@SelectET+@SelectDT
			Set @P3_SQL_CC_Cta1 = 
				' from
				(Select	p.RucE,p.Ejer,isnull(p.Cd_CC,'''') As Cd_CC,'''' As Cd_SC,'''' As Cd_SS,
					'+@cod_x_cta1+' As NroCta,'+@cod_x_cta1+' As Codigo
				'
			Set @P4_SQL_CC_Cta1 = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
			Set @P5_SQL_CC_Cta1 = -- ACA VIENE LA CONDICION DE INGRESO Y EGRESO
				'	--Inner Join CCostos c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC
					Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer and isnull(e.IB_Anulado,0)<>1
					and case when isnull(p.Cd_CC,'''')='''' then '''' else e.Cd_CC end =isnull(p.Cd_CC,'''') 
					and case when isnull(p.Cd_SC,'''')='''' then '''' else e.Cd_SC end =isnull(p.Cd_SC,'''')
					and case when isnull(p.Cd_SS,'''')='''' then '''' else e.Cd_SS end =isnull(p.Cd_SS,'''')
					and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
				Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
					Group by p.RucE,p.Ejer,p.Cd_CC,p.Cd_SC,p.Cd_SS,'+@cod_x_cta1+@GroupColum+@GroupColumT+'
				) As TablaCC_Cta
					Inner Join PlanCtas r On r.RucE=TablaCC_Cta.RucE and r.Ejer=TablaCC_Cta.Ejer and r.NroCta=TablaCC_Cta.NroCta
				Group by Cd_CC,Cd_SC,Cd_SS,TablaCC_Cta.NroCta,Codigo,r.NomCta
				'
		End
		if(@Nivel2=1)
		Begin
			Set @RptIngCC_Cta2 = '		
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''I'''
			Set @RptEgrCC_Cta2 = ' 	
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''E''' 
		
			Set @P1_SQL_CC_Cta2 = 
				'
				UNION ALL 
				Select Cd_CC,Cd_SC,Cd_SS,TablaCC_Cta.NroCta,Codigo,r.NomCta As Descrip'+@SelectP+@SelectE
			Set @P2_SQL_CC_Cta2 = @SelectD+@SelectPT+@SelectET+@SelectDT
			Set @P3_SQL_CC_Cta2 = 
				' from
				(Select	p.RucE,p.Ejer,isnull(p.Cd_CC,'''') As Cd_CC,'''' As Cd_SC,'''' As Cd_SS,
					'+@cod_x_cta2+' As NroCta,'+@cod_x_cta2+' As Codigo
				'
			Set @P4_SQL_CC_Cta2 = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
			Set @P5_SQL_CC_Cta2 = -- ACA VIENE LA CONDICION DE INGRESO Y EGRESO
				'	--Inner Join CCostos c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC
					Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer and isnull(e.IB_Anulado,0)<>1
					and case when isnull(p.Cd_CC,'''')='''' then '''' else e.Cd_CC end =isnull(p.Cd_CC,'''') 
					and case when isnull(p.Cd_SC,'''')='''' then '''' else e.Cd_SC end =isnull(p.Cd_SC,'''')
					and case when isnull(p.Cd_SS,'''')='''' then '''' else e.Cd_SS end =isnull(p.Cd_SS,'''')
					and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
				Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
					Group by p.RucE,p.Ejer,p.Cd_CC,p.Cd_SC,p.Cd_SS,'+@cod_x_cta2+@GroupColum+@GroupColumT+'
				) As TablaCC_Cta
					Inner Join PlanCtas r On r.RucE=TablaCC_Cta.RucE and r.Ejer=TablaCC_Cta.Ejer and r.NroCta=TablaCC_Cta.NroCta
				Group by Cd_CC,Cd_SC,Cd_SS,TablaCC_Cta.NroCta,Codigo,r.NomCta
				'
		End
		if(@Nivel3=1)
		Begin
			Set @RptIngCC_Cta3 = '		
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''I'''
			Set @RptEgrCC_Cta3 = ' 	
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''E''' 
		
			Set @P1_SQL_CC_Cta3 = 
				'
				UNION ALL 
				Select Cd_CC,Cd_SC,Cd_SS,TablaCC_Cta.NroCta,Codigo,r.NomCta As Descrip'+@SelectP+@SelectE
			Set @P2_SQL_CC_Cta3 = @SelectD+@SelectPT+@SelectET+@SelectDT
			Set @P3_SQL_CC_Cta3 = 
				' from
				(Select	p.RucE,p.Ejer,isnull(p.Cd_CC,'''') As Cd_CC,'''' As Cd_SC,'''' As Cd_SS,
					'+@cod_x_cta3+' As NroCta,'+@cod_x_cta3+' As Codigo
				'
			Set @P4_SQL_CC_Cta3 = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
			Set @P5_SQL_CC_Cta3 = -- ACA VIENE LA CONDICION DE INGRESO Y EGRESO
				'	--Inner Join CCostos c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC
					Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer and isnull(e.IB_Anulado,0)<>1
					and case when isnull(p.Cd_CC,'''')='''' then '''' else e.Cd_CC end =isnull(p.Cd_CC,'''') 
					and case when isnull(p.Cd_SC,'''')='''' then '''' else e.Cd_SC end =isnull(p.Cd_SC,'''')
					and case when isnull(p.Cd_SS,'''')='''' then '''' else e.Cd_SS end =isnull(p.Cd_SS,'''')
					and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
				Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
					Group by p.RucE,p.Ejer,p.Cd_CC,p.Cd_SC,p.Cd_SS,'+@cod_x_cta3+@GroupColum+@GroupColumT+'
				) As TablaCC_Cta
					Inner Join PlanCtas r On r.RucE=TablaCC_Cta.RucE and r.Ejer=TablaCC_Cta.Ejer and r.NroCta=TablaCC_Cta.NroCta
				Group by Cd_CC,Cd_SC,Cd_SS,TablaCC_Cta.NroCta,Codigo,r.NomCta
				'
		End
		if(@Nivel4=1)
		Begin
			Set @RptIngCC_Cta4 = '		
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''I'''
			Set @RptEgrCC_Cta4 = ' 	
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''E''' 
		
			Set @P1_SQL_CC_Cta4 = 
				'
				UNION ALL 
				Select Cd_CC,Cd_SC,Cd_SS,TablaCC_Cta.NroCta,Codigo,r.NomCta As Descrip'+@SelectP+@SelectE
			Set @P2_SQL_CC_Cta4 = @SelectD+@SelectPT+@SelectET+@SelectDT
			Set @P3_SQL_CC_Cta4 = 
				' from
				(Select	p.RucE,p.Ejer,isnull(p.Cd_CC,'''') As Cd_CC,'''' As Cd_SC,'''' As Cd_SS,
					'+@cod_x_cta4+' As NroCta,'+@cod_x_cta4+' As Codigo
				'
			Set @P4_SQL_CC_Cta4 = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
			Set @P5_SQL_CC_Cta4 = -- ACA VIENE LA CONDICION DE INGRESO Y EGRESO
				'	--Inner Join CCostos c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC
					Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer and isnull(e.IB_Anulado,0)<>1
					and case when isnull(p.Cd_CC,'''')='''' then '''' else e.Cd_CC end =isnull(p.Cd_CC,'''') 
					and case when isnull(p.Cd_SC,'''')='''' then '''' else e.Cd_SC end =isnull(p.Cd_SC,'''')
					and case when isnull(p.Cd_SS,'''')='''' then '''' else e.Cd_SS end =isnull(p.Cd_SS,'''')
					and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
				Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
					Group by p.RucE,p.Ejer,p.Cd_CC,p.Cd_SC,p.Cd_SS,'+@cod_x_cta4+@GroupColum+@GroupColumT+'
				) As TablaCC_Cta
					Inner Join PlanCtas r On r.RucE=TablaCC_Cta.RucE and r.Ejer=TablaCC_Cta.Ejer and r.NroCta=TablaCC_Cta.NroCta
				Group by Cd_CC,Cd_SC,Cd_SS,TablaCC_Cta.NroCta,Codigo,r.NomCta
				'
		End
	End
End

If (@esSC=1)
Begin
	Set @RptIngSC = '		
						From 	Presupuesto p
						Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''I'''
	Set @RptEgrSC = ' 	
						From 	Presupuesto p
						Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''E''' 
			

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
	Set @P5_SQL_SC = -- ACA VIENE LA CONDICION DE INGRESO Y EGRESO
		'	Inner Join CCSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC
			Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer and isnull(e.IB_Anulado,0)<>1
			and case when isnull(p.Cd_CC,'''')='''' then '''' else e.Cd_CC end =isnull(p.Cd_CC,'''') 
			and case when isnull(p.Cd_SC,'''')='''' then '''' else e.Cd_SC end =isnull(p.Cd_SC,'''')
			and case when isnull(p.Cd_SS,'''')='''' then '''' else e.Cd_SS end =isnull(p.Cd_SS,'''')
			and e.Cd_SC=p.Cd_SC and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
		Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
			Group by p.Cd_CC,p.Cd_SC,p.Cd_SS,c.Descrip,p.NroCta'+@GroupColum+@GroupColumT+'
		) As TablaSC
		Group by Cd_CC,Cd_SC,Cd_SS,NroCta,Codigo,Descrip
		--Having Sum(Total_P)- Case When Sum(Total_E)>0 Then Sum(Total_E) Else Sum(Total_E)*-1 End <> 0
		'
	If (@EsXCta=1 and @esSS=0) -- Si es con cuenta y no es SS
	Begin
		If(@Nivel1=1)
		Begin
			Set @RptIngSC_Cta1 = '		
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''I'''
			Set @RptEgrSC_Cta1 = ' 	
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''E''' 
		
			Set @P1_SQL_SC_Cta1 = 
				' 
				UNION ALL
				Select Cd_CC,Cd_SC,Cd_SS,TablaSC_Cta.NroCta,Codigo,r.NomCta As Descrip'+@SelectP+@SelectE
			Set @P2_SQL_SC_Cta1 = @SelectD+@SelectPT+@SelectET+@SelectDT
			Set @P3_SQL_SC_Cta1 = 
				' from
				(Select	p.RucE,p.Ejer,isnull(p.Cd_CC,'''') As Cd_CC,isnull(p.Cd_SC,'''') As Cd_SC,'''' As Cd_SS,
					'+@cod_x_cta1+' As NroCta,'+@cod_x_cta1+' As Codigo
				'
			Set @P4_SQL_SC_Cta1 = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
			Set @P5_SQL_SC_Cta1 = -- ACA VIENE LA CONDICION DE INGRESO Y EGRESO
				'	--Inner Join CCSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC
					Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer and isnull(e.IB_Anulado,0)<>1
					and case when isnull(p.Cd_CC,'''')='''' then '''' else e.Cd_CC end =isnull(p.Cd_CC,'''') 
					and case when isnull(p.Cd_SC,'''')='''' then '''' else e.Cd_SC end =isnull(p.Cd_SC,'''')
					and case when isnull(p.Cd_SS,'''')='''' then '''' else e.Cd_SS end =isnull(p.Cd_SS,'''')
					and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
				Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
				Group by p.RucE,p.Ejer,p.Cd_CC,p.Cd_SC,p.Cd_SS,'+@cod_x_cta1+@GroupColum+@GroupColumT+'
				) As TablaSC_Cta
					Inner Join PlanCtas r On r.RucE=TablaSC_Cta.RucE and r.Ejer=TablaSC_Cta.Ejer and r.NroCta=TablaSC_Cta.NroCta
				Group by Cd_CC,Cd_SC,Cd_SS,TablaSC_Cta.NroCta,Codigo,r.NomCta
				--Having Sum(Total_P)- Case When Sum(Total_E)>0 Then Sum(Total_E) Else Sum(Total_E)*-1 End <> 0
				'
		End
		If(@Nivel2=1)
		Begin
			Set @RptIngSC_Cta2 = '		
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''I'''
			Set @RptEgrSC_Cta2 = ' 	
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''E''' 


			Set @P1_SQL_SC_Cta2 = 
				' 
				UNION ALL
				Select Cd_CC,Cd_SC,Cd_SS,TablaSC_Cta.NroCta,Codigo,r.NomCta As Descrip'+@SelectP+@SelectE
			Set @P2_SQL_SC_Cta2 = @SelectD+@SelectPT+@SelectET+@SelectDT
			Set @P3_SQL_SC_Cta2 = 
				' from
				(Select	p.RucE,p.Ejer,isnull(p.Cd_CC,'''') As Cd_CC,isnull(p.Cd_SC,'''') As Cd_SC,'''' As Cd_SS,
					'+@cod_x_cta2+' As NroCta,'+@cod_x_cta2+' As Codigo
				'
			Set @P4_SQL_SC_Cta2 = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
			Set @P5_SQL_SC_Cta2 = -- ACA VIENE LA CONDICION DE INGRESO Y EGRESO
				'	--Inner Join CCSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC
					Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer and isnull(e.IB_Anulado,0)<>1
					and case when isnull(p.Cd_CC,'''')='''' then '''' else e.Cd_CC end =isnull(p.Cd_CC,'''') 
					and case when isnull(p.Cd_SC,'''')='''' then '''' else e.Cd_SC end =isnull(p.Cd_SC,'''')
					and case when isnull(p.Cd_SS,'''')='''' then '''' else e.Cd_SS end =isnull(p.Cd_SS,'''')
					and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
				Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
				Group by p.RucE,p.Ejer,p.Cd_CC,p.Cd_SC,p.Cd_SS,'+@cod_x_cta2+@GroupColum+@GroupColumT+'
				) As TablaSC_Cta
					Inner Join PlanCtas r On r.RucE=TablaSC_Cta.RucE and r.Ejer=TablaSC_Cta.Ejer and r.NroCta=TablaSC_Cta.NroCta
				Group by Cd_CC,Cd_SC,Cd_SS,TablaSC_Cta.NroCta,Codigo,r.NomCta
				--Having Sum(Total_P)- Case When Sum(Total_E)>0 Then Sum(Total_E) Else Sum(Total_E)*-1 End <> 0
				'
		End
		If(@Nivel3=1)
		Begin
			Set @RptIngSC_Cta3 = '		
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''I'''
			Set @RptEgrSC_Cta3 = ' 	
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''E''' 

		
			Set @P1_SQL_SC_Cta3 = 
				' 
				UNION ALL
				Select Cd_CC,Cd_SC,Cd_SS,TablaSC_Cta.NroCta,Codigo,r.NomCta As Descrip'+@SelectP+@SelectE
			Set @P2_SQL_SC_Cta3 = @SelectD+@SelectPT+@SelectET+@SelectDT
			Set @P3_SQL_SC_Cta3 = 
				' from
				(Select	p.RucE,p.Ejer,isnull(p.Cd_CC,'''') As Cd_CC,isnull(p.Cd_SC,'''') As Cd_SC,'''' As Cd_SS,
					'+@cod_x_cta3+' As NroCta,'+@cod_x_cta3+' As Codigo
				'
			Set @P4_SQL_SC_Cta3 = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
			Set @P5_SQL_SC_Cta3 = -- ACA VIENE LA CONDICION DE INGRESO Y EGRESO
				'	--Inner Join CCSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC
					Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer and isnull(e.IB_Anulado,0)<>1
					and case when isnull(p.Cd_CC,'''')='''' then '''' else e.Cd_CC end =isnull(p.Cd_CC,'''') 
					and case when isnull(p.Cd_SC,'''')='''' then '''' else e.Cd_SC end =isnull(p.Cd_SC,'''')
					and case when isnull(p.Cd_SS,'''')='''' then '''' else e.Cd_SS end =isnull(p.Cd_SS,'''')
					and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
				Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
				Group by p.RucE,p.Ejer,p.Cd_CC,p.Cd_SC,p.Cd_SS,'+@cod_x_cta3+@GroupColum+@GroupColumT+'
				) As TablaSC_Cta
					Inner Join PlanCtas r On r.RucE=TablaSC_Cta.RucE and r.Ejer=TablaSC_Cta.Ejer and r.NroCta=TablaSC_Cta.NroCta
				Group by Cd_CC,Cd_SC,Cd_SS,TablaSC_Cta.NroCta,Codigo,r.NomCta
				--Having Sum(Total_P)- Case When Sum(Total_E)>0 Then Sum(Total_E) Else Sum(Total_E)*-1 End <> 0
				'
		End
		If(@Nivel4=1)
		Begin
			Set @RptIngSC_Cta4 = '		
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''I'''
			Set @RptEgrSC_Cta4 = ' 	
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''E''' 

		
			Set @P1_SQL_SC_Cta4 = 
				' 
				UNION ALL
				Select Cd_CC,Cd_SC,Cd_SS,TablaSC_Cta.NroCta,Codigo,r.NomCta As Descrip'+@SelectP+@SelectE
			Set @P2_SQL_SC_Cta4 = @SelectD+@SelectPT+@SelectET+@SelectDT
			Set @P3_SQL_SC_Cta4 = 
				' from
				(Select	p.RucE,p.Ejer,isnull(p.Cd_CC,'''') As Cd_CC,isnull(p.Cd_SC,'''') As Cd_SC,'''' As Cd_SS,
					'+@cod_x_cta4+' As NroCta,'+@cod_x_cta4+' As Codigo
				'
			Set @P4_SQL_SC_Cta4 = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
			Set @P5_SQL_SC_Cta4 = -- ACA VIENE LA CONDICION DE INGRESO Y EGRESO
				'	--Inner Join CCSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC
					Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer and isnull(e.IB_Anulado,0)<>1
					and case when isnull(p.Cd_CC,'''')='''' then '''' else e.Cd_CC end =isnull(p.Cd_CC,'''') 
					and case when isnull(p.Cd_SC,'''')='''' then '''' else e.Cd_SC end =isnull(p.Cd_SC,'''')
					and case when isnull(p.Cd_SS,'''')='''' then '''' else e.Cd_SS end =isnull(p.Cd_SS,'''')
					and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
				Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
				Group by p.RucE,p.Ejer,p.Cd_CC,p.Cd_SC,p.Cd_SS,'+@cod_x_cta4+@GroupColum+@GroupColumT+'
				) As TablaSC_Cta
					Inner Join PlanCtas r On r.RucE=TablaSC_Cta.RucE and r.Ejer=TablaSC_Cta.Ejer and r.NroCta=TablaSC_Cta.NroCta
				Group by Cd_CC,Cd_SC,Cd_SS,TablaSC_Cta.NroCta,Codigo,r.NomCta
				--Having Sum(Total_P)- Case When Sum(Total_E)>0 Then Sum(Total_E) Else Sum(Total_E)*-1 End <> 0
				'
		End
	End

End


If (@esSS=1)
Begin

	Set @RptIngSS = '		
						From 	Presupuesto p
						Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''I'''
	Set @RptEgrSS = ' 	
						From 	Presupuesto p
						Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''E''' 
		

	Set @P1_SQL_SS = ' UNION  ALL '+
		'Select Cd_CC,Cd_SC,Cd_SS,NroCta,Codigo,Descrip'+@SelectP+@SelectE
	Set @P2_SQL_SS = @SelectD+@SelectPT+@SelectET+@SelectDT
	Set @P3_SQL_SS = 
		' from
		(Select	p.Cd_CC,p.Cd_SC,p.Cd_SS,'''' As NroCta,
			isnull(p.Cd_SS,'''') As Codigo, c.Descrip As Descrip	
		'
	Set @P4_SQL_SS = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
	Set @P5_SQL_SS = -- ACA VIENE LA CONDICION DE INGRESO Y EGRESO
		'	Inner Join CCSubSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC and c.Cd_SS=p.Cd_SS
			Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer and isnull(e.IB_Anulado,0)<>1
			and case when isnull(p.Cd_CC,'''')='''' then '''' else e.Cd_CC end =isnull(p.Cd_CC,'''') 
			and case when isnull(p.Cd_SC,'''')='''' then '''' else e.Cd_SC end =isnull(p.Cd_SC,'''')
			and case when isnull(p.Cd_SS,'''')='''' then '''' else e.Cd_SS end =isnull(p.Cd_SS,'''')
			and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
		Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
		Group by p.Cd_CC,p.Cd_SC,p.Cd_SS,c.Descrip,p.NroCta'+@GroupColum+@GroupColumT+'
		) As TablaSS
		Group by Cd_CC,Cd_SC,Cd_SS,NroCta,Codigo,Descrip
		--Having Sum(Total_P)- Case When Sum(Total_E)>0 Then Sum(Total_E) Else Sum(Total_E)*-1 End <> 0
		'
	If (@EsXCta=1) -- Si es con cuenta
	Begin
		If(@Nivel1=1)
		Begin
			Set @RptIngSS_Cta1 = '		
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''I'''
			Set @RptEgrSS_Cta1 = ' 	
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''E''' 

			Set @P1_SQL_SS_Cta1 = 
				' UNION ALL
				Select Cd_CC,Cd_SC,Cd_SS,TablaSS_Cta.NroCta,Codigo,r.NomCta As Descrip'+@SelectP+@SelectE
			Set @P2_SQL_SS_Cta1 = @SelectD+@SelectPT+@SelectET+@SelectDT
			Set @P3_SQL_SS_Cta1 = 
				' from
				(Select	p.RucE,p.Ejer,isnull(p.Cd_CC,'''') As Cd_CC,isnull(p.Cd_SC,'''') As Cd_SC,isnull(p.Cd_SS,'''') As Cd_SS,
					'+@cod_x_cta1+' As NroCta,'+@cod_x_cta1+' As Codigo
				'
			Set @P4_SQL_SS_Cta1 = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
			Set @P5_SQL_SS_Cta1 = -- ACA VIENE LA CONDICION DE INGRESO Y EGRESO
				'	--Inner Join CCSubSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC and c.Cd_SS=p.Cd_SS
					Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer and isnull(e.IB_Anulado,0)<>1
					and case when isnull(p.Cd_CC,'''')='''' then '''' else e.Cd_CC end =isnull(p.Cd_CC,'''') 
					and case when isnull(p.Cd_SC,'''')='''' then '''' else e.Cd_SC end =isnull(p.Cd_SC,'''')
					and case when isnull(p.Cd_SS,'''')='''' then '''' else e.Cd_SS end =isnull(p.Cd_SS,'''')
					and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
				Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
				Group by p.RucE,p.Ejer,p.Cd_CC,p.Cd_SC,p.Cd_SS,'+@cod_x_cta1+@GroupColum+@GroupColumT+'
				) As TablaSS_Cta
				Inner Join PlanCtas r On r.RucE=TablaSS_Cta.RucE and r.Ejer=TablaSS_Cta.Ejer and r.NroCta=TablaSS_Cta.NroCta
				Group by Cd_CC,Cd_SC,Cd_SS,TablaSS_Cta.NroCta,Codigo,r.NomCta
				--Having Sum(Total_P)- Case When Sum(Total_E)>0 Then Sum(Total_E) Else Sum(Total_E)*-1 End <> 0
				'
		End
		If(@Nivel2=1)
		Begin
			Set @RptIngSS_Cta2 = '		
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''I'''
			Set @RptEgrSS_Cta2 = ' 	
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''E''' 

		
			Set @P1_SQL_SS_Cta2 = 
				' UNION ALL
				Select Cd_CC,Cd_SC,Cd_SS,TablaSS_Cta.NroCta,Codigo,r.NomCta As Descrip'+@SelectP+@SelectE
			Set @P2_SQL_SS_Cta2 = @SelectD+@SelectPT+@SelectET+@SelectDT
			Set @P3_SQL_SS_Cta2 = 
				' from
				(Select	p.RucE,p.Ejer,isnull(p.Cd_CC,'''') As Cd_CC,isnull(p.Cd_SC,'''') As Cd_SC,isnull(p.Cd_SS,'''') As Cd_SS,
					'+@cod_x_cta2+' As NroCta,'+@cod_x_cta2+' As Codigo
				'
			Set @P4_SQL_SS_Cta2 = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
			Set @P5_SQL_SS_Cta2 = -- ACA VIENE LA CONDICION DE INGRESO Y EGRESO
				'	--Inner Join CCSubSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC and c.Cd_SS=p.Cd_SS
					Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer and isnull(e.IB_Anulado,0)<>1
					and case when isnull(p.Cd_CC,'''')='''' then '''' else e.Cd_CC end =isnull(p.Cd_CC,'''') 
					and case when isnull(p.Cd_SC,'''')='''' then '''' else e.Cd_SC end =isnull(p.Cd_SC,'''')
					and case when isnull(p.Cd_SS,'''')='''' then '''' else e.Cd_SS end =isnull(p.Cd_SS,'''')
					and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
				Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
				Group by p.RucE,p.Ejer,p.Cd_CC,p.Cd_SC,p.Cd_SS,'+@cod_x_cta2+@GroupColum+@GroupColumT+'
				) As TablaSS_Cta
				Inner Join PlanCtas r On r.RucE=TablaSS_Cta.RucE and r.Ejer=TablaSS_Cta.Ejer and r.NroCta=TablaSS_Cta.NroCta
				Group by Cd_CC,Cd_SC,Cd_SS,TablaSS_Cta.NroCta,Codigo,r.NomCta
				--Having Sum(Total_P)- Case When Sum(Total_E)>0 Then Sum(Total_E) Else Sum(Total_E)*-1 End <> 0
				'
		End
		If(@Nivel3=1)
		Begin
			Set @RptIngSS_Cta3 = '		
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''I'''
			Set @RptEgrSS_Cta3 = ' 	
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''E''' 

		
			Set @P1_SQL_SS_Cta3 = 
				' UNION ALL
				Select Cd_CC,Cd_SC,Cd_SS,TablaSS_Cta.NroCta,Codigo,r.NomCta As Descrip'+@SelectP+@SelectE
			Set @P2_SQL_SS_Cta3 = @SelectD+@SelectPT+@SelectET+@SelectDT
			Set @P3_SQL_SS_Cta3 = 
				' from
				(Select	p.RucE,p.Ejer,isnull(p.Cd_CC,'''') As Cd_CC,isnull(p.Cd_SC,'''') As Cd_SC,isnull(p.Cd_SS,'''') As Cd_SS,
					'+@cod_x_cta3+' As NroCta,'+@cod_x_cta3+' As Codigo
				'
			Set @P4_SQL_SS_Cta3 = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
			Set @P5_SQL_SS_Cta3 = -- ACA VIENE LA CONDICION DE INGRESO Y EGRESO
				'	--Inner Join CCSubSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC and c.Cd_SS=p.Cd_SS
					Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer and isnull(e.IB_Anulado,0)<>1
					and case when isnull(p.Cd_CC,'''')='''' then '''' else e.Cd_CC end =isnull(p.Cd_CC,'''') 
					and case when isnull(p.Cd_SC,'''')='''' then '''' else e.Cd_SC end =isnull(p.Cd_SC,'''')
					and case when isnull(p.Cd_SS,'''')='''' then '''' else e.Cd_SS end =isnull(p.Cd_SS,'''')
					and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
				Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
				Group by p.RucE,p.Ejer,p.Cd_CC,p.Cd_SC,p.Cd_SS,'+@cod_x_cta3+@GroupColum+@GroupColumT+'
				) As TablaSS_Cta
				Inner Join PlanCtas r On r.RucE=TablaSS_Cta.RucE and r.Ejer=TablaSS_Cta.Ejer and r.NroCta=TablaSS_Cta.NroCta
				Group by Cd_CC,Cd_SC,Cd_SS,TablaSS_Cta.NroCta,Codigo,r.NomCta
				--Having Sum(Total_P)- Case When Sum(Total_E)>0 Then Sum(Total_E) Else Sum(Total_E)*-1 End <> 0
				'
		End
		If(@Nivel4=1)
		Begin
			Set @RptIngSS_Cta4 = '		
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''I'''
			Set @RptEgrSS_Cta4 = ' 	
							From 	Presupuesto p
							Inner Join PlanCtas u On u.RucE=p.RucE and u.Ejer=p.Ejer and u.NroCta=p.NroCta and isnull(u.IC_IE'+@TipRpt+','''')=''E''' 

		
			Set @P1_SQL_SS_Cta4 = 
				' UNION ALL
				Select Cd_CC,Cd_SC,Cd_SS,TablaSS_Cta.NroCta,Codigo,r.NomCta As Descrip'+@SelectP+@SelectE
			Set @P2_SQL_SS_Cta4 = @SelectD+@SelectPT+@SelectET+@SelectDT
			Set @P3_SQL_SS_Cta4 = 
				' from
				(Select	p.RucE,p.Ejer,isnull(p.Cd_CC,'''') As Cd_CC,isnull(p.Cd_SC,'''') As Cd_SC,isnull(p.Cd_SS,'''') As Cd_SS,
					'+@cod_x_cta4+' As NroCta,'+@cod_x_cta4+' As Codigo
				'
			Set @P4_SQL_SS_Cta4 = @ColumnasP+@ColumnasE+@ColumnasPT+@ColumnasET
			Set @P5_SQL_SS_Cta4 = -- ACA VIENE LA CONDICION DE INGRESO Y EGRESO
				'	--Inner Join CCSubSub c On c.RucE=p.RucE and c.Cd_CC=p.Cd_CC and c.Cd_SC=p.Cd_SC and c.Cd_SS=p.Cd_SS
					Left Join Voucher e On e.RucE=p.RucE and e.Ejer=p.Ejer and isnull(e.IB_Anulado,0)<>1
					and case when isnull(p.Cd_CC,'''')='''' then '''' else e.Cd_CC end =isnull(p.Cd_CC,'''') 
					and case when isnull(p.Cd_SC,'''')='''' then '''' else e.Cd_SC end =isnull(p.Cd_SC,'''')
					and case when isnull(p.Cd_SS,'''')='''' then '''' else e.Cd_SS end =isnull(p.Cd_SS,'''')
					and e.NroCta=p.NroCta and e.Prdo>='''+@PrdoD+''' and e.Prdo<='''+@PrdoH+'''
				Where	p.RucE='''+@RucE+''' And p.Ejer='''+@Ejer+''''+@Condicion+'
				Group by p.RucE,p.Ejer,p.Cd_CC,p.Cd_SC,p.Cd_SS,'+@cod_x_cta4+@GroupColum+@GroupColumT+'
				) As TablaSS_Cta
				Inner Join PlanCtas r On r.RucE=TablaSS_Cta.RucE and r.Ejer=TablaSS_Cta.Ejer and r.NroCta=TablaSS_Cta.NroCta
				Group by Cd_CC,Cd_SC,Cd_SS,TablaSS_Cta.NroCta,Codigo,r.NomCta
				--Having Sum(Total_P)- Case When Sum(Total_E)>0 Then Sum(Total_E) Else Sum(Total_E)*-1 End <> 0
				'
		End
	End

End


-- MUESTRAS --
--***************************
	-- INGRESO
	Print @P1_SQL_CC
	Print @P2_SQL_CC
	Print @P3_SQL_CC
	Print @P4_SQL_CC
	Print @RptIngCC
	Print @P5_SQL_CC
	
	Print @P1_SQL_CC_Cta1
	Print @P2_SQL_CC_Cta1
	Print @P3_SQL_CC_Cta1
	Print @P4_SQL_CC_Cta1
	Print @RptIngCC_Cta1
	Print @P5_SQL_CC_Cta1
	
	Print @P1_SQL_CC_Cta2
	Print @P2_SQL_CC_Cta2
	Print @P3_SQL_CC_Cta2
	Print @P4_SQL_CC_Cta2
	Print @RptIngCC_Cta2
	Print @P5_SQL_CC_Cta2
	
	Print @P1_SQL_CC_Cta3
	Print @P2_SQL_CC_Cta3
	Print @P3_SQL_CC_Cta3
	Print @P4_SQL_CC_Cta3
	Print @RptIngCC_Cta3
	Print @P5_SQL_CC_Cta3
	
	Print @P1_SQL_CC_Cta4
	Print @P2_SQL_CC_Cta4
	Print @P3_SQL_CC_Cta4
	Print @P4_SQL_CC_Cta4
	Print @RptIngCC_Cta4
	Print @P5_SQL_CC_Cta4
	
	Print @P1_SQL_SC
	Print @P2_SQL_SC
	Print @P3_SQL_SC
	Print @P4_SQL_SC
	Print @RptIngSC
	Print @P5_SQL_SC
	
	Print @P1_SQL_SC_Cta1
	Print @P2_SQL_SC_Cta1
	Print @P3_SQL_SC_Cta1
	Print @P4_SQL_SC_Cta1
	Print @RptIngSC_Cta1
	Print @P5_SQL_SC_Cta1
	
	Print @P1_SQL_SC_Cta2
	Print @P2_SQL_SC_Cta2
	Print @P3_SQL_SC_Cta2
	Print @P4_SQL_SC_Cta2
	Print @RptIngSC_Cta2
	Print @P5_SQL_SC_Cta2
	
	Print @P1_SQL_SC_Cta3
	Print @P2_SQL_SC_Cta3
	Print @P3_SQL_SC_Cta3
	Print @P4_SQL_SC_Cta3
	Print @RptIngSC_Cta3
	Print @P5_SQL_SC_Cta3
	
	Print @P1_SQL_SC_Cta4
	Print @P2_SQL_SC_Cta4
	Print @P3_SQL_SC_Cta4
	Print @P4_SQL_SC_Cta4
	Print @RptIngSC_Cta4
	Print @P5_SQL_SC_Cta4
	
	Print @P1_SQL_SS
	Print @P2_SQL_SS
	Print @P3_SQL_SS
	Print @P4_SQL_SS
	Print @RptIngSS
	Print @P5_SQL_SS
	
	Print @P1_SQL_SS_Cta1
	Print @P2_SQL_SS_Cta1
	Print @P3_SQL_SS_Cta1
	Print @P4_SQL_SS_Cta1
	Print @RptIngSS_Cta1
	Print @P5_SQL_SS_Cta1
	
	Print @P1_SQL_SS_Cta2
	Print @P2_SQL_SS_Cta2
	Print @P3_SQL_SS_Cta2
	Print @P4_SQL_SS_Cta2
	Print @RptIngSS_Cta2
	Print @P5_SQL_SS_Cta2
	
	Print @P1_SQL_SS_Cta3
	Print @P2_SQL_SS_Cta3
	Print @P3_SQL_SS_Cta3
	Print @P4_SQL_SS_Cta3
	Print @RptIngSS_Cta3
	Print @P5_SQL_SS_Cta3
	
	Print @P1_SQL_SS_Cta4
	Print @P2_SQL_SS_Cta4
	Print @P3_SQL_SS_Cta4
	Print @P4_SQL_SS_Cta4
	Print @RptIngSS_Cta4
	Print @P5_SQL_SS_Cta4
	
	-- EGRESO
	Print @P1_SQL_CC
	Print @P2_SQL_CC
	Print @P3_SQL_CC
	Print @P4_SQL_CC
	Print @RptEgrCC
	Print @P5_SQL_CC
	
	Print @P1_SQL_CC_Cta1
	Print @P2_SQL_CC_Cta1
	Print @P3_SQL_CC_Cta1
	Print @P4_SQL_CC_Cta1
	Print @RptEgrCC_Cta1
	Print @P5_SQL_CC_Cta1
	
	Print @P1_SQL_CC_Cta2
	Print @P2_SQL_CC_Cta2
	Print @P3_SQL_CC_Cta2
	Print @P4_SQL_CC_Cta2
	Print @RptEgrCC_Cta2
	Print @P5_SQL_CC_Cta2
	
	Print @P1_SQL_CC_Cta3
	Print @P2_SQL_CC_Cta3
	Print @P3_SQL_CC_Cta3
	Print @P4_SQL_CC_Cta3
	Print @RptEgrCC_Cta3
	Print @P5_SQL_CC_Cta3
	
	Print @P1_SQL_CC_Cta4
	Print @P2_SQL_CC_Cta4
	Print @P3_SQL_CC_Cta4
	Print @P4_SQL_CC_Cta4
	Print @RptEgrCC_Cta4
	Print @P5_SQL_CC_Cta4
	
	Print @P1_SQL_SC
	Print @P2_SQL_SC
	Print @P3_SQL_SC
	Print @P4_SQL_SC
	Print @RptEgrSC
	Print @P5_SQL_SC
	
	Print @P1_SQL_SC_Cta1
	Print @P2_SQL_SC_Cta1
	Print @P3_SQL_SC_Cta1
	Print @P4_SQL_SC_Cta1
	Print @RptEgrSC_Cta1
	Print @P5_SQL_SC_Cta1
	
	Print @P1_SQL_SC_Cta2
	Print @P2_SQL_SC_Cta2
	Print @P3_SQL_SC_Cta2
	Print @P4_SQL_SC_Cta2
	Print @RptEgrSC_Cta2
	Print @P5_SQL_SC_Cta2
	
	Print @P1_SQL_SC_Cta3
	Print @P2_SQL_SC_Cta3
	Print @P3_SQL_SC_Cta3
	Print @P4_SQL_SC_Cta3
	Print @RptEgrSC_Cta3
	Print @P5_SQL_SC_Cta3
	
	Print @P1_SQL_SC_Cta4
	Print @P2_SQL_SC_Cta4
	Print @P3_SQL_SC_Cta4
	Print @P4_SQL_SC_Cta4
	Print @RptEgrSC_Cta4
	Print @P5_SQL_SC_Cta4
	
	Print @P1_SQL_SS
	Print @P2_SQL_SS
	Print @P3_SQL_SS
	Print @P4_SQL_SS
	Print @RptEgrSS
	Print @P5_SQL_SS
	
	Print @P1_SQL_SS_Cta1
	Print @P2_SQL_SS_Cta1
	Print @P3_SQL_SS_Cta1
	Print @P4_SQL_SS_Cta1
	Print @RptEgrSS_Cta1
	Print @P5_SQL_SS_Cta1
	
	Print @P1_SQL_SS_Cta2
	Print @P2_SQL_SS_Cta2
	Print @P3_SQL_SS_Cta2
	Print @P4_SQL_SS_Cta2
	Print @RptEgrSS_Cta2
	Print @P5_SQL_SS_Cta2
	
	Print @P1_SQL_SS_Cta3
	Print @P2_SQL_SS_Cta3
	Print @P3_SQL_SS_Cta3
	Print @P4_SQL_SS_Cta3
	Print @RptEgrSS_Cta3
	Print @P5_SQL_SS_Cta3
	
	Print @P1_SQL_SS_Cta4
	Print @P2_SQL_SS_Cta4
	Print @P3_SQL_SS_Cta4
	Print @P4_SQL_SS_Cta4
	Print @RptEgrSS_Cta4
	Print @P5_SQL_SS_Cta4
--***************************


if(@P1_SQL_CC+@P1_SQL_SC+@P1_SQL_SS <> '')
Begin
-- PARA INGRESO
Exec('('+
/*PARA CC*/
@P1_SQL_CC+
@P2_SQL_CC+
@P3_SQL_CC+
@P4_SQL_CC+
@RptIngCC+
@P5_SQL_CC+
@P1_SQL_CC_Cta1+
@P2_SQL_CC_Cta1+
@P3_SQL_CC_Cta1+
@P4_SQL_CC_Cta1+
@RptIngCC_Cta1+
@P5_SQL_CC_Cta1+
@P1_SQL_CC_Cta2+
@P2_SQL_CC_Cta2+
@P3_SQL_CC_Cta2+
@P4_SQL_CC_Cta2+
@RptIngCC_Cta2+
@P5_SQL_CC_Cta2+
@P1_SQL_CC_Cta3+
@P2_SQL_CC_Cta3+
@P3_SQL_CC_Cta3+
@P4_SQL_CC_Cta3+
@RptIngCC_Cta3+
@P5_SQL_CC_Cta3+
@P1_SQL_CC_Cta4+
@P2_SQL_CC_Cta4+
@P3_SQL_CC_Cta4+
@P4_SQL_CC_Cta4+
@RptIngCC_Cta4+
@P5_SQL_CC_Cta4+
/*PARA SC*/
@P1_SQL_SC+
@P2_SQL_SC+
@P3_SQL_SC+
@P4_SQL_SC+
@RptIngSC+
@P5_SQL_SC+
@P1_SQL_SC_Cta1+
@P2_SQL_SC_Cta1+
@P3_SQL_SC_Cta1+
@P4_SQL_SC_Cta1+
@RptIngSC_Cta1+
@P5_SQL_SC_Cta1+
@P1_SQL_SC_Cta2+
@P2_SQL_SC_Cta2+
@P3_SQL_SC_Cta2+
@P4_SQL_SC_Cta2+
@RptIngSC_Cta2+
@P5_SQL_SC_Cta2+
@P1_SQL_SC_Cta3+
@P2_SQL_SC_Cta3+
@P3_SQL_SC_Cta3+
@P4_SQL_SC_Cta3+
@RptIngSC_Cta3+
@P5_SQL_SC_Cta3+
@P1_SQL_SC_Cta4+
@P2_SQL_SC_Cta4+
@P3_SQL_SC_Cta4+
@P4_SQL_SC_Cta4+
@RptIngSC_Cta4+
@P5_SQL_SC_Cta4+
/*PARA SS*/
@P1_SQL_SS+
@P2_SQL_SS+
@P3_SQL_SS+
@P4_SQL_SS+
@RptIngSS+
@P5_SQL_SS+
@P1_SQL_SS_Cta1+
@P2_SQL_SS_Cta1+
@P3_SQL_SS_Cta1+
@P4_SQL_SS_Cta1+
@RptIngSS_Cta1+
@P5_SQL_SS_Cta1+
@P1_SQL_SS_Cta2+
@P2_SQL_SS_Cta2+
@P3_SQL_SS_Cta2+
@P4_SQL_SS_Cta2+
@RptIngSS_Cta2+
@P5_SQL_SS_Cta2+
@P1_SQL_SS_Cta3+
@P2_SQL_SS_Cta3+
@P3_SQL_SS_Cta3+
@P4_SQL_SS_Cta3+
@RptIngSS_Cta3+
@P5_SQL_SS_Cta3+
@P1_SQL_SS_Cta4+
@P2_SQL_SS_Cta4+
@P3_SQL_SS_Cta4+
@P4_SQL_SS_Cta4+
@RptIngSS_Cta4+
@P5_SQL_SS_Cta4
+') Order By 1,2,3,4')

-- PARA EGRESO
Exec('('+
/*PARA CC*/
@P1_SQL_CC+
@P2_SQL_CC+
@P3_SQL_CC+
@P4_SQL_CC+
@RptEgrCC+
@P5_SQL_CC+
@P1_SQL_CC_Cta1+
@P2_SQL_CC_Cta1+
@P3_SQL_CC_Cta1+
@P4_SQL_CC_Cta1+
@RptEgrCC_Cta1+
@P5_SQL_CC_Cta1+
@P1_SQL_CC_Cta2+
@P2_SQL_CC_Cta2+
@P3_SQL_CC_Cta2+
@P4_SQL_CC_Cta2+
@RptEgrCC_Cta2+
@P5_SQL_CC_Cta2+
@P1_SQL_CC_Cta3+
@P2_SQL_CC_Cta3+
@P3_SQL_CC_Cta3+
@P4_SQL_CC_Cta3+
@RptEgrCC_Cta3+
@P5_SQL_CC_Cta3+
@P1_SQL_CC_Cta4+
@P2_SQL_CC_Cta4+
@P3_SQL_CC_Cta4+
@P4_SQL_CC_Cta4+
@RptEgrCC_Cta4+
@P5_SQL_CC_Cta4+
/*PARA SC*/
@P1_SQL_SC+
@P2_SQL_SC+
@P3_SQL_SC+
@P4_SQL_SC+
@RptEgrSC+
@P5_SQL_SC+
@P1_SQL_SC_Cta1+
@P2_SQL_SC_Cta1+
@P3_SQL_SC_Cta1+
@P4_SQL_SC_Cta1+
@RptEgrSC_Cta1+
@P5_SQL_SC_Cta1+
@P1_SQL_SC_Cta2+
@P2_SQL_SC_Cta2+
@P3_SQL_SC_Cta2+
@P4_SQL_SC_Cta2+
@RptEgrSC_Cta2+
@P5_SQL_SC_Cta2+
@P1_SQL_SC_Cta3+
@P2_SQL_SC_Cta3+
@P3_SQL_SC_Cta3+
@P4_SQL_SC_Cta3+
@RptEgrSC_Cta3+
@P5_SQL_SC_Cta3+
@P1_SQL_SC_Cta4+
@P2_SQL_SC_Cta4+
@P3_SQL_SC_Cta4+
@P4_SQL_SC_Cta4+
@RptEgrSC_Cta4+
@P5_SQL_SC_Cta4+
/*PARA SS*/
@P1_SQL_SS+
@P2_SQL_SS+
@P3_SQL_SS+
@P4_SQL_SS+
@RptEgrSS+
@P5_SQL_SS+
@P1_SQL_SS_Cta1+
@P2_SQL_SS_Cta1+
@P3_SQL_SS_Cta1+
@P4_SQL_SS_Cta1+
@RptEgrSS_Cta1+
@P5_SQL_SS_Cta1+
@P1_SQL_SS_Cta2+
@P2_SQL_SS_Cta2+
@P3_SQL_SS_Cta2+
@P4_SQL_SS_Cta2+
@RptEgrSS_Cta2+
@P5_SQL_SS_Cta2+
@P1_SQL_SS_Cta3+
@P2_SQL_SS_Cta3+
@P3_SQL_SS_Cta3+
@P4_SQL_SS_Cta3+
@RptEgrSS_Cta3+
@P5_SQL_SS_Cta3+
@P1_SQL_SS_Cta4+
@P2_SQL_SS_Cta4+
@P3_SQL_SS_Cta4+
@P4_SQL_SS_Cta4+
@RptEgrSS_Cta4+
@P5_SQL_SS_Cta4
+') Order By 1,2,3,4')

End



-- Leyenda --
--Di : 26/02/2012 <Creacion del procedimiento almacenado>
--Di : 01/03/2012 <Se agrego los niveles de las cuentas>

GO

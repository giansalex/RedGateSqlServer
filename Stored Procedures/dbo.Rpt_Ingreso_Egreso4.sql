SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
exec Rpt_Ingreso_Egreso3 
'11111111111','2011','00','12',1,0,0,1,'01','F',null,null,null,null,0,0,0,null

exec Rpt_Ingreso_Egreso4 
'11111111111','2011',
'F','01',1,1,1,1,'00','12'
*/
CREATE procedure [dbo].[Rpt_Ingreso_Egreso4]
@RucE nvarchar(11),
@Ejer varchar(4),
@Opc char(1),
@Cd_Mda char(2),
@Nivel1 bit,
@Nivel2 bit,
@Nivel3 bit,
@Nivel4 bit,
@PrdoIni varchar(2),
@PrdoFin varchar(2),
@Cd_CC varChar(12),
@Cd_SC varChar(12),
@Cd_SS varChar(12),
@CcAll bit,
@ScAll bit,
@SsAll bit,
@Cadena nvarchar(4000)
AS

if (@Cd_CC is null) Set @Cd_CC = ''
if (@Cd_SC is null) Set @Cd_SC = ''
if (@Cd_SS is null) Set @Cd_SS = ''

Declare @Condicion nvarchar(4000), @esCC bit, @esSC bit, @esSS bit
Set @Condicion = '' 	-- Cadena de condicion
Set @esCC=0  			-- Mostrar CC
Set @esSC=0 			-- Mostrar SC
Set @esSS=0				-- Mostrar SS

If (isnull(@Cd_CC,'') <> '') -- Si cantidad CC = 1
Begin
	Set @Condicion = ' And v.Cd_CC='''+@Cd_CC+'''' -- Definiendo un CC a la condicion
	Set @esCC=1
	If (isnull(@Cd_SC,'') <> '') -- Si cantidad SC = 1
	Begin
		Set @Condicion = @Condicion + ' And v.Cd_SC='''+@Cd_SC+'''' -- Definiendo un SC a la condicion
		Set @esSC=1
		If (isnull(@Cd_SS,'') <> '') -- Si cantidad SS = 1
		Begin
			Set @Condicion = @Condicion + ' And v.Cd_SS='''+@Cd_SS+'''' -- Definiendo un SS a la condicion
			Set @esSS=1
		End
		Else Begin
			If (isnull(@Cadena,'') <> '') -- Si cantidad SC > 1
			Begin
				Set @Condicion = @Condicion + ' And v.Cd_SS in ('+@Cadena+')' -- Definiendo  mas de un SS a la condicion
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
			Set @Condicion = @Condicion + ' And v.Cd_SC in ('+@Cadena+')' -- Definiendo  mas de un SC a la condicion
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
		Set @Condicion = @Condicion + ' And v.Cd_CC in ('+@Cadena+')' -- Definiendo mas de un CC a la condicion	
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



declare @Condicion1 bit
set @Condicion1=1

--Internos
declare @Consulta varchar(max)
declare @SQL_1 varchar(max)
declare @SQL_2 varchar(max)
declare @SQL_3 varchar(max)
declare @SQL_4 varchar(max)

declare @SelCond varchar(500)
declare @GroupCond varchar(500)
declare @SelCond1 varchar(500)
declare @GroupCond1 varchar(500)
declare @Mda nchar(3)
set @Mda=''
set @SelCond='
		Max(Tab.Cd_CC) Cd_CC,
		Max(Tab.Cd_SC) Cd_SC,
		Max(Tab.Cd_SS) Cd_SS'
set @SelCond1='
			Max(v.Cd_CC) Cd_CC,
			Max(v.Cd_SC) Cd_SC,
			Max(v.Cd_SS) Cd_SS'
set @GroupCond=''
set @GroupCond1=''
if(Isnull(@Condicion1,0))<>0 
Begin
set @SelCond='
		Tab.Cd_CC,
		Tab.Cd_SC,
		Tab.Cd_SS,
		Tab.Prdo+''_''+Tab.Cd_CC+''_''+Tab.Cd_SC+''_''+Tab.Cd_SS as Col '
set @SelCond1='
			v.Cd_CC,
			v.Cd_SC,
			v.Cd_SS'
set @GroupCond='
		,Tab.Cd_CC
		,Tab.Cd_SC
		,Tab.Cd_SS'
set @GroupCond1='
			,v.Cd_CC
			,v.Cd_SC
			,v.Cd_SS'
End
if(@Cd_Mda='02') set @Mda='_ME'

set @SQL_1='
select 
		Left(Tab.NroCta,2) As Cuenta,
		p.NomCta As Descripción,
		Tab.Codigo,
		Sum(tab.Monto) As Monto,
		Tab.Prdo,'
		+@SelCond+'
from(select 
			v.RucE,
			v.Ejer,
			v.NroCta,
			p.IC_IE'+@Opc+' As Codigo,
			SUM(v.MtoH'+rtrim(@Mda)+' - v.MtoD'+rtrim(@Mda)+') As Monto,
			v.Prdo,'+@SelCond1+'
	from 
			voucher v 
			left join planctas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	where 
			v.RucE='''+@RucE+''' 
			and v.Ejer='''+@Ejer+''' 
			and Isnull(p.IC_IE'+@Opc+','''')<>'''' 
			and isnull(v.IB_Anulado,0)<>1 
			and v.Prdo between '''+Isnull(@PrdoIni,'')+''' and '''+Isnull(@PrdoFin,'')+'''
			'+@Condicion+'
	Group By 
			v.RucE
			,v.Ejer
			,v.NroCta
			,p.IC_IE'+@Opc+'
			,v.Prdo'+@GroupCond1+'
	) As Tab 
	left join PlanCtas p on p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=left(Tab.NroCta,2)
Group By
		left(Tab.NroCta,2)
		,p.NomCta
		,Tab.Codigo
		,Tab.Prdo'+@GroupCond+'
'


if(@Nivel2=1)
set @SQL_2='
union all
select 
		Left(Tab.NroCta,4) As Cuenta,
		p.NomCta As Descripción,
		Tab.Codigo,
		Sum(tab.Monto) As Monto,
		Tab.Prdo,'+@SelCond+'
from(select 
			v.RucE,
			v.Ejer,
			v.NroCta,
			p.IC_IE'+@Opc+' As Codigo,
			SUM(v.MtoH'+Rtrim(@Mda)+' - v.MtoD'+Rtrim(@Mda)+') As Monto,
			v.Prdo,'+@SelCond1+'
	from 
			voucher v 
			left join planctas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	where 
			v.RucE='''+@RucE+''' 
			and v.Ejer='''+@Ejer+''' 
			and Isnull(p.IC_IE'+@Opc+','''')<>'''' 
			and isnull(v.IB_Anulado,0)<>1 
			and v.Prdo between '''+Isnull(@PrdoIni,'')+''' and '''+Isnull(@PrdoFin,'')+'''
			'+@Condicion+'
	Group By 
			v.RucE
			,v.Ejer
			,v.NroCta
			,p.IC_IE'+@Opc+'
			,v.Prdo'+@GroupCond1+'
	) As Tab 
	left join PlanCtas p on p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=left(Tab.NroCta,4)
Group By
		left(Tab.NroCta,4)
		,p.NomCta
		,Tab.Codigo
		,Tab.Prdo'+@GroupCond+'
'

if(@Nivel3=1)
set @SQL_3='
union all
select 
		Left(Tab.NroCta,6) As Cuenta,
		p.NomCta As Descripción,
		Tab.Codigo,
		Sum(tab.Monto) As Monto,
		Tab.Prdo,'+@SelCond+'
from(select 
			v.RucE,
			v.Ejer,
			v.NroCta,
			p.IC_IE'+@Opc+' As Codigo,
			SUM(v.MtoH'+Rtrim(@Mda)+' - v.MtoD'+Rtrim(@Mda)+') As Monto,
			v.Prdo,'+@SelCond1+'
	from 
			voucher v 
			left join planctas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	where 
			v.RucE='''+@RucE+'''
			and v.Ejer='''+@Ejer+'''
			and Isnull(p.IC_IE'+@Opc+','''')<>'''' 
			and isnull(v.IB_Anulado,0)<>1 
			and v.Prdo between '''+Isnull(@PrdoIni,'')+''' and '''+Isnull(@PrdoFin,'')+'''
			'+@Condicion+'
	Group By 
			v.RucE
			,v.Ejer
			,v.NroCta
			,p.IC_IE'+@Opc+'
			,v.Prdo'+@GroupCond1+'
) As Tab left join PlanCtas p on p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=left(Tab.NroCta,6)
Group By
		left(Tab.NroCta,6)
		,p.NomCta
		,Tab.Codigo
		,Tab.Prdo'+@GroupCond+'
'

if(@Nivel4=1)
set @SQL_4='
union all
select 
		Tab.NroCta As Cuenta,
		p.NomCta As Descripción,
		Tab.Codigo,
		Sum(tab.Monto) As Monto,
		Tab.Prdo,'+@SelCond+'
from(select 
			v.RucE,
			v.Ejer,
			v.NroCta,
			p.IC_IE'+@Opc+' As Codigo,
			SUM(v.MtoH'+Rtrim(@Mda)+' - v.MtoD'+Rtrim(@Mda)+') As Monto,
			v.Prdo,'+@SelCond1+'
	from 
			voucher v 
			left join planctas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	where 
			v.RucE='''+@RucE+'''
			and v.Ejer='''+@Ejer+'''
			and Isnull(p.IC_IE'+@Opc+','''')<>''''
			and isnull(v.IB_Anulado,0)<>1 and v.Prdo between '''+Isnull(@PrdoIni,'')+''' and '''+Isnull(@PrdoFin,'')+'''
			'+@Condicion+'
	Group By 
			v.RucE
			,v.Ejer
			,v.NroCta
			,p.IC_IE'+@Opc+'
			,v.Prdo'+@GroupCond1+'
	) As Tab 
	left join PlanCtas p on p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
Group By
		Tab.NroCta
		,p.NomCta
		,Tab.Codigo
		,Tab.Prdo'+@GroupCond+'
'

print @Consulta



DECLARE @i INT SET @i=Convert(int,@PrdoIni)
DECLARE @f INT SET @f=Convert(int,@PrdoFin)

declare @SQL_CA varchar(max)
set @SQL_CA=''
	WHILE(@i<=@f)
	BEGIN
		IF(@i>Convert(int,@PrdoIni)) SET @SQL_CA=@SQL_CA+' UNION ALL '
		SET @SQL_CA=@SQL_CA+' SELECT '+''''+right('00'+ltrim(@i),2)+''''+' As Concepto,'+''''+user123.DameFormPrdo(right('00'+ltrim(@i),2),1,1)+''''+' As NCorto
		'
		SET @i=@i+1
	END
declare @Begin varchar(max)
set @Begin='select ''--'' Cuenta, ''Ingreso'' as Descripción,''I'' as Codigo,0.0 as Monto,''00'' as Prdo,'''' as Cd_CC,'''' as Cd_SC,'''' as Cd_SS, '''' As Col
union all
select ''--'' Cuenta, ''Egreso'' as Descripción,''E'' as Codigo,0.0 as Monto,''00'' as Prdo,'''' as Cd_CC,'''' as Cd_SC,'''' as Cd_SS, '''' As Col
union all
'
declare @End Varchar(Max)
set @End='union all
select Cuenta, Descripción,Codigo, Sum(Monto) Monto,Max(Prdo) Prdo,Max(Cd_CC) Cd_CC,Max(Cd_SC) Cd_SC,Max(Cd_SS) Cd_SS,Max(Col) Col
from (
Select ''-Z'' Cuenta, ''Total ''+case when Codigo=''i'' then ''Ingreso'' else ''Egreso'' end as Descripción,Codigo, Sum(Monto) Monto,'''' As Prdo 
, '''' Cd_CC, '''' Cd_SC, '''' Cd_SS,'''' Col from(		
select 
		Left(Tab.NroCta,2) As Cuenta,
		p.NomCta As Descripción,
		Tab.Codigo,
		Sum(tab.Monto) As Monto,
		Tab.Prdo,'
		+@SelCond+'
from(select 
			v.RucE,
			v.Ejer,
			v.NroCta,
			p.IC_IE'+@Opc+' As Codigo,
			SUM(v.MtoH'+rtrim(@Mda)+' - v.MtoD'+rtrim(@Mda)+') As Monto,
			v.Prdo,'+@SelCond1+'
	from 
			voucher v 
			left join planctas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	where 
			v.RucE='''+@RucE+''' 
			and v.Ejer='''+@Ejer+''' 
			and Isnull(p.IC_IE'+@Opc+','''')<>'''' 
			and isnull(v.IB_Anulado,0)<>1 
			and v.Prdo between '''+Isnull(@PrdoIni,'')+''' and '''+Isnull(@PrdoFin,'')+'''
			'+@Condicion+'
	Group By 
			v.RucE
			,v.Ejer
			,v.NroCta
			,p.IC_IE'+@Opc+'
			,v.Prdo'+@GroupCond1+'
	) As Tab 
	left join PlanCtas p on p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=left(Tab.NroCta,2)
Group By
		left(Tab.NroCta,2)
		,p.NomCta
		,Tab.Codigo
		,Tab.Prdo'+@GroupCond+'
) As Con
group By Cuenta,Descripción,Codigo) as Con group By Cuenta,Descripción, Codigo
order by 
		Codigo Desc
		,1
		,Prdo'


declare @Pa_CC_Ini varchar(max)
declare @Pa_CC_Fin varchar(max)
declare @Pa_SC_Ini varchar(max)
declare @Pa_SC_Fin varchar(max)
declare @Pa_SS_Ini varchar(max)
declare @Pa_SS_Fin varchar(max)
set @Pa_CC_Ini='
select cc.Cd_CC,c1.Descrip from ('
set @Pa_CC_Fin='
) as CC left join CCostos c1 on c1.RucE='''+@RucE+''' and c1.Cd_CC=cc.Cd_CC 
group by cc.Cd_CC,c1.Descrip
order by cc.Cd_CC'

--Columnas CC
print @SQL_CA
print @Pa_CC_Ini
print @SQL_1
print @SQL_2
print @SQL_3
print @SQL_4
print @Pa_CC_Fin

set @Pa_SC_Ini='
select SC.Cd_CC,SC.Cd_SC,cs.Descrip from ('
set @Pa_SC_Fin='
) as SC left join CCSub cs on cs.RucE='''+@RucE+''' and cs.Cd_CC=SC.Cd_CC and cs.Cd_SC=SC.Cd_SC
Group By SC.Cd_CC,SC.Cd_SC,cs.Descrip
order by SC.Cd_CC,SC.Cd_SC'

--Columnas SC
print @Pa_SC_Ini
print @SQL_1
print @SQL_2
print @SQL_3
print @SQL_4
print @Pa_SC_Fin

--Columnas SS
set @Pa_SS_Ini='Select SS.Cd_CC,SS.Cd_SC,SS.Cd_SS,s1.Descrip from ('
set @Pa_SS_Fin='
) as SS left join CCSubSub s1 on s1.RucE='''+@RucE+''' and s1.Cd_CC=SS.Cd_CC and s1.Cd_SC=SS.Cd_SC and s1.Cd_SS=SS.Cd_SS
Group By SS.Cd_CC,SS.Cd_SC,SS.Cd_SS,s1.Descrip
order by SS.Cd_CC,SS.Cd_SC,SS.Cd_SS
'

--Columnas SS
print @Pa_SS_Ini
print @SQL_1
print @SQL_2
print @SQL_3
print @SQL_4
print @Pa_SS_Fin


print @Begin
print @SQL_1
print @SQL_2
print @SQL_3
print @SQL_4
print @End


--para CC
exec(@SQL_CA+@Pa_CC_Ini+@SQL_1+@SQL_2+@SQL_3+@SQL_4+@Pa_CC_Fin)

--para SC
exec(@Pa_SC_Ini+@SQL_1+@SQL_2+@SQL_3+@SQL_4+@Pa_SC_Fin)

--para SC
exec(@Pa_SS_Ini+@SQL_1+@SQL_2+@SQL_3+@SQL_4+@Pa_SS_Fin)

--Data
exec (@Begin+@SQL_1+@SQL_2+@SQL_3+@SQL_4+@End)
/*
exec Rpt_Ingreso_Egreso4 
'11111111111','2011',
'F','01',1,1,1,1,'00','12'
*/
GO

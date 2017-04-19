SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [dbo].[Rpt_Ingreso_Egreso5]
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
@Cd_CC varchar(8000),
@Cd_SC varchar(8000),
@Cd_SS varchar(8000)
AS

if (@Cd_CC is null) Set @Cd_CC = ''
if (@Cd_SC is null) Set @Cd_SC = ''
if (@Cd_SS is null) Set @Cd_SS = ''

declare @Condicion1 bit
set @Condicion1=1

--Internos
declare @Consulta varchar(max)
declare @SQL_1_1 varchar(max), @SQL_1_2 varchar(max)
declare @SQL_2_1 varchar(max), @SQL_2_2 varchar(max)
declare @SQL_3_1 varchar(max), @SQL_3_2 varchar(max)
declare @SQL_4_1 varchar(max), @SQL_4_2 varchar(max)
declare @SQLCinilvl1 varchar(100),@SQLCfinlvl1 varchar(100)
declare @SQLSCinilvl1 varchar(100),@SQLSCfinlvl1 varchar(100)
declare @SQLSSCinilvl1 varchar(100),@SQLSSCfinlvl1 varchar(100)
--level 2
declare @SQLCinilvl2 varchar(100),@SQLCfinlvl2 varchar(100)
declare @SQLSCinilvl2 varchar(100),@SQLSCfinlvl2 varchar(100)
declare @SQLSSCinilvl2 varchar(100),@SQLSSCfinlvl2 varchar(100)
--level 3
declare @SQLCinilvl3 varchar(100),@SQLCfinlvl3 varchar(100)
declare @SQLSCinilvl3 varchar(100),@SQLSCfinlvl3 varchar(100)
declare @SQLSSCinilvl3 varchar(100),@SQLSSCfinlvl3 varchar(100)
--level 4
declare @SQLCinilvl4 varchar(100),@SQLCfinlvl4 varchar(100)
declare @SQLSCinilvl4 varchar(100),@SQLSCfinlvl4 varchar(100)
declare @SQLSSCinilvl4 varchar(100),@SQLSSCfinlvl4 varchar(100)

set @SQL_1_1='' set @SQL_1_2=''
set @SQL_2_1='' set @SQL_2_2=''
set @SQL_3_1='' set @SQL_3_2=''
set @SQL_4_1='' set @SQL_4_2=''
set @SQLCinilvl1='' set @SQLCfinlvl1=''
set @SQLSCinilvl1='' set @SQLSCfinlvl1=''
set @SQLSSCinilvl1='' set @SQLSSCfinlvl1=''
--level 2
set @SQLCinilvl2='' set @SQLCfinlvl2=''
set @SQLSCinilvl2='' set @SQLSCfinlvl2=''
set @SQLSSCinilvl2='' set @SQLSSCfinlvl2=''
--level 3
set @SQLCinilvl3='' set @SQLCfinlvl3=''
set @SQLSCinilvl3='' set @SQLSCfinlvl3=''
set @SQLSSCinilvl3='' set @SQLSSCfinlvl3=''
--level 4
set @SQLCinilvl4='' set @SQLCfinlvl4=''
set @SQLSCinilvl4='' set @SQLSCfinlvl4=''
set @SQLSSCinilvl4='' set @SQLSSCfinlvl4=''

declare @SelCond varchar(120)
declare @GroupCond varchar(120)
declare @SelCond1 varchar(120)
declare @GroupCond1 varchar(120)
declare @Mda nchar(3)
set @Mda=''
/*
centro de costos por niveles
*/

declare  @Cd_CC_lvl1 varchar(8000), @Cd_CC_lvl2 varchar(8000), @Cd_CC_lvl3 varchar(8000), @Cd_CC_lvl4 varchar(8000)
declare  @Cd_SC_lvl1 varchar(8000), @Cd_SC_lvl2 varchar(8000), @Cd_SC_lvl3 varchar(8000), @Cd_SC_lvl4 varchar(8000)
declare  @Cd_SS_lvl1 varchar(8000), @Cd_SS_lvl2 varchar(8000), @Cd_SS_lvl3 varchar(8000), @Cd_SS_lvl4 varchar(8000)
set @Cd_CC_lvl1='' set @Cd_CC_lvl2='' set @Cd_CC_lvl3='' set @Cd_CC_lvl4=''
set @Cd_SC_lvl1='' set @Cd_SC_lvl2='' set @Cd_SC_lvl3='' set @Cd_SC_lvl4=''
set @Cd_SS_lvl1='' set @Cd_SS_lvl2='' set @Cd_SS_lvl3='' set @Cd_SS_lvl4=''

if(isnull(@Cd_CC,'')<>'') 
begin
	set @Cd_CC_lvl1=@Cd_CC
	set @SQLCinilvl1=' 
					and v.Cd_CC in('
	set @SQLCfinlvl1=') '
	if(@Nivel2=1) 
	begin
		set @Cd_CC_lvl2=@Cd_CC
		set @SQLCinilvl2=' 
					and v.Cd_CC in('
		set @SQLCfinlvl2=') ' 
	end
	if(@Nivel3=1)
	begin
		set @Cd_CC_lvl3=@Cd_CC
		set @SQLCinilvl3=' 
					and v.Cd_CC in('
		set @SQLCfinlvl3=') ' 
	end
	if(@Nivel4=1)
	begin
		set @Cd_CC_lvl4=@Cd_CC
		set @SQLCinilvl4=' 
					and v.Cd_CC in('
		set @SQLCfinlvl4=') ' 
	end
end
else set @Cd_CC=''

if(Isnull(@Cd_SC,'')<>'')
Begin
	set @Cd_SC_lvl1=@Cd_SC
	set @SQLSCinilvl1=' 
					and v.Cd_SC in('
	set @SQLSCfinlvl1=') '
	if(@Nivel2=1)
	begin
		set @Cd_SC_lvl2=@Cd_SC
		set @SQLSCinilvl2=' 
						and v.Cd_SC in('
		set @SQLSCfinlvl2=') '
	end
	if(@Nivel3=1)
	begin
		set @Cd_SC_lvl3=@Cd_SC
		set @SQLSCinilvl3=' 
						and v.Cd_SC in('
		set @SQLSCfinlvl3=') '
	end
	if(@Nivel4=1)
	begin
		set @Cd_SC_lvl4=@Cd_SC
		set @SQLSCinilvl4=' 
						and v.Cd_SC in('
		set @SQLSCfinlvl4=') '
	end
End
else set @Cd_SC=''
if(Isnull(@Cd_SS,'')<>'')
Begin
	set @Cd_SS_lvl1=@Cd_SS
	set @SQLSSCinilvl1=' 
					and v.Cd_SS in('
	set @SQLSSCfinlvl1=') '
	if(@Nivel2=1)
	begin
		set @Cd_SS_lvl2=@Cd_SS
		set @SQLSSCinilvl2=' 
						and v.Cd_SS in('
		set @SQLSSCfinlvl2=') '
	end
	if(@Nivel3=1)
	begin
		set @Cd_SS_lvl3=@Cd_SS
		set @SQLSSCinilvl3=' 
						and v.Cd_SS in('
		set @SQLSSCfinlvl3=') '
	end
	if(@Nivel4=1)
	begin
		set @Cd_SS_lvl4=@Cd_SS
		set @SQLSSCinilvl4=' 
						and v.Cd_SS in('
		set @SQLSSCfinlvl4=') '
	end
End
else set @Cd_SS=''
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

set @SQL_1_1='
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
			'
set @SQL_1_2='
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
begin
set @SQL_2_1='
union all
select 
		Left(Tab.NroCta,4) As Cuenta,
		p.NomCta As Descripción,
		Tab.Codigo,
		Sum(tab.Monto) As Monto,
		Tab.Prdo,'+isnull(@SelCond,'')+'
from(select 
			v.RucE,
			v.Ejer,
			v.NroCta,
			p.IC_IE'+isnull(@Opc,'')+' As Codigo,
			SUM(v.MtoH'+Rtrim(isnull(@Mda,''))+' - v.MtoD'+Rtrim(isnull(@Mda,''))+') As Monto,
			v.Prdo,'+isnull(@SelCond1,'')+'
	from 
			voucher v 
			left join planctas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	where 
			v.RucE='''+isnull(@RucE,'')+''' 
			and v.Ejer='''+isnull(@Ejer,'')+''' 
			and Isnull(p.IC_IE'+isnull(@Opc,'')+','''')<>'''' 
			and isnull(v.IB_Anulado,0)<>1 
			and v.Prdo between '''+Isnull(@PrdoIni,'')+''' and '''+Isnull(@PrdoFin,'')+''' '
			
set @SQL_2_2='
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
end
if(@Nivel3=1)
begin
set @SQL_3_1='
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
			and v.Prdo between '''+Isnull(@PrdoIni,'')+''' and '''+Isnull(@PrdoFin,'')+''' '
set @SQL_3_2='
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
end
if(@Nivel4=1)
begin
set @SQL_4_1='
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
'
set @SQL_4_2='
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
end
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


set @Pa_SC_Ini='
select SC.Cd_CC,SC.Cd_SC,cs.Descrip from ('
set @Pa_SC_Fin='
) as SC left join CCSub cs on cs.RucE='''+@RucE+''' and cs.Cd_CC=SC.Cd_CC and cs.Cd_SC=SC.Cd_SC
Group By SC.Cd_CC,SC.Cd_SC,cs.Descrip
order by SC.Cd_CC,SC.Cd_SC'


--Columnas SS
set @Pa_SS_Ini='Select SS.Cd_CC,SS.Cd_SC,SS.Cd_SS,s1.Descrip from ('
set @Pa_SS_Fin='
) as SS left join CCSubSub s1 on s1.RucE='''+@RucE+''' and s1.Cd_CC=SS.Cd_CC and s1.Cd_SC=SS.Cd_SC and s1.Cd_SS=SS.Cd_SS
Group By SS.Cd_CC,SS.Cd_SC,SS.Cd_SS,s1.Descrip
order by SS.Cd_CC,SS.Cd_SC,SS.Cd_SS
'



/********************************** para CC *************************************/
--print
print rtrim(ltrim(@SQL_CA))
print rtrim(ltrim(@Pa_CC_Ini))
print rtrim(ltrim(@SQL_1_1))
print rtrim(ltrim(@SQLCinilvl1))
print rtrim(ltrim(@Cd_CC_lvl1))
print rtrim(ltrim(@SQLCfinlvl1))
print rtrim(ltrim(@SQLSCinilvl1))
print rtrim(ltrim(@Cd_SC_lvl1))
print rtrim(ltrim(@SQLSCfinlvl1))
print rtrim(ltrim(@SQLSSCinilvl1))
print rtrim(ltrim(@Cd_SS_lvl1))
print rtrim(ltrim(@SQLSSCfinlvl1))
print rtrim(ltrim(@SQL_1_2))
print rtrim(ltrim(@SQL_2_1))
print rtrim(ltrim(@SQLCinilvl2))
print rtrim(ltrim(@Cd_CC_lvl2))
print rtrim(ltrim(@SQLCfinlvl2))
print rtrim(ltrim(@SQLSCinilvl2))
print rtrim(ltrim(@Cd_SC_lvl2))
print rtrim(ltrim(@SQLSCfinlvl2))
print rtrim(ltrim(@SQLSSCinilvl2))
print rtrim(ltrim(@Cd_SS_lvl2))
print rtrim(ltrim(@SQLSSCfinlvl2))
print rtrim(ltrim(@SQL_2_2))
print rtrim(ltrim(@SQL_3_1))
print rtrim(ltrim(@SQLCinilvl3))
print rtrim(ltrim(@Cd_CC_lvl3))
print rtrim(ltrim(@SQLCfinlvl3))
print rtrim(ltrim(@SQLSCinilvl3))
print rtrim(ltrim(@Cd_SC_lvl3))
print rtrim(ltrim(@SQLSCfinlvl3))
print rtrim(ltrim(@SQLSSCinilvl3))
print rtrim(ltrim(@Cd_SS_lvl3))
print rtrim(ltrim(@SQLSSCfinlvl3))
print rtrim(ltrim(@SQL_3_2))
print rtrim(ltrim(@SQL_4_1))
print rtrim(ltrim(@SQLCinilvl4))
print rtrim(ltrim(@Cd_CC_lvl4))
print rtrim(ltrim(@SQLCfinlvl4))
print rtrim(ltrim(@SQLSCinilvl4))
print rtrim(ltrim(@Cd_SC_lvl4))
print rtrim(ltrim(@SQLSCfinlvl4))
print rtrim(ltrim(@SQLSSCinilvl4))
print rtrim(ltrim(@Cd_SS_lvl4))
print rtrim(ltrim(@SQLSSCfinlvl4))
print rtrim(ltrim(@SQL_4_2))
print rtrim(ltrim(@Pa_CC_Fin))

exec(
@SQL_CA
+@Pa_CC_Ini
 +@SQL_1_1
  +@SQLCinilvl1
   +@Cd_CC_lvl1
  +@SQLCfinlvl1
  +@SQLSCinilvl1
   +@Cd_SC_lvl1
  +@SQLSCfinlvl1
  +@SQLSSCinilvl1
   +@Cd_SS_lvl1
  +@SQLSSCfinlvl1
 +@SQL_1_2
 +@SQL_2_1
  +@SQLCinilvl2
   +@Cd_CC_lvl2
  +@SQLCfinlvl2
  +@SQLSCinilvl2
   +@Cd_SC_lvl2
  +@SQLSCfinlvl2
  +@SQLSSCinilvl2
   +@Cd_SS_lvl2
  +@SQLSSCfinlvl2
 +@SQL_2_2
 +@SQL_3_1
  +@SQLCinilvl3
   +@Cd_CC_lvl3
  +@SQLCfinlvl3
  +@SQLSCinilvl3
   +@Cd_SC_lvl3
  +@SQLSCfinlvl3
  +@SQLSSCinilvl3
   +@Cd_SS_lvl3
  +@SQLSSCfinlvl3
 +@SQL_3_2
 +@SQL_4_1
  +@SQLCinilvl4
   +@Cd_CC_lvl4
  +@SQLCfinlvl4
  +@SQLSCinilvl4
   +@Cd_SC_lvl4
  +@SQLSCfinlvl4
  +@SQLSSCinilvl4
   +@Cd_SS_lvl4
  +@SQLSSCfinlvl4
 +@SQL_4_2
+@Pa_CC_Fin
)




/**********************************************para SC*************************************************/
exec(
@Pa_SC_Ini
 +@SQL_1_1
  +@SQLCinilvl1
   +@Cd_CC_lvl1
  +@SQLCfinlvl1
  +@SQLSCinilvl1
   +@Cd_SC_lvl1
  +@SQLSCfinlvl1
  +@SQLSSCinilvl1
   +@Cd_SS_lvl1
  +@SQLSSCfinlvl1
 +@SQL_1_2
 +@SQL_2_1
  +@SQLCinilvl2
   +@Cd_CC_lvl2
  +@SQLCfinlvl2
  +@SQLSCinilvl2
   +@Cd_SC_lvl2
  +@SQLSCfinlvl2
  +@SQLSSCinilvl2
   +@Cd_SS_lvl2
  +@SQLSSCfinlvl2
 +@SQL_2_2
 +@SQL_3_1
  +@SQLCinilvl3
   +@Cd_CC_lvl3
  +@SQLCfinlvl3
  +@SQLSCinilvl3
   +@Cd_SC_lvl3
  +@SQLSCfinlvl3
  +@SQLSSCinilvl3
   +@Cd_SS_lvl3
  +@SQLSSCfinlvl3
 +@SQL_3_2
 +@SQL_4_1
  +@SQLCinilvl4
   +@Cd_CC_lvl4
  +@SQLCfinlvl4
  +@SQLSCinilvl4
   +@Cd_SC_lvl4
  +@SQLSCfinlvl4
  +@SQLSSCinilvl4
   +@Cd_SS_lvl4
  +@SQLSSCfinlvl4
 +@SQL_4_2
+@Pa_SC_Fin
)

--print
print rtrim(ltrim(@Pa_SC_Ini))
print rtrim(ltrim(@SQL_1_1))
print rtrim(ltrim(@SQLCinilvl1))
print rtrim(ltrim(@Cd_CC_lvl1))
print rtrim(ltrim(@SQLCfinlvl1))
print rtrim(ltrim(@SQLSCinilvl1))
print rtrim(ltrim(@Cd_SC_lvl1))
print rtrim(ltrim(@SQLSCfinlvl1))
print rtrim(ltrim(@SQLSSCinilvl1))
print rtrim(ltrim(@Cd_SS_lvl1))
print rtrim(ltrim(@SQLSSCfinlvl1))
print rtrim(ltrim(@SQL_1_2))
print rtrim(ltrim(@SQL_2_1))
print rtrim(ltrim(@SQLCinilvl2))
print rtrim(ltrim(@Cd_CC_lvl2))
print rtrim(ltrim(@SQLCfinlvl2))
print rtrim(ltrim(@SQLSCinilvl2))
print rtrim(ltrim(@Cd_SC_lvl2))
print rtrim(ltrim(@SQLSCfinlvl2))
print rtrim(ltrim(@SQLSSCinilvl2))
print rtrim(ltrim(@Cd_SS_lvl2))
print rtrim(ltrim(@SQLSSCfinlvl2))
print rtrim(ltrim(@SQL_2_2))
print rtrim(ltrim(@SQL_3_1))
print rtrim(ltrim(@SQLCinilvl3))
print rtrim(ltrim(@Cd_CC_lvl3))
print rtrim(ltrim(@SQLCfinlvl3))
print rtrim(ltrim(@SQLSCinilvl3))
print rtrim(ltrim(@Cd_SC_lvl3))
print rtrim(ltrim(@SQLSCfinlvl3))
print rtrim(ltrim(@SQLSSCinilvl3))
print rtrim(ltrim(@Cd_SS_lvl3))
print rtrim(ltrim(@SQLSSCfinlvl3))
print rtrim(ltrim(@SQL_3_2))
print rtrim(ltrim(@SQL_4_1))
print rtrim(ltrim(@SQLCinilvl4))
print rtrim(ltrim(@Cd_CC_lvl4))
print rtrim(ltrim(@SQLCfinlvl4))
print rtrim(ltrim(@SQLSCinilvl4))
print rtrim(ltrim(@Cd_SC_lvl4))
print rtrim(ltrim(@SQLSCfinlvl4))
print rtrim(ltrim(@SQLSSCinilvl4))
print rtrim(ltrim(@Cd_SS_lvl4))
print rtrim(ltrim(@SQLSSCfinlvl4))
print rtrim(ltrim(@SQL_4_2))
print rtrim(ltrim(@Pa_SC_Fin))
/******************************************************************************************/


/****************************************para SC*******************************************/
exec(
@Pa_SS_Ini
 +@SQL_1_1
  +@SQLCinilvl1
   +@Cd_CC_lvl1
  +@SQLCfinlvl1
  +@SQLSCinilvl1
   +@Cd_SC_lvl1
  +@SQLSCfinlvl1
  +@SQLSSCinilvl1
   +@Cd_SS_lvl1
  +@SQLSSCfinlvl1
 +@SQL_1_2
 +@SQL_2_1
  +@SQLCinilvl2
   +@Cd_CC_lvl2
  +@SQLCfinlvl2
  +@SQLSCinilvl2
   +@Cd_SC_lvl2
  +@SQLSCfinlvl2
  +@SQLSSCinilvl2
   +@Cd_SS_lvl2
  +@SQLSSCfinlvl2
 +@SQL_2_2
 +@SQL_3_1
  +@SQLCinilvl3
   +@Cd_CC_lvl3
  +@SQLCfinlvl3
  +@SQLSCinilvl3
   +@Cd_SC_lvl3
  +@SQLSCfinlvl3
  +@SQLSSCinilvl3
   +@Cd_SS_lvl3
  +@SQLSSCfinlvl3
 +@SQL_3_2
 +@SQL_4_1
  +@SQLCinilvl4
   +@Cd_CC_lvl4
  +@SQLCfinlvl4
  +@SQLSCinilvl4
   +@Cd_SC_lvl4
  +@SQLSCfinlvl4
  +@SQLSSCinilvl4
   +@Cd_SS_lvl4
  +@SQLSSCfinlvl4
 +@SQL_4_2
+@Pa_SS_Fin
)
--print 
print rtrim(ltrim(@Pa_SS_Ini))
print rtrim(ltrim(@SQL_1_1))
print rtrim(ltrim(@SQLCinilvl1))
print rtrim(ltrim(@Cd_CC_lvl1))
print rtrim(ltrim(@SQLCfinlvl1))
print rtrim(ltrim(@SQLSCinilvl1))
print rtrim(ltrim(@Cd_SC_lvl1))
print rtrim(ltrim(@SQLSCfinlvl1))
print rtrim(ltrim(@SQLSSCinilvl1))
print rtrim(ltrim(@Cd_SS_lvl1))
print rtrim(ltrim(@SQLSSCfinlvl1))
print rtrim(ltrim(@SQL_1_2))
print rtrim(ltrim(@SQL_2_1))
print rtrim(ltrim(@SQLCinilvl2))
print rtrim(ltrim(@Cd_CC_lvl2))
print rtrim(ltrim(@SQLCfinlvl2))
print rtrim(ltrim(@SQLSCinilvl2))
print rtrim(ltrim(@Cd_SC_lvl2))
print rtrim(ltrim(@SQLSCfinlvl2))
print rtrim(ltrim(@SQLSSCinilvl2))
print rtrim(ltrim(@Cd_SS_lvl2))
print rtrim(ltrim(@SQLSSCfinlvl2))
print rtrim(ltrim(@SQL_2_2))
print rtrim(ltrim(@SQL_3_1))
print rtrim(ltrim(@SQLCinilvl3))
print rtrim(ltrim(@Cd_CC_lvl3))
print rtrim(ltrim(@SQLCfinlvl3))
print rtrim(ltrim(@SQLSCinilvl3))
print rtrim(ltrim(@Cd_SC_lvl3))
print rtrim(ltrim(@SQLSCfinlvl3))
print rtrim(ltrim(@SQLSSCinilvl3))
print rtrim(ltrim(@Cd_SS_lvl3))
print rtrim(ltrim(@SQLSSCfinlvl3))
print rtrim(ltrim(@SQL_3_2))
print rtrim(ltrim(@SQL_4_1))
print rtrim(ltrim(@SQLCinilvl4))
print rtrim(ltrim(@Cd_CC_lvl4))
print rtrim(ltrim(@SQLCfinlvl4))
print rtrim(ltrim(@SQLSCinilvl4))
print rtrim(ltrim(@Cd_SC_lvl4))
print rtrim(ltrim(@SQLSCfinlvl4))
print rtrim(ltrim(@SQLSSCinilvl4))
print rtrim(ltrim(@Cd_SS_lvl4))
print rtrim(ltrim(@SQLSSCfinlvl4))
print rtrim(ltrim(@SQL_4_2))
print rtrim(ltrim(@Pa_SS_Fin))
/******************************************************************************************/

/******************************************Data********************************************/
exec (
@Begin
+@SQL_1_1
  +@SQLCinilvl1
   +@Cd_CC_lvl1
  +@SQLCfinlvl1
  +@SQLSCinilvl1
   +@Cd_SC_lvl1
  +@SQLSCfinlvl1
  +@SQLSSCinilvl1
   +@Cd_SS_lvl1
  +@SQLSSCfinlvl1
 +@SQL_1_2
 +@SQL_2_1
  +@SQLCinilvl2
   +@Cd_CC_lvl2
  +@SQLCfinlvl2
  +@SQLSCinilvl2
   +@Cd_SC_lvl2
  +@SQLSCfinlvl2
  +@SQLSSCinilvl2
   +@Cd_SS_lvl2
  +@SQLSSCfinlvl2
 +@SQL_2_2
 +@SQL_3_1
  +@SQLCinilvl3
   +@Cd_CC_lvl3
  +@SQLCfinlvl3
  +@SQLSCinilvl3
   +@Cd_SC_lvl3
  +@SQLSCfinlvl3
  +@SQLSSCinilvl3
   +@Cd_SS_lvl3
  +@SQLSSCfinlvl3
 +@SQL_3_2
 +@SQL_4_1
  +@SQLCinilvl4
   +@Cd_CC_lvl4
  +@SQLCfinlvl4
  +@SQLSCinilvl4
   +@Cd_SC_lvl4
  +@SQLSCfinlvl4
  +@SQLSSCinilvl4
   +@Cd_SS_lvl4
  +@SQLSSCfinlvl4
 +@SQL_4_2
+@End)

--print
print rtrim(ltrim(@Begin))
print rtrim(ltrim(@SQL_1_1))
print rtrim(ltrim(@SQLCinilvl1))
print rtrim(ltrim(@Cd_CC_lvl1))
print rtrim(ltrim(@SQLCfinlvl1))
print rtrim(ltrim(@SQLSCinilvl1))
print rtrim(ltrim(@Cd_SC_lvl1))
print rtrim(ltrim(@SQLSCfinlvl1))
print rtrim(ltrim(@SQLSSCinilvl1))
print rtrim(ltrim(@Cd_SS_lvl1))
print rtrim(ltrim(@SQLSSCfinlvl1))
print rtrim(ltrim(@SQL_1_2))
print rtrim(ltrim(@SQL_2_1))
print rtrim(ltrim(@SQLCinilvl2))
print rtrim(ltrim(@Cd_CC_lvl2))
print rtrim(ltrim(@SQLCfinlvl2))
print rtrim(ltrim(@SQLSCinilvl2))
print rtrim(ltrim(@Cd_SC_lvl2))
print rtrim(ltrim(@SQLSCfinlvl2))
print rtrim(ltrim(@SQLSSCinilvl2))
print rtrim(ltrim(@Cd_SS_lvl2))
print rtrim(ltrim(@SQLSSCfinlvl2))
print rtrim(ltrim(@SQL_2_2))
print rtrim(ltrim(@SQL_3_1))
print rtrim(ltrim(@SQLCinilvl3))
print rtrim(ltrim(@Cd_CC_lvl3))
print rtrim(ltrim(@SQLCfinlvl3))
print rtrim(ltrim(@SQLSCinilvl3))
print rtrim(ltrim(@Cd_SC_lvl3))
print rtrim(ltrim(@SQLSCfinlvl3))
print rtrim(ltrim(@SQLSSCinilvl3))
print rtrim(ltrim(@Cd_SS_lvl3))
print rtrim(ltrim(@SQLSSCfinlvl3))
print rtrim(ltrim(@SQL_3_2))
print rtrim(ltrim(@SQL_4_1))
print rtrim(ltrim(@SQLCinilvl4))
print rtrim(ltrim(@Cd_CC_lvl4))
print rtrim(ltrim(@SQLCfinlvl4))
print rtrim(ltrim(@SQLSCinilvl4))
print rtrim(ltrim(@Cd_SC_lvl4))
print rtrim(ltrim(@SQLSCfinlvl4))
print rtrim(ltrim(@SQLSSCinilvl4))
print rtrim(ltrim(@Cd_SS_lvl4))
print rtrim(ltrim(@SQLSSCfinlvl4))
print rtrim(ltrim(@SQL_4_2))
print rtrim(ltrim(@End))
/******************************************************************************************/

/*
exec Rpt_Ingreso_Egreso5 '11111111111','2012','F','01',1,0,0,0,'00','04','002',null,null
*/
GO

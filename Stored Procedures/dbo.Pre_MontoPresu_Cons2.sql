SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Pre_MontoPresu_Cons2]
--declare
@RucE nvarchar(11),
@Ejer nvarchar(11),
@PrdoIni nvarchar(11),
@PrdoFin nvarchar(11),
@Moneda nvarchar(2),
@ckCC bit,
@Cd_cc nvarchar(200),
@ckSC bit,
@Cd_sc nvarchar(200),
@ckSS bit,
@Cd_ss nvarchar(200),
@Det bit,
@msj varchar(100) output

as
Delete from Presupuesto where RucE=@RucE and NroCta not in (select NroCta from PlanCtas where RucE=@RucE and Ejer=@Ejer and IB_Psp=1 and Nivel=4 Group by NroCta)
/*
set @RucE ='11111111111'
set @Ejer ='2010'
set @PrdoIni ='01'
set @PrdoFin ='12'
set @Moneda ='01'
set @ckCC = '1'
set @Cd_ss =null--''''''
set @Cd_sc =null--''''''
set @Cd_cc ='''0001'', ''0002'', ''0003'', ''0100'', ''01010101 '''
set @ckSC = '0'
set @ckSS = '0'
set @Det = '1'
*/
print 'break 0'
Declare @Mda nvarchar(3)
Declare @ColMes nvarchar(1000)
Declare @SumMes nvarchar(1000)
Declare @ColDet nvarchar(1000)
Declare @Ene nvarchar(1000),@Feb nvarchar(1000),@Mar nvarchar(1000),@Abr nvarchar(1000),@May nvarchar(1000),@Jun nvarchar(1000)
Declare @Jul nvarchar(1000),@Ago nvarchar(1000),@Sep nvarchar(1000),@Oct nvarchar(1000),@Nov nvarchar(1000),@Dic nvarchar(1000)
Set @Mda = ''Set @ColMes = ''Set @SumMes = ''Set @ColDet = ''
Set @Ene= '' Set @Feb= '' Set @Mar= '' Set @Abr= '' Set @May= '' Set @Jun= '' 
Set @Jul= '' Set @Ago= '' Set @Sep= '' Set @Oct= '' Set @Nov= '' Set @Dic= ''

if(@Moneda = '02') Set @Mda = '_ME'
Declare @i int,@f int
Set @i = convert(int,@PrdoIni)
Set @f = convert(int,@PrdoFin)
while (@i <= @f)
begin
	if(@Det=1)
	begin
		if(@i = 1) Set @Ene = ',p.Ene'+@Mda+' as Ene_Psp,Sum(Case(v.Prdo) when ''01'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end) as Ene_Eje,(p.Ene'+@Mda+'-Sum(Case(v.Prdo) when ''01'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end)) as Ene_Dif,Case(p.Ene'+@Mda+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(13,2),((p.Ene'+@Mda+'-Sum(Case(v.Prdo) when ''01'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end))*100)/p.Ene'+@Mda+')) end as ''Ene_%'''
		if(@i = 2) Set @Feb = ',p.Feb'+@Mda+' as Feb_Psp,Sum(Case(v.Prdo) when ''02'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end) as Feb_Eje,(p.Feb'+@Mda+'-Sum(Case(v.Prdo) when ''02'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end)) as Feb_Dif,Case(p.Feb'+@Mda+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(13,2),((p.Feb'+@Mda+'-Sum(Case(v.Prdo) when ''02'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end))*100)/p.Feb'+@Mda+')) end as ''Feb_%'''
		if(@i = 3) Set @Mar = ',p.Mar'+@Mda+' as Mar_Psp,Sum(Case(v.Prdo) when ''03'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end) as Mar_Eje,(p.Mar'+@Mda+'-Sum(Case(v.Prdo) when ''03'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end)) as Mar_Dif,Case(p.Mar'+@Mda+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(13,2),((p.Mar'+@Mda+'-Sum(Case(v.Prdo) when ''03'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end))*100)/p.Mar'+@Mda+')) end as ''Mar_%'''
		if(@i = 4) Set @Abr = ',p.Abr'+@Mda+' as Abr_Psp,Sum(Case(v.Prdo) when ''04'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end) as Abr_Eje,(p.Abr'+@Mda+'-Sum(Case(v.Prdo) when ''04'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end)) as Abr_Dif,Case(p.Abr'+@Mda+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(13,2),((p.Abr'+@Mda+'-Sum(Case(v.Prdo) when ''04'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end))*100)/p.Abr'+@Mda+')) end as ''Abr_%'''
		if(@i = 5) Set @May = ',p.May'+@Mda+' as May_Psp,Sum(Case(v.Prdo) when ''05'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end) as May_Eje,(p.May'+@Mda+'-Sum(Case(v.Prdo) when ''05'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end)) as May_Dif,Case(p.May'+@Mda+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(13,2),((p.May'+@Mda+'-Sum(Case(v.Prdo) when ''05'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end))*100)/p.May'+@Mda+')) end as ''May_%'''
		if(@i = 6) Set @Jun = ',p.Jun'+@Mda+' as Jun_Psp,Sum(Case(v.Prdo) when ''06'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end) as Jun_Eje,(p.Jun'+@Mda+'-Sum(Case(v.Prdo) when ''06'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end)) as Jun_Dif,Case(p.Jun'+@Mda+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(13,2),((p.Jun'+@Mda+'-Sum(Case(v.Prdo) when ''06'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end))*100)/p.Jun'+@Mda+')) end as ''Jun_%'''
		if(@i = 7) Set @Jul = ',p.Jul'+@Mda+' as Jul_Psp,Sum(Case(v.Prdo) when ''07'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end) as Jul_Eje,(p.Jul'+@Mda+'-Sum(Case(v.Prdo) when ''07'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end)) as Jul_Dif,Case(p.Jul'+@Mda+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(13,2),((p.Jul'+@Mda+'-Sum(Case(v.Prdo) when ''07'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end))*100)/p.Jul'+@Mda+')) end as ''Jul_%'''
		if(@i = 8) Set @Ago = ',p.Ago'+@Mda+' as Ago_Psp,Sum(Case(v.Prdo) when ''08'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end) as Ago_Eje,(p.Ago'+@Mda+'-Sum(Case(v.Prdo) when ''08'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end)) as Ago_Dif,Case(p.Ago'+@Mda+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(13,2),((p.Ago'+@Mda+'-Sum(Case(v.Prdo) when ''08'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end))*100)/p.Ago'+@Mda+')) end as ''Ago_%'''
		if(@i = 9) Set @Sep = ',p.Sep'+@Mda+' as Sep_Psp,Sum(Case(v.Prdo) when ''09'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end) as Sep_Eje,(p.Sep'+@Mda+'-Sum(Case(v.Prdo) when ''09'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end)) as Sep_Dif,Case(p.Sep'+@Mda+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(13,2),((p.Sep'+@Mda+'-Sum(Case(v.Prdo) when ''09'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end))*100)/p.Sep'+@Mda+')) end as ''Sep_%'''
		if(@i = 10) Set @Oct = ',p.Oct'+@Mda+' as Oct_Psp,Sum(Case(v.Prdo) when ''10'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end) as Oct_Eje,(p.Oct'+@Mda+'-Sum(Case(v.Prdo) when ''10'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end)) as Oct_Dif,Case(p.Oct'+@Mda+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(13,2),((p.Oct'+@Mda+'-Sum(Case(v.Prdo) when ''10'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end))*100)/p.Oct'+@Mda+')) end as ''Oct_%'''
		if(@i = 11) Set @Nov = ',p.Nov'+@Mda+' as Nov_Psp,Sum(Case(v.Prdo) when ''11'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end) as Nov_Eje,(p.Nov'+@Mda+'-Sum(Case(v.Prdo) when ''11'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end)) as Mov_Dif,Case(p.Nov'+@Mda+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(13,2),((p.Nov'+@Mda+'-Sum(Case(v.Prdo) when ''11'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end))*100)/p.Nov'+@Mda+')) end as ''Nov_%'''
		if(@i = 12) Set @Dic = ',p.Dic'+@Mda+' as Dic_Psp,Sum(Case(v.Prdo) when ''12'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end) as Dic_Eje,(p.Dic'+@Mda+'-Sum(Case(v.Prdo) when ''12'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end)) as Dic_Dif,Case(p.Dic'+@Mda+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(13,2),((p.Dic'+@Mda+'-Sum(Case(v.Prdo) when ''12'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end))*100)/p.Dic'+@Mda+')) end as ''Dic_%'''
	end
	Set @ColMes = @ColMes + ',p.'+ (Select user123.DameFormPrdo(right('0'+Convert(nvarchar,@i),2),0,1)+@Mda)
	Set @SumMes = @SumMes + 'p.'+(Select user123.DameFormPrdo(right('0'+Convert(nvarchar,@i),2),0,1)+@Mda)+'+'
	Set @i = @i+1
end

Set @SumMes = left(@SumMes,len(@SumMes)-1)

Declare @GEN_P nvarchar(4000)
Set @GEN_P=''

if(@Det=1)  Set @ColDet = @ColMes

Declare @M1 nvarchar(4000),@M2 nvarchar(4000),@M3 nvarchar(4000)
Declare @CTA_I nvarchar(4000),@CTA_F nvarchar(4000)
Declare @CC_I nvarchar(4000),@CC_F nvarchar(4000)
Declare @SC_I nvarchar(4000),@SC_F nvarchar(4000)
Declare @SS_I nvarchar(4000),@SS_F nvarchar(4000)

Set @M1 =@Ene+'
	'+@Feb+'
	'+@Mar+'
	'+@Abr+'
	'+@May+'
	'+@Jun+'
	'
Set @M2 =@Jul+'
	'+@Ago+'
	'+@Sep+'
	'+@Oct+'
	'+@Nov+'
	'+@Dic+'
	'
Set @M3=',('+@SumMes+') as Mto_Psp,
	isnull(Sum(v.MtoD-v.MtoH),0) as Mto_Eje,
	('+@SumMes+')-isnull(Sum(v.MtoD-v.MtoH),0) as Mto_Dif,
	Case('+@SumMes+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(10,2),((('+@SumMes+')-isnull(Sum(v.MtoD-v.MtoH),0))*100)/('+@SumMes+'))) end as ''Mto_%''
	'
--******************************** CUENTA NIVEL 0 ********************************--
Set @CTA_I = 'select  0 as Nivel,p.NroCta+isnull(p.Cd_CC,'''')+isnull(p.Cd_SC,'''')+isnull(p.Cd_SS,'''') as Codigo,''CTA_''+p.NroCta as Indicador, c.NomCta as Descripcion
	'
Set @CTA_F = 'from VPresupuesto p
	left join Voucher v on v.RucE=p.RucE and v.Ejer=p.Ejer and v.NroCta=p.NroCta and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
	left join PlanCtas c on c.RucE=p.RucE and c.NroCta=p.NroCta and c.Ejer=v.Ejer
	where   p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and p.Cd_CC is null and p.Cd_SC is null and p.Cd_SS is null
	Group by p.NroCta,p.Cd_CC,p.Cd_SC,p.Cd_SS,c.NomCta'+@ColMes+'
	Having ('+@SumMes+')-isnull(Sum(v.MtoD-v.MtoH),0)<>0
	'
--******************************** CC NIVEL 1 ********************************--
if(@ckCC = 1)
	begin
	Set @CC_I = 	'UNION ALL
	select  1 as Nivel,p.NroCta+isnull(p.Cd_CC,'''')+isnull(p.Cd_SC,'''')+isnull(p.Cd_SS,'''') as Codigo,''CC_''+p.Cd_CC as Indicador,cc.Descrip as Descripcion
	'
	Set @CC_F ='from VPresupuesto p
	left join Voucher v on v.RucE=p.RucE and v.Ejer=p.Ejer and v.NroCta=p.NroCta and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and v.Cd_CC=p.Cd_CC
	left join CCostos cc on cc.RucE=p.RucE and cc.Cd_CC=p.Cd_CC
	where   p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+'''	and  p.Cd_CC in ('+isnull(@Cd_cc,'')+') and p.Cd_SC is null and p.Cd_SS is null
	Group by p.NroCta,p.Cd_CC,p.Cd_SC,p.Cd_SS,cc.Descrip'+@ColMes+'
	Having ('+@SumMes+')-isnull(Sum(v.MtoD-v.MtoH),0)<>0
	'
end
--******************************** SC NIVEL 2 ********************************--
if(@ckSC = 1)
begin
	Set @SC_I = 'UNION ALL
	select  2 as Nivel,p.NroCta+isnull(p.Cd_CC,'''')+isnull(p.Cd_SC,'''')+isnull(p.Cd_SS,'''') as Codigo,''SC_''+p.Cd_SC as Indicador,sc.Descrip as Descripcion
	'
	Set @SC_F = 'from VPresupuesto p
	left join Voucher v on v.RucE=p.RucE and v.Ejer=p.Ejer and v.NroCta=p.NroCta and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and v.Cd_CC=p.Cd_CC and v.Cd_SC=p.Cd_SC
	left join CCostos cc on cc.RucE=p.RucE and cc.Cd_CC=p.Cd_CC
	left join CCSub sc on sc.RucE=p.RucE and sc.Cd_CC=p.Cd_CC and sc.Cd_SC=p.Cd_SC
	where   p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and  p.Cd_CC in ('+isnull(@Cd_sc,'')+') and p.Cd_SC in ('+isnull(@Cd_cc,'')+') and p.Cd_SS is null
	Group by p.NroCta,p.Cd_CC,p.Cd_SC,p.Cd_SS,sc.Descrip'+@ColMes+'
	Having ('+@SumMes+')-isnull(Sum(v.MtoD-v.MtoH),0)<>0
	'
end
--******************************** SS NIVEL 3 ********************************--
if(@ckSS = 1)
begin
	Set @SS_I = 'UNION ALL
	select  3 as Nivel,p.NroCta+isnull(p.Cd_CC,'''')+isnull(p.Cd_SC,'''')+isnull(p.Cd_SS,'''') as Codigo,''SS_''+p.Cd_SS as Indicador,ss.Descrip as Descripcion
	'
	Set @SS_F = 'from VPresupuesto p
	left join Voucher v on v.RucE=p.RucE and v.Ejer=p.Ejer and v.NroCta=p.NroCta and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''  and v.Cd_CC=p.Cd_CC and v.Cd_SC=p.Cd_SC and v.Cd_SS=p.Cd_SS
	left join CCostos cc on cc.RucE=p.RucE and cc.Cd_CC=p.Cd_CC
	left join CCSub sc on sc.RucE=p.RucE and sc.Cd_CC=p.Cd_CC and sc.Cd_SC=p.Cd_SC
	left join CCSubSub ss on ss.RucE=p.RucE and ss.Cd_CC=p.Cd_CC and ss.Cd_SC=p.Cd_SC and ss.Cd_SS=p.Cd_SS
	where   p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and  p.Cd_CC in ('+isnull(@Cd_cc,'')+') and p.Cd_SC  in ('+isnull(@Cd_sc,'')+') and p.Cd_SS in ('+isnull(@Cd_ss,'')+')
	Group by p.NroCta,p.Cd_CC,p.Cd_SC,p.Cd_SS,ss.Descrip'+@ColMes+'
	Having ('+@SumMes+')-isnull(Sum(v.MtoD-v.MtoH),0)<>0
	'
end
--************** CUENTA **************--
Print @CTA_I
Print @M1
Print @M2
Print @M3
Print @CTA_F
--************** CC **************--
Print @CC_I
Print @M1
Print @M2
Print @M3
Print @CC_F
--************** SC **************--
Print @SC_I
Print @M1
Print @M2
Print @M3
Print @SC_F
--************** SS **************--
Print @SS_I
Print @M1
Print @M2
Print @M3
Print @SS_F

if(@ckSS = 1)
	Exec  (	@CTA_I+@M1+@M2+@M3+@CTA_F+
		@CC_I+@M1+@M2+@M3+@CC_F+
		@SC_I+@M1+@M2+@M3+@SC_F+
		@SS_I+@M1+@M2+@M3+@SS_F+'Order by 2,1')
else
begin
	if(@ckSC = 1)
		Exec  (	@CTA_I+@M1+@M2+@M3+@CTA_F+
			@CC_I+@M1+@M2+@M3+@CC_F+
			@SC_I+@M1+@M2+@M3+@SC_F+'Order by 2,1')
	else
	begin
		if(@ckCC = 1)
			Exec  (	@CTA_I+@M1+@M2+@M3+@CTA_F+
				@CC_I+@M1+@M2+@M3+@CC_F+'Order by 2,1')
		else
			Exec  (	@CTA_I+@M1+@M2+@M3+@CTA_F+'Order by 2,1')
	end
end
-- Leyenda --

-- DI : 11/01/10 <se creo el procedimiento almacenado para realizar la consulta a presupuestos y voucher>
-- DI : 13/01/10 <se modifico el procedimiento almacenado ... se cambio las columnas de periodos>
-- PP : 2010-09-23 12:48:32.327	<Modificacion para la selecion de centros de costos>
--					<Parametros agregados>
GO

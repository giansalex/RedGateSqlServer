SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Pre_MontoPresu_Cons]
@RucE nvarchar(11),
@Ejer nvarchar(11),
@PrdoIni nvarchar(11),
@PrdoFin nvarchar(11),
@Moneda nvarchar(2),
@ckCC bit,
@ckSC bit,
@ckSS bit,
@Det bit,
@msj varchar(100) output

as
Delete from Presupuesto where RucE=@RucE and NroCta not in (select NroCta from PlanCtas where RucE=@RucE and Ejer=@Ejer and IB_Psp=1 and Nivel=4 Group by NroCta)
/*

Declare @RucE nvarchar(11)
Declare @Ejer nvarchar(11)
Declare @PrdoIni nvarchar(11)
Declare @PrdoFin nvarchar(11)
Declare @Moneda nvarchar(2)
Declare @ckCC bit
Declare @ckSC bit
Declare @ckSS bit
Declare @Det bit
Declare @Nom bit

Set @RucE ='11111111111'
Set @Ejer ='2009'
Set @PrdoIni ='01'
Set @PrdoFin ='12'
Set @Moneda ='02'
Set @ckCC = '1'
Set @ckSC = '1'
Set @ckSS = '1'
Set @Det = '1'
*/

Declare @Mda nvarchar(3)
Declare @ColMes nvarchar(1000)
Declare @SumMes nvarchar(1000)
Declare @ColDet nvarchar(1000)
Declare @Ene nvarchar(1000),@Feb nvarchar(1000),@Mar nvarchar(1000),@Abr nvarchar(1000),@May nvarchar(1000),@Jun nvarchar(1000)
Declare @Jul nvarchar(1000),@Ago nvarchar(1000),@Sep nvarchar(1000),@Oct nvarchar(1000),@Nov nvarchar(1000),@Dic nvarchar(1000)
Set @Mda = ''
Set @ColMes = ''
Set @SumMes = ''
Set @ColDet = ''
Set @Ene= '' Set @Feb= '' Set @Mar= '' Set @Abr= '' Set @May= '' Set @Jun= '' 
Set @Jul= '' Set @Ago= '' Set @Sep= '' Set @Oct= '' Set @Nov= '' Set @Dic= ''

if(@Moneda = '02') Set @Mda = '_ME'

Declare @i int,@f int
Set @i = convert(int,@PrdoIni)
Set @f = convert(int,@PrdoFin)

while (@i <= @f)
begin
	if(@i < 10)	
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
		end

		Set @ColMes = @ColMes + ',p.'+ (Select user123.DameFormPrdo('0'+Convert(nvarchar,@i),0,1)+@Mda)
		Set @SumMes = @SumMes + 'p.'+(Select user123.DameFormPrdo('0'+Convert(nvarchar,@i),0,1)+@Mda)+'+'			
	end
	
	else	
	begin	
		if(@Det=1)
		begin
			if(@i = 10) Set @Oct = ',p.Oct'+@Mda+' as Oct_Psp,Sum(Case(v.Prdo) when ''10'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end) as Oct_Eje,(p.Oct'+@Mda+'-Sum(Case(v.Prdo) when ''10'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end)) as Oct_Dif,Case(p.Oct'+@Mda+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(13,2),((p.Oct'+@Mda+'-Sum(Case(v.Prdo) when ''10'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end))*100)/p.Oct'+@Mda+')) end as ''Oct_%'''
			if(@i = 11) Set @Nov = ',p.Nov'+@Mda+' as Nov_Psp,Sum(Case(v.Prdo) when ''11'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end) as Nov_Eje,(p.Nov'+@Mda+'-Sum(Case(v.Prdo) when ''11'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end)) as Mov_Dif,Case(p.Nov'+@Mda+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(13,2),((p.Nov'+@Mda+'-Sum(Case(v.Prdo) when ''11'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end))*100)/p.Nov'+@Mda+')) end as ''Nov_%'''
			if(@i = 12) Set @Dic = ',p.Dic'+@Mda+' as Dic_Psp,Sum(Case(v.Prdo) when ''12'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end) as Dic_Eje,(p.Dic'+@Mda+'-Sum(Case(v.Prdo) when ''12'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end)) as Dic_Dif,Case(p.Dic'+@Mda+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(13,2),((p.Dic'+@Mda+'-Sum(Case(v.Prdo) when ''12'' then isnull((v.MtoD'+@Mda+'-v.MtoH'+@Mda+'),0) else 0 end))*100)/p.Dic'+@Mda+')) end as ''Dic_%'''
		end
		
		Set @ColMes = @ColMes + ',p.'+ (Select user123.DameFormPrdo(Convert(nvarchar,@i),0,1)+@Mda)
		Set @SumMes = @SumMes + 'p.'+(Select user123.DameFormPrdo(Convert(nvarchar,@i),0,1)+@Mda)+'+'	
	end
	Set @i = @i+1
end

Set @SumMes = left(@SumMes,len(@SumMes)-1)

Declare @GEN_P nvarchar(4000)
Set @GEN_P=''

if(@Det=1)  Set @ColDet = @ColMes

Set @GEN_P = 
	'	,('+@SumMes+') as Mto_Psp,
		isnull(Sum(v.MtoD-v.MtoH),0) as Mto_Eje,
		('+@SumMes+')-isnull(Sum(v.MtoD-v.MtoH),0) as Mto_Dif,
		Case('+@SumMes+') when 0 then ''-'' else Convert(nvarchar,Convert(decimal(10,2),((('+@SumMes+')-isnull(Sum(v.MtoD-v.MtoH),0))*100)/('+@SumMes+'))) end as ''Mto_%''
	'
--***************** Muestra *****************--
Print '--********** Muestra **********--'
Print @ColMes
Print @SumMes
Print @Ene
Print @Feb
Print @Mar
Print @Abr
Print @May
Print @Jun
Print @Jul
Print @Ago
Print @Sep
Print @Oct
Print @Nov
Print @Dic
Print '--********** Fin Muestra **********--'
--***************** Muestra *****************--

Declare @CTA_P1 nvarchar(4000),@CTA_P2 nvarchar(4000),@CTA_P3 nvarchar(4000),@CTA_P4 nvarchar(4000),@CTA_P5 nvarchar(4000)
Declare @CC_P1 nvarchar(4000),@CC_P2 nvarchar(4000),@CC_P3 nvarchar(4000),@CC_P4 nvarchar(4000),@CC_P5 nvarchar(4000)
Declare @SC_P1 nvarchar(4000),@SC_P2 nvarchar(4000),@SC_P3 nvarchar(4000),@SC_P4 nvarchar(4000),@SC_P5 nvarchar(4000)
Declare @SS_P1 nvarchar(4000),@SS_P2 nvarchar(4000),@SS_P3 nvarchar(4000),@SS_P4 nvarchar(4000),@SS_P5 nvarchar(4000)
Set @CTA_P1='' Set @CTA_P2='' Set @CTA_P3='' Set @CTA_P4='' Set @CTA_P5=''
Set @CC_P1='' Set @CC_P2='' Set @CC_P3='' Set @CC_P4='' Set @CC_P5=''
Set @SC_P1='' Set @SC_P2='' Set @SC_P3='' Set @SC_P4='' Set @SC_P5=''
Set @SS_P1='' Set @SS_P2='' Set @SS_P3='' Set @SS_P4='' Set @SS_P5=''


--******************************** CUENTA NIVEL 0 ********************************--

Set @CTA_P1 = 
	'
	select  0 as Nivel,
		p.NroCta+isnull(p.Cd_CC,'''')+isnull(p.Cd_SC,'''')+isnull(p.Cd_SS,'''') as Codigo,
		''CTA_''+p.NroCta as Indicador, c.NomCta as Descripcion
	'
Set @CTA_P2 =
	''+@Ene+@Feb+@Mar+@Abr+@May+@Jun+''
Set @CTA_P3 =
	''+@Jul+@Ago+@Sep+@Oct+@Nov+@Dic+''

Set @CTA_P4 = @GEN_P

Set @CTA_P5 = 
	'
	from VPresupuesto p
	left join Voucher v on v.RucE=p.RucE and v.Ejer=p.Ejer and v.NroCta=p.NroCta and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
	left Join PlanCtas c on c.RucE=p.RucE and c.NroCta=p.NroCta and c.Ejer=v.Ejer
	where   p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+'''
		and isnull(p.Cd_CC,''*'')=''*'' and isnull(p.Cd_SC,''*'')=''*'' and isnull(p.Cd_SS,''*'')=''*''
	Group by p.NroCta,p.Cd_CC,p.Cd_SC,p.Cd_SS,c.NomCta'+@ColMes+'
	Having ('+@SumMes+')-isnull(Sum(v.MtoD-v.MtoH),0)<>0
	'

--******************************** CC NIVEL 1 ********************************--
if(@ckCC = 1)
begin
	Set @CC_P1 = 
		'

		UNION ALL

		select  1 as Nivel,
			p.NroCta+isnull(p.Cd_CC,'''')+isnull(p.Cd_SC,'''')+isnull(p.Cd_SS,'''') as Codigo,
			''CC_''+p.Cd_CC as Indicador,cc.Descrip as Descripcion
		'
	Set @CC_P2 =
		''+@Ene+@Feb+@Mar+@Abr+@May+@Jun+''
	Set @CC_P3 =
		''+@Jul+@Ago+@Sep+@Oct+@Nov+@Dic+''

	Set @CC_P4 = @GEN_P

	Set @CC_P5 = 
		'
		from VPresupuesto p
		left join Voucher v on v.RucE=p.RucE and v.Ejer=p.Ejer and v.NroCta=p.NroCta and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and v.Cd_CC=p.Cd_CC
		left join CCostos cc on cc.RucE=p.RucE and cc.Cd_CC=p.Cd_CC
		where   p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+'''
			and isnull(p.Cd_CC,''*'')<>''*'' and isnull(p.Cd_SC,''*'')=''*'' and isnull(p.Cd_SS,''*'')=''*''
		Group by p.NroCta,p.Cd_CC,p.Cd_SC,p.Cd_SS,cc.Descrip'+@ColMes+'
		Having ('+@SumMes+')-isnull(Sum(v.MtoD-v.MtoH),0)<>0
		'
end

--******************************** SC NIVEL 2 ********************************--
if(@ckSC = 1)
begin
	Set @SC_P1 = 
		'

		UNION ALL

		select  2 as Nivel,
			p.NroCta+isnull(p.Cd_CC,'''')+isnull(p.Cd_SC,'''')+isnull(p.Cd_SS,'''') as Codigo,
			''SC_''+p.Cd_SC as Indicador,sc.Descrip as Descripcion
		'

	Set @SC_P2 =
		''+@Ene+@Feb+@Mar+@Abr+@May+@Jun+''
	Set @SC_P3 =
		''+@Jul+@Ago+@Sep+@Oct+@Nov+@Dic+''

	Set @SC_P4 = @GEN_P
	
	Set @SC_P5 = 
		'
		from VPresupuesto p
		left join Voucher v on v.RucE=p.RucE and v.Ejer=p.Ejer and v.NroCta=p.NroCta and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and v.Cd_CC=p.Cd_CC and v.Cd_SC=p.Cd_SC
		left join CCostos cc on cc.RucE=p.RucE and cc.Cd_CC=p.Cd_CC
		left join CCSub sc on sc.RucE=p.RucE and sc.Cd_CC=p.Cd_CC and sc.Cd_SC=p.Cd_SC
		where   p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+'''
			and isnull(p.Cd_CC,''*'')<>''*'' and isnull(p.Cd_SC,''*'')<>''*'' and isnull(p.Cd_SS,''*'')=''*''
		Group by p.NroCta,p.Cd_CC,p.Cd_SC,p.Cd_SS,sc.Descrip'+@ColMes+'
		Having ('+@SumMes+')-isnull(Sum(v.MtoD-v.MtoH),0)<>0
		'
end

--******************************** SS NIVEL 2 ********************************--
if(@ckSS = 1)
begin
	Set @SS_P1 = 
		'

		UNION ALL

		select  3 as Nivel,
			p.NroCta+isnull(p.Cd_CC,'''')+isnull(p.Cd_SC,'''')+isnull(p.Cd_SS,'''') as Codigo,
			''SS_''+p.Cd_SS as Indicador,ss.Descrip as Descripcion
		'

	Set @SS_P2 =
		''+@Ene+@Feb+@Mar+@Abr+@May+@Jun+''
	Set @SS_P3 =
		''+@Jul+@Ago+@Sep+@Oct+@Nov+@Dic+''

	Set @SS_P4 = @GEN_P

	Set @SS_P5 = 
		'
		from VPresupuesto p
		left join Voucher v on v.RucE=p.RucE and v.Ejer=p.Ejer and v.NroCta=p.NroCta and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''  and v.Cd_CC=p.Cd_CC and v.Cd_SC=p.Cd_SC and v.Cd_SS=p.Cd_SS
		left join CCostos cc on cc.RucE=p.RucE and cc.Cd_CC=p.Cd_CC
		left join CCSub sc on sc.RucE=p.RucE and sc.Cd_CC=p.Cd_CC and sc.Cd_SC=p.Cd_SC
		left join CCSubSub ss on ss.RucE=p.RucE and ss.Cd_CC=p.Cd_CC and ss.Cd_SC=p.Cd_SC and ss.Cd_SS=p.Cd_SS
		where   p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+'''
			and isnull(p.Cd_CC,''*'')<>''*'' and isnull(p.Cd_SC,''*'')<>''*'' and isnull(p.Cd_SS,''*'')<>''*''
		Group by p.NroCta,p.Cd_CC,p.Cd_SC,p.Cd_SS,ss.Descrip'+@ColMes+'
		Having ('+@SumMes+')-isnull(Sum(v.MtoD-v.MtoH),0)<>0
		'
end

--************** CUENTA **************--
Print @CTA_P1
Print @CTA_P2
Print @CTA_P3
Print @CTA_P4
Print @CTA_P5

--************** CC **************--
Print @CC_P1
Print @CC_P2
Print @CC_P3
Print @CC_P4
Print @CC_P5


--************** SC **************--
Print @SC_P1
Print @SC_P2
Print @SC_P3
Print @SC_P4
Print @SC_P5

--************** SS **************--
Print @SS_P1
Print @SS_P2
Print @SS_P3
Print @SS_P4
Print @SS_P5


Exec  (@CTA_P1+@CTA_P2+@CTA_P3+@CTA_P4+@CTA_P5+
	@CC_P1+@CC_P2+@CC_P3+@CC_P4+@CC_P5+
	@SC_P1+@SC_P2+@SC_P3+@SC_P4+@SC_P5+
	@SS_P1+@SS_P2+@SS_P3+@SS_P4+@SS_P5+
	'Order by 2,1')

-- Leyenda --
-- DI : 11/01/10 <se creo el procedimiento almacenado para realizar la consulta a presupuestos y voucher>
-- DI : 13/01/10 <se modifico el procedimiento almacenado ... se cambio las columnas de periodos>
GO

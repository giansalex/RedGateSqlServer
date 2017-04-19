SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Pre_CCPresupuestados_Explo3 '11111111111','2011','01','F','01','06',1,null,null,null
CREATE procedure [dbo].[Pre_CCPresupuestados_Explo3]
@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Mda varchar(2),
@Opc char(1),
@PrdoIni char(2),
@PrdoFin char(2),
@VerCta bit,
@Cd_CC varchar(8000),
@Cd_SC varchar(8000),
@Cd_SS varchar(8000)
AS



-- Internos
declare @ConsCC varchar(50),@ConsSC varchar(50),@ConsSS varchar(50)
declare @Mon char(3), @Consulta varchar(max),@Consulta1 varchar(max),@Consulta2 varchar(500), @Cond varchar(500)
declare @Col1 varchar(500), @Col2 varchar(500), @Col3 varchar(500) 
declare @OrderBy varchar(500)

declare @Cons1 varchar(8000),@Cons2 varchar(8000),@Cons3 varchar(8000)
declare @mcons1 varchar(5),@mcons2 varchar(5),@mcons3 varchar(5)
set @mcons1='' set @mcons2='' set @mcons3=''
declare @Cons_CC_Ini varchar(500), @Cons_SC_Ini varchar(500), @Cons_SS_Ini varchar(500)
declare @Cons_CC_Fin varchar(500), @Cons_SC_Fin varchar(500), @Cons_SS_Fin varchar(500)

--Set
set @Cond='' set @Col1='' set @Col2='' set @Col3='' set @Mon=''
set @ConsCC='' set @ConsSC='' set @ConsSS=''
-- si elijo para que filtre tambien las cuentas de ingreso/egreso por funcion o naturaleza --
if(ISNULL(@Opc,'')<>'')
begin
	set @Cond=' and Isnull(pc.IC_IE'+@Opc+','''')<>'''' '
	set @Col1=', pc.IC_IE'+@Opc
	set @Col2=', t1.IC_IE'
	set @Col3=', '''' IC_IE'
end
if(Isnull(@Cd_CC,'')<>'')
Begin
	set @ConsCC='and p.Cd_CC in ('
	set @mcons1=') '
End
if(Isnull(@Cd_SC,'')<>'')
Begin
	set @ConsSC='and p.Cd_SC in ('
	set @mcons2=') '
End
if(Isnull(@Cd_SS,'')<>'')
Begin
	set @ConsSS='and p.Cd_SS in ('
	set @mcons3=') '
End
if(@Cd_Mda='02') set @Mon='_Me'

-- Consulta principal --
--case when Month(@FecIni)<=1 and Month(@FecFin)>=1  

set @Consulta='
select t1.niv,t1.RucE,t1.Ejer,t1.Cd_CC,Isnull(t1.Cd_SC,''Sin SC.'') Cd_SC,Isnull(t1.Cd_SS,''Sin SS.'') Cd_SS,t1.NroCta,tpc.NomCta,
		Isnull(t1.Ene_P,.0) Ene_P,Isnull(t2.Ene_E,.0) Ene_E,(Isnull(t1.Ene_P,.0)-Isnull(t2.Ene_E,.0)) as Ene_D,Isnull(t1.Feb_P,.0) Feb_P,Isnull(t2.Feb_E,.0) Feb_E,(Isnull(t1.Feb_P,.0)-Isnull(t2.Feb_E,.0)) as Feb_D,
		Isnull(t1.Mar_P,.0) Mar_P,Isnull(t2.Mar_E,.0) Mar_E,(Isnull(t1.Mar_P,.0)-Isnull(t2.Mar_E,.0)) as Mar_D,Isnull(t1.Abr_P,.0) Abr_P,Isnull(t2.Abr_E,.0) Abr_E,(Isnull(t1.Abr_P,.0)-Isnull(t2.Abr_E,.0)) As Abr_D,
		Isnull(t1.May_P,.0) May_P,Isnull(t2.May_E,.0) May_E,(Isnull(t1.May_P,.0)-Isnull(t2.May_E,.0)) as May_D,Isnull(t1.Jun_P,.0) Jun_P,Isnull(t2.Jun_E,.0) Jun_E,(Isnull(t1.Jun_P,.0)-Isnull(t2.Jun_E,.0)) as Jun_D,
		Isnull(t1.Jul_P,.0) Jul_P,Isnull(t2.Jul_E,.0) Jul_E,(Isnull(t1.Jul_P,.0)-Isnull(t2.Jul_E,.0)) As Jul_D,Isnull(t1.Ago_P,.0) Ago_P,Isnull(t2.Ago_E,.0) Ago_E,(Isnull(t1.Ago_P,.0)-Isnull(t2.Ago_E,.0)) As Ago_D,
		Isnull(t1.Sep_P,.0) Sep_P,Isnull(t2.Sep_E,.0) Sep_E,(Isnull(t1.Sep_P,.0)-Isnull(t2.Sep_E,.0)) As Sep_D,Isnull(t1.Oct_P,.0) Oct_P,Isnull(t2.Oct_E,.0) Oct_E,(Isnull(t1.Oct_P,.0)-Isnull(t2.Oct_E,.0)) As Oct_D,
		Isnull(t1.Nov_P,.0) Nov_P,Isnull(t2.Nov_E,.0) Nov_E,(Isnull(t1.Nov_P,.0)-Isnull(t2.Nov_E,.0)) As Nov_D,Isnull(t1.Dic_P,.0) Dic_P,Isnull(t2.Dic_E,.0) Dic_E,(Isnull(t1.Dic_P,.0)-Isnull(t2.Dic_E,.0)) As Dic_D
		'+@Col2+' from(select 1 as niv, Max(p.RucE) RucE, Max(p.Ejer) Ejer, Cd_CC, Cd_SC, Cd_SS, '''' NroCta, Case when Convert(int,'+@PrdoIni+')<=1 and Convert(int,'+@PrdoFin+')>=1 then Sum(Ene'+RTrim(@Mon)+') else .0 End As Ene_P,Case when Convert(int,'+@PrdoIni+')<=2 and Convert(int,'+@PrdoFin+')>=2 then Sum(Feb'+RTrim(@Mon)+') else .0 End As Feb_P,case when Convert(int,'+@PrdoIni+')<=3 and Convert(int,'+@PrdoFin+')>=3 then Sum(Mar'+RTrim(@Mon)+') else .0 End As Mar_P,case when Convert(int,'+@PrdoIni+')<=4 and Convert(int,'+@PrdoFin+')>=4 then Sum(Abr'+RTrim(@Mon)+') else .0 End As Abr_P,
		Case When Convert(int,'+@PrdoIni+')<=5 and Convert(int,'+@PrdoFin+')>=5 then Sum(May'+RTrim(@Mon)+') else .0 End As May_P,Case when Convert(int,'+@PrdoIni+')<=6 and Convert(int,'+@PrdoFin+')>=6 then Sum(Jun'+RTrim(@Mon)+') else .0 End As Jun_P,case when Convert(int,'+@PrdoIni+')<=7 and Convert(int,'+@PrdoFin+')>=7 then Sum(Jul'+RTrim(@Mon)+') else .0 End As Jul_P,case when Convert(int,'+@PrdoIni+')<=8 and Convert(int,'+@PrdoFin+')>=8 then Sum(Ago'+RTrim(@Mon)+') else .0 End As Ago_P,
		Case When Convert(int,'+@PrdoIni+')<=9 and Convert(int,'+@PrdoFin+')>=9 then Sum(Sep'+RTrim(@Mon)+') Else .0 End As Sep_P,Case when Convert(int,'+@PrdoIni+')<=10 and Convert(int,'+@PrdoFin+')>=10 then Sum(Oct'+RTrim(@Mon)+') Else .0 End As Oct_P,Case when Convert(int,'+@PrdoIni+')<=11 and Convert(int,'+@PrdoFin+')>=11 then Sum(Nov'+RTrim(@Mon)+') Else .0 End As Nov_P,case when Convert(int,'+@PrdoIni+')<=12 and Convert(int,'+@PrdoFin+')>=12 then Sum(Dic'+RTrim(@Mon)+') Else .0 End As Dic_P
		'+@Col3+' from  presupuesto p left join PlanCtas pc on pc.RucE=p.RucE and pc.Ejer=p.Ejer and pc.NroCta=p.NroCta
where p.RucE='''+Convert(varchar,@RucE)+''' and p.Ejer='''+Convert(varchar,@Ejer)+''' '

set @Cons1='
'+@Cond+' Group By p.Cd_CC,p.Cd_SC,p.Cd_SS
union all
select 2 as niv,Max(p.RucE) RucE,Max(p.Ejer) Ejer,Cd_CC,Cd_SC,Cd_SS,p.NroCta,Case when Convert(int,'+@PrdoIni+')<=1 and Convert(int,'+@PrdoFin+')>=1 then Sum(Ene'+RTrim(@Mon)+') else .0 End As Ene_P,Case when Convert(int,'+@PrdoIni+')<=2 and Convert(int,'+@PrdoFin+')>=2 then Sum(Feb'+RTrim(@Mon)+') else .0 End As Feb_P,case when Convert(int,'+@PrdoIni+')<=3 and Convert(int,'+@PrdoFin+')>=3 then Sum(Mar'+RTrim(@Mon)+') else .0 End As Mar_P,case when Convert(int,'+@PrdoIni+')<=4 and Convert(int,'+@PrdoFin+')>=4 then Sum(Abr'+RTrim(@Mon)+') else .0 End As Abr_P,
		Case When Convert(int,'+@PrdoIni+')<=5 and Convert(int,'+@PrdoFin+')>=5 then Sum(May'+RTrim(@Mon)+') else .0 End As May_P,Case when Convert(int,'+@PrdoIni+')<=6 and Convert(int,'+@PrdoFin+')>=6 then Sum(Jun'+RTrim(@Mon)+') else .0 End As Jun_P,case when Convert(int,'+@PrdoIni+')<=7 and Convert(int,'+@PrdoFin+')>=7 then Sum(Jul'+RTrim(@Mon)+') else .0 End As Jul_P,case when Convert(int,'+@PrdoIni+')<=8 and Convert(int,'+@PrdoFin+')>=8 then Sum(Ago'+RTrim(@Mon)+') else .0 End As Ago_P,
		Case When Convert(int,'+@PrdoIni+')<=9 and Convert(int,'+@PrdoFin+')>=9 then Sum(Sep'+RTrim(@Mon)+') Else .0 End As Sep_P,Case when Convert(int,'+@PrdoIni+')<=10 and Convert(int,'+@PrdoFin+')>=10 then Sum(Oct'+RTrim(@Mon)+') Else .0 End As Oct_P,Case when Convert(int,'+@PrdoIni+')<=11 and Convert(int,'+@PrdoFin+')>=11 then Sum(Nov'+RTrim(@Mon)+') Else .0 End As Nov_P,case when Convert(int,'+@PrdoIni+')<=12 and Convert(int,'+@PrdoFin+')>=12 then Sum(Dic'+RTrim(@Mon)+') Else .0 End As Dic_P
		'+@Col1+' from presupuesto p left join PlanCtas pc on pc.RucE=p.RucE and pc.Ejer=p.Ejer and pc.NroCta=p.NroCta
where p.RucE='''+Convert(varchar,@RucE)+''' and p.Ejer='''+Convert(varchar,@Ejer)+'''
		'+@Cond+' '
set @Cons2='
Group By p.Cd_CC,p.Cd_SC,p.Cd_SS,p.NroCta'+@Col1+') as t1 

left join (select niv,con.RucE,con.Ejer,con.Cd_CC,con.Cd_SC,con.Cd_SS,con.NroCta,
	con.Ene_E,con.Feb_E,con.Mar_E,con.Abr_E,con.May_E,con.Jun_E,
	con.Jul_E,con.Ago_E,con.Sep_E, con.Oct_E,con.Nov_E,con.Dic_E
from (select 1 as niv,Max(v.RucE) RucE,Max(v.Ejer) Ejer,p.Cd_CC,p.Cd_SC,p.Cd_SS, '''' NroCta,SUM(case when v.Prdo=''01'' then v.MtoD'+RTrim(@Mon)+' - v.MtoH'+RTrim(@Mon)+' else 0.00 end) as Ene_E
		,SUM(case when v.Prdo=''02'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Feb_E
		,SUM(case when v.Prdo=''03'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Mar_E
		,SUM(case when v.Prdo=''04'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Abr_E
		,SUM(case when v.Prdo=''05'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as May_E
		,SUM(case when v.Prdo=''06'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Jun_E
		,SUM(case when v.Prdo=''07'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Jul_E
		,SUM(case when v.Prdo=''08'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Ago_E
		,SUM(case when v.Prdo=''09'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Sep_E
		,SUM(case when v.Prdo=''10'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Oct_E
		,SUM(case when v.Prdo=''11'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Nov_E
		,SUM(case when v.Prdo=''12'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Dic_E
from Presupuesto p left join voucher v on v.RucE=p.RucE and v.Ejer=p.Ejer and v.NroCta=p.NroCta
		and case when ISNULL(p.Cd_CC,'''')='''' then '''' else v.Cd_CC end = ISNULL(p.Cd_CC,'''')
		and case when ISNULL(p.Cd_SC,'''')='''' then '''' else v.Cd_SC end = ISNULL(p.Cd_SC,'''')
		and case when ISNULL(p.Cd_SS,'''')='''' then '''' else v.Cd_SS end = ISNULL(p.Cd_SS,'''')
where v.RucE='''+Convert(varchar,@RucE)+''' and v.Ejer='''+Convert(varchar,@Ejer)+''' and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
'
set @Consulta1='
Group By 
		p.Cd_CC, p.Cd_SC, p.Cd_SS
Union all
select 2 as niv, Max(v.RucE) RucE, Max(v.Ejer) Ejer, p.Cd_CC, p.Cd_SC, p.Cd_SS, v.NroCta
		,SUM(case when v.Prdo=''01'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Ene_E
		,SUM(case when v.Prdo=''02'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Feb_E
		,SUM(case when v.Prdo=''03'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Mar_E
		,SUM(case when v.Prdo=''04'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Abr_E
		,SUM(case when v.Prdo=''05'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as May_E
		,SUM(case when v.Prdo=''06'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Jun_E
		,SUM(case when v.Prdo=''07'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Jul_E
		,SUM(case when v.Prdo=''08'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Ago_E
		,SUM(case when v.Prdo=''09'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Sep_E
		,SUM(case when v.Prdo=''10'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Oct_E
		,SUM(case when v.Prdo=''11'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Nov_E
		,SUM(case when v.Prdo=''12'' then v.MtoD'+RTrim(@Mon)+'-v.MtoH'+RTrim(@Mon)+' else .0 end) as Dic_E
from Presupuesto p left join voucher v on v.RucE=p.RucE and v.Ejer=p.Ejer and v.NroCta=p.NroCta
		and case when ISNULL(p.Cd_CC,'''')='''' then '''' else v.Cd_CC end = ISNULL(p.Cd_CC,'''')
		and case when ISNULL(p.Cd_SC,'''')='''' then '''' else v.Cd_SC end = ISNULL(p.Cd_SC,'''')
		and case when ISNULL(p.Cd_SS,'''')='''' then '''' else v.Cd_SS end = ISNULL(p.Cd_SS,'''')
where 
		v.RucE='''+Convert(varchar,@RucE)+''' and v.Ejer='''+Convert(varchar,@Ejer)+''' and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' 
'
set @Consulta2='
Group By 
		p.Cd_CC, p.Cd_SC, p.Cd_SS,v.NroCta) as con) as t2 on t2.RucE=t1.RucE and t2.Ejer=t1.Ejer 
		and case when ISNULL(t2.Cd_CC,'''')='''' then '''' else t1.Cd_CC end = ISNULL(t2.Cd_CC,'''')
		and case when ISNULL(t2.Cd_SC,'''')='''' then '''' else t1.Cd_SC end = ISNULL(t2.Cd_SC,'''')
		and case when ISNULL(t2.Cd_SS,'''')='''' then '''' else t1.Cd_SS end = ISNULL(t2.Cd_SS,'''')
		and t2.NroCta=t1.NroCta
		left join PlanCtas tpc On tpc.RucE=t1.RucE and tpc.Ejer=t1.Ejer and tpc.NroCta=t1.NroCta
		'

-- Seteo de Selects para obtener los Centros de costos --
set @Cons_CC_Ini= '
			   select Cons.Cd_CC, cc.Descrip from ('
set @Cons_CC_Fin=') 
			   as Cons inner join CCostos cc on cc.RucE=Cons.RucE and cc.Cd_CC=cons.Cd_CC
			   where Cons.NroCta<>'''' Group By Cons.Cd_CC, cc.Descrip 
			   order by Cons.Cd_CC
			   '
set @Cons_SC_Ini='
			  select Cons.Cd_CC, isnull(Cons.Cd_SC,''Sin SC.'') Cd_SC, Isnull(cc.Descrip,''Sin Sub Centro de Costo'') Descrip 
			  from ('
set @Cons_SC_Fin=') as Cons left join CCSub cc on cc.RucE=Cons.RucE and cc.Cd_CC=Cons.Cd_CC and cc.Cd_SC=Cons.Cd_SC
			  where Cons.NroCta<>'''' Group by Cons.Cd_CC, Cons.Cd_SC, cc.Descrip
			  order by Cons.Cd_CC, Cons.Cd_SC
			  '
set @Cons_SS_Ini='
			  select Cons.Cd_CC, isnull(Cons.Cd_SC,''Sin SC.'') Cd_SC, isnull(Cons.Cd_SS,''Sin SS.'') Cd_SS, Isnull(cc.Descrip,''Sin Sub Sub Centro de Costo'') Descrip 
			  from ('
set @Cons_SS_Fin=') as Cons left join CCSubSub cc on cc.RucE=Cons.RucE and cc.Cd_CC=Cons.Cd_CC and cc.Cd_SC=Cons.Cd_SC and cc.Cd_SS=Cons.Cd_SS
			  where Cons.NroCta<>'''' Group by Cons.Cd_CC, Cons.Cd_SC, Cons.Cd_SS, cc.Descrip
			  order by Cons.Cd_CC, Cons.Cd_SC, Cons.Cd_SS
			  '

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


-- Print del Length de consulta principal --
print 'Len(@Consulta): '+Convert(varchar,len(@Consulta))
print 'Len(@Consulta1): '+Convert(varchar,len(@Consulta1))
print 'Len(@Consulta2): '+Convert(varchar,len(@Consulta2))
-- Imprimiendo las consultas --
print 'Imprimiendo las Consultas'

print @SQL_CA
--Centro de Costos
print @Cons_CC_Ini
print @Consulta
print @Consulta1
print @Consulta2
print @Cons_CC_Fin
-- Sub Centro de Costos
print @Cons_SC_Ini
print @Consulta
print @Consulta1
print @Consulta2
print @Cons_SC_Fin
-- Sub Sub Centro de Costos
print @Cons_SS_Ini
print @Consulta
print @Consulta1
print @Consulta2
print @Cons_SS_Fin

print @Consulta
print @Consulta1
print @Consulta2

if(@VerCta=1)
	set @OrderBy='
				where t1.niv <> 1 order by NroCta'
else
	set @OrderBy='
				where t1.niv <> 2 order by Cd_CC, Cd_SC, Cd_SS, NroCta'
--print 'where t1.niv <> 1 order by Cd_CC, Cd_SC, Cd_SS, NroCta'
--print @OrderBy
print @SQL_CA
-- Centro de Costos --
--print @Cons_CC_Ini
--print @consulta
--print @ConsCC+@Cd_CC+ @mcons1
--print @ConsSC+@Cd_SC+ @mcons2
--print @ConsSS+@Cd_SS+ @mcons3
--print @Cons1
--print @ConsCC+@Cd_CC+ @mcons1
--print @ConsSC+@Cd_SC+ @mcons2
--print @ConsSS+@Cd_SS+ @mcons3
--print @Cons2
--print @ConsCC+@Cd_CC+ @mcons1
--print @ConsSC+@Cd_SC+ @mcons2
--print @ConsSS+@Cd_SS+ @mcons3
--print @Consulta1
--print @ConsCC+@Cd_CC+ @mcons1
--print @ConsSC+@Cd_SC+ @mcons2
--print @ConsSS+@Cd_SS+ @mcons3
--print @Consulta2
--print @Cons_CC_Fin
---- Sub Centro de Costos --
--print @Cons_SC_Ini
--print @consulta
--print @ConsCC+@Cd_CC+ @mcons1
--print @ConsSC+@Cd_SC+ @mcons2
--print @ConsSS+@Cd_SS+ @mcons3
--print @Cons1
--print @ConsCC+@Cd_CC+ @mcons1
--print @ConsSC+@Cd_SC+ @mcons2
--print @ConsSS+@Cd_SS+ @mcons3
--print @Cons2
--print @ConsCC+@Cd_CC+ @mcons1
--print @ConsSC+@Cd_SC+ @mcons2
--print @ConsSS+@Cd_SS+ @mcons3
--print @Consulta1
--print @ConsCC+@Cd_CC+ @mcons1
--print @ConsSC+@Cd_SC+ @mcons2
--print @ConsSS+@Cd_SS+ @mcons3
--print @Consulta2
--print @Cons_SC_Fin
---- Sub Sub Centro de Costos --
--print @Cons_SS_Ini
--print @consulta
--print @ConsCC+@Cd_CC+ @mcons1
--print @ConsSC+@Cd_SC+ @mcons2
--print @ConsSS+@Cd_SS+ @mcons3
--print @Cons1
--print @ConsCC+@Cd_CC+ @mcons1
--print @ConsSC+@Cd_SC+ @mcons2
--print @ConsSS+@Cd_SS+ @mcons3
--print @Cons2
--print @ConsCC+@Cd_CC+ @mcons1
--print @ConsSC+@Cd_SC+ @mcons2
--print @ConsSS+@Cd_SS+ @mcons3
--print @Consulta1
--print @ConsCC+@Cd_CC+ @mcons1
--print @ConsSC+@Cd_SC+ @mcons2
--print @ConsSS+@Cd_SS+ @mcons3
--print @Consulta2
--print @Cons_SS_Fin
-- Consulta Principal --
print @consulta
print @ConsCC+@Cd_CC+ @mcons1
print @ConsSC+@Cd_SC+ @mcons2
print @ConsSS+@Cd_SS+ @mcons3
print @Cons1
print @ConsCC+@Cd_CC+ @mcons1
print @ConsSC+@Cd_SC+ @mcons2
print @ConsSS+@Cd_SS+ @mcons3
print @Cons2
print @ConsCC+@Cd_CC+ @mcons1
print @ConsSC+@Cd_SC+ @mcons2
print @ConsSS+@Cd_SS+ @mcons3
print @Consulta1
print @ConsCC+@Cd_CC+ @mcons1
print @ConsSC+@Cd_SC+ @mcons2
print @ConsSS+@Cd_SS+ @mcons3
print @Consulta2
print @OrderBy

--Pre_CCPresupuestados_Explo3 '11111111111','2011','01','F','01','06',1,null,null,null
exec (
 @SQL_CA+
-- Centro de Costos --
 @Cons_CC_Ini+
   @consulta +
     @ConsCC+@Cd_CC+ @mcons1 + 
     @ConsSC+@Cd_SC+ @mcons2 +
     @ConsSS+@Cd_SS+ @mcons3 +
   @Cons1 +
     @ConsCC+@Cd_CC+ @mcons1 + 
     @ConsSC+@Cd_SC+ @mcons2 +
     @ConsSS+@Cd_SS+ @mcons3 +
   @Cons2 +
     @ConsCC+@Cd_CC+ @mcons1 + 
     @ConsSC+@Cd_SC+ @mcons2 +
     @ConsSS+@Cd_SS+ @mcons3 +
   @Consulta1 +
     @ConsCC+@Cd_CC+ @mcons1 + 
     @ConsSC+@Cd_SC+ @mcons2 +
     @ConsSS+@Cd_SS+ @mcons3 +
   @Consulta2 +
 @Cons_CC_Fin+
-- Sub Centro de Costos --
 @Cons_SC_Ini+
     @consulta +
     @ConsCC+@Cd_CC+ @mcons1 + 
     @ConsSC+@Cd_SC+ @mcons2 +
     @ConsSS+@Cd_SS+ @mcons3 +
   @Cons1 +
     @ConsCC+@Cd_CC+ @mcons1 + 
     @ConsSC+@Cd_SC+ @mcons2 +
     @ConsSS+@Cd_SS+ @mcons3 +
   @Cons2 +
     @ConsCC+@Cd_CC+ @mcons1 + 
     @ConsSC+@Cd_SC+ @mcons2 +
     @ConsSS+@Cd_SS+ @mcons3 +
   @Consulta1 +
     @ConsCC+@Cd_CC+ @mcons1 + 
     @ConsSC+@Cd_SC+ @mcons2 +
     @ConsSS+@Cd_SS+ @mcons3 +
   @Consulta2 +
 @Cons_SC_Fin+
-- Sub Sub Centro de Costos --
 @Cons_SS_Ini+
   @consulta +
     @ConsCC+@Cd_CC+ @mcons1 + 
     @ConsSC+@Cd_SC+ @mcons2 +
     @ConsSS+@Cd_SS+ @mcons3 +
   @Cons1 +
     @ConsCC+@Cd_CC+ @mcons1 + 
     @ConsSC+@Cd_SC+ @mcons2 +
     @ConsSS+@Cd_SS+ @mcons3 +
   @Cons2 +
     @ConsCC+@Cd_CC+ @mcons1 + 
     @ConsSC+@Cd_SC+ @mcons2 +
     @ConsSS+@Cd_SS+ @mcons3 +
   @Consulta1 +
     @ConsCC+@Cd_CC+ @mcons1 + 
     @ConsSC+@Cd_SC+ @mcons2 +
     @ConsSS+@Cd_SS+ @mcons3 +
   @Consulta2 +
 @Cons_SS_Fin+
-- Consulta Principal --
   @consulta +
     @ConsCC+@Cd_CC+ @mcons1 + 
     @ConsSC+@Cd_SC+ @mcons2 +
     @ConsSS+@Cd_SS+ @mcons3 +
   @Cons1 +
     @ConsCC+@Cd_CC+ @mcons1 + 
     @ConsSC+@Cd_SC+ @mcons2 +
     @ConsSS+@Cd_SS+ @mcons3 +
   @Cons2 +
     @ConsCC+@Cd_CC+ @mcons1 + 
     @ConsSC+@Cd_SC+ @mcons2 +
     @ConsSS+@Cd_SS+ @mcons3 +
   @Consulta1 +
     @ConsCC+@Cd_CC+ @mcons1 + 
     @ConsSC+@Cd_SC+ @mcons2 +
     @ConsSS+@Cd_SS+ @mcons3 +
   @Consulta2 +
@OrderBy
)
GO

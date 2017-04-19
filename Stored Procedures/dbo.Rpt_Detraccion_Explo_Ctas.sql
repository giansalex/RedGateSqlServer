SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec Rpt_Detraccion_Explo_Ctas '11111111111','2012','01','02',null,null,null,null,0,0,0,null

CREATE procedure [dbo].[Rpt_Detraccion_Explo_Ctas]
@RucE nvarchar(11),
@Ejer varchar(4),
@PrdoIni varchar(2),
@PrdoFin varchar(2),
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),
@Cadena varchar(8000),
@CcAll bit,
@ScAll bit,
@SsAll bit,
@Cd_Prv char(7)
AS


Declare @Condicion nvarchar(4000), @esCC bit, @esSC bit, @esSS bit
Set @Condicion = '' 	-- Cadena de condicion
Set @esCC=0  		-- Mostrar CC
Set @esSC=0 		-- Mostrar SC
Set @esSS=0		-- Mostrar SS

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


declare @Cons_Niv1_1 varchar(max), @Cons_Niv1_2 varchar(max),@Cons_Niv1_End varchar(400)
declare @Cons_Niv2_1 varchar(max), @Cons_Niv2_2 varchar(800),@Cons_Niv2_3 varchar(max),@Cons_Niv2_4 varchar(800),@Cons_Niv2_End varchar(400)
--NIVELES
--1 = Documentos
--2 = Registros Contables
--Documentos
--1 = Pagados
--2 = Pendientes de pago

set @Cons_Niv2_1='
select 
	v.NroCta,p.NomCta 
from 
	voucher v inner join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
where 
	v.RucE='''+Convert(varchar,@RucE)+''' and v.Ejer='''+Convert(varchar,@Ejer)+''' and 
	v.RegCtb in (
select RegCtb from (
select distinct
2 as niv, CONVERT(bit,1) as Canc,v.RucE,v.Ejer,v.Cd_Prv,p2.NDoc
, case when ISNULL(p2.RSocial,'''')='''' then ISNULL(p2.ApPat,'''')+'' ''+ISNULL(p2.ApMat,'''')+'' ''+ISNULL(p2.Nom,'''') else ISNULL(p2.RSocial,'''') end as Proveedor
, Convert(varchar,v.FecMov,103) FecMov, CONVERT(Varchar,v.FecED,103) FecED, CONVERT(Varchar,v.FecVD,103) FecVD
,v.RegCtb,v.Glosa,v.Cd_TD,Isnull(v.NroSre,'''') NroSre ,Isnull(v.NroDoc,'''') NroDoc,
v.MtoD, v.MtoH, (v.MtoD - v.MtoH) as SaldoMN, v.MtoD_ME, v.MtoH_ME, (v.MtoD_ME - v.MtoH_ME) as SaldoME
,v.Cd_Area,v.Cd_CC,v.Cd_SC,v.Cd_SS,v.IB_EsProv,v.IB_Anulado,v.UsuCrea,v.FecReg
from Voucher v
left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
inner join Proveedor2 p2 on p2.RucE=v.RucE and p2.Cd_Prv=v.Cd_Prv
inner join  
(
	select 
	1 as niv, Convert(bit,1) as Canc, v.RucE,v.Ejer, v.Cd_Prv,p2.NDoc
	,v.Cd_TD,Isnull(v.NroSre,'''') NroSre ,Isnull(v.NroDoc,'''') NroDoc
	,Sum(v.MtoD) MtoD, Sum(v.MtoH) MtoH,Sum(v.MtoD - v.MtoH) SaldoMN
	,Sum(v.MtoD_ME) MtoD_ME, Sum(v.MtoH_ME) MtoH_ME, Sum(v.MtoD_ME - v.MtoH_ME) SaldoME
	from  
		 voucher v left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
		 inner join Proveedor2 p2 on p2.RucE=v.RucE and p2.Cd_Prv=v.Cd_Prv
	where 
		 v.RucE='''+Convert(varchar,@RucE)+''' and v.Ejer='''+Convert(varchar,@Ejer)+''' and isnull(p.IB_Dtr,0)<>0
		 and v.Prdo between '''+Convert(varchar,@PrdoIni)+''' and '''+Convert(varchar,@PrdoFin)+'''
		 and Case When isnull('''+Convert(varchar,Isnull(@Cd_Prv,''))+''','''') <>'''' Then v.Cd_Prv Else '''' End =  isnull('''+Convert(varchar,Isnull(@Cd_Prv,''))+''','''') '
set @Cons_Niv2_2='
	Group By v.RucE,v.Ejer,v.Cd_Prv,p2.NDoc
			 ,case when ISNULL(p2.RSocial,'''')='''' then ISNULL(p2.ApPat,'''')+'' ''+ISNULL(p2.ApMat,'''')+'' ''+ISNULL(p2.Nom,'''') else ISNULL(p2.RSocial,'''') end
			 ,v.Cd_TD,v.NroSre,v.NroDoc
	Having Sum(v.MtoD - v.MtoH) + Sum(v.MtoD_ME - v.MtoH_ME) = 0
) as dp on v.NroDoc = dp.NroDoc and v.Cd_TD = dp.Cd_TD and v.NroSre = dp.NroSre
where v.RucE ='''+Convert(varchar,@RucE)+''' and v.Ejer ='''+Convert(varchar,@Ejer)+'''  and ISNULL(p.IB_Dtr,0)<>0 '

set @Cons_Niv2_3='
union all
select
2 as niv,CONVERT(bit,0) as Canc,v.RucE,v.Ejer,v.Cd_Prv,p2.NDoc
, case when ISNULL(p2.RSocial,'''')='''' then ISNULL(p2.ApPat,'''')+'' ''+ISNULL(p2.ApMat,'''')+'' ''+ISNULL(p2.Nom,'''') else ISNULL(p2.RSocial,'''') end as Proveedor
, Convert(varchar,v.FecMov,103) FecMov, CONVERT(Varchar,v.FecED,103) FecED, CONVERT(Varchar,v.FecVD,103) FecVD
,v.RegCtb,v.Glosa,v.Cd_TD,Isnull(v.NroSre,'''') NroSre ,Isnull(v.NroDoc,'''') NroDoc,
v.MtoD, v.MtoH, (v.MtoD - v.MtoH) as SaldoMN, v.MtoD_ME, v.MtoH_ME, (v.MtoD_ME - v.MtoH_ME) as SaldoME
,v.Cd_Area,v.Cd_CC,v.Cd_SC,v.Cd_SS,v.IB_EsProv,v.IB_Anulado,v.UsuCrea,v.FecReg
from Voucher v left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
inner join Proveedor2 p2 on p2.RucE=v.RucE and p2.Cd_Prv=v.Cd_Prv
inner join  
(
	select 
	1 as niv, Convert(bit,0) as Canc, v.RucE,v.Ejer, v.Cd_Prv,p2.NDoc
	, '''' as RegCtb	,v.Cd_TD,Isnull(v.NroSre,'''') NroSre ,Isnull(v.NroDoc,'''') NroDoc
	,Sum(v.MtoD) MtoD, Sum(v.MtoH) MtoH,Sum(v.MtoD - v.MtoH) SaldoMN
	,Sum(v.MtoD_ME) MtoD_ME, Sum(v.MtoH_ME) MtoH_ME, Sum(v.MtoD_ME - v.MtoH_ME) SaldoME
	from  
	 voucher v left join PlanCtas p on p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
	 inner join Proveedor2 p2 on p2.RucE=v.RucE and p2.Cd_Prv=v.Cd_Prv
	where 
		v.RucE='''+Convert(varchar,@RucE)+''' and v.Ejer='''+Convert(varchar,@Ejer)+''' and isnull(p.IB_Dtr,0)<>0
		and v.Prdo between '''+Convert(varchar,@PrdoIni)+''' and '''+Convert(varchar,@PrdoFin)+'''
		and Case When isnull('''+Convert(varchar,Isnull(@Cd_Prv,''))+''','''') <>'''' Then v.Cd_Prv Else '''' End =  isnull('''+Convert(varchar,Isnull(@Cd_Prv,''))+''','''') '
set @Cons_Niv2_4='
Group By v.RucE,v.Ejer,v.Cd_Prv,p2.NDoc
		 ,case when ISNULL(p2.RSocial,'''')='''' then ISNULL(p2.ApPat,'''')+'' ''+ISNULL(p2.ApMat,'''')+'' ''+ISNULL(p2.Nom,'''') else ISNULL(p2.RSocial,'''') end
		 ,v.Cd_TD,v.NroSre,v.NroDoc
Having Sum(v.MtoD - v.MtoH) + Sum(v.MtoD_ME - v.MtoH_ME) <> 0

) as dp on v.NroDoc = dp.NroDoc and v.Cd_TD = dp.Cd_TD and v.NroSre = dp.NroSre
where v.RucE ='''+Convert(varchar,@RucE)+''' and v.Ejer ='''+Convert(varchar,@Ejer)+'''  and ISNULL(p.IB_Dtr,0)<>0 '

set @Cons_Niv2_End='
) as t
Group By 
 niv,Canc,RucE,Ejer,Cd_Prv,NDoc,Proveedor,FecMov,FecED,FecVD,RegCtb,Glosa,Cd_TD,NroSre,NroDoc,MtoD,MtoH,SaldoMN,MtoD_ME,MtoH_ME,SaldoME,Cd_Area,Cd_CC,Cd_SC,Cd_SS,IB_EsProv,IB_Anulado,UsuCrea,FecReg
 ) group by v.NroCta, p.NomCta
order by v.NroCta desc
'


print @Cons_Niv2_1
print @Condicion
print @Cons_Niv2_2
print @Condicion
print @Cons_Niv2_3
print @Condicion
print @Cons_Niv2_4
print @Condicion
print @Cons_Niv2_End




exec(
@Cons_Niv2_1+
 @Condicion+
@Cons_Niv2_2+
 @Condicion+
@Cons_Niv2_3+
 @Condicion+
@Cons_Niv2_4+
 @Condicion+
@Cons_Niv2_End
)
GO

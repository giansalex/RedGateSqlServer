SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Rpt_CtasXCbr_Detallada_Ctb_CCVR]
@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Mda char(2),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_Clt char(10),
@IB_VerSaldados bit,
@Cd_CC varchar(8),
@Cd_SC varchar(8),
@Cd_SS varchar(8),
@Cadena nvarchar(400),
@CcAll bit,
@ScAll bit,
@SsAll bit
as

--A Usar en un futuro
declare @Cons1_1 varchar(MAX) declare @Cons1_2 varchar(MAX) declare @Cons1_3 varchar(MAX) declare @Cons1_4 varchar(MAX)
declare @Cons2_1 varchar(MAX) declare @Cons2_2 varchar(MAX) declare @Cons2_3 varchar(MAX) declare @Cons2_4 varchar(MAX)

declare @EndCons_1 varchar(200) declare @EndCons_2 varchar(200)

if(@Cd_CC is null) Set @Cd_CC=''
if(@Cd_SC is null) Set @Cd_SC=''
if(@Cd_SS is null) Set @Cd_SS=''

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


declare @CondCta varchar (1000)
set @CondCta = ''

if(isnull(@NroCta1,'') <> '' or isnull(@NroCta2,'') <> '')
begin
	if(@NroCta1 = @NroCta2)
	begin
		set @CondCta =
						'
			and Case When '''+convert(varchar,isnull(@NroCta1,''))+'''='''' Then '''' Else v.NroCta End like ''' + Convert(nvarchar,isnull(@NroCta1,''))+'%'' '
	end 
	else
	begin
		set  @CondCta = '
			and Case When '''+convert(varchar,isnull(@NroCta1,''))+'''='''' Then '''' Else v.NroCta End >= isnull('''+convert(varchar,isnull(@NroCta1,''))+''','''')
			and Case When '''+convert(varchar,isnull(@NroCta2,''))+'''='''' Then '''' Else v.NroCta End <= isnull('''+convert(varchar,isnull(@NroCta2,''))+''','''')
						'	

	end
end 





set @Cons1_1='
select 
	CliProv,
	RucC,
	MAX(RSocial) As RSocial,
	SUM(Debe) As Debe,
	SUM(Haber) As Haber,
	SUM(Saldo) As Saldo,
	SUM(Saldo_Dias) SaldoDias,
	Case when SUM(Saldo_Dias) <= 0 then SUM(Saldo) else 0.00 end As Vencido,
	Case when SUM(Saldo_Dias) > 0 and SUM(Saldo_Dias) <= 30 then SUM(Saldo) else 0.00 end As Hasta30,
	Case when SUM(Saldo_Dias) > 30 and SUM(Saldo_Dias) <= 60 then SUM(Saldo) else 0.00 end As Hasta60,
	Case when SUM(Saldo_Dias) > 60 and SUM(Saldo_Dias) <= 90 then SUM(Saldo) else 0.00 end As Hasta90,
	Case when SUM(Saldo_Dias) > 90 then SUM(Saldo) else 0.00 end As AMAS
from
(
	Select 
		CliProv,
		NDocAux As RucC,
		NomAux As RSocial,
		NroDoc,
		FecED,
		FecVD,
		Debe,
		Haber,
		Saldo,
		Saldo_Dias
	from (
		Select 
				v.NroCta,Max(v.RegCtb) RegCtb,
				case when(isnull(v.Cd_Clt,''''))='''' then ''P'' when (Isnull(v.Cd_Prv,''''))='''' then ''C''  end as CliProv,
				isnull(c.NDoc,isnull(r.NDoc,''--Sin Documento--'')) As NDocAux,
				Case When isnull(v.Cd_Clt,'''')='''' and isnull(v.Cd_Prv,'''')='''' Then ''-- Sin Auxiliar --'' Else Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) 
				Else isnull(r.RSocial,isnull(r.ApPat,'''')+'' ''+isnull(r.ApMat,'''')+'' ''+isnull(r.Nom,'''')) End
				End As NomAux,
				Isnull(v.Cd_TD,'''') Cd_TD,
				isnull(v.NroSre,'''') NroSre,
				isnull(v.NroDoc,'''') NroDoc,
				Max(Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecED,103) else '''' end) as FecED,
				Max(Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecCbr,103) else '''' end) as FecVD,
				Sum(Case When isnull(v.IB_EsProv,0)=1 Then Datediff(Day,'''+Convert(varchar,GetDate())+''',IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,''Sin Especificar'')))) Else 0 End) As Saldo_Dias,
				Sum(Case When '''+Isnull(@Cd_Mda,'')+'''=''01'' Then v.MtoD Else v.MtoD_ME End) As Debe,
				Sum(Case When '''+Isnull(@Cd_Mda,'')+'''=''01'' Then v.MtoH Else v.MtoH_ME End) As Haber,
				Sum(Case When '''+Isnull(@Cd_Mda,'')+'''=''01'' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When '''+Isnull(@Cd_Mda,'')+'''=''01'' Then v.MtoH Else v.MtoH_ME End) As Saldo,
				'''+Isnull(@Cd_Mda,'')+''' as Cd_MdRg,
				Max(Convert(varchar,v.FecMov,103)) As FecMov
		From
		' 
set @Cons1_2='
			  Voucher v
			  Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
			  left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
			  left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
		Where 
			  v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''
			  and Isnull(v.IB_Anulado,0)<>1
			  '+@CondCta+'
			  and Case When isnull('''+Convert(varchar,Isnull(@Cd_Clt,''))+''','''') <>'''' Then v.Cd_Clt Else '''' End =isnull('''+Convert(varchar,Isnull(@Cd_Clt,''))+''','''')
		'
set @Cons1_3='
		Group by 
			  v.NroCta,v.Cd_Clt,v.Cd_Prv,
			  isnull(c.NDoc,isnull(r.NDoc,''--Sin Documento--'')),
			  c.RSocial,c.ApPat,c.ApMat,c.Nom,
			  r.RSocial,r.ApPat,r.ApMat,r.Nom,
			  v.Cd_TD,v.NroSre,v.NroDoc
		Having
			  Sum(Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' Then v.MtoH Else v.MtoH_ME End) + '''+Convert(varchar,@IB_VerSaldados)+''' <>0
	) As con
) As Con
group by CliProv,RucC,RSocial
Having Case when SUM(Saldo_Dias) <= 0 then SUM(Saldo) else 0.00 end = .0 and
	Case when SUM(Saldo_Dias) > 0 and SUM(Saldo_Dias) <= 30 then SUM(Saldo) else 0.00 end <> .0 and
	Case when SUM(Saldo_Dias) > 30 and SUM(Saldo_Dias) <= 60 then SUM(Saldo) else 0.00 end = .0 and
	Case when SUM(Saldo_Dias) > 60 and SUM(Saldo_Dias) <= 90 then SUM(Saldo) else 0.00 end = .0 and
	Case when SUM(Saldo_Dias) > 90 then SUM(Saldo) else 0.00 end = .0
Order by RSocial
'
	print @Cons1_1
	print @Cons1_2
	print @Cons1_3
	print @condicion
	print @Cons1_4
	print @EndCons_1
exec(@Cons1_1+@Cons1_2+@Condicion+@Cons1_3)


--Grilla 2
set @Cons2_1='
select 
	CliProv,
	RucC,
	RSocial,
	RegCtb,
	MAX(Cd_TD) Cd_TD,
	MAx(NroSre) NroSre,
	MAX(NroDoc) As NroDoc,
	MAX(FecED) As FecED,
	MAX(FecVD) As FecVD,
	SUM(Debe) As Debe1,
	SUM(Haber) As Haber1,
	SUM(Saldo) As Saldo1,
	SUM(Saldo_Dias) SaldoDias,
	Case when SUM(Saldo_Dias) <= 0 then SUM(Saldo) else 0.00 end As Vencido,
	Case when SUM(Saldo_Dias) > 0 and SUM(Saldo_Dias) <= 30 then SUM(Saldo) else 0.00 end As Hasta30,
	Case when SUM(Saldo_Dias) > 30 and SUM(Saldo_Dias) <= 60 then SUM(Saldo) else 0.00 end As Hasta60,
	Case when SUM(Saldo_Dias) > 60 and SUM(Saldo_Dias) <= 90 then SUM(Saldo) else 0.00 end As Hasta90,
	Case when SUM(Saldo_Dias) > 90 then SUM(Saldo) else 0.00 end As AMAS
from
(
	Select 
		CliProv
		, NDocAux As RucC
		, NomAux As RSocial
		, RegCtb
		, Isnull(Cd_TD,'''') Cd_TD
		, Isnull(NroSre,'''') NroSre
		, Isnull(NroDoc,'''') NroDoc
		, FecED
		, FecVD
		, Debe
		, Haber
		, Saldo
		, Saldo_Dias
	from (
		Select 
			v.NroCta,Max(v.RegCtb) RegCtb,
			case when(isnull(v.Cd_Clt,''''))='''' then ''P'' when (Isnull(v.Cd_Prv,''''))='''' then ''C''  end as CliProv,
			isnull(c.NDoc,isnull(r.NDoc,''--Sin Documento--'')) As NDocAux,
			Case When isnull(v.Cd_Clt,'''')='''' and isnull(v.Cd_Prv,'''')='''' Then ''-- Sin Auxiliar --'' Else Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) 
			Else isnull(r.RSocial,isnull(r.ApPat,'''')+'' ''+isnull(r.ApMat,'''')+'' ''+isnull(r.Nom,'''')) End
			End As NomAux,
			Isnull(v.Cd_TD,'''') Cd_TD,
			isnull(v.NroSre,'''') NroSre,
			isnull(v.NroDoc,'''') NroDoc,
			Max(Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecED,103) else '''' end) as FecED,
			Max(Case When isnull(v.IB_EsProv,0)=1 Then Convert(varchar,v.FecCbr,103) else '''' end) as FecVD,
			Sum(Case When isnull(v.IB_EsProv,0)=1 Then Datediff(Day,'''+Convert(varchar,GetDate())+''',IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,''Sin Especificar'')))) Else 0 End) As Saldo_Dias,
			Sum(Case When '''+Isnull(@Cd_Mda,'')+'''=''01'' Then v.MtoD Else v.MtoD_ME End) As Debe,
			Sum(Case When '''+Isnull(@Cd_Mda,'')+'''=''01'' Then v.MtoH Else v.MtoH_ME End) As Haber,
			Sum(Case When '''+Isnull(@Cd_Mda,'')+'''=''01'' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When '''+Isnull(@Cd_Mda,'')+'''=''01'' Then v.MtoH Else v.MtoH_ME End) As Saldo,
			'''+Isnull(@Cd_Mda,'')+''' as Cd_MdRg,
			Max(Convert(varchar,v.FecMov,103)) As FecMov
		From 
	'
set @Cons2_2='
			 Voucher v
			 Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
			 left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
			 left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv
		Where 
	  		  v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''
			  and Isnull(v.IB_Anulado,0)<>1
			  '+@CondCta+'
			  and Case When isnull('''+Convert(varchar,Isnull(@Cd_Clt,''))+''','''')<>'''' Then v.Cd_Clt Else '''' End =isnull('''+Convert(varchar,Isnull(@Cd_Clt,''))+''','''')
		'
set @Cons2_3='
		Group by 
		  v.NroCta,v.Cd_Clt,v.Cd_Prv,
		  isnull(c.NDoc,isnull(r.NDoc,''--Sin Documento--'')),
		  c.RSocial,c.ApPat,c.ApMat,c.Nom,
		  r.RSocial,r.ApPat,r.ApMat,r.Nom,
		  v.Cd_TD,v.NroSre,v.NroDoc
		Having			  
			  Sum(Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' Then v.MtoD Else v.MtoD_ME End) + Sum(Case When '''+Convert(varchar,@Cd_Mda)+'''=''01'' Then v.MtoH Else v.MtoH_ME End) + '''+Convert(varchar,@IB_VerSaldados)+''' <> 0
	) As con
) As Con
group by CliProv,RucC,RSocial,RegCtb
Having SUM(Saldo_Dias) > 0 and SUM(Saldo_Dias) <= 30 and SUM(Saldo)<> .0
Order by RucC Desc
'
	print @Cons2_1
	print @Cons2_2
	print @condicion
	print @Cons2_3
	
exec(@Cons2_1+@Cons2_2+@Condicion+@Cons2_3)
-- Leyenda -- 
--JJ <Creado por Jujo>
--DI 24/06/2011 <Reestructurwado> 
--exec dbo.Rpt_CtasXCbr_Detallada_Ctb '11111111111','2010','01/03/2010','31/05/2010','01',0
--exec dbo.Rpt_CtasXCbr_Detallada_Ctb_CC '20512141022','2011','01/07/2011','31/08/2011','01','12.1.1.10','13.3.3.50',null,1,null,null,null,null,0,0,0
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_CtasXCbr_Detallada_CtbNroVR1]
@RucE nvarchar(11),
@Ejer varchar(4),
@Cd_Mda char(2),
@NroCta1 nvarchar(10),
@NroCta2 nvarchar(10),
@Cd_Clt char(10),
@IB_VerSaldados bit,
@FecD date,
@FecH date,
@Dias int
as



declare @Cons_1 varchar(max),@Cons_2 varchar(max),@Cons_3 varchar(max)
declare @Cons_4 varchar(max)

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

set @Cons_1='
select 
	Count(CliProv) as Nro
from
(
	select 
		CliProv,
		RucC,
		RSocial,
		RegCtb,
		MAX(Cd_TD) As Cd_TD,
		MAX(NroSre) As NroSre,
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
			CliProv,
			NDocAux As RucC,
			NomAux As RSocial,
			RegCtb,
			Cd_TD,
			NroSre,
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
				Sum(Case When isnull(v.IB_EsProv,0)=1 Then Datediff(Day,'''+convert(varchar,GetDate())+''',IsNull(v.FecCbr,IsNuLL(v.FecED,IsNull(v.FecMov,''Sin Especificar'')))) Else 0 End) As Saldo_Dias,
				Sum(Case When '''+Isnull(@Cd_Mda,'')+'''=''01'' Then v.MtoD Else v.MtoD_ME End) As Debe,
				Sum(Case When '''+Isnull(@Cd_Mda,'')+'''=''01'' Then v.MtoH Else v.MtoH_ME End) As Haber,
				Sum(Case When '''+Isnull(@Cd_Mda,'')+'''=''01'' Then v.MtoD Else v.MtoD_ME End) - Sum(Case When '''+Isnull(@Cd_Mda,'')+'''=''01'' Then v.MtoH Else v.MtoH_ME End) As Saldo,
				'''+Isnull(@Cd_Mda,'')+''' as Cd_MdRg,
				Max(Convert(varchar,v.FecMov,103)) As FecMov
			From 
				  Voucher v
				  Inner Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.IB_CtasXCbr,0)=1
				  left join Cliente2 as c on c.RucE=v.RucE and c.Cd_Clt=v.Cd_Clt
				  left join Proveedor2 as r on r.RucE=v.RucE and r.Cd_Prv = v.Cd_Prv'
set @Cons_2='
			Where 
				  v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''  
				  and Isnull(v.IB_Anulado,0)<>1  '+@CondCta+'
				  and Case When isnull('''+Convert(varchar,isnull(@Cd_Clt,''))+''','''')<>'''' Then v.Cd_Clt Else '''' End =isnull('''+Convert(varchar,isnull(@Cd_Clt,''))+''','''')
				  and convert(date,v.FecMov) between convert(date,'''+Convert(varchar(50),@FecD)+''') and convert(date,'''+Convert(varchar(50),@FecH)+''') 
			Group by 
				  v.NroCta,v.Cd_Clt,v.Cd_Prv,
				  isnull(c.NDoc,isnull(r.NDoc,''--Sin Documento--'')),
				  c.RSocial,c.ApPat,c.ApMat,c.Nom,
				  r.RSocial,r.ApPat,r.ApMat,r.Nom,
				  v.Cd_TD,v.NroSre,v.NroDoc
			Having
				  Sum(Case When '''+Isnull(@Cd_Mda,'')+'''=''01'' Then v.MtoD Else v.MtoD_ME End) + Sum(Case When '''+Isnull(@Cd_Mda,'')+'''=''01'' Then v.MtoH Else v.MtoH_ME End) + '''+Convert(varchar,isnull(@IB_VerSaldados,0))+''' <> 0
		) As con
	) As Con
		where Convert(int,Saldo_Dias) <= Convert(int,'''+Convert(nvarchar(10),@Dias)+''') --GGGONz
	group by CliProv,RucC,RSocial,RegCtb
) As Con Where Vencido = .0 and Hasta60 =.0 and Hasta90 = .0 and AMAS = .0 and Hasta30 <> .0
'
print @Cons_1
print @Cons_2

exec (@Cons_1+@Cons_2)
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_BalanceGeneral]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@n1 bit,
@n2 bit,
@n3 bit,
@n4 bit,
@most bit,
@Cd_Mda nvarchar(2),
@NroCtaD nvarchar(10),
@NroCtaH nvarchar(10),
@msj varchar(100) output
as


--//////////////////////////////

/*
Declare @RucE nvarchar(11)
Declare @Ejer nvarchar(4)
Declare @PrdoIni nvarchar(2)
Declare @PrdoFin nvarchar(2)
Declare @n1 bit
Declare @n2 bit
Declare @n3 bit
Declare @n4 bit
Declare @most bit
Declare @Cd_Mda nvarchar(2)
Declare @NroCtaD nvarchar(10)
Declare @NroCtaH nvarchar(10)

Set @RucE = '20512635025'
Set @Ejer = '2009'
Set @PrdoIni = '01'
Set @PrdoFin = '11'
Set @n1 = '1'
Set @n2 = '0'
Set @n3 = '0'
Set @n4 = '1'
Set @most = '1'
Set @Cd_Mda = '01'
Set @NroCtaD = ''
Set @NroCtaH = ''
*/


Declare @Mda  nvarchar(5)
if(@Cd_Mda = '01') Set @Mda=''
else Set @Mda='_D'
print @Mda

Declare @RangoD nvarchar(100)
Declare @RangoH nvarchar(100)
Set @RangoD=''
Set @RangoH=''

if(isnull(len(@NroCtaD),0) = 0) 
	set @NroCtaD = '0000000000'
else
Begin 
	if(len(@NroCtaD) = 2)	Set @RangoD = ' and left(p.NroCta,2)>='+@NroCtaD
	else if(len(@NroCtaD) = 4) Set @RangoD = ' and left(p.NroCta,4)>='+@NroCtaD
	else if(len(@NroCtaD) = 6) Set @RangoD = ' and left(p.NroCta,6)>='+@NroCtaD
	else Set @RangoD = ' and p.NroCta>='+@NroCtaD
End
if(isnull(len(@NroCtaH),0) = 0) 
	set @NroCtaH = '9999999999'
else
Begin 
	if(len(@NroCtaH) = 2)	Set @RangoH = ' and left(p.NroCta,2)<='+@NroCtaH
	else if(len(@NroCtaH) = 4) Set @RangoH = ' and left(p.NroCta,4)<='+@NroCtaH
	else if(len(@NroCtaH) = 6) Set @RangoH = ' and left(p.NroCta,6)<='+@NroCtaH
	else Set @RangoH = ' and p.NroCta<='+@NroCtaH
End

Declare @TCabecera nvarchar(2000)
Declare @i int
Declare @Mes nvarchar(10)
Declare @Cabecera nvarchar(2000)
Declare @Colum varchar(1000), @ColumT varchar(1000), @Suma varchar(1000), @SumaT varchar(1000)
Declare @m0 nvarchar(500),@m1 nvarchar(500),@m2 nvarchar(500),@m3 nvarchar(500),@m4 nvarchar(500),@m5 nvarchar(500),@m6 nvarchar(500),@m7 nvarchar(500),@m8 nvarchar(500),@m9 nvarchar(500),@m10 nvarchar(500),@m11 nvarchar(500),@m12 nvarchar(500),@m13 nvarchar(500),@m14 nvarchar(500),@mT nvarchar(1000)
Declare @Sm0 nvarchar(2000),@Sm1 nvarchar(2000),@Sm2 nvarchar(2000),@Sm3 nvarchar(2000),@Sm4 nvarchar(2000),@Sm5 nvarchar(2000),@Sm6 nvarchar(2000),@Sm7 nvarchar(2000),@Sm8 nvarchar(2000),@Sm9 nvarchar(2000),@Sm10 nvarchar(2000),@Sm11 nvarchar(2000),@Sm12 nvarchar(2000),@Sm13 nvarchar(2000),@Sm14 nvarchar(2000),@SmT nvarchar(2000)
Set @Cabecera='' Set @Colum = '' Set @ColumT = '' Set @Suma = '' Set @SumaT = '' Set @i = 0 Set @Mes = '' Set @TCabecera=''
Set @m0='' Set @m1='' Set @m2='' Set @m3='' Set @m4='' Set @m5='' Set @m6='' Set @m7='' Set @m8='' Set @m9='' Set @m10='' Set @m11='' Set @m12='' Set @m13='' Set @m14='' Set @mT=''
Set @Sm0='' Set @Sm1='' Set @Sm2='' Set @Sm3='' Set @Sm4='' Set @Sm5='' Set @Sm6='' Set @Sm7='' Set @Sm8='' Set @Sm9='' Set @Sm10='' Set @Sm11='' Set @Sm12='' Set @Sm13='' Set @Sm14='' Set @SmT=''
Set @i = Convert(int,@PrdoIni)
Set @PrdoFin = Convert(int,@PrdoFin)


--*************************************************************************************************************************************************************
Declare @R00_n1 decimal(13,2),@R01_n1 decimal(13,2),@R02_n1 decimal(13,2),@R03_n1 decimal(13,2),@R04_n1 decimal(13,2),@R05_n1 decimal(13,2),@R06_n1 decimal(13,2),@R07_n1 decimal(13,2)
Declare @R08_n1 decimal(13,2),@R09_n1 decimal(13,2),@R10_n1 decimal(13,2),@R11_n1 decimal(13,2),@R12_n1 decimal(13,2),@R13_n1 decimal(13,2),@R14_n1 decimal(13,2),@R15_n1 decimal(13,2)
Set @R00_n1=0 Set @R01_n1=0 Set @R02_n1=0 Set @R03_n1=0 Set @R04_n1=0 Set @R05_n1=0 Set @R06_n1=0 Set @R07_n1=0 Set @R08_n1=0 Set @R09_n1=0 Set @R10_n1=0 Set @R11_n1=0 Set @R12_n1=0 Set @R13_n1=0 Set @R14_n1=0 Set @R15_n1=0

Declare @D00_n1 nvarchar(500),@D01_n1 nvarchar(500),@D02_n1 nvarchar(500),@D03_n1 nvarchar(500),@D04_n1 nvarchar(500),@D05_n1 nvarchar(500),@D06_n1 nvarchar(500),@D07_n1 nvarchar(500)
Declare @D08_n1 nvarchar(500),@D09_n1 nvarchar(500),@D10_n1 nvarchar(500),@D11_n1 nvarchar(500),@D12_n1 nvarchar(500),@D13_n1 nvarchar(500),@D14_n1 nvarchar(500),@D15_n1 nvarchar(800)
Set @D00_n1='' Set @D01_n1='' Set @D02_n1='' Set @D03_n1='' Set @D04_n1='' Set @D05_n1='' Set @D06_n1='' Set @D07_n1='' Set @D08_n1='' Set @D09_n1='' Set @D10_n1='' Set @D11_n1='' Set @D12_n1='' Set @D13_n1='' Set @D14_n1='' Set @D15_n1=''



Declare @S00_n1 nvarchar(2000),@S01_n1 nvarchar(2000),@S02_n1 nvarchar(2000),@S03_n1 nvarchar(2000),@S04_n1 nvarchar(2000),@S05_n1 nvarchar(2000),@S06_n1 nvarchar(2000),@S07_n1 nvarchar(2000)
Declare @S08_n1 nvarchar(2000),@S09_n1 nvarchar(2000),@S10_n1 nvarchar(2000),@S11_n1 nvarchar(2000),@S12_n1 nvarchar(2000),@S13_n1 nvarchar(2000),@S14_n1 nvarchar(2000),@S15_n1 nvarchar(2000)
Set @S00_n1='' Set @S01_n1='' Set @S02_n1='' Set @S03_n1='' Set @S04_n1='' Set @S05_n1='' Set @S06_n1='' Set @S07_n1='' Set @S08_n1='' Set @S09_n1='' Set @S10_n1='' Set @S11_n1='' Set @S12_n1='' Set @S13_n1='' Set @S14_n1='' Set @S15_n1=''


Declare @T00_n1 nvarchar(2000),@T01_n1 nvarchar(2000),@T02_n1 nvarchar(2000),@T03_n1 nvarchar(2000),@T04_n1 nvarchar(2000),@T05_n1 nvarchar(2000),@T06_n1 nvarchar(2000),@T07_n1 nvarchar(2000)
Declare @T08_n1 nvarchar(2000),@T09_n1 nvarchar(2000),@T10_n1 nvarchar(2000),@T11_n1 nvarchar(2000),@T12_n1 nvarchar(2000),@T13_n1 nvarchar(2000),@T14_n1 nvarchar(2000),@T15_n1 nvarchar(2000)
Set @T00_n1='' Set @T01_n1='' Set @T02_n1='' Set @T03_n1='' Set @T04_n1='' Set @T05_n1='' Set @T06_n1='' Set @T07_n1='' Set @T08_n1='' Set @T09_n1='' Set @T10_n1='' Set @T11_n1='' Set @T12_n1='' Set @T13_n1='' Set @T14_n1='' Set @T15_n1=''


select 
	@R00_n1 = (Sum(Case(p.Cd_Blc) when 'A100' then s.saldo00 else 0 end )+Sum(Case(p.Cd_Blc) when 'A200' then s.saldo00 else 0 end ))-(Sum(Case(p.Cd_Blc) when 'P100' then (s.saldo01)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'P200' then (s.saldo00)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'PT10' then (s.saldo00)*-1 else 0 end )),
	@R01_n1 = (Sum(Case(p.Cd_Blc) when 'A100' then s.saldo01 else 0 end )+Sum(Case(p.Cd_Blc) when 'A200' then s.saldo01 else 0 end ))-(Sum(Case(p.Cd_Blc) when 'P100' then (s.saldo01)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'P200' then (s.saldo01)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'PT10' then (s.saldo01)*-1 else 0 end )),
	@R02_n1 = (Sum(Case(p.Cd_Blc) when 'A100' then s.saldo02 else 0 end )+Sum(Case(p.Cd_Blc) when 'A200' then s.saldo02 else 0 end ))-(Sum(Case(p.Cd_Blc) when 'P100' then (s.saldo02)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'P200' then (s.saldo02)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'PT10' then (s.saldo02)*-1 else 0 end )),
	@R03_n1 = (Sum(Case(p.Cd_Blc) when 'A100' then s.saldo03 else 0 end )+Sum(Case(p.Cd_Blc) when 'A200' then s.saldo03 else 0 end ))-(Sum(Case(p.Cd_Blc) when 'P100' then (s.saldo03)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'P200' then (s.saldo03)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'PT10' then (s.saldo03)*-1 else 0 end )),
	@R04_n1 = (Sum(Case(p.Cd_Blc) when 'A100' then s.saldo04 else 0 end )+Sum(Case(p.Cd_Blc) when 'A200' then s.saldo04 else 0 end ))-(Sum(Case(p.Cd_Blc) when 'P100' then (s.saldo04)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'P200' then (s.saldo04)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'PT10' then (s.saldo04)*-1 else 0 end )),
	@R05_n1 = (Sum(Case(p.Cd_Blc) when 'A100' then s.saldo05 else 0 end )+Sum(Case(p.Cd_Blc) when 'A200' then s.saldo05 else 0 end ))-(Sum(Case(p.Cd_Blc) when 'P100' then (s.saldo05)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'P200' then (s.saldo05)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'PT10' then (s.saldo05)*-1 else 0 end )),
	@R06_n1 = (Sum(Case(p.Cd_Blc) when 'A100' then s.saldo06 else 0 end )+Sum(Case(p.Cd_Blc) when 'A200' then s.saldo06 else 0 end ))-(Sum(Case(p.Cd_Blc) when 'P100' then (s.saldo06)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'P200' then (s.saldo06)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'PT10' then (s.saldo06)*-1 else 0 end )),
	@R07_n1 = (Sum(Case(p.Cd_Blc) when 'A100' then s.saldo07 else 0 end )+Sum(Case(p.Cd_Blc) when 'A200' then s.saldo07 else 0 end ))-(Sum(Case(p.Cd_Blc) when 'P100' then (s.saldo07)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'P200' then (s.saldo07)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'PT10' then (s.saldo07)*-1 else 0 end )),
	@R08_n1 = (Sum(Case(p.Cd_Blc) when 'A100' then s.saldo08 else 0 end )+Sum(Case(p.Cd_Blc) when 'A200' then s.saldo08 else 0 end ))-(Sum(Case(p.Cd_Blc) when 'P100' then (s.saldo08)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'P200' then (s.saldo08)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'PT10' then (s.saldo08)*-1 else 0 end )),
	@R09_n1 = (Sum(Case(p.Cd_Blc) when 'A100' then s.saldo09 else 0 end )+Sum(Case(p.Cd_Blc) when 'A200' then s.saldo09 else 0 end ))-(Sum(Case(p.Cd_Blc) when 'P100' then (s.saldo09)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'P200' then (s.saldo09)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'PT10' then (s.saldo09)*-1 else 0 end )),
	@R10_n1 = (Sum(Case(p.Cd_Blc) when 'A100' then s.saldo10 else 0 end )+Sum(Case(p.Cd_Blc) when 'A200' then s.saldo10 else 0 end ))-(Sum(Case(p.Cd_Blc) when 'P100' then (s.saldo10)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'P200' then (s.saldo10)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'PT10' then (s.saldo10)*-1 else 0 end )),
	@R11_n1 = (Sum(Case(p.Cd_Blc) when 'A100' then s.saldo11 else 0 end )+Sum(Case(p.Cd_Blc) when 'A200' then s.saldo11 else 0 end ))-(Sum(Case(p.Cd_Blc) when 'P100' then (s.saldo11)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'P200' then (s.saldo11)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'PT10' then (s.saldo11)*-1 else 0 end )),
	@R12_n1 = (Sum(Case(p.Cd_Blc) when 'A100' then s.saldo12 else 0 end )+Sum(Case(p.Cd_Blc) when 'A200' then s.saldo12 else 0 end ))-(Sum(Case(p.Cd_Blc) when 'P100' then (s.saldo12)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'P200' then (s.saldo12)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'PT10' then (s.saldo12)*-1 else 0 end )),
	@R13_n1 = (Sum(Case(p.Cd_Blc) when 'A100' then s.saldo13 else 0 end )+Sum(Case(p.Cd_Blc) when 'A200' then s.saldo13 else 0 end ))-(Sum(Case(p.Cd_Blc) when 'P100' then (s.saldo13)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'P200' then (s.saldo13)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'PT10' then (s.saldo13)*-1 else 0 end )),
	@R14_n1 = (Sum(Case(p.Cd_Blc) when 'A100' then s.saldo14 else 0 end )+Sum(Case(p.Cd_Blc) when 'A200' then s.saldo14 else 0 end ))-(Sum(Case(p.Cd_Blc) when 'P100' then (s.saldo14)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'P200' then (s.saldo14)*-1 else 0 end )+Sum(Case(p.Cd_Blc) when 'PT10' then (s.saldo14)*-1 else 0 end ))
from SaldosXPrdoN4 s
left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN4 and p.Ejer=s.Ejer
where s.RucE=@RucE and s.Ejer=@Ejer and p.Cd_Blc in ('A100','A200','P100','P200','PT10')
print @R00_n1
print @R01_n1
print @R02_n1
print @R03_n1
print @R04_n1
print @R05_n1
print @R06_n1
print @R07_n1
print @R08_n1
print @R09_n1
print @R10_n1
print @R11_n1
print @R12_n1
print @R13_n1
print @R14_n1
--*************************************************************************************************************************************************************

while(@i <= @PrdoFin and @i < 10)
begin
	if(@i = 0)
	Begin 	Set @Mes = 'INICIAL'
		Set @m0=',Case(left(Convert(varchar,s.Saldo00*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)),1)) when ''-'' then ''(''+Convert(varchar,s.Saldo00*Case When s.Saldo00>0 Then 1 Else -1 End)+'')'' else Convert(varchar,s.Saldo00*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)) end as INICIAL'
		Set @Sm0=',Case(left(Convert(varchar,Sum(s.Saldo00)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R00_n1)+' else 0 end),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo00)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R00_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,Sum(s.Saldo00)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R00_n1)+' else 0 end) end as INICIAL'
		Set @D00_n1 = ',Case(left('''+Convert(nvarchar,@R00_n1)+''',1)) when ''-'' then ''(''+'''+Convert(nvarchar,@R00_n1*-1)+'''+'')'' else '''+Convert(nvarchar,@R00_n1)+''' end as INICIAL'
		Set @S00_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo00)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R00_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo00)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R00_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo00)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R00_n1)+' else 0 end)) end) as INICIAL'
		Set @T00_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo00)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R00_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo00)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R00_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo00)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R00_n1)+' else 0 end)) end) as INICIAL'
	End
	if(@i = 1) 
	Begin 	Set @Mes = 'ENE'
		Set @m1=',Case(left(Convert(varchar,s.Saldo01*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)),1)) when ''-'' then ''(''+Convert(varchar,s.Saldo01*Case When s.Saldo01>0 Then 1 Else -1 End)+'')'' else Convert(varchar,s.Saldo01*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)) end as ENE'
		Set @Sm1=',Case(left(Convert(varchar,Sum(s.Saldo01)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R01_n1)+' else 0 end),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo01)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R01_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,Sum(s.Saldo01)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R01_n1)+' else 0 end) end as ENE'
		Set @D01_n1 = ',Case(left('''+Convert(nvarchar,@R01_n1)+''',1)) when ''-'' then ''(''+'''+Convert(nvarchar,@R01_n1*-1)+'''+'')'' else '''+Convert(nvarchar,@R01_n1)+''' end as ENE'
		Set @S01_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo01)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R01_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo01)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R01_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo01)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R01_n1)+' else 0 end)) end) as ENE'	
		Set @T01_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo01)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R01_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo01)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R01_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo01)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R01_n1)+' else 0 end)) end) as ENE'
	End
	if(@i = 2) 
	Begin	Set @Mes = 'FEB'
		Set @m2=',Case(left(Convert(varchar,s.Saldo02*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)),1)) when ''-'' then ''(''+Convert(varchar,s.Saldo02*Case When s.Saldo02>0 Then 1 Else -1 End)+'')'' else Convert(varchar,s.Saldo02*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)) end as FEB'
		Set @Sm2=',Case(left(Convert(varchar,Sum(s.Saldo02)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R02_n1)+' else 0 end),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo02)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R02_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,Sum(s.Saldo02)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R02_n1)+' else 0 end) end as FEB'
		Set @D02_n1 = ',Case(left('''+Convert(nvarchar,@R02_n1)+''',1)) when ''-'' then ''(''+'''+Convert(nvarchar,@R02_n1*-1)+'''+'')'' else '''+Convert(nvarchar,@R02_n1)+''' end as FEB'
		Set @S02_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo02)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R02_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo02)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R02_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo02)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R02_n1)+' else 0 end)) end) as FEB'
		Set @T02_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo02)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R02_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo02)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R02_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo02)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R02_n1)+' else 0 end)) end) as FEB'
	End
	if(@i = 3) 
	Begin	Set @Mes = 'MAR'
		Set @m3=',Case(left(Convert(varchar,s.Saldo03*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)),1)) when ''-'' then ''(''+Convert(varchar,s.Saldo03*Case When s.Saldo03>0 Then 1 Else -1 End)+'')'' else Convert(varchar,s.Saldo03*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)) end as MAR'
		Set @Sm3=',Case(left(Convert(varchar,Sum(s.Saldo03)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R03_n1)+' else 0 end),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo03)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R03_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,Sum(s.Saldo03)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R03_n1)+' else 0 end) end as MAR'
		Set @D03_n1 = ',Case(left('''+Convert(nvarchar,@R03_n1)+''',1)) when ''-'' then ''(''+'''+Convert(nvarchar,@R03_n1*-1)+'''+'')'' else '''+Convert(nvarchar,@R03_n1)+''' end as MAR'
		Set @S03_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo03)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R03_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo03)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R03_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo03)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R03_n1)+' else 0 end)) end) as MAR'
		Set @T03_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo03)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R03_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo03)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R03_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo03)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R03_n1)+' else 0 end)) end) as MAR'
	End
	if(@i = 4) 
	Begin	Set @Mes = 'ABR'
		Set @m4=',Case(left(Convert(varchar,s.Saldo04*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)),1)) when ''-'' then ''(''+Convert(varchar,s.Saldo04*Case When s.Saldo04>0 Then 1 Else -1 End)+'')'' else Convert(varchar,s.Saldo04*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)) end as ABR'
		Set @Sm4=',Case(left(Convert(varchar,Sum(s.Saldo04)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R04_n1)+' else 0 end),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo04)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R04_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,Sum(s.Saldo04)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R04_n1)+' else 0 end) end as ABR'
		Set @D04_n1 = ',Case(left('''+Convert(nvarchar,@R04_n1)+''',1)) when ''-'' then ''(''+'''+Convert(nvarchar,@R04_n1*-1)+'''+'')'' else '''+Convert(nvarchar,@R04_n1)+''' end as ABR'
		Set @S04_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo04)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R04_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo04)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R04_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo04)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R04_n1)+' else 0 end)) end) as ABR'
		Set @T04_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo04)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R04_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo04)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R04_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo04)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R04_n1)+' else 0 end)) end) as ABR'
	End
	if(@i = 5) 
	Begin	Set @Mes = 'MAY'
		Set @m5=',Case(left(Convert(varchar,s.Saldo05*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)),1)) when ''-'' then ''(''+Convert(varchar,s.Saldo05*Case When s.Saldo05>0 Then 1 Else -1 End)+'')'' else Convert(varchar,s.Saldo05*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)) end as MAY'
		Set @Sm5=',Case(left(Convert(varchar,Sum(s.Saldo05)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R05_n1)+' else 0 end),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo05)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R05_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,Sum(s.Saldo05)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R05_n1)+' else 0 end) end as MAY'
		Set @D05_n1 = ',Case(left('''+Convert(nvarchar,@R05_n1)+''',1)) when ''-'' then ''(''+'''+Convert(nvarchar,@R05_n1*-1)+'''+'')'' else '''+Convert(nvarchar,@R05_n1)+''' end as MAY'
		Set @S05_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo05)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R05_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo05)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R05_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo05)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R05_n1)+' else 0 end)) end) as MAY'
		Set @T05_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo05)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R05_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo05)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R05_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo05)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R05_n1)+' else 0 end)) end) as MAY'
	End
	if(@i = 6) 
	Begin	Set @Mes = 'JUN'
		Set @m6=',Case(left(Convert(varchar,s.Saldo06*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)),1)) when ''-'' then ''(''+Convert(varchar,s.Saldo06*Case When s.Saldo06>0 Then 1 Else -1 End)+'')'' else Convert(varchar,s.Saldo06*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)) end as JUN'
		Set @Sm6=',Case(left(Convert(varchar,Sum(s.Saldo06)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R06_n1)+' else 0 end),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo06)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R06_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,Sum(s.Saldo06)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R06_n1)+' else 0 end) end as JUN'
		Set @D06_n1 = ',Case(left('''+Convert(nvarchar,@R06_n1)+''',1)) when ''-'' then ''(''+'''+Convert(nvarchar,@R06_n1*-1)+'''+'')'' else '''+Convert(nvarchar,@R06_n1)+''' end as JUN'
		Set @S06_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo06)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R06_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo06)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R06_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo06)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R06_n1)+' else 0 end)) end) as JUN'
		Set @T06_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo06)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R06_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo06)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R06_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo06)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R06_n1)+' else 0 end)) end) as JUN'
	End
	if(@i = 7) 
	Begin	Set @Mes = 'JUL'
		Set @m7=',Case(left(Convert(varchar,s.Saldo07*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)),1)) when ''-'' then ''(''+Convert(varchar,s.Saldo07*Case When s.Saldo07>0 Then 1 Else -1 End)+'')'' else Convert(varchar,s.Saldo07*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)) end as JUL'
		Set @Sm7=',Case(left(Convert(varchar,Sum(s.Saldo07)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R07_n1)+' else 0 end),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo07)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R07_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,Sum(s.Saldo07)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R07_n1)+' else 0 end) end as JUL'
		Set @D07_n1 = ',Case(left('''+Convert(nvarchar,@R07_n1)+''',1)) when ''-'' then ''(''+'''+Convert(nvarchar,@R07_n1*-1)+'''+'')'' else '''+Convert(nvarchar,@R07_n1)+''' end as JUL'
		Set @S07_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo07)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R07_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo07)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R07_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo07)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R07_n1)+' else 0 end)) end) as JUL'
		Set @T07_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo07)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R07_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo07)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R07_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo07)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R07_n1)+' else 0 end)) end) as JUL'
	End
	if(@i = 8) 
	Begin	Set @Mes = 'AGO'
		Set @m8=',Case(left(Convert(varchar,s.Saldo08*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)),1)) when ''-'' then ''(''+Convert(varchar,s.Saldo08*Case When s.Saldo08>0 Then 1 Else -1 End)+'')'' else Convert(varchar,s.Saldo08*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)) end as AGO'
		Set @Sm8=',Case(left(Convert(varchar,Sum(s.Saldo08)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R08_n1)+' else 0 end),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo08)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R08_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,Sum(s.Saldo08)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R08_n1)+' else 0 end) end as AGO'
		Set @D08_n1 = ',Case(left('''+Convert(nvarchar,@R08_n1)+''',1)) when ''-'' then ''(''+'''+Convert(nvarchar,@R08_n1*-1)+'''+'')'' else '''+Convert(nvarchar,@R08_n1)+''' end as AGO'
		Set @S08_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo08)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R08_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo08)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R08_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo08)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R08_n1)+' else 0 end)) end) as AGO'
		Set @T08_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo08)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R08_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo08)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R08_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo08)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R08_n1)+' else 0 end)) end) as AGO'
	End
	if(@i = 9) 
	Begin	Set @Mes = 'SEP'
		Set @m9=',Case(left(Convert(varchar,s.Saldo09*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)),1)) when ''-'' then ''(''+Convert(varchar,s.Saldo09*Case When s.Saldo09>0 Then 1 Else -1 End)+'')'' else Convert(varchar,s.Saldo09*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)) end as SEP'
		Set @Sm9=',Case(left(Convert(varchar,Sum(s.Saldo09)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R09_n1)+' else 0 end),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo09)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R09_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,Sum(s.Saldo09)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R09_n1)+' else 0 end) end as SEP'
		Set @D09_n1 = ',Case(left('''+Convert(nvarchar,@R09_n1)+''',1)) when ''-'' then ''(''+'''+Convert(nvarchar,@R09_n1*-1)+'''+'')'' else '''+Convert(nvarchar,@R09_n1)+''' end as SEP'
		Set @S09_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo09)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R09_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo09)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R09_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo09)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R09_n1)+' else 0 end)) end) as SEP'
		Set @T09_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo09)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R09_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo09)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R09_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo09)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R09_n1)+' else 0 end)) end) as SEP'
	End
	Set @Cabecera = @Cabecera +','+''''''+' as '+@Mes
	Set @Colum = @Colum + 's.Saldo0'+convert(varchar,@i)+' as '+@Mes+','

	if(@most=0 or @most=1)
	Begin
		Set @TCabecera=','''' as TOTAL'
		Set @Suma = @Suma + 's.Saldo0'+convert(varchar,@i)+'+'
	End
	
	Set @i = @i + 1 
end
while(@i <= @PrdoFin and @PrdoFin >= 10)
begin
	if(@i = 10)
	Begin	Set @Mes = 'OCT'
		Set @m10=',Case(left(Convert(varchar,s.Saldo10*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)),1)) when ''-'' then ''(''+Convert(varchar,s.Saldo10*Case When s.Saldo10>0 Then 1 Else -1 End)+'')'' else Convert(varchar,s.Saldo10*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)) end as OCT'
		Set @Sm10=',Case(left(Convert(varchar,Sum(s.Saldo10)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R10_n1)+' else 0 end),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo10)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R10_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,Sum(s.Saldo10)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R10_n1)+' else 0 end) end as OCT'
		Set @D10_n1 = ',Case(left('''+Convert(nvarchar,@R10_n1)+''',1)) when ''-'' then ''(''+'''+Convert(nvarchar,@R10_n1*-1)+'''+'')'' else '''+Convert(nvarchar,@R10_n1)+''' end as OCT'
		Set @S10_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo10)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R10_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo10)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R10_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo10)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R10_n1)+' else 0 end)) end) as OCT'
		Set @T10_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo10)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R10_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo10)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R10_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo10)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R10_n1)+' else 0 end)) end) as OCT'
	End
	if(@i = 11)
	Begin	Set @Mes = 'NOV'
		Set @m11=',Case(left(Convert(varchar,s.Saldo11*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)),1)) when ''-'' then ''(''+Convert(varchar,s.Saldo11*Case When s.Saldo11>0 Then 1 Else -1 End)+'')'' else Convert(varchar,s.Saldo11*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)) end as NOV'
		Set @Sm11=',Case(left(Convert(varchar,Sum(s.Saldo11)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R11_n1)+' else 0 end),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo11)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R11_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,Sum(s.Saldo11)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R11_n1)+' else 0 end) end as NOV'
		Set @D11_n1 = ',Case(left('''+Convert(nvarchar,@R11_n1)+''',1)) when ''-'' then ''(''+'''+Convert(nvarchar,@R11_n1*-1)+'''+'')'' else '''+Convert(nvarchar,@R11_n1)+''' end as NOV'
		Set @S11_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo11)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R11_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo11)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R11_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo11)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R11_n1)+' else 0 end)) end) as NOV'
		Set @T11_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo11)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R11_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo11)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R11_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo11)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R11_n1)+' else 0 end)) end) as NOV'
	End
	if(@i = 12)
	Begin	Set @Mes = 'DIC'
		Set @m12=',Case(left(Convert(varchar,s.Saldo12*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)),1)) when ''-'' then ''(''+Convert(varchar,s.Saldo12*Case When s.Saldo12>0 Then 1 Else -1 End)+'')'' else Convert(varchar,s.Saldo12*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)) end as DIC'
		Set @Sm12=',Case(left(Convert(varchar,Sum(s.Saldo12)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R12_n1)+' else 0 end),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo12)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R12_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,Sum(s.Saldo12)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R12_n1)+' else 0 end) end as DIC'
		Set @D12_n1 = ',Case(left('''+Convert(nvarchar,@R12_n1)+''',1)) when ''-'' then ''(''+'''+Convert(nvarchar,@R12_n1*-1)+'''+'')'' else '''+Convert(nvarchar,@R12_n1)+''' end as DIC'
		Set @S12_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo12)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R12_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo12)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R12_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo12)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R12_n1)+' else 0 end)) end) as DIC'
		Set @T12_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo12)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R12_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo12)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R12_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo12)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R12_n1)+' else 0 end)) end) as DIC'
	End
	if(@i = 13)
	Begin	Set @Mes = 'AJUSTE'
		Set @m13=',Case(left(Convert(varchar,s.Saldo13*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)),1)) when ''-'' then ''(''+Convert(varchar,s.Saldo13*Case When s.Saldo13>0 Then 1 Else -1 End)+'')'' else Convert(varchar,s.Saldo13*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)) end as AJUSTE'
		Set @Sm13=',Case(left(Convert(varchar,Sum(s.Saldo13)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R13_n1)+' else 0 end),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo13)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R13_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,Sum(s.Saldo13)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R13_n1)+' else 0 end) end as AJUSTE'
		Set @D13_n1 = ',Case(left('''+Convert(nvarchar,@R13_n1)+''',1)) when ''-'' then ''(''+'''+Convert(nvarchar,@R13_n1*-1)+'''+'')'' else '''+Convert(nvarchar,@R13_n1)+''' end as AJUSTE'
		Set @S13_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo13)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R13_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo13)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R13_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo13)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R13_n1)+' else 0 end)) end) as AJUSTE'
		Set @T13_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo13)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R13_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo13)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R13_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo13)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R13_n1)+' else 0 end)) end) as AJUSTE'
	End
	if(@i = 14)
	Begin	Set @Mes = 'CIERRE'
		Set @m14=',Case(left(Convert(varchar,s.Saldo14*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)),1)) when ''-'' then ''(''+Convert(varchar,s.Saldo14*Case When s.Saldo14>0 Then 1 Else -1 End)+'')'' else Convert(varchar,s.Saldo14*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)) end as CIERRE'
		Set @Sm14=',Case(left(Convert(varchar,Sum(s.Saldo14)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R14_n1)+' else 0 end),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo14)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R14_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,Sum(s.Saldo14)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+Convert(nvarchar,@R14_n1)+' else 0 end) end as CIERRE'
		Set @D14_n1 = ',Case(left('''+Convert(nvarchar,@R14_n1)+''',1)) when ''-'' then ''(''+'''+Convert(nvarchar,@R14_n1*-1)+'''+'')'' else '''+Convert(nvarchar,@R14_n1)+''' end as CIERRE'
		Set @S14_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo14)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R14_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo14)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R14_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo14)*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+Convert(nvarchar,@R14_n1)+' else 0 end)) end) as CIERRE'
		Set @T14_n1=',(Case(left(Convert(varchar,(Sum(s.Saldo14)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R14_n1)+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum(s.Saldo14)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R14_n1)+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum(s.Saldo14)*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+Convert(nvarchar,@R14_n1)+' else 0 end)) end) as CIERRE'
	End
	Set @Cabecera = @Cabecera +','+''''''+' as '+@Mes
	Set @Colum = @Colum + 's.Saldo'+convert(varchar,@i)+' as '+@Mes+','

	if(@most=0 or @most=1)
	Begin
		Set @TCabecera=','''' as TOTAL'
		Set @Suma = @Suma + 's.Saldo'+convert(varchar,@i)+'+'
	End

	Set @i = @i + 1 
end
--Set @Cabecera = left(@Cabecera,(len(@Cabecera)-1))
Set @Colum = left(@Colum,(len(@Colum)-1))
if(@most=0 or @most=1)
Begin 	
	Set @Suma = left(@Suma,(len(@Suma)-1)) 
	Declare @Temp nvarchar(2000)
	Set @Temp =
		'  
		Declare @A decimal(13,2)
		Set @A = (
		select 
			(Sum(Case(p.Cd_Blc) when ''A100'' then ('+@Suma+') else 0 end )+
				     Sum(Case(p.Cd_Blc) when ''A200'' then ('+@Suma+') else 0 end ))-
				    (Sum(Case(p.Cd_Blc) when ''P100'' then ('+@Suma+')*-1 else 0 end )+
				     Sum(Case(p.Cd_Blc) when ''P200'' then ('+@Suma+')*-1 else 0 end )+
				     Sum(Case(p.Cd_Blc) when ''PT10'' then ('+@Suma+')*-1 else 0 end ))
		from SaldosXPrdoN4 s
		left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN4 and p.Ejer=s.Ejer 
		where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and p.Cd_Blc in (''A100'',''A200'',''P100'',''P200'',''PT10'')
		)

		Update TablaTemp Set valordcm = @A
	     	'
	Print @Temp
	Exec(@Temp)

	Set @D15_n1 = (select Case(left(Convert(nvarchar,valordcm),1)) when '-' then '('+substring(Convert(nvarchar,valordcm),2,len(Convert(nvarchar,valordcm))-1)+')' else Convert(nvarchar,valordcm) end from TablaTemp)
	Declare @Val nvarchar(200)
	Set @Val = (select Convert(nvarchar,valordcm) from TablaTemp)
	Set @D15_n1 = ','''+@D15_n1+''' as TOTAL'

	Set @mT = ',Case(left(Convert(varchar,('+@Suma+')*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)),1)) when ''-'' then ''(''+Convert(varchar,('+@Suma+')*Case When '+@Suma+'>0 Then 1 Else -1 end)+'')'' else Convert(varchar,('+@Suma+')*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)) end as TOTAL'
	Set @SmT = ',Case(left(Convert(varchar,Sum('+@Suma+')*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+@Val+' else 0 end),1)) when ''-'' then ''(''+Convert(varchar,(Sum('+@Suma+')*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+@Val+' else 0 end)*-1)+'')'' else Convert(varchar,Sum('+@Suma+')*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(left(s.NroCtaN4,2)) when ''59'' then '+@Val+' else 0 end) end as TOTAL'

	Set @S15_n1=',(Case(left(Convert(varchar,(Sum('+@Suma+')*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+@Val+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum('+@Suma+')*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+@Val+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum('+@Suma+')*(Case(p.Cd_Blc) when ''P100'' then -1 when ''P200'' then -1 when ''PT10'' then -1 else 1 end)+Case(p.Cd_Blc) when ''PT10'' then '+@Val+' else 0 end)) end) as TOTAL'
	Print @S15_n1
	Set @T15_n1=',(Case(left(Convert(varchar,(Sum('+@Suma+')*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+@Val+' else 0 end)),1)) when ''-'' then ''(''+Convert(varchar,(Sum('+@Suma+')*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+@Val+' else 0 end)*-1)+'')'' else Convert(varchar,(Sum('+@Suma+')*(Case(left(p.Cd_Blc,1)) when ''P'' then -1 else 1 end)+Case(left(p.Cd_Blc,1)) when ''P'' then '+@Val+' else 0 end)) end) as TOTAL'
	
	Set @Suma = ','+@Suma+' as TOTAL' 
End

--REALIZANDO EL FORMATO ACORDE A TIPO DE MUESTRA QUE DESEA VISUALIZAR EL USUARIO

If(@most=0)
Begin
	Set @Cabecera=''
	Set @m0='' Set @m1='' Set @m2='' Set @m3='' Set @m4='' Set @m5='' Set @m6='' Set @m7='' Set @m8='' Set @m9='' Set @m10='' Set @m11='' Set @m12='' Set @m13='' Set @m14=''
	Set @Sm0='' Set @Sm1='' Set @Sm2='' Set @Sm3='' Set @Sm4='' Set @Sm5='' Set @Sm6='' Set @Sm7='' Set @Sm8='' Set @Sm9='' Set @Sm10='' Set @Sm11='' Set @Sm12='' Set @Sm13='' Set @Sm14=''
	Set @D00_n1='' Set @D01_n1='' Set @D02_n1='' Set @D03_n1='' Set @D04_n1='' Set @D05_n1='' Set @D06_n1='' Set @D07_n1='' Set @D08_n1='' Set @D09_n1='' Set @D10_n1='' Set @D11_n1='' Set @D12_n1='' Set @D13_n1='' Set @D14_n1=''
	Set @S00_n1='' Set @S01_n1='' Set @S02_n1='' Set @S03_n1='' Set @S04_n1='' Set @S05_n1='' Set @S06_n1='' Set @S07_n1='' Set @S08_n1='' Set @S09_n1='' Set @S10_n1='' Set @S11_n1='' Set @S12_n1='' Set @S13_n1='' Set @S14_n1=''
	Set @T00_n1='' Set @T01_n1='' Set @T02_n1='' Set @T03_n1='' Set @T04_n1='' Set @T05_n1='' Set @T06_n1='' Set @T07_n1='' Set @T08_n1='' Set @T09_n1='' Set @T10_n1='' Set @T11_n1='' Set @T12_n1='' Set @T13_n1='' Set @T14_n1=''
End
/*
Else
Begin
	 Set @TCabecera=''
	 Set @mT=''
	 Set @SmT=''
End*/
------------------------------------------------------------------------------------

print '-----RESULTADOS------'
print @TCabecera   
print @Cabecera
print @Colum
print @Suma
print @mT
print @SmT
print @D15_n1
print @T15_n1
print '---------------------'



Declare @SQL1 nvarchar(4000)
Declare @SQL2_1 nvarchar(4000),@SQL2_2 nvarchar(4000),@SQL2_3 nvarchar(4000),@SQL2_4 nvarchar(4000),@SQL2_5 nvarchar(4000)
Declare @SQL3_1 nvarchar(4000),@SQL3_2 nvarchar(4000),@SQL3_3 nvarchar(4000),@SQL3_4 nvarchar(4000),@SQL3_5 nvarchar(4000)
Declare @SQL4_1 nvarchar(4000),@SQL4_2 nvarchar(4000),@SQL4_3 nvarchar(4000),@SQL4_4 nvarchar(4000),@SQL4_5 nvarchar(4000)
Declare @SQL5_1 nvarchar(4000),@SQL5_2 nvarchar(4000),@SQL5_3 nvarchar(4000),@SQL5_4 nvarchar(4000),@SQL5_5 nvarchar(4000)
Declare @SQL6_1 nvarchar(4000),@SQL6_2 nvarchar(4000),@SQL6_3 nvarchar(4000),@SQL6_4 nvarchar(4000)
Declare @SQL7_1 nvarchar(4000),@SQL7_2 nvarchar(4000),@SQL7_3 nvarchar(4000),@SQL7_4 nvarchar(4000)
Declare @SQL8_1 nvarchar(4000),@SQL8_2 nvarchar(4000)
Set @SQL1=''
Set @SQL2_1='' Set @SQL2_2='' Set @SQL2_3='' Set @SQL2_4='' Set @SQL2_5=''
Set @SQL3_1='' Set @SQL3_2='' Set @SQL3_3='' Set @SQL3_4='' Set @SQL3_5=''
Set @SQL4_1='' Set @SQL4_2='' Set @SQL4_3='' Set @SQL4_4='' Set @SQL4_5=''
Set @SQL5_1='' Set @SQL5_2='' Set @SQL5_3='' Set @SQL5_4='' Set @SQL5_5=''
Set @SQL8_1='' Set @SQL8_2=''
Set @SQL6_1='' Set @SQL6_2='' Set @SQL6_3='' Set @SQL6_4='' 
Set @SQL7_1='' Set @SQL7_2='' Set @SQL7_3='' Set @SQL7_4=''

Set @SQL1 =
	'
	(select 
		0 Num,0 Cab,
		Case(left(p.Cd_Blc,1)) when ''A'' then ''A'' when ''P'' then ''P'' end as Ind,
		s.RucE,s.Ejer,
		Case(left(p.Cd_Blc,1)) when ''A'' then ''-'' when ''P'' then ''-'' end as NroCta,
		Case(left(p.Cd_Blc,1)) when ''A'' then ''ACTIVO'' when ''P'' then ''PASIVO Y PATRIMONIO'' end as NomCta
		'+@Cabecera+@TCabecera+'
	from SaldosXPrdoN1 s
	left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN1 and p.Ejer=s.Ejer 
	where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and p.Cd_Blc in (''A100'',''A200'',''P100'',''P200'',''PT10'')'+@RangoD+@RangoH+'
	Group by s.RucE,s.Ejer,left(p.Cd_Blc,1))
	UNION ALL
	(select 
		0 Num,1 Cab,
		Case(p.Cd_Blc) when ''A100'' then ''AC'' when ''A200'' then ''AN'' when ''P100'' then ''PC'' when ''P200'' then ''PN'' when ''PT10'' then ''PT'' end as Ind,
		s.RucE,s.Ejer,
		Case(p.Cd_Blc) when ''A100'' then ''-'' when ''A200'' then ''-'' when ''P100'' then ''-'' when ''P200'' then ''-'' when ''PT10'' then ''-'' end as NroCta,
		Case(p.Cd_Blc) when ''A100'' then ''ACTIVO CORRIENTE'' when ''A200'' then ''ACTIVO NO CORRIENTE'' when ''P100'' then ''PASIVO CORRIENTE'' when ''P200'' then ''PASIVO NO CORRIENTE'' when ''PT10'' then ''PATRIMONIO'' end as NomCta
		'+@Cabecera+@TCabecera+'
	from SaldosXPrdoN1'+@Mda+' s
	left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN1 and p.Ejer=s.Ejer
	where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and p.Cd_Blc in (''A100'',''A200'',''P100'',''P200'',''PT10'')'+@RangoD+@RangoH+'
	Group by s.RucE,s.Ejer,p.Cd_Blc)
	'
if(@n1=1 or @n2=1 or @n3=1 or @n4=1) Set @SQL1=@SQL1+' UNION ALL '
if(@n1 = 1)
Begin
	Set @SQL2_1=
		'
		(select 
			1 Num,2 Cab,
			Case(p.Cd_Blc) when ''A100'' then ''AC'' when ''A200'' then ''AN'' when ''P100'' then ''PC'' when ''P200'' then ''PN'' when ''PT10'' then ''PT'' end as Ind,
			s.RucE,s.Ejer,left(s.NroCtaN4,2) as NroCta,p1.NomCta
			'+@Sm0+@Sm1+@Sm2+''
	Set @SQL2_2=
		''+@Sm3+@Sm4+@Sm5+@Sm6+''
	Set @SQL2_3=
		''+@Sm7+@Sm8+@Sm9+@Sm10+''
	Set @SQL2_4=
		''+@Sm11+@Sm12+@Sm13+@Sm14+''
	Set @SQL2_5=
		''+@SmT+'
		from SaldosXPrdoN4'+@Mda+' s
		left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN4 and p.Ejer=s.Ejer
		left join PlanCtas p1 on p1.RucE=p.RucE and p1.NroCta=left(p.NroCta,2) and p1.Ejer=s.Ejer 
		where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and p.Cd_Blc in (''A100'',''A200'',''P100'',''P200'',''PT10'')'+@RangoD+@RangoH+'
		Group by s.RucE,s.Ejer,left(s.NroCtaN4,2),p1.NomCta,p.Cd_Blc)
		'
	
End

if(@n2 = 1)
Begin
	if(@n1 = 1) Set @SQL3_1 = @SQL3_1 + 'UNION ALL '
	Set @SQL3_1=@SQL3_1+
		'
		(select 
			2 Num,2 Cab,
			Case(p.Cd_Blc) when ''A100'' then ''AC'' when ''A200'' then ''AN'' when ''P100'' then ''PC'' when ''P200'' then ''PN'' when ''PT10'' then ''PT'' end as Ind,
			s.RucE,s.Ejer,left(s.NroCtaN4,4) as NroCta,p1.NomCta
			'+@Sm0+@Sm1+@Sm2+''
	Set @SQL3_2=
		''+@Sm3+@Sm4+@Sm5+@Sm6+''
	Set @SQL3_3=
		''+@Sm7+@Sm8+@Sm9+@Sm10+''
	Set @SQL3_4=
		''+@Sm11+@Sm12+@Sm13+@Sm14+''
	Set @SQL3_5=
		''+@SmT+'
		from SaldosXPrdoN4'+@Mda+' s
		left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN4 and p.Ejer=s.Ejer
		left join PlanCtas p1 on p1.RucE=p.RucE and p1.NroCta=left(p.NroCta,4) and p1.Ejer=s.Ejer
		where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and p.Cd_Blc in (''A100'',''A200'',''P100'',''P200'',''PT10'')'+@RangoD+@RangoH+'
		Group by s.RucE,s.Ejer,left(s.NroCtaN4,4),s.NroCtaN4,p1.NomCta,p.Cd_Blc)
		'
End

if(@n3 = 1)
Begin
	if(@n1 = 1 or @n2 = 1) Set @SQL4_1 = @SQL4_1 + 'UNION ALL '
	Set @SQL4_1=@SQL4_1+
		'
		(select 
			3 Num,2 Cab,
			Case(p.Cd_Blc) when ''A100'' then ''AC'' when ''A200'' then ''AN'' when ''P100'' then ''PC'' when ''P200'' then ''PN'' when ''PT10'' then ''PT'' end as Ind,
			s.RucE,s.Ejer,left(s.NroCtaN4,6) as NroCta,p1.NomCta
			'+@Sm0+@Sm1+@Sm2+''
	Set @SQL4_2 =
		''+@Sm3+@Sm4+@Sm5+@Sm6+''
	Set @SQL4_3 =
		''+@Sm7+@Sm8+@Sm9+@Sm10+''	
	Set @SQL4_4 =
		''+@Sm11+@Sm12+@Sm13+@Sm14+''
	Set @SQL4_5 =
		''+@SmT+'
		from SaldosXPrdoN4'+@Mda+' s
		left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN4 and p.Ejer=s.Ejer
		left join PlanCtas p1 on p1.RucE=p.RucE and p1.NroCta=left(p.NroCta,6) and p1.Ejer=s.Ejer
		where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and p.Cd_Blc in (''A100'',''A200'',''P100'',''P200'',''PT10'')'+@RangoD+@RangoH+'
		Group by s.RucE,s.Ejer,left(s.NroCtaN4,6),s.NroCtaN4,p1.NomCta,p.Cd_Blc)
		'
End


if(@n4 = 1)
Begin
	if(@n1 = 1 or @n2 = 1 or @n3 = 1) Set @SQL5_1 = @SQL5_1 + 'UNION ALL '
	Set @SQL5_1=@SQL5_1+
		'
		(select 
			4 Num,2 Cab,
			Case(p.Cd_Blc) when ''A100'' then ''AC'' when ''A200'' then ''AN'' when ''P100'' then ''PC'' when ''P200'' then ''PN'' when ''PT10'' then ''PT'' end as Ind,
			s.RucE,s.Ejer,s.NroCtaN4 as NroCta,p.NomCta
			'+@m0+'
			'
	Set @SQL5_2=
		''+@m1+@m2+@m3+@m4+''
	Set @SQL5_3=
		''+@m5+@m6+@m7+@m8+@m9+''
	Set @SQL5_4=
		''+@m10+@m11+@m12+@m13+@m14+''
	Set @SQL5_5=
		''+@mT+'
		from SaldosXPrdoN4'+@Mda+' s
		left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN4 and p.Ejer=s.Ejer
		where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and p.Cd_Blc in (''A100'',''A200'',''P100'',''P200'',''PT10'')'+@RangoD+@RangoH+')
		'
End

if(@n1=1 or @n2=1 or @n3=1 or @n4=1)
Begin
	Set @SQL6_1=
		'
		UNION ALL
		(select 
			5 Num,3 Cab,
			Case(p.Cd_Blc) when ''A100'' then ''AC'' when ''A200'' then ''AN'' when ''P100'' then ''PC'' when ''P200'' then ''PN'' when ''PT10'' then ''PT'' End as Ind,
			s.RucE,s.Ejer,
			Case(p.Cd_Blc) when ''A100'' then ''TAC'' when ''A200'' then ''TAN'' when ''P100'' then ''TPC'' when ''P200'' then ''TPN'' when ''PT10'' then ''TPA'' End as NroCta,
			Case(p.Cd_Blc) when ''A100'' then ''TOTAL ACTIVO CORRIENTE'' when ''A200'' then ''TOTAL ACTIVO NO CORRIENTE'' when ''P100'' then ''TOTAL PASIVO CORRIENTE'' when ''P200'' then ''TOTAL PASIVO NO CORRIENTE'' when ''PT10'' then ''TOTAL PATRIMONIO'' End as NomCta
			'+@S00_n1+@S01_n1+@S02_n1+@S03_n1+@S04_n1+'
		'
	Set @SQL6_2=
		''+@S05_n1+@S06_n1+@S07_n1+@S08_n1+@S09_n1+''
	Set @SQL6_3=
		''+@S10_n1+@S11_n1+@S12_n1+@S13_n1+@S14_n1+''
	Set @SQL6_4=
		''+@S15_n1+'
		from SaldosXPrdoN4'+@Mda+' s
		left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN4 and p.Ejer=s.Ejer
		where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and p.Cd_Blc in (''A100'',''A200'',''P100'',''P200'',''PT10'')'+@RangoD+@RangoH+'
		Group by s.RucE,s.Ejer,p.Cd_Blc)
		'
		

	Set @SQL7_1=
		'
		UNION ALL
		(select 
			6 Num,4 Cab,Case(left(p.Cd_Blc,1)) when ''A'' then ''AT'' when ''P'' then ''PT'' End as Ind,
			s.RucE,s.Ejer,
			Case(left(p.Cd_Blc,1)) when ''A'' then ''TAT'' when ''P'' then ''TPT'' End as NroCta,
			Case(left(p.Cd_Blc,1)) when ''A'' then ''TOTAL ACTIVO'' when ''P'' then ''TOTAL PASIVO Y PATRIMONIO'' End as NomCta
			'+@T00_n1+@T01_n1+@T02_n1+@T03_n1+@T04_n1+'
		'

	Set @SQL7_2=
		''+@T05_n1+@T06_n1+@T07_n1+@T08_n1+@T09_n1+''
	Set @SQL7_3=
		''+@T10_n1+@T11_n1+@T12_n1+@T13_n1+@T14_n1+''
	Set @SQL7_4=
		''+@T15_n1+'		
		from SaldosXPrdoN4'+@Mda+' s
		left join PlanCtas p on p.RucE=s.RucE and p.NroCta=s.NroCtaN4 and p.Ejer=s.Ejer
		where s.RucE='''+@RucE+''' and s.Ejer='''+@Ejer+''' and p.Cd_Blc in (''A100'',''A200'',''P100'',''P200'',''PT10'')'+@RangoD+@RangoH+'
		Group by s.RucE,s.Ejer,left(p.Cd_Blc,1))
		'

	Set @SQL8_1=
		'
		UNION ALL
		(Select 
			4 Num,3 Cab,
			''PT'' as Ind,
			'''+@RucE+'''as RucE ,'''+@Ejer+''' as Ejer,''---------'' as NroCta,''RESULTADO DEL EJERCICIO'' as NomCta
			'+@D00_n1+@D01_n1+@D02_n1+@D03_n1+@D04_n1+@D05_n1+@D06_n1+@D07_n1+@D08_n1+'
		'
	Set @SQL8_2=
		''+@D09_n1+@D10_n1+@D11_n1+@D12_n1+@D13_n1+@D14_n1+@D15_n1+')
		'
End

print 'MARKUS'
PRINT @SQL1
PRINT @SQL2_1
PRINT @SQL2_2
PRINT @SQL2_3
PRINT @SQL2_4
PRINT @SQL2_5
PRINT @SQL3_1
PRINT @SQL3_2
PRINT @SQL3_3
PRINT @SQL3_4
PRINT @SQL3_5
PRINT @SQL4_1
PRINT @SQL4_2
PRINT @SQL4_3
PRINT @SQL4_4
PRINT @SQL4_5
PRINT @SQL5_1
PRINT @SQL5_2
PRINT @SQL5_3
PRINT @SQL5_4
PRINT @SQL5_5
PRINT @SQL6_1
PRINT @SQL6_2
PRINT @SQL6_3 
PRINT @SQL6_4
PRINT @SQL7_1
PRINT @SQL7_2
PRINT @SQL7_3
PRINT @SQL7_4
PRINT @SQL8_1
PRINT @SQL8_2

exec (@SQL1+@SQL2_1+@SQL2_2+@SQL2_3+@SQL2_4+@SQL2_5+@SQL3_1+@SQL3_2+@SQL3_3+@SQL3_4+@SQL3_5+@SQL4_1+@SQL4_2+@SQL4_3+@SQL4_4+@SQL4_5+@SQL5_1+@SQL5_2+@SQL5_3+@SQL5_4+@SQL5_5+@SQL6_1+@SQL6_2+@SQL6_3+@SQL6_4+@SQL7_1+@SQL7_2+@SQL7_3+@SQL7_4+@SQL8_1+@SQL8_2+' Order by 3,2,6')

-- Leyenda --

-- DI 17/11/09 : Modificacion; se agrego una fila donde se calcula el Resultado del Ejercicio
-- DI 10/12/09 : Modificacion; se modifico los resultados de la operacion (RESULTADO DEL EJERCICIO)
-- FL 23/09/10 : Se trabajo ejercicio
-- MP 07/10/10 : Se arreglo el sp
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Ctb_ReporteFinancieroCons_Rpt]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@CadenaEjer varchar(200),
@Cd_REF nvarchar(5),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@Cd_Mda nvarchar(2),
@VerMes bit,
@EsCc bit,
@EsSc bit,
@EsSs bit,
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@CadenaCC varchar(8000),
@CadenaSC varchar(8000),
@CadenaSS varchar(8000),
@N1 bit,
@N2 bit,
@N3 bit,
@N4 bit,
@msj varchar(100) output

AS
/*
DECLARE  
	@RucE nvarchar(11),
	@Ejer nvarchar(4),
	@CadenaEjer varchar(200),
	@Cd_REF nvarchar(5),
	@PrdoD nvarchar(2),
	@PrdoH nvarchar(2),
	@Cd_Mda nvarchar(2),
	@VerMes bit,
	@EsCc bit,
	@EsSc bit,
	@EsSs bit,
	@Cd_CC nvarchar(8),
	@Cd_SC nvarchar(8),
	@Cd_SS nvarchar(8),
	@CadenaCC varchar(8000),
	@CadenaSC varchar(8000),
	@CadenaSS varchar(8000),
	@N1 bit,
	@N2 bit,
	@N3 bit,
	@N4 bit

Set @RucE='11111111111'
Set @Ejer='2012'
Set @CadenaEjer=''
Set @Cd_REF='REF01'
Set @PrdoD='01'
Set @PrdoH='02'
Set @Cd_Mda='01'
Set @VerMes='0'
Set @EsCc='1'
Set @EsSc='1'
Set @EsSs='0'
Set @Cd_CC=''
Set @Cd_SC='01010101'
Set @Cd_SS=''
Set @CadenaCC='''01010101'',''0P560'''
Set @CadenaSC=''
Set @CadenaSS=''
Set @N1='1'
Set @N2='0'
Set @N3='0'
Set @N4='0'
*/

--////////// CONDICION //////////
Declare @Mda varchar(3) Set @Mda = '' If(@Cd_Mda = '02') Set @Mda ='_ME'

Declare @CondCC Varchar(8000) Set @CondCC=''
Declare @CondSC Varchar(8000) Set @CondSC=''
Declare @CondSS Varchar(8000) Set @CondSS=''

Declare @CondEjer Varchar(8000) Set @CondEjer=''
If(@Ejer='') 
	Set @CondEjer='and v.Ejer in ('+@CadenaEjer+')'
Else 
	Set @CondEjer='and v.Ejer='''+@Ejer+''''
	
---------------------------------------------------------------------------
--> Centro de costos
------------------------------
If(@Cd_CC<>'') --> cantidad de cc = 1
	Set @CondCC = ' and v.Cd_CC='''+@Cd_CC+''''
Else
Begin
	If(@CadenaCC<>'') --> cantidad de cc > 1
		Set @CondCC = ' and v.Cd_CC in ('+@CadenaCC+')'
End
--> Sub Centro de costos
------------------------------
If(@Cd_SC<>'') --> cantidad de sc = 1
	Set @CondSC = ' and v.Cd_SC='''+@Cd_SC+''''
Else
Begin
	If(@CadenaSC<>'') --> cantidad de sc > 1
		Set @CondSC = ' and v.Cd_CC+''_''+v.Cd_SC in ('+@CadenaSC+')'	
End
--> Sub Sub Centro de costos
------------------------------
If(@Cd_SS<>'') --> cantidad de ss = 1
	Set @CondSS = ' and v.Cd_SS='''+@Cd_SS+''''
Else
Begin
	If(@CadenaSS<>'') --> cantidad de ss > 1
		Set @CondSS = ' and v.Cd_CC+''_''+v.Cd_SC+''_''v.Cd_SS in ('+@CadenaSS+')'	
End

Print @CondCC
Print @CondSC
Print @CondSS
---------------------------------------------------------------------------

Declare @TabPrdo varchar(8000) Set @TabPrdo=''
Declare @TabCC varchar(8000) Set @TabCC=''
Declare @TabSC varchar(8000) Set @TabSC=''
Declare @TabSS varchar(8000) Set @TabSS=''

Declare @colCC varchar(50),@gruCC varchar(50) Set @colCC='' Set @gruCC=''
Declare @colSC varchar(50),@gruSC varchar(50) Set @colSC='' Set @gruSC=''
Declare @colSS varchar(50),@gruSS varchar(50) Set @colSS='' Set @gruSS=''

Declare @colPrdo varchar(50),@gruPrdo varchar(50) Set @colPrdo='' Set @gruPrdo=''
If(@VerMes=1)
Begin
Declare @i Int Set @i=Convert(int,@PrdoD)
	Declare @f Int Set @f=Convert(int,@PrdoH)
	While(@i<=@f)
	Begin
		If(@i>Convert(int,@PrdoD)) Set @TabPrdo=@TabPrdo+' Union All '
		Set @TabPrdo=@TabPrdo+' Select '+''''+right('00'+ltrim(@i),2)+''''+' As Prdo,'+''''+user123.DameFormPrdo(right('00'+ltrim(@i),2),0,1)+''''+' As NomPrdo'
		Set @i=@i+1
	End
	
	Set @colPrdo=',v.Prdo'
	Set @gruPrdo=',v.Prdo'
End
Else
Begin
	Set @TabPrdo='Select Top 0 '''' Prdo,'''' NCorto'
	Set @colPrdo=','''''
	Set @gruPrdo=''
End

If(@EsCc=1)
Begin
	Set @TabCC='Select v.Cd_CC,v.NCorto As NomCC From CCostos v Where v.RucE='''+@RucE+''''+@CondCC
	Set @colCC=',v.Cd_CC'
	Set @gruCC=',v.Cd_CC'
End
Else 
Begin
	Set @TabCC='Select Top 0 '''' Cd_CC,'''' NomCC'
	Set @colCC=','''''
End
If(@EsSc=1)	
Begin
	Set @TabSC='Select v.Cd_CC,v.Cd_SC,c.NCorto As NomCC,v.NCorto As NomSC From CCSub v Left Join CCostos c On c.RucE=v.RucE and c.Cd_CC=v.Cd_CC Where v.RucE='''+@RucE+''''+@CondCC+@CondSC
	Set @colSC=',v.Cd_SC'
	Set @gruSC=',v.Cd_SC'
End
Else 
Begin
	Set @TabSC='Select Top 0 '''' Cd_CC,'''' Cd_SC,'''' NomCC,'''' NomSC'
	Set @colSC=','''''
End

If(@EsSs=1)	
Begin
	Set @TabSS='Select v.Cd_CC,v.Cd_SC,v.Cd_SS,c.NCorto As NomCC,s.NCorto As NomSC,v.NCorto As NomSS From CCSubSub v Left Join CCSub s On s.RucE=v.RucE and s.Cd_CC=v.Cd_CC and s.Cd_SC=v.Cd_SC Left Join CCostos c On c.RucE=s.RucE and c.Cd_CC=s.Cd_CC Where v.RucE='''+@RucE+''''+@CondCC+@CondSC+@CondSS
	Set @colSS=',v.Cd_SS'
	Set @gruSS=',v.Cd_SS'
End
Else 
Begin
	Set @TabSS='Select Top 0 '''' Cd_CC,'''' Cd_SC,'''' Cd_SS,'''' NomCC,'''' NomSC,'''' NomSS'
	Set @colSS=','''''
End

Print @TabPrdo
Print @TabCC
Print @TabSC
Print @TabSS

Print @colCC
Print @gruCC
Print @colSC
Print @gruSC
Print @colSS
Print @gruSS

Exec (@TabPrdo)
Exec (@TabCC)
Exec (@TabSC)
Exec (@TabSS)

Declare @TabDatos_1 varchar(8000) Set @TabDatos_1=''
Declare @TabDatos_2 varchar(8000) Set @TabDatos_1=''

Declare @TabDatos1_1 varchar(8000) Set @TabDatos1_1=''
Declare @TabDatos1_2 varchar(8000) Set @TabDatos1_2=''
Declare @CondCC_1 Varchar(8000) Set @CondCC_1=''
Declare @CondSC_1 Varchar(8000) Set @CondSC_1=''
Declare @CondSS_1 Varchar(8000) Set @CondSS_1=''

Declare @TabDatos2_1 varchar(8000) Set @TabDatos2_1=''
Declare @TabDatos2_2 varchar(8000) Set @TabDatos2_2=''
Declare @CondCC_2 Varchar(8000) Set @CondCC_2=''
Declare @CondSC_2 Varchar(8000) Set @CondSC_2=''
Declare @CondSS_2 Varchar(8000) Set @CondSS_2=''

Declare @TabDatos3_1 varchar(8000) Set @TabDatos3_1=''
Declare @TabDatos3_2 varchar(8000) Set @TabDatos3_2=''
Declare @CondCC_3 Varchar(8000) Set @CondCC_3=''
Declare @CondSC_3 Varchar(8000) Set @CondSC_3=''
Declare @CondSS_3 Varchar(8000) Set @CondSS_3=''

Declare @TabDatos4_1 varchar(8000) Set @TabDatos4_1=''
Declare @TabDatos4_2 varchar(8000) Set @TabDatos4_2=''
Declare @CondCC_4 Varchar(8000) Set @CondCC_4=''
Declare @CondSC_4 Varchar(8000) Set @CondSC_4=''
Declare @CondSS_4 Varchar(8000) Set @CondSS_4=''

Set @TabDatos_1=
'
Select
	r.Ejer,r.NroCta,p.NomCta,r.Cd_Rub,
	Case When left(ltrim(r.NroCta),1) in (4,5,6,7,8,9) Then r.Monto*-1 Else r.Monto end As Monto,
	r.Prdo,r.Cd_CC,r.Cd_SC,r.Cd_SS
From
(
Select 
	v.RucE,v.Ejer,left(v.NroCta,2) As NroCta,p.'+@Cd_REF+' As Cd_Rub,
	Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Monto'+@colPrdo+' As Prdo
	'+@ColCC+' As Cd_CC'+@ColSC+' As Cd_SC'+@ColSS+' As Cd_SS
From 
	Voucher v
	Left Join ReporteFinancieroDet f On f.RucE=v.RucE and f.Ejer=v.Ejer and f.Cd_REF='''+@Cd_REF+'''
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.'+@Cd_REF+','''')=f.Cd_Rub
Where 
	v.RucE='''+@RucE+'''
	'+@CondEjer+'
	and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''
	and isnull(v.IB_Anulado,0)=0
	and isnull(p.'+@Cd_REF+','''')<>'''''
	
	--+@CondCC+@CondSC+@CondSS+
	
Set @TabDatos_2=
'
Group by
	v.RucE,v.Ejer,left(v.NroCta,2),p.'+@Cd_REF+@gruPrdo+@gruCC+@gruSC+@gruSS+'
Having
	Sum(v.MtoD-v.MtoH)<>0
) As r
Left Join PlanCtas p On p.RucE=r.RucE and p.Ejer=r.Ejer and p.NroCta=r.NroCta
'

if(@N1 = 1)
Begin
	
Set @TabDatos1_1=
'
Select
	r.Ejer,r.NroCta As NroCtaN1,'''' As NroCtaN2,'''' As NroCtaN3,'''' As NroCtaN4,p.NomCta,r.Cd_Rub,
	Case When left(ltrim(r.NroCta),1) in (4,5,6,7,8,9) Then r.Monto*-1 Else r.Monto end As Monto,
	r.Prdo,r.Cd_CC,r.Cd_SC,r.Cd_SS
From
(
Select 
	v.RucE,v.Ejer,left(v.NroCta,2) As NroCta,p.'+@Cd_REF+' As Cd_Rub,
	Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Monto'+@colPrdo+' As Prdo
	'+@ColCC+' As Cd_CC'+@ColSC+' As Cd_SC'+@ColSS+' As Cd_SS
From 
	Voucher v
	Left Join ReporteFinancieroDet f On f.RucE=v.RucE and f.Ejer=v.Ejer and f.Cd_REF='''+@Cd_REF+'''
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.'+@Cd_REF+','''')=f.Cd_Rub
Where 
	v.RucE='''+@RucE+'''
	'+@CondEjer+'
	and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''
	and isnull(v.IB_Anulado,0)=0
	and isnull(p.'+@Cd_REF+','''')<>'''''

Set @CondCC_1 = @CondCC
Set @CondSC_1 = @CondSC
Set @CondSS_1 = @CondSS

Set @TabDatos1_2=
'
Group by
	v.RucE,v.Ejer,left(v.NroCta,2),p.'+@Cd_REF+@gruPrdo+@gruCC+@gruSC+@gruSS+'
Having
	Sum(v.MtoD-v.MtoH)<>0
) As r
Left Join PlanCtas p On p.RucE=r.RucE and p.Ejer=r.Ejer and p.NroCta=r.NroCta
'
	
End
Else
Begin
Set @TabDatos1_1=
'
Select Top 0 
	'''' As Ejer,'''' As NroCtaN1,'''' As NroCtaN2,'''' As NroCtaN3,'''' As NroCtaN4,'''' As NomCta,
	'''' As Cd_Rub,'''' As Monto,'''' As Prdo,'''' As Cd_CC,'''' As Cd_SC,'''' As Cd_SS
'
End

if(@N2 = 1)
Begin
	
Set @TabDatos2_1=
'
Select
	r.Ejer,left(r.NroCta,2) As NroCtaN1,r.NroCta As NroCtaN2,'''' As NroCtaN3,'''' As NroCtaN4,p.NomCta,r.Cd_Rub,
	Case When left(ltrim(r.NroCta),1) in (4,5,6,7,8,9) Then r.Monto*-1 Else r.Monto end As Monto,
	r.Prdo,r.Cd_CC,r.Cd_SC,r.Cd_SS
From
(
Select 
	v.RucE,v.Ejer,left(v.NroCta,4) As NroCta,p.'+@Cd_REF+' As Cd_Rub,
	Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Monto'+@colPrdo+' As Prdo
	'+@ColCC+' As Cd_CC'+@ColSC+' As Cd_SC'+@ColSS+' As Cd_SS
From 
	Voucher v
	Left Join ReporteFinancieroDet f On f.RucE=v.RucE and f.Ejer=v.Ejer and f.Cd_REF='''+@Cd_REF+'''
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.'+@Cd_REF+','''')=f.Cd_Rub
Where 
	v.RucE='''+@RucE+'''
	'+@CondEjer+'
	and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''
	and isnull(v.IB_Anulado,0)=0
	and isnull(p.'+@Cd_REF+','''')<>'''''
	
Set @CondCC_2 = @CondCC
Set @CondSC_2 = @CondSC
Set @CondSS_2 = @CondSS

Set @TabDatos2_2=
'
Group by
	v.RucE,v.Ejer,left(v.NroCta,4),p.'+@Cd_REF+@gruPrdo+@gruCC+@gruSC+@gruSS+'
Having
	Sum(v.MtoD-v.MtoH)<>0
) As r
Left Join PlanCtas p On p.RucE=r.RucE and p.Ejer=r.Ejer and p.NroCta=r.NroCta
'
	
End
Else
Begin
Set @TabDatos2_1=
'
Select Top 0 
	'''' As Ejer,'''' As NroCtaN1,'''' As NroCtaN2,'''' As NroCtaN3,'''' As NroCtaN4,'''' As NomCta,
	'''' As Cd_Rub,'''' As Monto,'''' As Prdo,'''' As Cd_CC,'''' As Cd_SC,'''' As Cd_SS
'
End

if(@N3 = 1)
Begin
	
Set @TabDatos3_1=
'
Select
	r.Ejer,left(r.NroCta,2) As NroCtaN1,left(r.NroCta,4) As NroCtaN2,r.NroCta As NroCtaN3,'''' As NroCtaN4,p.NomCta,r.Cd_Rub,
	Case When left(ltrim(r.NroCta),1) in (4,5,6,7,8,9) Then r.Monto*-1 Else r.Monto end As Monto,
	r.Prdo,r.Cd_CC,r.Cd_SC,r.Cd_SS
From
(
Select 
	v.RucE,v.Ejer,left(v.NroCta,6) As NroCta,p.'+@Cd_REF+' As Cd_Rub,
	Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Monto'+@colPrdo+' As Prdo
	'+@ColCC+' As Cd_CC'+@ColSC+' As Cd_SC'+@ColSS+' As Cd_SS
From 
	Voucher v
	Left Join ReporteFinancieroDet f On f.RucE=v.RucE and f.Ejer=v.Ejer and f.Cd_REF='''+@Cd_REF+'''
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.'+@Cd_REF+','''')=f.Cd_Rub
Where 
	v.RucE='''+@RucE+'''
	'+@CondEjer+'
	and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''
	and isnull(v.IB_Anulado,0)=0
	and isnull(p.'+@Cd_REF+','''')<>'''''

Set @CondCC_3 = @CondCC
Set @CondSC_3 = @CondSC
Set @CondSS_3 = @CondSS

Set @TabDatos3_2=
'
Group by
	v.RucE,v.Ejer,left(v.NroCta,6),p.'+@Cd_REF+@gruPrdo+@gruCC+@gruSC+@gruSS+'
Having
	Sum(v.MtoD-v.MtoH)<>0
) As r
Left Join PlanCtas p On p.RucE=r.RucE and p.Ejer=r.Ejer and p.NroCta=r.NroCta
'
	
End
Else
Begin
Set @TabDatos3_1=
'
Select Top 0 
	'''' As Ejer,'''' As NroCtaN1,'''' As NroCtaN2,'''' As NroCtaN3,'''' As NroCtaN4,'''' As NomCta,
	'''' As Cd_Rub,'''' As Monto,'''' As Prdo,'''' As Cd_CC,'''' As Cd_SC,'''' As Cd_SS
'
End


if(@N4 = 1)
Begin
	
Set @TabDatos4_1=
'
Select
	r.Ejer,left(r.NroCta,2) As NroCtaN1,left(r.NroCta,4) As NroCtaN2,left(r.NroCta,6) As NroCtaN3,r.NroCta As NroCtaN4,p.NomCta,r.Cd_Rub,
	Case When left(ltrim(r.NroCta),1) in (4,5,6,7,8,9) Then r.Monto*-1 Else r.Monto end As Monto,
	r.Prdo,r.Cd_CC,r.Cd_SC,r.Cd_SS
From
(
Select 
	v.RucE,v.Ejer,v.NroCta As NroCta,p.'+@Cd_REF+' As Cd_Rub,
	Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Monto'+@colPrdo+' As Prdo
	'+@ColCC+' As Cd_CC'+@ColSC+' As Cd_SC'+@ColSS+' As Cd_SS
From 
	Voucher v
	Left Join ReporteFinancieroDet f On f.RucE=v.RucE and f.Ejer=v.Ejer and f.Cd_REF='''+@Cd_REF+'''
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta and isnull(p.'+@Cd_REF+','''')=f.Cd_Rub
Where 
	v.RucE='''+@RucE+'''
	'+@CondEjer+'
	and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+'''
	and isnull(v.IB_Anulado,0)=0
	and isnull(p.'+@Cd_REF+','''')<>'''''

Set @CondCC_4 = @CondCC
Set @CondSC_4 = @CondSC
Set @CondSS_4 = @CondSS

Set @TabDatos4_2=
'
Group by
	v.RucE,v.Ejer,v.NroCta,p.'+@Cd_REF+@gruPrdo+@gruCC+@gruSC+@gruSS+'
Having
	Sum(v.MtoD-v.MtoH)<>0
) As r
Left Join PlanCtas p On p.RucE=r.RucE and p.Ejer=r.Ejer and p.NroCta=r.NroCta
'
	
End
Else
Begin
Set @TabDatos4_1=
'
Select Top 0 
	'''' As Ejer,'''' As NroCtaN1,'''' As NroCtaN2,'''' As NroCtaN3,'''' As NroCtaN4,'''' As NomCta,
	'''' As Cd_Rub,'''' As Monto,'''' As Prdo,'''' As Cd_CC,'''' As Cd_SC,'''' As Cd_SS
'
End


Print @TabDatos_1
Print @CondCC
Print @CondSC
Print @CondSS
Print @TabDatos_2

Print @TabDatos1_1
Print @CondCC_1
Print @CondSC_1
Print @CondSS_1
Print @TabDatos1_2

Print @TabDatos2_1
Print @CondCC_2
Print @CondSC_2
Print @CondSS_2
Print @TabDatos2_2

Print @TabDatos3_1
Print @CondCC_3
Print @CondSC_3
Print @CondSS_3
Print @TabDatos3_2

Print @TabDatos4_1
Print @CondCC_4
Print @CondSC_4
Print @CondSS_4
Print @TabDatos4_2


Exec (@TabDatos_1+
	  @CondCC+@CondSC+@CondSS+
	  @TabDatos_2)
	  
Exec (@TabDatos1_1+
	  @CondCC_1+@CondSC_1+@CondSS_1+
	  @TabDatos1_2)

Exec (@TabDatos2_1+
	  @CondCC_2+@CondSC_2+@CondSS_2+
	  @TabDatos2_2)

Exec (@TabDatos3_1+
	  @CondCC_3+@CondSC_3+@CondSS_3+
	  @TabDatos3_2)

Exec (@TabDatos4_1+
	  @CondCC_4+@CondSC_4+@CondSS_4+
	  @TabDatos4_2)

-- Leyenda --
-- DI : 13/09/2012 <Creacion del SP>

GO

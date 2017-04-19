SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_BalanceComprobacion3]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoD nvarchar(2),
@PrdoH nvarchar(2),
@Cd_Mda nvarchar(2),
@N1 bit, --Nivel Cta 1
@N2 bit, --Nivel Cta 2
@N3 bit, --Nivel Cta 3
@N4 bit, --Nivel Cta 4
@CtaD nvarchar(10),
@CtaH nvarchar(10),
@VerCta1 bit, -- VerCta Normal
@VerCta2 bit, -- VerCta Hmlgd 1
@VerCta3 bit, -- VerCta Hmlgd 2
@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Datos varchar(7000) --Cd_CC,Cd_SC,Cd_SS
As

--Set @RucE='11111111111'
--Set @Ejer='2012'
--Set @PrdoD='00'
--Set @PrdoH='03'
--Set @Cd_Mda='01'
--Set @N1=1
--Set @N2=1
--Set @N3=1
--Set @N4=1
--Set @CtaD=''
--Set @CtaH=''
--Set @VerCta1=1
--Set @VerCta2=0
--Set @VerCta3=0
--Set @Cd_CC='01010101'
--Set @Cd_SC=''
--Set @Cd_SS=''
--Set @Datos='''01010101'',''01010102'''

Declare @N1_SELECT1 varchar(8000),@N1_SELECT2 varchar(8000),@N1_WHERE varchar(8000),@N1_GROUP varchar(8000)
Declare @N2_SELECT1 varchar(8000),@N2_SELECT2 varchar(8000),@N2_WHERE varchar(8000),@N2_GROUP varchar(8000)
Declare @N3_SELECT1 varchar(8000),@N3_SELECT2 varchar(8000),@N3_WHERE varchar(8000),@N3_GROUP varchar(8000)
Declare @N4_SELECT1 varchar(8000),@N4_SELECT2 varchar(8000),@N4_WHERE varchar(8000),@N4_GROUP varchar(8000)

Set @N1_SELECT1='' Set @N1_SELECT2='' Set @N1_WHERE='' Set @N1_GROUP=''
Set @N2_SELECT1='' Set @N2_SELECT2='' Set @N2_WHERE='' Set @N2_GROUP=''
Set @N3_SELECT1='' Set @N3_SELECT2='' Set @N3_WHERE='' Set @N3_GROUP=''
Set @N4_SELECT1='' Set @N4_SELECT2='' Set @N4_WHERE='' Set @N4_GROUP=''

Declare @_NroCta_1 nvarchar(100)
Declare @_NroCta_2 nvarchar(100)
Declare @_NroCta_3 nvarchar(100)
Declare @_NroCta_4 nvarchar(100)

Declare @_NomCta nvarchar(100)


--****************************************************************
-- Definiendo el condicion de rango para las cuentas contables
Declare @_RangoCta nvarchar(100) Set @_RangoCta=''
If(@CtaD <> '') Set @_RangoCta = @_RangoCta + ' and v.NroCta >='''+@CtaD+''''
If(@CtaH <> '') Set @_RangoCta = @_RangoCta + ' and v.NroCta <='''+@CtaH+''''
--****************************************************************


--****************************************************************
-- Definiendo el condicion de rango para`los centro de costos
Declare @RangoCC varchar(8000) Set @RangoCC=''
Declare @N1_RangoCC varchar(8000) Set @N1_RangoCC=''
Declare @N2_RangoCC varchar(8000) Set @N2_RangoCC=''
Declare @N3_RangoCC varchar(8000) Set @N3_RangoCC=''
Declare @N4_RangoCC varchar(8000) Set @N4_RangoCC=''
if(isnull(@Cd_CC,'')<>'') --CENTRO COSTOS
begin
	Set @RangoCC = ' and v.Cd_CC='''+@Cd_CC+''''
	if(isnull(@Cd_SC,'')<>'')  --SUB CENTRO COSTOS
	begin
		Set @RangoCC = @RangoCC + ' and v.Cd_SC='''+@Cd_SC+''''
		if(isnull(@Cd_SS,'')<>'')  --SUB SUB CENTRO COSTOS
		begin
			Set @RangoCC = @RangoCC +' and v.Cd_SS='''+@Cd_SS+''''
		end
		else if(isnull(@Datos,'') <> '')
			Set @RangoCC = @RangoCC + ' and v.Cd_SS in ('+@Datos+')'
	end
	else if(isnull(@Datos,'') <> '')
		Set @RangoCC = @RangoCC + ' and v.Cd_SC in ('+@Datos+')'
end
else if(isnull(@Datos,'') <> '')
	Set @RangoCC = ' and v.Cd_CC in ('+@Datos+')'
else	Set @RangoCC=''
--****************************************************************



--****************************************************************
-- Definiendo el condicion para las cuentas homologadas 1 o 2
if(@VerCta3=1)
Begin
	Set @_NroCta_1 = 'Case When isnull(p.NroCtaH2,'''')<>'''' Then p.NroCtaH2 Else p.NroCta End'--'Case When isnull(p.NroCtaH2,'''')<>'''' Then left(p.NroCtaH2,2) Else left(p.NroCta,2) End'
	Set @_NroCta_2 = 'Case When isnull(p.NroCtaH2,'''')<>'''' Then p.NroCtaH2 Else p.NroCta End'--'Case When isnull(p.NroCtaH2,'''')<>'''' Then left(p.NroCtaH2,4) Else left(p.NroCta,4) End'
	Set @_NroCta_3 = 'Case When isnull(p.NroCtaH2,'''')<>'''' Then p.NroCtaH2 Else p.NroCta End'--'Case When isnull(p.NroCtaH2,'''')<>'''' Then left(p.NroCtaH2,6) Else left(p.NroCta,6) End'	
	Set @_NroCta_4 = 'Case When isnull(p.NroCtaH2,'''')<>'''' Then p.NroCtaH2 Else p.NroCta End'--'Case When isnull(p.NroCtaH2,'''')<>'''' Then p.NroCtaH2 Else p.NroCta End'
	
	Set @_NomCta = 'Case When isnull(p.NomCtaH2,'''')<>'''' Then p.NomCtaH2 Else p.NomCta End'
End
Else if(@VerCta2=1)
Begin
	Set @_NroCta_1 = 'Case When isnull(p.NroCtaH1,'''')<>'''' Then p.NroCtaH1 Else p.NroCta End'--'Case When isnull(p.NroCtaH1,'''')<>'''' Then left(p.NroCtaH1,2) Else left(p.NroCta,2) End'
	Set @_NroCta_2 = 'Case When isnull(p.NroCtaH1,'''')<>'''' Then p.NroCtaH1 Else p.NroCta End'--'Case When isnull(p.NroCtaH1,'''')<>'''' Then left(p.NroCtaH1,4) Else left(p.NroCta,4) End'
	Set @_NroCta_3 = 'Case When isnull(p.NroCtaH1,'''')<>'''' Then p.NroCtaH1 Else p.NroCta End'--'Case When isnull(p.NroCtaH1,'''')<>'''' Then left(p.NroCtaH1,6) Else left(p.NroCta,6) End'	
	Set @_NroCta_4 = 'Case When isnull(p.NroCtaH1,'''')<>'''' Then p.NroCtaH1 Else p.NroCta End'--'Case When isnull(p.NroCtaH1,'''')<>'''' Then p.NroCtaH2 Else p.NroCta End'
	
	Set @_NomCta = 'Case When isnull(p.NomCtaH1,'''')<>'''' Then p.NomCtaH1 Else p.NomCta End'
End
Else
Begin
	Set @_NroCta_1 = 'p.NroCta'--'left(v.NroCta,2)'
	Set @_NroCta_2 = 'p.NroCta'--'left(v.NroCta,4)'
	Set @_NroCta_3 = 'p.NroCta'--'left(v.NroCta,6)'
	Set @_NroCta_4 = 'p.NroCta'--'v.NroCta'
	
	Set @_NomCta = 'p.NomCta'
End
--****************************************************************




DECLARE @mda VARCHAR(3) SET @mda = ''
SET @mda = CASE WHEN @Cd_Mda='02' THEN '_ME' ELSE '' END


IF(@N1=1)
BEGIN

Set @N1_SELECT1 =
'
SELECT 
	r.Nivel,'+@_NroCta_1+' As NroCta,'+@_NomCta+' As NomCta,r.Debe_00,r.Haber_00,r.Debe_1N,r.Haber_1N,r.Sum_Debe,r.Sum_Haber,r.Saldo_Deudor,r.Saldo_Acreedor,r.INVE_ACT,r.INVE_PAS,r.NATU_PER,r.NATU_GAN,r.FUNC_PER,r.FUNC_GAN,r.INVE,r.NATU,r.FUNC
FROM
(
Select 
	1 As Nivel,
	left(v.NroCta,2) As NroCta,
	Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) As Debe_00,
	Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) As Haber_00,
	Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End) As Debe_1N,
	Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End) As Haber_1N,
	Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End) As Sum_Debe,
	Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End) As Sum_Haber,
	
	
	--********** INICIO SALDOS **********
	CASE 
		WHEN (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
		ELSE 0
	END Saldo_Deudor,
	CASE 
		WHEN (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
		ELSE 0
	END Saldo_Acreedor,
	
	--********** INICIO INVENTARIO **********
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))>(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END INVE_ACT,
'
/*
'
Select 
	1 As Nivel,
	--left(v.NroCta,2) As NroCta,
	--p.NomCta,
	'+@_NroCta_1+' As NroCta,
	'+@_NomCta+' As NomCta,
	--Prdo,
	Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) As Debe_00,
	Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) As Haber_00,
	Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End) As Debe_1N,
	Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End) As Haber_1N,
	Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End) As Sum_Debe,
	Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End) As Sum_Haber,
	
	
	--********** INICIO SALDOS **********
	Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
				Then 
					(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
				Else 0
	End Saldo_Deudor,
				
	Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
				Then 
					(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
				Else 0 
	End Saldo_Acreedor,
	
	
	--********** INICIO INVENTARIO **********
	Case When Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Else 0
					End
				Else 0.00
	End INVE_ACT,
	Case When Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
								Else 0 
					End
				Else 0.00
	End INVE_PAS,
	
	--********** INICIO NATURALEZA **********
	Case When Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Else 0
					End
				Else 0.00
	End NATU_PER,
	'*/
Set @N1_SELECT2 =
'	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))<(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END INVE_PAS,
--********** INICIO NATURALEZA **********
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))>(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END NATU_PER,
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))<(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END NATU_GAN,
	
	--********** INICIO FUNCION		 **********
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))>(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END FUNC_PER,
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))<(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END FUNC_GAN,
			
	Sum(Case When isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' Then 1 Else 0 End) As INVE,
	Sum(Case When isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' Then 1 Else 0 End) As NATU,
	Sum(Case When isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' Then 1 Else 0 End) As FUNC
'
/*
'	Case When Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
								Else 0 
					End
				Else 0.00
	End NATU_GAN,
	
	
	--********** INICIO FUNCION		 **********
	Case When Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Else 0
					End
				Else 0.00
	End FUNC_PER,
	Case When Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
								Else 0 
					End
				Else 0.00
	End FUNC_GAN,
	
			
	Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End As INVE,
	Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End As NATU,
	Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End As FUNC
'
*/
Set @N1_WHERE =
'
From 
	Voucher v
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta--left(v.NroCta,2)
Where 
	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''  and isnull(v.IB_Anulado,0)=0 and isnull(v.NroCta,'''')<>'''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''''+@_RangoCta+'
'
/*
'
From 
	Voucher v
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=left(v.NroCta,2)
Where 
	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''  and isnull(v.IB_Anulado,0)=0 and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''''+@_RangoCta+'
'
*/
Set @N1_GROUP =
'
Group by 
	left(v.NroCta,2)
Having
	Sum(Case When isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' Then 1 Else 0 End) +
	Sum(Case When isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' Then 1 Else 0 End)  +
	Sum(Case When isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' Then 1 Else 0 End) <> 0
--ORDER BY 2
) r LEFT JOIN PlanCtas p On p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and p.NroCta=r.NroCta
'
/*
'
Group by 
	'+@_NroCta_1+',
	'+@_NomCta+',
	Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End,
	Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End,
	Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End
Having
	Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End +
	Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End +
	Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End <> 0
'
*/

SET @N1_RangoCC = @RangoCC

PRINT @N1_SELECT1
PRINT @N1_SELECT2
PRINT @N1_WHERE
PRINT @N1_RangoCC
PRINT @N1_GROUP

END


IF(@N2=1)
BEGIN

if(@N1=1)
	Set @N2_SELECT1 = ' UNION ALL'

Set @N2_SELECT1 = @N2_SELECT1 +
'
SELECT 
	r.Nivel,'+@_NroCta_2+' As NroCta,'+@_NomCta+' As NomCta,r.Debe_00,r.Haber_00,r.Debe_1N,r.Haber_1N,r.Sum_Debe,r.Sum_Haber,r.Saldo_Deudor,r.Saldo_Acreedor,r.INVE_ACT,r.INVE_PAS,r.NATU_PER,r.NATU_GAN,r.FUNC_PER,r.FUNC_GAN,r.INVE,r.NATU,r.FUNC
FROM
(
Select 
	2 As Nivel,
	left(v.NroCta,4) As NroCta,
	Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) As Debe_00,
	Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) As Haber_00,
	Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End) As Debe_1N,
	Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End) As Haber_1N,
	Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End) As Sum_Debe,
	Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End) As Sum_Haber,
	
	
	--********** INICIO SALDOS **********
	CASE 
		WHEN (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
		ELSE 0
	END Saldo_Deudor,
	CASE 
		WHEN (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
		ELSE 0
	END Saldo_Acreedor,
	
	--********** INICIO INVENTARIO **********
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))>(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END INVE_ACT,
'
/*
'
Select 
	2 As Nivel,
	'+@_NroCta_2+' As NroCta,
	'+@_NomCta+' As NomCta,
	Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) As Debe_00,
	Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) As Haber_00,
	Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End) As Debe_1N,
	Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End) As Haber_1N,
	Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End) As Sum_Debe,
	Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End) As Sum_Haber,
	
	
	--********** INICIO SALDOS **********
	Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
				Then 
					(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
				Else 0
	End Saldo_Deudor,
				
	Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
				Then 
					(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
				Else 0 
	End Saldo_Acreedor,
	
	
	--********** INICIO INVENTARIO **********
	Case When Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Else 0
					End
				Else 0.00
	End INVE_ACT,
	Case When Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
								Else 0 
					End
				Else 0.00
	End INVE_PAS,
	
	--********** INICIO NATURALEZA **********
	Case When Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Else 0
					End
				Else 0.00
	End NATU_PER,
'
*/
Set @N2_SELECT2 =
'	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))<(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END INVE_PAS,
--********** INICIO NATURALEZA **********
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))>(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END NATU_PER,
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))<(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END NATU_GAN,
	
	--********** INICIO FUNCION		 **********
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))>(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END FUNC_PER,
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))<(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END FUNC_GAN,
			
	Sum(Case When isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' Then 1 Else 0 End) As INVE,
	Sum(Case When isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' Then 1 Else 0 End) As NATU,
	Sum(Case When isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' Then 1 Else 0 End) As FUNC
'
/*
'	Case When Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
								Else 0 
					End
				Else 0.00
	End NATU_GAN,
	
	
	--********** INICIO FUNCION		 **********
	Case When Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Else 0
					End
				Else 0.00
	End FUNC_PER,
	Case When Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
								Else 0 
					End
				Else 0.00
	End FUNC_GAN,
		
	Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End As INVE,
	Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End As NATU,
	Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End As FUNC
'
*/
Set @N2_WHERE =
'
From 
	Voucher v
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta--left(v.NroCta,4)
Where 
	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''  and isnull(v.IB_Anulado,0)=0 and isnull(v.NroCta,'''')<>'''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''''+@_RangoCta+'
'
/*
'
From 
	Voucher v
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=left(v.NroCta,4)
Where 
	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and isnull(v.IB_Anulado,0)=0 and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''''+@_RangoCta+'
'
*/
Set @N2_GROUP =
'
Group by 
	left(v.NroCta,4)
Having
	Sum(Case When isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' Then 1 Else 0 End) +
	Sum(Case When isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' Then 1 Else 0 End)  +
	Sum(Case When isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' Then 1 Else 0 End) <> 0
--ORDER BY 2
) r LEFT JOIN PlanCtas p On p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and p.NroCta=r.NroCta
'
/*
'
Group by 
	'+@_NroCta_2+',
	'+@_NomCta+',
	Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End,
	Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End,
	Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End
Having
	Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End +
	Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End +
	Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End <> 0
'
*/

SET @N2_RangoCC = @RangoCC

PRINT @N2_SELECT1
PRINT @N2_SELECT2
PRINT @N2_WHERE
PRINT @N2_RangoCC
PRINT @N2_GROUP

END


IF(@N3=1)
BEGIN

if(@N1=1 or @N2=1)
	Set @N3_SELECT1 = ' UNION ALL'

Set @N3_SELECT1 = @N3_SELECT1 +
'
SELECT 
	r.Nivel,'+@_NroCta_3+' As NroCta,'+@_NomCta+' As NomCta,r.Debe_00,r.Haber_00,r.Debe_1N,r.Haber_1N,r.Sum_Debe,r.Sum_Haber,r.Saldo_Deudor,r.Saldo_Acreedor,r.INVE_ACT,r.INVE_PAS,r.NATU_PER,r.NATU_GAN,r.FUNC_PER,r.FUNC_GAN,r.INVE,r.NATU,r.FUNC
FROM
(
Select 
	3 As Nivel,
	left(v.NroCta,6) As NroCta,
	Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) As Debe_00,
	Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) As Haber_00,
	Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End) As Debe_1N,
	Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End) As Haber_1N,
	Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End) As Sum_Debe,
	Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End) As Sum_Haber,
	
	
	--********** INICIO SALDOS **********
	CASE 
		WHEN (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
		ELSE 0
	END Saldo_Deudor,
	CASE 
		WHEN (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
		ELSE 0
	END Saldo_Acreedor,
	
	--********** INICIO INVENTARIO **********
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))>(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END INVE_ACT,
'
/*
'
Select
	3 As Nivel, 
	'+@_NroCta_3+' As NroCta,
	'+@_NomCta+' As NomCta,
	Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) As Debe_00,
	Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) As Haber_00,
	Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End) As Debe_1N,
	Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End) As Haber_1N,
	Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End) As Sum_Debe,
	Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End) As Sum_Haber,
	
	
	--********** INICIO SALDOS **********
	Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
				Then 
					(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
				Else 0
	End Saldo_Deudor,
				
	Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
				Then 
					(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
				Else 0 
	End Saldo_Acreedor,
	
	
	--********** INICIO INVENTARIO **********
	Case When Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Else 0
					End
				Else 0.00
	End INVE_ACT,
	Case When Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
								Else 0 
					End
				Else 0.00
	End INVE_PAS,
	
	--********** INICIO NATURALEZA **********
	Case When Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Else 0
					End
				Else 0.00
	End NATU_PER,
'
*/
Set @N3_SELECT2 =
'	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))<(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END INVE_PAS,
--********** INICIO NATURALEZA **********
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))>(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END NATU_PER,
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))<(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END NATU_GAN,
	
	--********** INICIO FUNCION		 **********
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))>(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END FUNC_PER,
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))<(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END FUNC_GAN,
			
	Sum(Case When isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' Then 1 Else 0 End) As INVE,
	Sum(Case When isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' Then 1 Else 0 End) As NATU,
	Sum(Case When isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' Then 1 Else 0 End) As FUNC
'
/*
'
	Case When Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
								Else 0 
					End
				Else 0.00
	End NATU_GAN,
	
	
	--********** INICIO FUNCION		 **********
	Case When Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Else 0
					End
				Else 0.00
	End FUNC_PER,
	Case When Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
								Else 0 
					End
				Else 0.00
	End FUNC_GAN,
		
	Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End As INVE,
	Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End As NATU,
	Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End As FUNC
'
*/
Set @N3_WHERE =
'
From 
	Voucher v
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta--left(v.NroCta,6)
Where 
	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''  and isnull(v.IB_Anulado,0)=0 and isnull(v.NroCta,'''')<>'''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''''+@_RangoCta+'
'
/*
'
From 
	Voucher v
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=left(v.NroCta,6)
Where 
	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and isnull(v.IB_Anulado,0)=0 and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''''+@_RangoCta+'
'
*/
Set @N3_GROUP =
'
Group by 
	left(v.NroCta,6)
Having
	Sum(Case When isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' Then 1 Else 0 End) +
	Sum(Case When isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' Then 1 Else 0 End)  +
	Sum(Case When isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' Then 1 Else 0 End) <> 0
--ORDER BY 2
) r LEFT JOIN PlanCtas p On p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and p.NroCta=r.NroCta
'
/*
'
Group by 
	'+@_NroCta_3+',
	'+@_NomCta+',
	Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End,
	Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End,
	Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End
Having
	Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End +
	Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End +
	Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End <> 0
'
*/

SET @N3_RangoCC = @RangoCC

PRINT @N3_SELECT1
PRINT @N3_SELECT2
PRINT @N3_WHERE
PRINT @N3_RangoCC
PRINT @N3_GROUP

END


IF(@N4=1)
BEGIN

if(@N1=1 or @N2=1 or @N3=1)
	Set @N4_SELECT1 = ' UNION ALL'

Set @N4_SELECT1 = @N4_SELECT1 +
'
SELECT 
	r.Nivel,'+@_NroCta_4+' As NroCta,'+@_NomCta+' As NomCta,r.Debe_00,r.Haber_00,r.Debe_1N,r.Haber_1N,r.Sum_Debe,r.Sum_Haber,r.Saldo_Deudor,r.Saldo_Acreedor,r.INVE_ACT,r.INVE_PAS,r.NATU_PER,r.NATU_GAN,r.FUNC_PER,r.FUNC_GAN,r.INVE,r.NATU,r.FUNC
FROM
(
Select 
	4 As Nivel,
	v.NroCta As NroCta,
	Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) As Debe_00,
	Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) As Haber_00,
	Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End) As Debe_1N,
	Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End) As Haber_1N,
	Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End) As Sum_Debe,
	Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End) As Sum_Haber,
	
	
	--********** INICIO SALDOS **********
	CASE 
		WHEN (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
		ELSE 0
	END Saldo_Deudor,
	CASE 
		WHEN (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
		ELSE 0
	END Saldo_Acreedor,
	
	--********** INICIO INVENTARIO **********
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))>(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END INVE_ACT,
'

/*
'
Select 
	4 As Nivel,
	'+@_NroCta_4+' As NroCta,
	'+@_NomCta+' As NomCta,
	Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) As Debe_00,
	Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) As Haber_00,
	Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End) As Debe_1N,
	Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End) As Haber_1N,
	Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End) As Sum_Debe,
	Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End) As Sum_Haber,
	
	
	--********** INICIO SALDOS **********
	Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
				Then 
					(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
				Else 0
	End Saldo_Deudor,
				
	Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
				Then 
					(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
				Else 0 
	End Saldo_Acreedor,
	
	
	--********** INICIO INVENTARIO **********
	Case When Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Else 0
					End
				Else 0.00
	End INVE_ACT,
	Case When Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
								Else 0 
					End
				Else 0.00
	End INVE_PAS,
	
	--********** INICIO NATURALEZA **********
	Case When Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Else 0
					End
				Else 0.00
	End NATU_PER,
'
*/
Set @N4_SELECT2 =
'	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))<(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END INVE_PAS,
--********** INICIO NATURALEZA **********
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))>(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END NATU_PER,
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))<(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END NATU_GAN,
	
	--********** INICIO FUNCION		 **********
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))>(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END FUNC_PER,
	CASE
		WHEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))<(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))
		THEN (Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoH'+@mda+' ELSE 0 END Else 0 End))-(Sum(Case When v.Prdo=''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End) + Sum(Case When v.Prdo<>''00'' Then CASE WHEN isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' THEN v.MtoD'+@mda+' ELSE 0 END Else 0 End))
		ELSE 0
	END FUNC_GAN,
			
	Sum(Case When isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' Then 1 Else 0 End) As INVE,
	Sum(Case When isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' Then 1 Else 0 End) As NATU,
	Sum(Case When isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' Then 1 Else 0 End) As FUNC
'
/*
'
	Case When Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
								Else 0 
					End
				Else 0.00
	End NATU_GAN,
	
	
	--********** INICIO FUNCION		 **********
	Case When Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))>(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Else 0
					End
				Else 0.00
	End FUNC_PER,
	Case When Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End=1
				Then
					Case When (Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))<(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))
								Then 
									(Sum(Case When v.Prdo=''00'' Then v.MtoH'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoH'+@mda+' Else 0 End))-(Sum(Case When v.Prdo=''00'' Then v.MtoD'+@mda+' Else 0 End) + Sum(Case When v.Prdo<>''00'' Then v.MtoD'+@mda+' Else 0 End))
								Else 0 
					End
				Else 0.00
	End FUNC_GAN,
		
	Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End As INVE,
	Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End As NATU,
	Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End As FUNC
'
*/
Set @N4_WHERE = 
'
From 
	Voucher v
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
Where 
	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''  and isnull(v.IB_Anulado,0)=0 and isnull(v.NroCta,'''')<>'''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''''+@_RangoCta+'
'
/*
'
From 
	Voucher v
	Left Join PlanCtas p On p.RucE=v.RucE and p.Ejer=v.Ejer and p.NroCta=v.NroCta
Where 
	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+'''  and isnull(v.IB_Anulado,0)=0 and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''''+@_RangoCta+'
'
*/
Set @N4_GROUP =
'
Group by 
	v.NroCta
Having
	Sum(Case When isnull(p.Cd_Blc,'''') like ''A%'' or isnull(p.Cd_Blc,'''') like ''P%'' Then 1 Else 0 End) +
	Sum(Case When isnull(p.Cd_EGPN,'''') like ''I%'' or isnull(p.Cd_EGPN,'''') like ''E%'' Then 1 Else 0 End)  +
	Sum(Case When isnull(p.Cd_EGPF,'''') like ''I%'' or isnull(p.Cd_EGPF,'''') like ''E%'' Then 1 Else 0 End) <> 0
--ORDER BY 2
) r LEFT JOIN PlanCtas p On p.RucE='''+@RucE+''' and p.Ejer='''+@Ejer+''' and p.NroCta=r.NroCta
'
/*
'
Group by 
	'+@_NroCta_4+',
	'+@_NomCta+',
	Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End,
	Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End,
	Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End
Having
	Case When len(isnull(p.Cd_Blc,''''))>0 Then 1 Else 0 End +
	Case When len(isnull(p.Cd_EGPN,''''))>0 Then 1 Else 0 End +
	Case When len(isnull(p.Cd_EGPF,''''))>0 Then 1 Else 0 End <> 0
'
*/

SET @N4_RangoCC = @RangoCC

PRINT @N4_SELECT1
PRINT @N4_SELECT2
PRINT @N4_WHERE
PRINT @N4_RangoCC
PRINT @N4_GROUP

END


Exec ('('+
	  @N1_SELECT1+
	  @N1_SELECT2+
	  @N1_WHERE+
	  @N1_RangoCC+
	  @N1_GROUP+
	  @N2_SELECT1+
	  @N2_SELECT2+
	  @N2_WHERE+
	  @N2_RangoCC+
	  @N2_GROUP+
	  @N3_SELECT1+
	  @N3_SELECT2+
	  @N3_WHERE+
	  @N3_RangoCC+
	  @N3_GROUP+
	  @N4_SELECT1+
	  @N4_SELECT2+
	  @N4_WHERE+
	  @N4_RangoCC+
	  @N4_GROUP+
	  ') Order by 2,1')

-- Leyenda --
-- DI : 27/03/2013 <Se modifico el query hecho por JUJO>

GO

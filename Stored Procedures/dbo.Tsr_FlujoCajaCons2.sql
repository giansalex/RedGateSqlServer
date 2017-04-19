SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Tsr_FlujoCajaCons2]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoD nvarchar(11),
@PrdoH nvarchar(11),
@Moneda nvarchar(2),
@N1 bit,
@N2 bit,
@N3 bit,
@N4 bit,

@msj varchar(100) output

AS
/*
Declare @RucE nvarchar(11) Set @RucE='20504743561'
Declare @Ejer nvarchar(4) Set @Ejer='2010'
Declare @PrdoD nvarchar(2) Set @PrdoD='01'
Declare @PrdoH nvarchar(2) Set @PrdoH='03'
Declare @Moneda nvarchar(2) Set @Moneda='01'
Declare @N1 Bit Set @N1=1
Declare @N2 Bit Set @N2=0
Declare @N3 Bit Set @N3=0
Declare @N4 Bit Set @N4=0
*/


Declare @Mda nvarchar(3) Set @Mda='' if(@Moneda='02') Set @Mda='_ME'

DECLARE @SQL_CA VARCHAR(8000) SET @SQL_CA=''

DECLARE @i INT SET @i=Convert(int,@PrdoD)
DECLARE @f INT SET @f=Convert(int,@PrdoH)

WHILE(@i<=@f)
BEGIN
	IF(@i>Convert(int,@PrdoD)) SET @SQL_CA=@SQL_CA+' UNION ALL '
	SET @SQL_CA=@SQL_CA+' SELECT '+''''+right('00'+ltrim(@i),2)+''''+' As Concepto,'+''''+user123.DameFormPrdo(right('00'+ltrim(@i),2),1,1)+''''+' As NCorto'
	SET @i=@i+1
END

PRINT @SQL_CA
EXEC (@SQL_CA)

DECLARE @SQL_N1_IS VARCHAR(8000) SET @SQL_N1_IS=''
DECLARE @SQL_N1_I1 VARCHAR(8000) SET @SQL_N1_I1=''
DECLARE @SQL_N1_I2 VARCHAR(8000) SET @SQL_N1_I2=''
DECLARE @SQL_N1_E1 VARCHAR(8000) SET @SQL_N1_E1=''
DECLARE @SQL_N1_E2 VARCHAR(8000) SET @SQL_N1_E2=''

DECLARE @SQL_N2_IS VARCHAR(8000) SET @SQL_N2_IS=''
DECLARE @SQL_N2_I1 VARCHAR(8000) SET @SQL_N2_I1=''
DECLARE @SQL_N2_I2 VARCHAR(8000) SET @SQL_N2_I2=''
DECLARE @SQL_N2_E1 VARCHAR(8000) SET @SQL_N2_E1=''
DECLARE @SQL_N2_E2 VARCHAR(8000) SET @SQL_N2_E2=''

DECLARE @SQL_N3_IS VARCHAR(8000) SET @SQL_N3_IS=''
DECLARE @SQL_N3_I1 VARCHAR(8000) SET @SQL_N3_I1=''
DECLARE @SQL_N3_I2 VARCHAR(8000) SET @SQL_N3_I2=''
DECLARE @SQL_N3_E1 VARCHAR(8000) SET @SQL_N3_E1=''
DECLARE @SQL_N3_E2 VARCHAR(8000) SET @SQL_N3_E2=''

DECLARE @SQL_N4_IS VARCHAR(8000) SET @SQL_N4_IS=''
DECLARE @SQL_N4_I1 VARCHAR(8000) SET @SQL_N4_I1=''
DECLARE @SQL_N4_I2 VARCHAR(8000) SET @SQL_N4_I2=''
DECLARE @SQL_N4_IA VARCHAR(8000) SET @SQL_N4_IA=''
DECLARE @SQL_N4_E1 VARCHAR(8000) SET @SQL_N4_E1=''
DECLARE @SQL_N4_E2 VARCHAR(8000) SET @SQL_N4_E2=''
DECLARE @SQL_N4_EA VARCHAR(8000) SET @SQL_N4_EA=''


DECLARE @DCGan nvarchar(10)
DECLARE @DCPer nvarchar(10)
SELECT @DCGan=DCGan,@DCPer=DCPer From PlanCtasDef Where RucE=@RucE and Ejer=@Ejer


--If(@N1 = 1)
Begin
SET @SQL_N1_IS=
'
Select  0 As Posi,1 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto
From
(	Select  RucE,Ejer,left(NroCta,2) As NroCta,''S'' As Tipo,Isnull(Sum(MtoD'+@Mda+'-MtoH'+@Mda+'),0.00) As Importe,Prdo As Concepto 
	From    VoucherFC Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo=''00'' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,left(NroCta,2),Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta

UNION ALL
'
SET @SQL_N1_I1=
'
Select Posi,Nivel,NroCta,NomCta,Tipo,Sum(Importe) As Importe,Concepto From (
-------------------------------------------------------------
-- Contrapartidas de la cuenta 10 execto las de destino y las de diferencia de cambio
Select  1 As Posi,1 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,left(v.NroCta,2) As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe,v.Prdo As Concepto 
	From	( Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>=Sum(MtoH'+@Mda+') and Count(NroCta)>1) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
		and ((v.MtoH'+@Mda+'<>0) or (v.NroCta not like ''10%'' and v.MtoH'+@Mda+'>0))
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,left(v.NroCta,2),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
  
UNION ALL

Select  1 As Posi,1 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,left(v.NroCta,2) As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe,v.Prdo As Concepto 
	From	( Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>=Sum(MtoH'+@Mda+') and Count(NroCta)=1) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
		and ((v.MtoH'+@Mda+'<>0) or (v.NroCta not like ''10%'' and v.MtoH'+@Mda+'+v.MtoD'+@Mda+'>0))
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,left(v.NroCta,2),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
'
SET @SQL_N1_I2=
'
UNION ALL

-- Contrapartidas de la diferencias de las cuentas 10 en LD
Select  1 As Posi,1 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,Left(d.DCGan,2) As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe, v.Prdo As Concepto 
	From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')<>0
		) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
	Where  	
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.NroCta like ''10%'' and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@Mda+'<>0
	Group by v.RucE,v.Ejer,left(d.DCGan,2),v.Prdo
	--Having Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') > 0
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta

UNION ALL

-- Contrapartidas de la cuenta 10 solo las de diferencia de cambio en CB
Select  2 As Posi,1 As Nivel,''_ ''+left('''+@DCGan+''',2)+'' y ''+left('''+@DCPer+''',2) As NroCta,''DIFERENCIA DE CAMBIO'' As NomCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe, v.Prdo As Concepto 
From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where  RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')<>0
	) As Res
	Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
	--Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
	and (v.NroCta='''+@DCGan+''' or v.NroCta='''+@DCPer+''')
Group by /*d.DCGan,d.DCPer,*/v.Prdo
--Having Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') > 0
-------------------------------------------------------------
) As RESUL
GROUP BY Posi,Nivel,NroCta,NomCta,Tipo,Concepto
'

SET @SQL_N1_E1=
'
Select Posi,Nivel,NroCta,NomCta,Tipo,Sum(Importe) As Importe,Concepto From (
-------------------------------------------------------------
-- Contrapartidas de la cuenta 10 execto las de destino y las de diferencia de cambio
Select  1 As Posi,1 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,left(v.NroCta,2) As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe,v.Prdo As Concepto 
	From	( Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>=Sum(MtoD'+@Mda+') and Count(NroCta)>1) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
		and ((v.MtoD'+@Mda+'<>0) or (v.NroCta not like ''10%'' and v.MtoD'+@Mda+'>0))
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,left(v.NroCta,2),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
  
UNION ALL

Select  1 As Posi,1 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,left(v.NroCta,2) As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe,v.Prdo As Concepto 
	From	( Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>=Sum(MtoD'+@Mda+') and Count(NroCta)=1) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
		and ((v.MtoD'+@Mda+'<>0) or (v.NroCta not like ''10%'' and v.MtoD'+@Mda+'+v.MtoH'+@Mda+'>0))
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,left(v.NroCta,2),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
'

SET @SQL_N1_E2=
'
UNION ALL

-- Contrapartidas de la diferencias de las cuentas 10 en LD
Select  1 As Posi,1 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,Left(d.DCPer,2) As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe, v.Prdo As Concepto 
	From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')<>0
		) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
	Where  	
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.NroCta like ''10%'' and isnull(v.IB_EsDes,0)=0 and v.MtoD'+@Mda+'<>0
	Group by v.RucE,v.Ejer,left(d.DCPer,2),v.Prdo
	--Having Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') > 0
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta

UNION ALL

-- Contrapartidas de la cuenta 10 solo las de diferencia de cambio en CB
Select  2 As Posi,1 As Nivel,''_ ''+left('''+@DCGan+''',2)+'' y ''+left('''+@DCPer+''',2) As NroCta,''DIFERENCIA DE CAMBIO'' As NomCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe, v.Prdo As Concepto 
From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where  RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')<>0
	) As Res
	Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
	--Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
	and (v.NroCta='''+@DCGan+''' or v.NroCta='''+@DCPer+''')
Group by /*d.DCGan,d.DCPer,*/v.Prdo
--Having Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') > 0
) As RESUL
GROUP BY Posi,Nivel,NroCta,NomCta,Tipo,Concepto
'

PRINT @SQL_N1_IS
PRINT @SQL_N1_I1
PRINT @SQL_N1_I2
PRINT ' UNION ALL '
PRINT @SQL_N1_E1
PRINT @SQL_N1_E2
EXEC ('('+@SQL_N1_IS+
		  @SQL_N1_I1+
		  @SQL_N1_I2+
        ' UNION ALL '+
          @SQL_N1_E1+
          @SQL_N1_E2 +')Order by 5 Desc,1,3,7')

End



If(@N2 = 1)
Begin
SET @SQL_N2_IS=
'
Select  0 As Posi,2 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto
From
(	Select  RucE,Ejer,left(NroCta,4) As NroCta,''S'' As Tipo,Isnull(Sum(MtoD'+@Mda+'-MtoH'+@Mda+'),0.00) As Importe,Prdo As Concepto 
	From    VoucherFC Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo=''00'' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,left(NroCta,4),Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta

UNION ALL
'

SET @SQL_N2_I1=
'
Select Posi,Nivel,NroCta,NomCta,Tipo,Sum(Importe) As Importe,Concepto From (
-------------------------------------------------------------
-- Contrapartidas de la cuenta 10 execto las de destino y las de diferencia de cambio
Select  1 As Posi,2 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,left(v.NroCta,4) As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe,v.Prdo As Concepto 
	From	( Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>=Sum(MtoH'+@Mda+') and Count(NroCta)>1) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
		and ((v.MtoH'+@Mda+'<>0) or (v.NroCta not like ''10%'' and v.MtoH'+@Mda+'>0))
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,v.NroCta,v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
  
UNION ALL

Select  1 As Posi,2 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,left(v.NroCta,4) As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe,v.Prdo As Concepto 
	From	( Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>=Sum(MtoH'+@Mda+') and Count(NroCta)=1) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
		and ((v.MtoH'+@Mda+'<>0) or (v.NroCta not like ''10%'' and v.MtoH'+@Mda+'+v.MtoD'+@Mda+'>0))
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,left(v.NroCta,4),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
'
SET @SQL_N2_I2=
'
UNION ALL

-- Contrapartidas de la diferencias de las cuentas 10 en LD
Select  1 As Posi,2 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,Left(d.DCGan,4) As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe, v.Prdo As Concepto 
	From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')<>0
		) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
	Where  	
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.NroCta like ''10%'' and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@Mda+'<>0
	Group by v.RucE,v.Ejer,left(d.DCGan,4),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta

UNION ALL

-- Contrapartidas de la cuenta 10 solo las de diferencia de cambio en CB
Select  2 As Posi,2 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	
Select  v.RucE,v.Ejer,Left(v.NroCta,4) As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe, v.Prdo As Concepto 
From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where  RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')<>0
	) As Res
	Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
	--Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
	and (v.NroCta='''+@DCGan+''' or v.NroCta='''+@DCPer+''')
Group by v.RucE,v.Ejer,left(v.NroCta,4),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
'

SET @SQL_N2_E1=
'
Select Posi,Nivel,NroCta,NomCta,Tipo,Sum(Importe) As Importe,Concepto From (
-------------------------------------------------------------
-- Contrapartidas de la cuenta 10 execto las de destino y las de diferencia de cambio
Select  1 As Posi,2 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,left(v.NroCta,4) As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe,v.Prdo As Concepto 
	From	( Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>=Sum(MtoD'+@Mda+') and Count(NroCta)>1) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
		and ((v.MtoD'+@Mda+'<>0) or (v.NroCta not like ''10%'' and v.MtoD'+@Mda+'>0))
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,left(v.NroCta,4),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
  
UNION ALL

Select  1 As Posi,2 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,left(v.NroCta,4) As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe,v.Prdo As Concepto 
	From	( Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>=Sum(MtoD'+@Mda+') and Count(NroCta)=1) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
		and ((v.MtoD'+@Mda+'<>0) or (v.NroCta not like ''10%'' and v.MtoD'+@Mda+'+v.MtoH'+@Mda+'>0))
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,left(v.NroCta,4),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
'

SET @SQL_N2_E2=
'
UNION ALL

-- Contrapartidas de la diferencias de las cuentas 10 en LD
Select  1 As Posi,2 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,Left(d.DCPer,4) As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe, v.Prdo As Concepto 
	From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')<>0
		) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
	Where  	
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.NroCta like ''10%'' and isnull(v.IB_EsDes,0)=0 and v.MtoD'+@Mda+'<>0
	Group by v.RucE,v.Ejer,left(d.DCPer,4),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta

UNION ALL

-- Contrapartidas de la cuenta 10 solo las de diferencia de cambio en CB
Select  2 As Posi,2 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	
Select  v.RucE,v.Ejer,Left(v.NroCta,4) As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe, v.Prdo As Concepto 
From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where  RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')<>0
	) As Res
	Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
	--Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
	and (v.NroCta='''+@DCGan+''' or v.NroCta='''+@DCPer+''')
Group by v.RucE,v.Ejer,left(v.NroCta,4),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
'

PRINT @SQL_N2_IS
PRINT @SQL_N2_I1
PRINT @SQL_N2_I2
PRINT ' UNION ALL '
PRINT @SQL_N2_E1
PRINT @SQL_N2_E2
EXEC ('('+@SQL_N2_IS+
		  @SQL_N2_I1+
		  @SQL_N2_I2+
        ' UNION ALL '+
          @SQL_N2_E1+
          @SQL_N2_E2 +')Order by 5 Desc,1,3,7')
End



If(@N3 = 1)
Begin
SET @SQL_N3_IS=
'
Select  0 As Posi,3 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto
From
(	Select  RucE,Ejer,left(NroCta,6) As NroCta,''S'' As Tipo,Isnull(Sum(MtoD'+@Mda+'-MtoH'+@Mda+'),0.00) As Importe,Prdo As Concepto 
	From    VoucherFC Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo=''00'' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,left(NroCta,6),Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta

UNION ALL
'

SET @SQL_N3_I1=
'
Select Posi,Nivel,NroCta,NomCta,Tipo,Sum(Importe) As Importe,Concepto From (
-------------------------------------------------------------
-- Contrapartidas de la cuenta 10 execto las de destino y las de diferencia de cambio
Select  1 As Posi,3 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,left(v.NroCta,6) As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe,v.Prdo As Concepto 
	From	( Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>=Sum(MtoH'+@Mda+') and Count(NroCta)>1) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
		and ((v.MtoH'+@Mda+'<>0) or (v.NroCta not like ''10%'' and v.MtoH'+@Mda+'>0))
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,left(v.NroCta,6),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
  
UNION ALL

Select  1 As Posi,3 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,left(v.NroCta,6) As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe,v.Prdo As Concepto 
	From	( Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>=Sum(MtoH'+@Mda+') and Count(NroCta)=1) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
		and ((v.MtoH'+@Mda+'<>0) or (v.NroCta not like ''10%'' and v.MtoH'+@Mda+'+v.MtoD'+@Mda+'>0))
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,left(v.NroCta,6),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
'

SET @SQL_N3_I2=
'
UNION ALL

-- Contrapartidas de la diferencias de las cuentas 10 en LD
Select  1 As Posi,3 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,Left(d.DCGan,6) As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe, v.Prdo As Concepto 
	From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')<>0
		) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
	Where  	
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.NroCta like ''10%'' and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@Mda+'<>0
	Group by v.RucE,v.Ejer,left(d.DCGan,6),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta

UNION ALL

-- Contrapartidas de la cuenta 10 solo las de diferencia de cambio en CB
Select  2 As Posi,3 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	
Select  v.RucE,v.Ejer,Left(v.NroCta,6) As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe, v.Prdo As Concepto 
From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where  RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')<>0
	) As Res
	Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
	--Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
	and (v.NroCta='''+@DCGan+''' or v.NroCta='''+@DCPer+''')
Group by v.RucE,v.Ejer,left(v.NroCta,6),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
'


-- Contrapartidas de la cuenta 10 execto las de destino y las de diferencia de cambio
SET @SQL_N3_E1=
'
Select Posi,Nivel,NroCta,NomCta,Tipo,Sum(Importe) As Importe,Concepto From (
-------------------------------------------------------------
Select  1 As Posi,3 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,left(v.NroCta,6) As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe,v.Prdo As Concepto 
	From	( Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>=Sum(MtoD'+@Mda+') and Count(NroCta)>1) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
		and ((v.MtoD'+@Mda+'<>0) or (v.NroCta not like ''10%'' and v.MtoD'+@Mda+'>0))
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,left(v.NroCta,6),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
  
UNION ALL

Select  1 As Posi,3 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,left(v.NroCta,6) As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe,v.Prdo As Concepto 
	From	( Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>=Sum(MtoD'+@Mda+') and Count(NroCta)=1) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
		and ((v.MtoD'+@Mda+'<>0) or (v.NroCta not like ''10%'' and v.MtoD'+@Mda+'+v.MtoH'+@Mda+'>0))
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,left(v.NroCta,6),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
'

SET @SQL_N3_E2=
'
UNION ALL

-- Contrapartidas de la diferencias de las cuentas 10 en LD
Select  1 As Posi,3 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,Left(d.DCPer,6) As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe, v.Prdo As Concepto 
	From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')<>0
		) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
	Where  	
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.NroCta like ''10%'' and isnull(v.IB_EsDes,0)=0 and v.MtoD'+@Mda+'<>0
	Group by v.RucE,v.Ejer,left(d.DCPer,6),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta

UNION ALL

-- Contrapartidas de la cuenta 10 solo las de diferencia de cambio en CB
Select  2 As Posi,3 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	
Select  v.RucE,v.Ejer,Left(v.NroCta,6) As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe, v.Prdo As Concepto 
From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where  RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')<>0
	) As Res
	Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
	--Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
	and (v.NroCta='''+@DCGan+''' or v.NroCta='''+@DCPer+''')
Group by v.RucE,v.Ejer,left(v.NroCta,6),v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
'

PRINT @SQL_N3_IS
PRINT @SQL_N3_I1
PRINT @SQL_N3_I2
PRINT ' UNION ALL '
PRINT @SQL_N3_E1
PRINT @SQL_N3_E2
EXEC ('('+@SQL_N3_IS+
		  @SQL_N3_I1+
		  @SQL_N3_I2+
        ' UNION ALL '+
          @SQL_N3_E1+
          @SQL_N3_E2 +')Order by 5 Desc,1,3,7')
End



If(@N4 = 1)
Begin
SET @SQL_N4_IS=
'
Select  0 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto
From
(	Select  RucE,Ejer,NroCta As NroCta,''S'' As Tipo,Isnull(Sum(MtoD'+@Mda+'-MtoH'+@Mda+'),0.00) As Importe,Prdo As Concepto 
	From    VoucherFC Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo=''00'' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,NroCta,Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta

UNION ALL
'

SET @SQL_N4_I1=
'
Select Posi,Nivel,NroCta,NomCta,Tipo,Sum(Importe) As Importe,Concepto From (
-------------------------------------------------------------
Select  1 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,v.NroCta As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe,v.Prdo As Concepto 
	From	( Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>=Sum(MtoH'+@Mda+') and Count(NroCta)>1) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
		and ((v.MtoH'+@Mda+'<>0) or (v.NroCta not like ''10%'' and v.MtoH'+@Mda+'>0))
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,v.NroCta,v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
  
UNION ALL

Select  1 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,v.NroCta As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe,v.Prdo As Concepto 
	From	( Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')>=Sum(MtoH'+@Mda+') and Count(NroCta)=1) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
		and ((v.MtoH'+@Mda+'<>0) or (v.NroCta not like ''10%'' and v.MtoH'+@Mda+'+v.MtoD'+@Mda+'>0))
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,v.NroCta,v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
'

SET @SQL_N4_I2=
'
UNION ALL

-- Contrapartidas de la diferencias de las cuentas 10 en LD
Select  1 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,d.DCGan As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe, v.Prdo As Concepto 
	From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')<>0
		) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
	Where  	
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.NroCta like ''10%'' and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@Mda+'<>0
	Group by v.RucE,v.Ejer,d.DCGan,v.Prdo
	--Having Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') > 0
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta

UNION ALL

-- Contrapartidas de la cuenta 10 solo las de diferencia de cambio en CB
Select  2 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	
Select  v.RucE,v.Ejer,v.NroCta As NroCta,''I'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe, v.Prdo As Concepto 
From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where  RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')<>0
	) As Res
	Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
	--Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
	and (v.NroCta='''+@DCGan+''' or v.NroCta='''+@DCPer+''')
Group by v.RucE,v.Ejer,v.NroCta,v.Prdo
--Having Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') > 0
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
'

SET @SQL_N4_IA=
'-- (CUENTA 10)Contrapartidas de la cuenta 10 execto las de destino y las de diferencia de cambio
Select  5 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,v.NroCta As NroCta,''I'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe, v.Prdo As Concepto 
	From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')<>0
		) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 and v.NroCta like ''10%'' and v.MtoH'+@Mda+'=0
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,v.NroCta,v.Prdo
	--Having Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') > 0
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta

UNION ALL

-- (CUENTA 10)Contrapartidas de la diferencias de las cuentas 10 en LD
Select  5 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,v.NroCta As NroCta,''I'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe, v.Prdo As Concepto 
	From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoD'+@Mda+')<>0
		) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
	Where  	
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.NroCta like ''10%'' and isnull(v.IB_EsDes,0)=0 and v.MtoD'+@Mda+'<>0
	Group by v.RucE,v.Ejer,v.NroCta,v.Prdo
	--Having Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') > 0
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
-------------------------------------------------------------
) As RESUL
GROUP BY Posi,Nivel,NroCta,NomCta,Tipo,Concepto
'

SET @SQL_N4_E1=
'
Select Posi,Nivel,NroCta,NomCta,Tipo,Sum(Importe) As Importe,Concepto From (
-------------------------------------------------------------
Select  1 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,v.NroCta As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe,v.Prdo As Concepto 
	From	( Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>=Sum(MtoD'+@Mda+') and Count(NroCta)>1) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
		and ((v.MtoD'+@Mda+'<>0) or (v.NroCta not like ''10%'' and v.MtoD'+@Mda+'>0))
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,v.NroCta,v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
  
UNION ALL

Select  1 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,v.NroCta As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe,v.Prdo As Concepto 
	From	( Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')>=Sum(MtoD'+@Mda+') and Count(NroCta)=1) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 
		and ((v.MtoD'+@Mda+'<>0) or (v.NroCta not like ''10%'' and v.MtoD'+@Mda+'+v.MtoH'+@Mda+'>0))
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,v.NroCta,v.Prdo
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
'

SET @SQL_N4_E2=
'
UNION ALL

-- Contrapartidas de la diferencias de las cuentas 10 en LD
Select  1 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,d.DCPer As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe, v.Prdo As Concepto 
	From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')<>0
		) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
	Where  	
		v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.NroCta like ''10%'' and isnull(v.IB_EsDes,0)=0 and v.MtoD'+@Mda+'<>0
	Group by v.RucE,v.Ejer,d.DCPer,v.Prdo
	--Having Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') > 0
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta

UNION ALL

-- Contrapartidas de la cuenta 10 solo las de diferencia de cambio en CB
Select  2 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	
Select  v.RucE,v.Ejer,v.NroCta As NroCta,''E'' As Tipo,Sum(v.MtoD'+@Mda+'-v.MtoH'+@Mda+') As Importe, v.Prdo As Concepto 
From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where  RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')<>0
	) As Res
	Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
	--Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0
	and (v.NroCta='''+@DCGan+''' or v.NroCta='''+@DCPer+''')
Group by v.RucE,v.Ejer,v.NroCta,v.Prdo
--Having Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') > 0
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
'

SET @SQL_N4_EA=
'-- (CUENTA 10)Contrapartidas de la cuenta 10 execto las de destino y las de diferencia de cambio
Select  5 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,v.NroCta As NroCta,''E'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe, v.Prdo As Concepto 
	From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''CB'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')<>0
		) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer -- AGREGADO POR PEDIDOS DE GUILLE
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and isnull(v.IB_EsDes,0)=0 and v.NroCta like ''10%'' and v.MtoD'+@Mda+'=0
		and v.NroCta<>d.DCGan and v.NroCta<>d.DCPer -- AGREGADO POR PEDIDOS DE GUILLE
	Group by v.RucE,v.Ejer,v.NroCta,v.Prdo
	--Having Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') > 0
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta

UNION ALL

-- (CUENTA 10)Contrapartidas de la diferencias de las cuentas 10 en LD
Select  5 As Posi,4 As Nivel,Tab.NroCta,p.NomCta,Tab.Tipo,Tab.Importe,Tab.Concepto 
From
(	Select  v.RucE,v.Ejer,v.NroCta As NroCta,''E'' As Tipo,Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') As Importe, v.Prdo As Concepto 
	From	(	Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and Cd_Fte=''LD'' and NroCta like ''10%'' Group by RucE,Ejer,Prdo,RegCtb Having Sum(MtoH'+@Mda+')<>0
		) As Res
		Inner Join VoucherFC v On v.RucE=Res.RucE and v.Ejer=Res.Ejer and v.Prdo=Res.Prdo and v.RegCtb=Res.RegCtb
		Left Join PlanCtasDef d On d.RucE=v.RucE and d.Ejer=v.Ejer
	Where  	v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo between '''+@PrdoD+''' and '''+@PrdoH+''' and v.NroCta like ''10%'' and isnull(v.IB_EsDes,0)=0 and v.MtoH'+@Mda+'<>0
	Group by v.RucE,v.Ejer,v.NroCta,v.Prdo
	--Having Sum(v.MtoH'+@Mda+'-v.MtoD'+@Mda+') > 0
) As Tab
  Left Join PlanCtas p On p.RucE=Tab.RucE and p.Ejer=Tab.Ejer and p.NroCta=Tab.NroCta
-------------------------------------------------------------
) As RESUL
GROUP BY Posi,Nivel,NroCta,NomCta,Tipo,Concepto
'

PRINT @SQL_N4_IS
PRINT @SQL_N4_I1
PRINT @SQL_N4_I2
PRINT ' UNION ALL '
PRINT @SQL_N4_IA
PRINT ' UNION ALL '
PRINT @SQL_N4_E1
PRINT @SQL_N4_E2
PRINT ' UNION ALL '
PRINT @SQL_N4_EA


EXEC ('('+@SQL_N4_IS+
		@SQL_N4_I1+
		@SQL_N4_I2+
	' UNION ALL '+
	  @SQL_N4_IA+
        ' UNION ALL '+
          @SQL_N4_E1 +
          @SQL_N4_E2 +
        ' UNION ALL '+
	  @SQL_N4_EA+')Order by 5 Desc,1,3,7')
End

-- Leyenda --
-- Di : 25/03/2011 <Creacion del procedimiento almacenado>
GO

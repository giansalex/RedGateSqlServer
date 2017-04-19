SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Tsr_MovimientosConsFC]

@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@NroCta nvarchar(10),
@Tipo nvarchar(2),

@msj varchar(100) output

AS
/*
Declare @RucE nvarchar(11)
Declare @Ejer nvarchar(4)
Declare @PrdoIni nvarchar(2)
Declare @PrdoFin nvarchar(2)
Declare @NroCta nvarchar(10)
Declare @Tipo nvarchar(2)

Set @RucE = '11111111111'
Set @Ejer = '2010'
Set @PrdoIni = '00'
Set @PrdoFin = '02'
Set @NroCta = '42'
Set @Tipo = 'IN'
*/

Declare @MtoT1 nvarchar(1),@MtoT2 nvarchar(1)
Set @MtoT1 = ''
If (@Tipo = 'I')Begin Set @MtoT1='D' Set @MtoT2='H' End --INGRESO
If (@Tipo = 'E')Begin Set @MtoT1='H' Set @MtoT2='D' End --EGRESO
If (@Tipo = 'IN')Begin Set @MtoT1='D' Set @MtoT2='D' End --INGRESO NEGATIVO
If (@Tipo = 'EN')Begin Set @MtoT1='H' Set @MtoT2='H' End --EGRESO NEGATIVO

Declare @Condicion nvarchar(1000) Set @Condicion = ''
If(len(@NroCta) = 2) Set @Condicion = ' and left(v.NroCta,2)='''+@NroCta+''''
Else If(len(@NroCta) = 4) Set @Condicion = ' and left(v.NroCta,4)='''+@NroCta+''''
Else If(len(@NroCta) = 6) Set @Condicion = ' and left(v.NroCta,6)='''+@NroCta+''''
Else If(len(@NroCta) > 6) Set @Condicion = ' and v.NroCta='''+@NroCta+''''


Declare @SQL_P1_1 varchar(8000), @SQL_P1_2 varchar(8000)
Declare @SQL_P2_1 varchar(8000), @SQL_P2_2 varchar(8000)
Declare @SQL_P3_1 varchar(8000), @SQL_P3_2 varchar(8000)
Declare @SQL_INI varchar(8000)
Declare @SQL_INIT varchar(8000)
Set @SQL_P1_1 = '' Set @SQL_P1_2 = ''
Set @SQL_P2_1 = '' Set @SQL_P1_2 = ''
Set @SQL_P3_1 = '' Set @SQL_P1_2 = ''
Set @SQL_INI = ''
Set @SQL_INIT = ''

If(@PrdoIni = '00') -- SI CONSULTA SALDOS
Begin
	
	Set @SQL_INI =
		'
		Select  v.Cd_Fte,v.RegCtb,v.Prdo,Convert(nvarchar,v.FecMov,103) as FecMov,
			v.NroCta As NroCta, 
			c.NomCta As NomCta,
			v.Glosa,
			Case When isnull(v.Cd_Clt,'''')<>'''' Then a1.NDoc Else a2.NDoc End As RucAux,
			Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(a1.RSocial,isnull(a1.ApPat,'''')+'' ''+isnull(a1.ApMat,'''')+'' ''+isnull(a1.Nom,'''')) Else isnull(a2.RSocial,isnull(a2.ApPat,'''')+'' ''+isnull(a2.ApMat,'''')+'' ''+isnull(a2.Nom,'''')) End As NomAux,
			t.NCorto As TipDoc,
			v.NroSre As Serie,v.NroDoc As Numero,
			v.MtoD as [Debe S/.],v.MtoH as [Haber S/.],
			v.MtoD_ME as [Debe US$.],v.MtoH_ME as [Haber US$.]			
		From 
			VoucherFC v 
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta
			Left Join Cliente2 a1 On a1.RucE=v.RucE and a1.Cd_Clt=v.Cd_Clt
			Left Join Proveedor2 a2 On a2.RucE=v.RucE and a2.Cd_Prv=v.Cd_Prv
			Left Join TipDoc t On t.Cd_TD=v.Cd_TD
		Where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo<='''+@PrdoFin+''''+@Condicion
	Set @SQL_INIT =
		'
		Select  ''--'' as Cd_Fte,
			''--------------'' as RegCtb,''--'' as Prdo,
			''----------'' as FecMov,
			''---------'' as NroCta,
			''R. Sumas ='' as NomCta,
			''----------'' as Glosa,
			''--------'' As RucAux,
			''--------'' As NomAux,
			''---'' As TipDoc,
			''---''  As Serie,
			''-------'' As Numero,
			Sum(v.MtoD) as [Debe S/.],Sum(v.MtoH) as [Haber S/.],
			Sum(v.MtoD_ME) as [Debe US$.],Sum(v.MtoH_ME) as [Haber US$.]
		From 
			VoucherFC v 
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta	
		Where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo<='''+@PrdoFin+''''+@Condicion
	
	If(@PrdoFin<>'00')
	Begin
	Set @PrdoIni='01'
	Set @SQL_P1_1 = 
		'
		UNION ALL
		Select  
			v.Cd_Fte,v.RegCtb,v.Prdo,Convert(nvarchar,v.FecMov,103) as FecMov,
			v.NroCta As NroCta,c.NomCta As NomCta,
			v.Glosa,
			Case When isnull(v.Cd_Clt,'''')<>'''' Then a1.NDoc Else a2.NDoc End As RucAux,
			Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(a1.RSocial,isnull(a1.ApPat,'''')+'' ''+isnull(a1.ApMat,'''')+'' ''+isnull(a1.Nom,'''')) Else isnull(a2.RSocial,isnull(a2.ApPat,'''')+'' ''+isnull(a2.ApMat,'''')+'' ''+isnull(a2.Nom,'''')) End As NomAux,
			t.NCorto As TipDoc,
			v.NroSre As Serie,v.NroDoc As Numero,
			v.MtoD as [Debe S/.],v.MtoH as [Haber S/.],
			v.MtoD_ME as [Debe US$.],v.MtoH_ME as [Haber US$.]
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(Mto'+@MtoT1+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta		
			Left Join Cliente2 a1 On a1.RucE=v.RucE and a1.Cd_Clt=v.Cd_Clt
			Left Join Proveedor2 a2 On a2.RucE=v.RucE and a2.Cd_Prv=v.Cd_Prv
			Left Join TipDoc t On t.Cd_TD=v.Cd_TD
		Where	
			v.RucE='''+@RucE+'''
			and v.Ejer='''+@Ejer+'''
			and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(v.IB_EsDes,0)=0 
			and v.Mto'+@MtoT2+'<>0
		'
	Set @SQL_P1_2 = 
		'
		UNION ALL
		Select  
			v.Cd_Fte,v.RegCtb,v.Prdo,Convert(nvarchar,v.FecMov,103) as FecMov,
			v.NroCta As NroCta,c.NomCta As NomCta,
			v.Glosa,
			Case When isnull(v.Cd_Clt,'''')<>'''' Then a1.NDoc Else a2.NDoc End As RucAux,
			Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(a1.RSocial,isnull(a1.ApPat,'''')+'' ''+isnull(a1.ApMat,'''')+'' ''+isnull(a1.Nom,'''')) Else isnull(a2.RSocial,isnull(a2.ApPat,'''')+'' ''+isnull(a2.ApMat,'''')+'' ''+isnull(a2.Nom,'''')) End As NomAux,
			t.NCorto As TipDoc,
			v.NroSre As Serie,v.NroDoc As Numero,
			v.MtoD as [Debe S/.],v.MtoH as [Haber S/.],
			v.MtoD_ME as [Debe US$.],v.MtoH_ME as [Haber US$.]
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(Mto'+@MtoT1+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta		
			Left Join Cliente2 a1 On a1.RucE=v.RucE and a1.Cd_Clt=v.Cd_Clt
			Left Join Proveedor2 a2 On a2.RucE=v.RucE and a2.Cd_Prv=v.Cd_Prv
			Left Join TipDoc t On t.Cd_TD=v.Cd_TD
		Where	
			v.RucE='''+@RucE+'''
			and v.Ejer='''+@Ejer+'''
			and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(v.IB_EsDes,0)=0 
			and v.Mto'+@MtoT2+'<>0	
		'
	Set @SQL_P2_1 = 
		'
		UNION ALL
		Select  
			''--'' as Cd_Fte,''--------------'' as RegCtb,''--'' as Prdo,''----------'' as FecMov,''---------'' as NroCta,
			''R. Sumas ='' as NomCta,
			''----------'' as Glosa,
			''--------'' As RucAux,
			''--------'' As NomAux,
			''---'' As TipDoc,
			''---''  As Serie,
			''-------'' As Numero,
			Sum(v.MtoD) as [Debe S/.],Sum(v.MtoH) as [Haber S/.],Sum(v.MtoD_ME) as [Debe US$.],Sum(v.MtoH_ME) as [Haber US$.]
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(Mto'+@MtoT1+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta		
		Where	
			v.RucE='''+@RucE+'''
			and v.Ejer='''+@Ejer+'''
			and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(v.IB_EsDes,0)=0 
			and v.Mto'+@MtoT2+'<>0	
		'
	Set @SQL_P2_2 = 
		'
		UNION ALL
		Select  
			''--'' as Cd_Fte,''--------------'' as RegCtb,''--'' as Prdo,''----------'' as FecMov,''---------'' as NroCta,
			''R. Sumas ='' as NomCta,
			''----------'' as Glosa,
			''--------'' As RucAux,
			''--------'' As NomAux,
			''---'' As TipDoc,
			''---''  As Serie,
			''-------'' As Numero,
			Sum(v.MtoD) as [Debe S/.],Sum(v.MtoH) as [Haber S/.],Sum(v.MtoD_ME) as [Debe US$.],Sum(v.MtoH_ME) as [Haber US$.]
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(Mto'+@MtoT1+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta		
		Where	
			v.RucE='''+@RucE+'''
			and v.Ejer='''+@Ejer+'''
			and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(v.IB_EsDes,0)=0 
			and v.Mto'+@MtoT2+'<>0	
		'
	End
	Set @SQL_P3_1 = 
		'
		UNION ALL
		select 
			'''' as Cd_Fte,'''' as RegCtb,'''' as Prdo,'''' as FecMov,'''' as NroCta,''Saldo ='' as NomCta,
			'''' as Glosa,
			''--------'' As RucAux,
			''--------'' As NomAux,
			''---'' As TipDoc,
			''---''  As Serie,
			''-------'' As Numero,
			0.00 as [Debe S/.],0.00 as [Haber S/.],
			0.00 as [Debe US$.],0.00 as [Haber US$.]
		UNION ALL
		select 
			''--'' as Cd_Fte,''--------------'' as RegCtb,''--'' as Prdo,''----------'' as FecMov,''---------'' as NroCta,''S. Total ='' as NomCta,
			''----------'' as Glosa,
			''--------'' As RucAux,
			''--------'' As NomAux,
			''---'' As TipDoc,
			''---''  As Serie,
			''-------'' As Numero,
			0.00 as [Debe S/.],0.00 as [Haber S/.],
			0.00 as [Debe US$.],0.00 as [Haber US$.]
		'
	Print @SQL_INI
	Print @SQL_P1_1
	Print @SQL_P1_2

	Print 'Select Cd_Fte,RegCtb,Prdo,FecMov,NroCta,NomCta,Glosa,RucAux,NomAux,TipDoc,Serie,Numero,Sum([Debe S/.]) as [Debe S/.],Sum([Haber S/.]) as [Haber S/.],Sum([Debe US$.]) as [Debe US$.],Sum([Haber US$.]) as [Haber US$.] From ('
	Print @SQL_INIT
	Print @SQL_P2_1
	Print @SQL_P2_2
	Print ') As RESUL Group by Cd_Fte,RegCtb,Prdo,FecMov,Glosa,NroCta,NomCta,RucAux,NomAux,TipDoc,Serie,Numero'
	Print @SQL_P3_1
	Print @SQL_P3_2
	
	Exec (@SQL_INI+@SQL_P1_1+@SQL_P1_2+
	      'Select  Cd_Fte,RegCtb,Prdo,FecMov,NroCta,NomCta,Glosa,RucAux,NomAux,TipDoc,Serie,Numero,
			Sum([Debe S/.]) as [Debe S/.],Sum([Haber S/.]) as [Haber S/.],
			Sum([Debe US$.]) as [Debe US$.],Sum([Haber US$.]) as [Haber US$.]
	      From ('+@SQL_INIT+@SQL_P2_1+@SQL_P2_2+') As RESUL Group by Cd_Fte,RegCtb,Prdo,FecMov,Glosa,NroCta,NomCta,RucAux,NomAux,TipDoc,Serie,Numero '+@SQL_P3_1+@SQL_P3_2)
End
Else
Begin
	Set @SQL_P1_1 = 
		'
		Select  
			v.Cd_Fte,v.RegCtb,v.Prdo,Convert(nvarchar,v.FecMov,103) as FecMov,
			v.NroCta As NroCta, 
			c.NomCta As NomCta,
			v.Glosa,
			Case When isnull(v.Cd_Clt,'''')<>'''' Then a1.NDoc Else a2.NDoc End As RucAux,
			Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(a1.RSocial,isnull(a1.ApPat,'''')+'' ''+isnull(a1.ApMat,'''')+'' ''+isnull(a1.Nom,'''')) Else isnull(a2.RSocial,isnull(a2.ApPat,'''')+'' ''+isnull(a2.ApMat,'''')+'' ''+isnull(a2.Nom,'''')) End As NomAux,
			t.NCorto As TipDoc,
			v.NroSre As Serie,v.NroDoc As Numero,
			v.MtoD as [Debe S/.],v.MtoH as [Haber S/.],
			v.MtoD_ME as [Debe US$.],v.MtoH_ME as [Haber US$.]
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(Mto'+@MtoT1+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta		
			Left Join Cliente2 a1 On a1.RucE=v.RucE and a1.Cd_Clt=v.Cd_Clt
			Left Join Proveedor2 a2 On a2.RucE=v.RucE and a2.Cd_Prv=v.Cd_Prv
			Left Join TipDoc t On t.Cd_TD=v.Cd_TD
		Where	
			v.RucE='''+@RucE+'''
			and v.Ejer='''+@Ejer+'''
			and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(v.IB_EsDes,0)=0 
			--and v.Mto'+@MtoT2+'<>0	
			'+@Condicion+'
		'
	
	Set @SQL_P2_1 = 
		'
		Select  
			''--'' as Cd_Fte,
			''--------------'' as RegCtb,''--'' as Prdo,
			''----------'' as FecMov,
			''---------'' as NroCta,
			''R. Sumas ='' as NomCta,
			''----------'' as Glosa,
			''--------'' As RucAux,
			''--------'' As NomAux,
			''---'' As TipDoc,
			''---''  As Serie,
			''-------'' As Numero,
			Sum(v.MtoD) as [Debe S/.],Sum(v.MtoH) as [Haber S/.],
			Sum(v.MtoD_ME) as [Debe US$.],Sum(v.MtoH_ME) as [Haber US$.]
		From 
			(
			Select RucE,Ejer,Prdo,RegCtb from VoucherFC_RegCtb
			Where RucE='''+@RucE+''' and Ejer='''+@Ejer+''' and Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''' and Cd_Fte=''CB'' and NroCta like ''10%'' 
			Group by RucE,Ejer,Prdo,RegCtb Having Sum(Mto'+@MtoT1+')<>0
			) As RCTB
		
			Inner Join VoucherFC v On v.RucE=RCTB.RucE and v.Ejer=RCTB.Ejer and v.Prdo=RCTB.Prdo and v.RegCtb=RCTB.RegCtb
			Left Join PlanCtas c On c.RucE=v.RucE and c.Ejer=v.Ejer and c.NroCta=v.NroCta		
		Where	
			v.RucE='''+@RucE+'''
			and v.Ejer='''+@Ejer+'''
			and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
			and isnull(v.IB_EsDes,0)=0 
			--and v.Mto'+@MtoT2+'<>0	
			'+@Condicion+'
		'
	Set @SQL_P3_1 = 
		'
		UNION ALL
		select 
			'''' as Cd_Fte,'''' as RegCtb,'''' as Prdo,'''' as FecMov,'''' as NroCta,''Saldo ='' as NomCta,
			'''' as Glosa,
			''--------'' As RucAux,
			''--------'' As NomAux,
			''---'' As TipDoc,
			''---''  As Serie,
			''-------'' As Numero,
			0.00 as [Debe S/.],0.00 as [Haber S/.],
			0.00 as [Debe US$.],0.00 as [Haber US$.]
		UNION ALL
		select 
			''--'' as Cd_Fte,''--------------'' as RegCtb,''--'' as Prdo,''----------'' as FecMov,''---------'' as NroCta,''S. Total ='' as NomCta,
			''----------'' as Glosa,
			''--------'' As RucAux,
			''--------'' As NomAux,
			''---'' As TipDoc,
			''---''  As Serie,
			''-------'' As Numero,
			0.00 as [Debe S/.],0.00 as [Haber S/.],
			0.00 as [Debe US$.],0.00 as [Haber US$.]
		'
	
	Print @SQL_P1_1
	Print @SQL_P1_2
	Print @SQL_P2_1
	Print @SQL_P2_2
	Print @SQL_P3_1
	Print @SQL_P3_2
	
	Exec (@SQL_P1_1+@SQL_P1_2+@SQL_P2_1+@SQL_P2_2+@SQL_P3_1+@SQL_P3_2)

End

-- Leyenda --
-- Di : 04/02/2011 <Creacion del procedimiento almacenado>




GO

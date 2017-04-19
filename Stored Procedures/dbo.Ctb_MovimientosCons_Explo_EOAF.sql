SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_MovimientosCons_Explo_EOAF]

@RucE nvarchar(11),	--Ruc de la empresa
@Ejer nvarchar(4),	--Ejercicio de la empresa
@RPrdo1 nvarchar(2),	--Rango inicial del periodo
@RPrdo2 nvarchar(2),	--Rango final del periodo

@Cd_CC nvarchar(8),
@Cd_SC nvarchar(8),
@Cd_SS nvarchar(8),
@Datos nvarchar(4000),

@NroCta nvarchar(10),	--cuenta inicial de consulta

--Ingresado para consultar por Inventario Balance
--------------------------------------------------
@Most bit,
@Cd_Aux nvarchar(11),
@Cd_TD nvarchar(2),
@NroSre nvarchar(4),
@NroDoc nvarchar(15),
--------------------------------------------------

@RubroRpt nvarchar(50),

@msj nvarchar(100) output

as
/*
Set @RucE = '20512635025'
Set @Ejer = '2009'
Set @RPrdo1 = '05'
Set @RPrdo2 = '05'
Set @NroCta = '10.0.0.01'
Set @Cd_Mda = '01'
*/



Declare @RangoCC nvarchar(4000)
Set @RangoCC = ''

--**************************************************************************************

if(isnull(len(@Cd_CC),'0') <> '0') --CENTRO COSTOS
begin
	Set @RangoCC = ' and v.Cd_CC='''+@Cd_CC+''''
	if(isnull(len(@Cd_SC),'0') <> '0')  --SUB CENTRO COSTOS
	begin
		Set @RangoCC = @RangoCC + ' and v.Cd_SC='''+@Cd_SC+''''
		if(isnull(len(@Cd_SS),'0') <> '0')  --SUB SUB CENTRO COSTOS
		begin
			Set @RangoCC = @RangoCC +' and v.Cd_SS='''+@Cd_SS+''''
		end
		else if(isnull(len(@Datos),'0') <> '0')
			Set @RangoCC = @RangoCC + ' and v.Cd_SS in ('+@Datos+')'
	end
	else if(isnull(len(@Datos),'0') <> '0')
		Set @RangoCC = @RangoCC + ' and v.Cd_SC in ('+@Datos+')'
end
else if(isnull(len(@Datos),'0') <> '0')
	Set @RangoCC = ' and v.Cd_CC in ('+@Datos+')'
else	Set @RangoCC=''

--**************************************************************************************



Declare @CadNroCta nvarchar(200)
Set @CadNroCta = ''

if (len(@NroCta) = 2)
	Set @CadNroCta = ' and left(v.NroCta,2) = '''+@NroCta+''''
else if (len(@NroCta) = 4)
	Set @CadNroCta = ' and left(v.NroCta,4) = '''+@NroCta+''''
else if (len(@NroCta) = 6)
	Set @CadNroCta = ' and left(v.NroCta,6) = '''+@NroCta+''''
else if (len(@NroCta) > 6)
	Set @CadNroCta = ' and v.NroCta = '''+@NroCta+''''

print @CadNroCta


--**************************************************************************************

Declare @CadCom nvarchar(1000)
Declare @TabAux nvarchar(1000)
Set @CadCom = ''
Set @TabAux = ''

if(@Most = 1)
begin
	Set @CadCom = ' and (isnull(a1.Cd_Clt,'''')='''+@Cd_Aux+''' or isnull(a2.Cd_Prv,'''')='''+@Cd_Aux+''') and isnull(v.Cd_TD,'''')='''+@Cd_TD+''' and isnull(v.NroSre,'''')='''+@NroSre+''' and isnull(v.NroDoc,'''')='''+@NroDoc+''' '
	Set @TabAux = ' --left join Auxiliar a On a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux '
end

--**************************************************************************************



Declare @SQL1 nvarchar(4000)
Declare @SQL2 nvarchar(4000)
Set @SQL1 = ''
Set @SQL2 = ''

Set @SQL1 = 
	'
	select 
		v.Cd_Fte,
		v.RegCtb,v.Prdo,
		Convert(nvarchar,v.FecMov,103) as FecMov,
		v.NroCta,
		p.NomCta,
		v.Glosa,
		Case When isnull(v.Cd_Clt,'''')<>'''' Then a1.NDoc Else a2.NDoc End As RucAux,
		Case When isnull(v.Cd_Clt,'''')<>'''' Then isnull(a1.RSocial,isnull(a1.ApPat,'''')+'' ''+isnull(a1.ApMat,'''')+'' ''+isnull(a1.Nom,'''')) Else isnull(a2.RSocial,isnull(a2.ApPat,'''')+'' ''+isnull(a2.ApMat,'''')+'' ''+isnull(a2.Nom,'''')) End As NomAux,
		t.NCorto As TipDoc,
		v.NroSre As Serie,v.NroDoc As Numero,
		v.MtoD as [Debe S/.],v.MtoH as [Haber S/.],
		v.MtoD_ME as [Debe US$.],v.MtoH_ME as [Haber US$.]
	from Voucher v
	Inner join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and v.Ejer=p.Ejer and isnull(p.Cd_Blc,'''') in ('+@RubroRpt+')
	Left Join Cliente2 a1 On a1.RucE=v.RucE and a1.Cd_Clt=v.Cd_Clt
	Left Join Proveedor2 a2 On a2.RucE=v.RucE and a2.Cd_Prv=v.Cd_Prv
	Left Join TipDoc t On t.Cd_TD=v.Cd_TD
	'+@TabAux+'
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.IB_Anulado=0 and v.Prdo between '''+@RPrdo1+''' and '''+@RPrdo2+''''+@RangoCC+@CadNroCta+@CadCom+
	'Order by 2,4'

Set @SQL2 = 
	'
	select 
		''--'' as Cd_Fte,''--------------'' as RegCtb,''--'' as Prdo,''----------'' as FecMov,''---------'' as NroCta,''R. Sumas ='' as NomCta,
		''----------'' as Glosa,
		''-------'' As RucAux,
		''-------'' As NomAux,
		''---'' As TipDoc,
		''---'' As Serie,
		''-------'' As Numero,
		Sum(v.MtoD) as [Debe S/.],Sum(v.MtoH) as [Haber S/.],
		Sum(v.MtoD_ME) as [Debe US$.],Sum(v.MtoH_ME) as [Haber US$.]
	from Voucher v
	Inner join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and v.Ejer=p.Ejer and isnull(p.Cd_Blc,'''') in ('+@RubroRpt+')
	Left Join Cliente2 a1 On a1.RucE=v.RucE and a1.Cd_Clt=v.Cd_Clt
	Left Join Proveedor2 a2 On a2.RucE=v.RucE and a2.Cd_Prv=v.Cd_Prv
	'+@TabAux+'
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.IB_Anulado=0 and v.Prdo between '''+@RPrdo1+''' and '''+@RPrdo2+''''+@RangoCC+@CadNroCta+@CadCom+
	'UNION ALL
	select 
		'''' as Cd_Fte,'''' as RegCtb,'''' as Prdo,'''' as FecMov,'''' as NroCta,''Saldo ='' as NomCta,
		''----------'' as Glosa,
		''-------'' As RucAux,
		''-------'' As NomAux,
		''---'' As TipDoc,
		''---'' As Serie,
		''-------'' As Numero,
		0.00 as [Debe S/.],0.00 as [Haber S/.],
		0.00 as [Debe US$.],0.00 as [Haber US$.]
	UNION ALL
	select 
		''--'' as Cd_Fte,''--------------'' as RegCtb,''--'' as Prdo,''----------'' as FecMov,''---------'' as NroCta,''S. Total ='' as NomCta,
		''----------'' as Glosa,
		''-------'' As RucAux,
		''-------'' As NomAux,
		''---'' As TipDoc,
		''---'' As Serie,
		''-------'' As Numero,
		0.00 as [Debe S/.],0.00 as [Haber S/.],
		0.00 as [Debe US$.],0.00 as [Haber US$.]
	'
	

print @SQL1
print @SQL2

Exec (@SQL1)
Exec (@SQL2)


----------------------PRUEBA------------------------
--exec Ctb_MovimientosCons '11111111111','2009','05','07','10.4','10.4','01','01010101','01010101','01010101','01010101','','','0','0','0','1',null

------CODIGO DE MODIFICACION--------

-- Leyenda --

-- DI->(31/08/2011) : Creacion del procedimiento almacenado

GO

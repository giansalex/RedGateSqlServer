SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_MovimientosCons_Explo3]

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
	Set @CadCom = ' and isnull(a.NDoc,'''')='''+@Cd_Aux+''' and isnull(v.Cd_TD,'''')='''+@Cd_TD+''' and isnull(v.NroSre,'''')='''+@NroSre+''' and isnull(v.NroDoc,'''')='''+@NroDoc+''' '
	Set @TabAux = ' left join Auxiliar a On a.RucE=v.RucE and a.Cd_Aux=v.Cd_Aux '
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
		v.Glosa,
		v.NroCta,
		p.NomCta,
		v.MtoD as [Debe S/.],v.MtoH as [Haber S/.],
		v.MtoD_ME as [Debe US$.],v.MtoH_ME as [Haber US$.]
	from Voucher v
	left join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta and v.Ejer=p.Ejer
	'+@TabAux+'
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.IB_Anulado=0 and v.Prdo between '''+@RPrdo1+''' and '''+@RPrdo2+''''+@RangoCC+@CadNroCta+@CadCom+
	'Order by 2,4'

Set @SQL2 = 
	'
	select 
		''--'' as Cd_Fte,''--------------'' as RegCtb,''--'' as Prdo,''----------'' as FecMov, ''----------'' as Glosa,''---------'' as NroCta,''R. Sumas ='' as NomCta,
		Sum(v.MtoD) as [Debe S/.],Sum(v.MtoH) as [Haber S/.],
		Sum(v.MtoD_ME) as [Debe US$.],Sum(v.MtoH_ME) as [Haber US$.]
	from Voucher v
	'+@TabAux+'
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.IB_Anulado=0 and v.Prdo between '''+@RPrdo1+''' and '''+@RPrdo2+''''+@RangoCC+@CadNroCta+@CadCom+
	'UNION ALL
	select 
		'''' as Cd_Fte,'''' as RegCtb,'''' as Prdo,'''' as FecMov, '''' as Glosa,'''' as NroCta,''Saldo ='' as NomCta,
		0.00 as [Debe S/.],0.00 as [Haber S/.],
		0.00 as [Debe US$.],0.00 as [Haber US$.]
	UNION ALL
	select 
		''--'' as Cd_Fte,''--------------'' as RegCtb,''--'' as Prdo,''----------'' as FecMov, ''----------'' as Glosa,''---------'' as NroCta,''S. Total ='' as NomCta,
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
--CM=RE01

-- Leyenda --

-- DI->(15/10/2009) : Creacion del procedimiento almacenado
-- DI->(25/11/2009) : Copia del procedimiento anterior y Modificacion del CC,SC,SS
-- DI->(03/12/2009) : Copia del procedimiento anterior y Modificacion del los campos Auxiliar,Serie , etc para Inventario Balance
-- FL: 17/09/2010 <se agrego ejercicio en el left join con voucher and v.Ejer=p.Ejer>
GO

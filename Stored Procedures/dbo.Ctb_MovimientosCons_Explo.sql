SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_MovimientosCons_Explo]
--exec Ctb_MovimientosCons_Explo '11111111111','2009','05','05','10.0.0.01','01',null
@RucE nvarchar(11),	--Ruc de la empresa
@Ejer nvarchar(4),	--Ejercicio de la empresa
@RPrdo1 nvarchar(2),	--Rango inicial del periodo
@RPrdo2 nvarchar(2),	--Rango final del periodo
@NroCta nvarchar(10),	--cuenta inicial de consulta
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

Declare @SQL1 nvarchar(4000)
Declare @SQL2 nvarchar(4000)
Set @SQL1 = ''
Set @SQL2 = ''

Set @SQL1 = 
	'
	select 
		v.Cd_Fte,
		v.RegCtb,v.Prdo,
		v.NroCta,
		p.NomCta,
		v.MtoD as [Debe S/.],v.MtoH as [Haber S/.],
		v.MtoD_ME as [Debe US$.],v.MtoH_ME as [Haber US$.]
	from Voucher v
	left join PlanCtas p On p.RucE=v.RucE and p.NroCta=v.NroCta
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.IB_Anulado=0 and v.Prdo between '''+@RPrdo1+''' and '''+@RPrdo2+''''+@CadNroCta+
	'Order by 2,4'

Set @SQL2 = 
	'
	select 
		''--'' as Cd_Fte,''--------------'' as RegCtb,''--'' as Prdo,''---------'' as NroCta,''R. Sumas ='' as NomCta,
		Sum(v.MtoD) as [Debe S/.],Sum(v.MtoH) as [Haber S/.],
		Sum(v.MtoD_ME) as [Debe US$.],Sum(v.MtoH_ME) as [Haber US$.]
	from Voucher v
	where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.IB_Anulado=0 and v.Prdo between '''+@RPrdo1+''' and '''+@RPrdo2+''''+@CadNroCta+
	'UNION ALL
	select 
		'''' as Cd_Fte,'''' as RegCtb,'''' as Prdo,'''' as NroCta,''Saldo ='' as NomCta,
		0.00 as [Debe S/.],0.00 as [Haber S/.],
		0.00 as [Debe US$.],0.00 as [Haber US$.]
	UNION ALL
	select 
		''--'' as Cd_Fte,''--------------'' as RegCtb,''--'' as Prdo,''---------'' as NroCta,''S. Total ='' as NomCta,
		0.00 as [Debe S/.],0.00 as [Haber S/.],
		0.00 as [Debe US$.],0.00 as [Haber US$.]
	'
	

print @SQL1
print @SQL2

Exec (@SQL1)
Exec (@SQL2)

----------------------PRUEBA------------------------
--exec Ctb_MovimientosCons_Explo '11111111111','2009','05','05','10.0.0.01','01',null

------CODIGO DE MODIFICACION--------
--CM=RE01

-- Leyenda --
--FL: 17/09/2010 <se agrego ejercicio>
-- DI->(15/10/2009) : Creacion del procedimiento almacenado
GO

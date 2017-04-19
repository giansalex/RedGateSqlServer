SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Tsr_DisponiBancaria]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@Detalle bit,
@msj varchar(100) Output
as


Declare @ColDet nvarchar(100), @GruDet nvarchar(100)
Declare @ColTem nvarchar(100)
Set @ColDet = '' Set @GruDet = ''
Set @ColTem = ''

if(@Detalle = 1)
Begin
	Set @ColDet = ',v.RegCtb as RegCtb'
	Set @GruDet = ',v.RegCtb'
	
	Set @ColTem = ','''' as RegCtb'
End
	

Declare @SQL1 nvarchar(4000), @SQL2 nvarchar(4000)
Set @SQL1='' Set @SQL2=''

Set @SQL1 =
	'
	select
		b.NroCta,
		p.NomCta,
		Case(b.Cd_Mda) when ''01'' then ''S/.'' else ''US$.'' end Moneda,
		Sum(v.MtoD) as I_MN ,Sum(v.MtoH) as S_MN,
		Sum(v.MtoD-v.MtoH) as Sal_MN,
		Sum(v.MtoD_ME) as I_ME,Sum(v.MtoH_ME) as S_ME,
		Sum(v.MtoD_ME-v.MtoH_ME) as Sal_ME'
		+@ColDet+
		'
	from Banco b
	left join PlanCtas p On p.RucE=b.RucE and p.NroCta=b.NroCta and p.Ejer='''+@Ejer+'''
	left join Voucher v On v.RucE=b.RucE and v.NroCta=b.NroCta
	where b.Ejer='''+@Ejer+''' and b.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and isnull(v.IB_Anulado,0)=0 and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
	Group by b.NroCta,p.NomCta,b.Cd_Mda'+@GruDet+
	' Order by 1'
	
Set @SQL2 = 
	'
	select
		''TOTAL'' as NroCta,
		''>>>>>>>>'' as NomCta,
		''>>>'' as Moneda,
		Sum(v.MtoD) as I_MN ,Sum(v.MtoH) as S_MN,
		Sum(v.MtoD-v.MtoH) as Sal_MN,
		Sum(v.MtoD_ME) as I_ME,Sum(v.MtoH_ME) as S_ME,
		Sum(v.MtoD_ME-v.MtoH_ME) as Sal_ME'
		+@ColTem+
		'
	from Banco b
	left join PlanCtas p On p.RucE=b.RucE and p.NroCta=b.NroCta and p.Ejer='''+@Ejer+'''
	left join Voucher v On v.RucE=b.RucE and v.NroCta=b.NroCta
	where b.Ejer='''+@Ejer+''' and b.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and isnull(v.IB_Anulado,0)=0 and v.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+'''
	'

Print @SQL1
Print @SQL2

Exec (@SQL1)
Exec (@SQL2)

--Leyenda
----------

-- DI : 01/09/2009 Creacion del procedimiento almacenado
-- FL : 28/09/2010 <se reviso lo de ejercicio para plan de cuentas>
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_VoucherCons_CB_Ctzado]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@Moneda nvarchar(2),
@Rango1 nvarchar(10),
@Rango2 nvarchar(10),
@msj varchar(100) output

AS
/*
IF(@RucE in ('20514186031','20516980452','20519425662','20491936291','20519252890'))
	SET @Moneda='02'
ELSE	SET @Moneda='01'
*/
IF(isnull(len(@Rango1),0) = 0 and isnull(len(@Rango2),0) = 0)
BEGIN
	set @Rango1 = '000000000'
	set @Rango2 = '999999999'
END

DECLARE @SQL1 nvarchar(4000)
DECLARE @SQL2 nvarchar(4000)
SET @SQL1 = ''
SET @SQL2 = ''

--***************************************************************************************************************************************
--CABECERA-------------------------------------------------------------------------------------------------------------------------------
--***************************************************************************************************************************************

SET @SQL1 =
	'
	select
		vou.RucE, emp.RSocial,
		case('''+@Moneda+''') when '+'''01'''+' then '+'''En Nuevos Soles'''+' else '+'''En Dólares Americanos'''+' end as TipoMoneda,
		'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
	from Voucher vou
	left join Empresa emp on emp.Ruc=vou.RucE
	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte = ''CB'' and vou.NroCta between '''+@Rango1+''' and '''+@Rango2+''''+' and vou.IB_Anulado<>1
	Group by vou.RucE, emp.RSocial'


--***************************************************************************************************************************************
--DETALLE-------------------------------------------------------------------------------------------------------------------------------
--***************************************************************************************************************************************
SET @SQL2=
	'
	select
		vou.RucE, emp.RSocial,
		''CENT_CB''+vou.Prdo+''-01'' as RegCtb, 
		vou.Prdo,
		'''' as FechaReg,
		vou.NroCta,cta.NomCta,
		'''' as Cd_Aux,
		'''' as NomAux,
		'''' as TD, '''' as DCTO,
		''Centralización del mes '' +vou.Prdo as Glosa,
		----------------------------------------------------------------------
		--CONVERTIR A SOLES o DOLARES
		----------------------------------------------------------------------		
		/*
		Sum(
		Case('''+@Moneda+''') when ''01'' then
			             case(vou.IC_CtrMd) when ''$'' then ''0.00''
							 else vou.MtoD 
				      			 end								      
			   else      case(vou.IC_CtrMd) when ''s'' then ''0.00''
							 else vou.MtoD_ME
							 end
		end) as Debe,
		Sum(
		Case('''+@Moneda+''') when ''01'' then 
			             case(vou.IC_CtrMd) when ''$'' then ''0.00''
							 else vou.MtoH 
				      			 end								      
			   else      case(vou.IC_CtrMd) when ''s'' then ''0.00''
							 else vou.MtoH_ME
							 end
		end) as Haber
		*/

		Sum(
		Case('''+@Moneda+''') when ''01'' then vou.MtoD								      
			   	      		  else vou.MtoD_ME
		end) as Debe,
		Sum(
		Case('''+@Moneda+''') when ''01'' then vou.MtoH 
				 		  else vou.MtoH_ME
		end) as Haber
	
	------------------------------------------------------------------------
	from Voucher vou
	left join Empresa emp on emp.Ruc=vou.RucE
	left join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux
	left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte = ''CB'' and vou.NroCta between  '''+@Rango1+''' and '''+@Rango2+''' and vou.IB_Anulado<>1
	Group by vou.RucE, emp.RSocial,vou.NroCta,cta.NomCta,	vou.Prdo
	'	

PRINT @SQL1
PRINT @SQL2


EXEC sp_executesql @SQL1
EXEC sp_executesql @SQL2
------CODIGO DE MODIFICACION--------
--CM=MG01
GO

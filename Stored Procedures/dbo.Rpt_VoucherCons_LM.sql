SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_VoucherCons_LM]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@Moneda nvarchar(2),
@Tipos nvarchar(100),
@Rango1 nvarchar(10),
@Rango2 nvarchar(10),
@msj varchar(100) output

AS
IF(isnull(len(@Rango1),0) = 0 and isnull(len(@Rango2),0) = 0)
BEGIN
	set @Rango1 = '00000'
	set @Rango2 = '99999'
END

DECLARE @SQL1 nvarchar(4000)
DECLARE @SQL2 nvarchar(4000)
DECLARE @SQL3 nvarchar(4000)

--***************************************************************************************************************************************
--CABECERA-------------------------------------------------------------------------------------------------------------------------------
--***************************************************************************************************************************************
SET @SQL1 = '
	select
		vou.RucE, emp.RSocial,
		case('''+@Moneda+''') when '+'''01'''+' then '+'''En Nuevos Soles'''+' else '+'''En Dólares Americanos'''+' end as TipoMoneda,
		'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
	from Voucher vou
	left join Empresa emp on emp.Ruc=vou.RucE
	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in ('+@Tipos+')'+' and vou.NroCta >= '''+@Rango1+''' and vou.NroCta <= '''+@Rango2+''''+' and vou.IB_Anulado<>1 


	Group by vou.RucE, emp.RSocial'

--	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in ('+@Tipos+')'+' and vou.NroCta between '''+@Rango1+''' and '''+@Rango2+''''+'

PRINT @SQL1
EXEC sp_executesql @SQL1

--***************************************************************************************************************************************
--DETALLE-------------------------------------------------------------------------------------------------------------------------------
--***************************************************************************************************************************************
SET @SQL2= '
	select
		vou.RucE, emp.RSocial,
		vou.NroCta,cta.NomCta,
		vou.Prdo,
		Convert(varchar,vou.FecMov,103) as FechaReg,
		vou.RegCtb,
		vou.Cd_Aux,aux.NDoc as NomAux,
		vou.Cd_TD as TD, isnull(vou.NroSre+''-'','''')+isnull(vou.NroDoc,'''') as DCTO,
		vou.Glosa,
		----------------------------------------------------------------------
		--CONVERTIR A SOLES o DOLARES
		----------------------------------------------------------------------		
		/*
		Case('''+@Moneda+''') when ''01'' then
			             case(vou.IC_CtrMd) when ''$'' then ''0.00''
							 else vou.MtoD 
				      			 end								      
			   else      case(vou.IC_CtrMd) when ''s'' then ''0.00''
							 else vou.MtoD_ME
							 end
		end as Debe,

		Case('''+@Moneda+''') when ''01'' then 
			             case(vou.IC_CtrMd) when ''$'' then ''0.00''
							 else vou.MtoH 
				      			 end								      
			   else      case(vou.IC_CtrMd) when ''s'' then ''0.00''
							 else vou.MtoH_ME
							 end
		end as Haber,
		''0.00'' as Saldo,
		case('''+@Moneda+''') when '+'''01'''+' then '+'''0.000'''+' else vou.CamMda end as TipCamb
		*/

		Case('''+@Moneda+''') when ''01'' then vou.MtoD								      
			   	      		  else vou.MtoD_ME
		end as Debe,

		Case('''+@Moneda+''') when ''01'' then vou.MtoH 
				 		  else vou.MtoH_ME
		end as Haber
	
	------------------------------------------------------------------------
	from Voucher vou
	left join Empresa emp on emp.Ruc=vou.RucE
	left join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux
	left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in ('+@Tipos+')'+' and vou.NroCta >= '''+@Rango1+''' and vou.NroCta <= '''+@Rango2+'''  and vou.IB_Anulado<>1 ORDER BY vou.NroCta,vou.Prdo'	

--	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in ('+@Tipos+')'+' and vou.NroCta between '''+@Rango1+''' and '''+@Rango2+''' ORDER BY vou.NroCta,vou.Prdo'	
	
PRINT @SQL2
EXEC sp_executesql @SQL2

--***************************************************************************************************************************************
--SALDO ANTERIORES-------------------------------------------------------------------------------------------------------------------------------
--***************************************************************************************************************************************

SET @SQL3 = '
	  select 
		vou.RucE,vou.NroCta,
		sum(Case('''+@Moneda+''') when ''01'' then vou.MtoD else vou.MtoD_ME end) as MtoD, sum(Case('''+@Moneda+''') when ''01'' then vou.MtoH else vou.MtoH_ME end) as MtoH,Sum(Case('''+@Moneda+''') when ''01'' then vou.MtoD-vou.MtoH else vou.MtoD_ME-vou.MtoH_ME end) SaldoAnt 
	  from voucher vou
	  where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo < '''+@PrdoIni+''' and vou.Cd_Fte in ('+@Tipos+')'+' and vou.NroCta >= '''+@Rango1+''' and vou.NroCta <= '''+@Rango2+''' and vou.IB_Anulado<>1  Group by RucE,NroCta
	  UNION ALL
	  Select 
		v.RucE,v.NroCta,
		0.00 as MtoD, 0.00 as MtoH, 0.00 as SaldoAnt 
	  from Voucher v	  
	  where v.RucE='''+@RucE+''' and v.Ejer='''+@Ejer+''' and v.Prdo >= '''+@PrdoIni+''' and v.Cd_Fte in ('+@Tipos+')'+' and v.NroCta >= '''+@Rango1+''' and v.NroCta <= '''+@Rango2+''' and 
		v.NroCta not in (	select vou.NroCta 
				   	from Voucher vou
				   	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo < '''+@PrdoIni+''' and vou.Cd_Fte in ('+@Tipos+')'+' and vou.NroCta >= '''+@Rango1+''' and vou.NroCta <= '''+@Rango2+''' Group by vou.NroCta
			 	  ) 
		and v.IB_Anulado<>1 
	  Group by v.RucE,v.NroCta 
	  Order by NroCta'

PRINT @SQL3
EXEC sp_executesql @SQL3
------CODIGO DE MODIFICACION--------
--CM=MG01
GO

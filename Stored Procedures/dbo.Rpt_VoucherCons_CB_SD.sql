SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_VoucherCons_CB_SD]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@Moneda nvarchar(2),
@Ctzado bit,
@Rango1 nvarchar(5),
@Rango2 nvarchar(5),
@msj varchar(100) output

AS

IF(isnull(len(@Rango1),0) = 0 and isnull(len(@Rango2),0) = 0)
BEGIN
	set @Rango1 = '00000'
	set @Rango2 = '99999'
END

DECLARE @SQL1 nvarchar(4000)
DECLARE @SQL2 nvarchar(4000)
SET @SQL1 = ''
SET @SQL2 = ''

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
	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte = ''CB'' and right(vou.RegCtb,5) between '''+@Rango1+''' and '''+@Rango2+''''+' and vou.IB_Anulado<>1
	Group by vou.RucE, emp.RSocial'
--***************************************************************************************************************************************
--DETALLE-------------------------------------------------------------------------------------------------------------------------------
--***************************************************************************************************************************************
SET @SQL2= '

	select
		vou.RucE, emp.RSocial,
		vou.RegCtb,
		vou.Prdo,
		Convert(varchar,vou.FecMov,103) as FechaReg,
		vou.NroCta,cta.NomCta,
		vou.Cd_Aux,aux.NDoc as NomAux,
		vou.Cd_TD as TD, vou.NroSre+''-''+vou.NroDoc as DCTO,
		vou.Glosa,
		-------------------------------------------------------------------------------------------------------
		
		--------------------------
		--SOLES
		--------------------------
		/*
		case(vou.IC_CtrMd) when ''$'' then ''0.00''
				   else vou.MtoD 
		end as DebeMN,

                case(vou.IC_CtrMd) when ''$'' then ''0.00''
				   else vou.MtoH 
		end as HaberMN,
		*/

		vou.MtoD as DebeMN,
                vou.MtoH as HaberMN,

		--------------------------
		--CDOLARES
		--------------------------
		/*
		case(vou.IC_CtrMd) when ''s'' then ''0.00''
				   else vou.MtoD_ME 
		end as DebeME,

                case(vou.IC_CtrMd) when ''s'' then ''0.00''
				   else vou.MtoH_ME 
		end as HaberME
		*/

		vou.MtoD_ME as DebeME,
		vou.MtoH_ME as HaberME
	------------------------------------------------------------------------
	from Voucher vou
	left join Empresa emp on emp.Ruc=vou.RucE
	left join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux
	left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte = ''CB'' and vou.IB_Anulado<>1 and right(vou.RegCtb,5) between '''+@Rango1+''' and '''+@Rango2+''''


PRINT @SQL1
PRINT @SQL2


EXEC sp_executesql @SQL1
EXEC sp_executesql @SQL2
		/*
		--------------------------
		--CONVERTIR A SOLES
		--------------------------
		Case(vou.Cd_MdRg) when ''02'' then convert(decimal(13,2),case(vou.IC_CtrMd) when ''$'' then ''0.00''
										            else vou.MtoD*vou.CamMda 
								       end
                                                           ) 
					      else case(vou.IC_CtrMd) when ''$'' then ''0.00''
								      else vou.MtoD
						   end
               	 end as DebeMN,
	
		Case(vou.Cd_MdRg) when ''02'' then convert(decimal(13,2),case(vou.IC_CtrMd) when ''$'' then ''0.00''
										            else vou.MtoH*vou.CamMda 
                                                                       end
                                                           ) 
                                              else case(vou.IC_CtrMd) when ''$'' then ''0.00''
								      else vou.MtoH 
						   end
               	 end as HaberMN,

		--------------------------
		--CONVERTIR A DOLARES
		--------------------------
		Case(vou.Cd_MdRg) when ''01'' then convert(decimal(13,2),case(vou.IC_CtrMd) when ''s'' then ''0.00''
										            else vou.MtoD/vou.CamMda 
                  						         end
							   ) 
					      else case(vou.IC_CtrMd) when ''s'' then ''0.00''
								      else vou.MtoD 
						   end
               	 end as DebeME,

		Case(vou.Cd_MdRg) when ''01'' then convert(decimal(13,2),case(vou.IC_CtrMd) when ''s'' then ''0.00''
										            else vou.MtoH/vou.CamMda 
							 	         end
							   ) 
                                              else case(vou.IC_CtrMd) when ''s'' then ''0.00''
							              else vou.MtoH 
						   end
		end as HaberME
		*/
------CODIGO DE MODIFICACION--------
--CM=MG01
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_VoucherCons_CB_SD_Ctzado2]
@RucE nvarchar(11),--Reg.Unico de Contribuyentes de la Empr.
@Ejer nvarchar(4),--Ejercicio(2009,2010..)
@PrdoIni nvarchar(2),--Periodo inicial de la consulta (01,02,03..)
@PrdoFin nvarchar(2),--Periodo final de la consulta (01,02,03..)
@Moneda nvarchar(2),--Codigo de la Moneda (01,02...)
@Rango1 nvarchar(5),--Rango de Nro.Cta 1 (10.0.1.10,...)
@Rango2 nvarchar(5),--Rango de Nro.Cta 2 (99999..)
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
if not exists(select * from voucher where RucE=@RucE and Ejer =@Ejer and Prdo between @PrdoIni and @PrdoFin and Cd_Fte='CB' and right(RegCtb,5) between @Rango1 and @Rango2 and IB_Anulado<>1)
	begin

		Declare @RSocial nvarchar(150)
		set @RSocial = (select RSocial from Empresa Where Ruc=@RucE)

		select top 1
		@RucE as RucE,
		--'*** No contiene información ***' as RSocial,
		@RSocial as RSocial,
		case(@Moneda) when '01' then 'En Nuevos Soles' else 'En Dólares Americanos' end as TipoMoneda,
		@PrdoIni +' al '+ @PrdoFin+' del '+ @Ejer as Periodo
		from voucher
		Where RucE=@RucE and Ejer=@Ejer

		select top 1
		@RucE as RucE,
		--'--' as RSocial,
		@RSocial as RSocial,
		'*** No contiene información ***' as RegCtb,
		'--' as Prdo,
		'--' as FechaReg,
		'--' as NroCta,
		'--' as NomCta,
		'--' as Cd_Aux,
		'--' as NomAux,
		'--' as TD,
		'--' as DCTO,
		'--' as Glosa,
		0.00 as DebeMN,
                0.00 as HaberMN,
		0.00 as DebeME,
		0.00 as HaberME		
		from Voucher
		Where RucE=RucE and Ejer=@Ejer

	end
else
begin
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
	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte = ''CB'' and right(vou.RegCtb,5) between '''+@Rango1+''' and '''+@Rango2+''''+' and vou.IB_Anulado<>1
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
	--left join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux
	left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte = ''CB'' and right(vou.RegCtb,5) between '''+@Rango1+''' and '''+@Rango2+''' and vou.IB_Anulado<>1
	Group by vou.RucE, emp.RSocial,vou.NroCta,cta.NomCta,	vou.Prdo,vou.MtoD,vou.MtoH,vou.MtoD_ME,vou.MtoH_ME
	'	

PRINT @SQL1
PRINT @SQL2


EXEC sp_executesql @SQL1
EXEC sp_executesql @SQL2
		/*
		--------------------------
		--CONVERTIR A SOLES
		--------------------------
		Sum(
		Case(vou.Cd_MdRg) when ''02'' then convert(decimal(13,2),case(vou.IC_CtrMd) when ''$'' then ''0.00''
										            else vou.MtoD*vou.CamMda 
								       end
                                                           ) 
					      else case(vou.IC_CtrMd) when ''$'' then ''0.00''
								      else vou.MtoD
						   end
               	 end) as DebeMN,
		Sum(
		Case(vou.Cd_MdRg) when ''02'' then convert(decimal(13,2),case(vou.IC_CtrMd) when ''$'' then ''0.00''
										            else vou.MtoH*vou.CamMda 
                                                                       end
                                                           ) 
                                              else case(vou.IC_CtrMd) when ''$'' then ''0.00''
								      else vou.MtoH 
						   end
               	 end) as HaberMN,

		--------------------------
		--CONVERTIR A DOLARES
		--------------------------
		Sum(
		Case(vou.Cd_MdRg) when ''01'' then convert(decimal(13,2),case(vou.IC_CtrMd) when ''s'' then ''0.00''
										            else vou.MtoD/vou.CamMda 
                  						         end
							   ) 
					      else case(vou.IC_CtrMd) when ''s'' then ''0.00''
								      else vou.MtoD 
						   end
               	 end) as DebeME,
		Sum(
		Case(vou.Cd_MdRg) when ''01'' then convert(decimal(13,2),case(vou.IC_CtrMd) when ''s'' then ''0.00''
										            else vou.MtoH/vou.CamMda 
							 	         end
							   ) 
                                              else case(vou.IC_CtrMd) when ''s'' then ''0.00''
							              else vou.MtoH 
						   end
		end) as HaberME

		*/
end
--Jesus -> 06/07/2010 -> Se agrego la condición que 'marque' el Ruc,Prdo.. cuando no hayan registros contables
--Ejemplo: 
--exec Rpt_VoucherCons_CB_SD_Ctzado2 '11111111111','2010','01','09','02','0','9999999999',null
GO

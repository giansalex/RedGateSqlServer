SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--exec Rpt_VoucherCons_LD3_SD '20521620090','2011','08','08','01','''CB'',''LD'',''RC'',''RV''','','',null

CREATE procedure [dbo].[Rpt_VoucherCons_LD3_SD]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@Moneda nvarchar(2),
@Tipos nvarchar(100),
@Rango1 nvarchar(5),
@Rango2 nvarchar(5),
@msj varchar(100) output
AS

if(isnull(len(@Rango1),0) = 0 and isnull(len(@Rango2),0) = 0)
BEGIN
	set @Rango1 = '00000'
	set @Rango2 = '99999'
END

DECLARE @SQL1 nvarchar(4000)
DECLARE @SQL2 nvarchar(4000)


if not exists(select * from voucher where RucE=@RucE and Ejer=@Ejer and Prdo between @PrdoIni and @PrdoFin and Cd_Fte in ('CB') and IB_Anulado<>1)
	begin
		select top 1
		@RucE as RucE,
		'*** No contiene información ***' as RSocial,
		'--' as RegCtb,
		case(@Moneda) when '01' then 'En Nuevos Soles' else 'En Dólares Americanos' end as TipoMoneda,
		@PrdoIni +' al '+ @PrdoFin+' del '+ @Ejer as Periodo
		from voucher
		Where RucE=@RucE and Ejer=@Ejer

		select top 1
		@RucE as RucE,
		'*** No contiene información ***' as RSocial,
		'--' as RegCtb,
		'--' as Prdo,
		'--' as FechaReg,
		'--' as NroCta,
		'--' as NomCta,
		'--' as Cd_Aux,
		'--' as NomAux,
		'--' as TD,
		'--' as DCTO,
		'--' as Glosa,
		case(@Moneda) when '01' then 0.00 else 0.00 end as DebeMN,
		case(@Moneda) when '01' then 0.00 else 0.00 end as HaberMN,		
		case(@Moneda) when '01' then 0.00 else 0.00 end as DebeME,
		case(@Moneda) when '01' then 0.00 else 0.00 end as HaberME
		from Voucher
		where RucE=@RucE and Ejer=@Ejer
	end
else
begin
--***************************************************************************************************************************************
--CABECERA-------------------------------------------------------------------------------------------------------------------------------
--***************************************************************************************************************************************
SET @SQL1 = '
	select
		vou.RucE, emp.RSocial,
		vou.RegCtb,
				case('''+@Moneda+''') when '+'''01'''+' then '+'''En Nuevos Soles y Dólares Americanos'''+' else '+'''En Nuevos Soles y Dólares Americanos'''+' end as TipoMoneda,
		'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
	from Voucher vou
	left join Empresa emp on emp.Ruc=vou.RucE
	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in ('+@Tipos+')'+' and right(vou.RegCtb,5) between '''+@Rango1+''' and '''+@Rango2+''''+' and vou.IB_Anulado<>1
	Group by vou.RucE, emp.RSocial,vou.RegCtb'
PRINT @SQL1
EXEC sp_executesql @SQL1

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
		--vou.Cd_Aux,aux.NDoc as NomAux,--<<-- Modificado en lineas 85 y 86

		case(isnull(len(vou.Cd_Clt),0)) when 0 then p.Cd_Prv else c.Cd_Clt end as Cd_Aux,
    		case(isnull(len(vou.Cd_Clt),0)) when 0 then p.NDoc else c.NDoc end as NomAux,

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
	--left join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux--<<-- Modificado en linea 127
	left join Cliente2 c on vou.Cd_Clt = c.Cd_Clt and c.RucE = vou.RucE
	left join Proveedor2 p on vou.Cd_Prv = p.Cd_Prv and p.RucE = vou.RucE
	left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in ('+@Tipos+')'+' and vou.IB_Anulado<>1 and right(vou.RegCtb,5) between '''+@Rango1+''' and '''+@Rango2+''''
	
PRINT @SQL2
EXEC sp_executesql @SQL2

		/*
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
end
--Jesus -> 06/07/2010 : Modificado -> Se agrego la condicion para que 'marque' el Ruc,Prdo cuando no haya registros
--CAM -> 21/09/2010 : Modificado -> Se quito la tabla Auxiliar y se agrego Cliente2 y Proveedor2 en @SQL2

--Ejemplos:
--exec dbo.Rpt_VoucherCons_LD3_SD '11111111111','2010','01','12','01','1','0','0','0','0','0','0','0','','',null
--exec Rpt_VoucherCons_LD3_SD '11111111111','2010','01','12','01','''RC''','0','999999999',null


GO

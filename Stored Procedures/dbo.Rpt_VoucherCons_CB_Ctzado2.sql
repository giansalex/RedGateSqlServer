SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_VoucherCons_CB_Ctzado2]
@RucE nvarchar(11),--Reg.Unico de Contribuyentes de la Empr.
@Ejer nvarchar(4),--Ejercicio(2009,2010..)
@PrdoIni nvarchar(2),--Periodo inicial de la consulta (01,02,03..)
@PrdoFin nvarchar(2),--Periodo final de la consulta (01,02,03..)
@Moneda nvarchar(2),--Codigo de la Moneda (01,02...)
@Rango1 nvarchar(10),--Rango de Nro.Cta 1 (10.0.1.10,...)
@Rango2 nvarchar(10),--Rango de Nro.Cta 2 (99999..)
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

if not exists(select * from voucher where RucE=@RucE and Ejer =@Ejer and Prdo between @PrdoIni and @PrdoFin and Cd_Fte='CB' and right(RegCtb,5) between @Rango1 and @Rango2 and IB_Anulado<>1)
	begin

		Declare @RSocial nvarchar(150)
		set @RSocial = (select RSocial from Empresa Where Ruc=@RucE)

		select top 1
		@RucE as RucE,
		--'--' as RSocial,
		@RSocial as RSocial,
		case(@Moneda) when '01' then 'En Nuevos Soles' else 'En Dólares Americanos' end as TipoMoneda,
		@PrdoIni +' al '+ @PrdoFin+' del '+ @Ejer as Periodo
		from voucher
		Where RucE=@RucE and Ejer=@Ejer

		select top 1
		@RucE as RucE,
		'--' as RSocial,
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
		Case(@Moneda) when '01' then 0.00 else 0.00 end as Debe,
		Case(@Moneda) when '01' then 0.00 else 0.00 end as Haber
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
	--left join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux
	left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte = ''CB'' and vou.NroCta between  '''+@Rango1+''' and '''+@Rango2+''' and vou.IB_Anulado<>1
	Group by vou.RucE, emp.RSocial,vou.NroCta,cta.NomCta,	vou.Prdo
	'	
PRINT @SQL1
PRINT @SQL2


EXEC sp_executesql @SQL1
EXEC sp_executesql @SQL2
end
------LEYENDA--------
--Jesus -> se agrego para que 'marque' el ruc, prdo,.. cuando no hayan registros
--FL : 20/09/2010 <Se comento Auxiliar en el segundo left join de @SQL2 porque no se utilizaba>
--exec Rpt_VoucherCons_CB_Ctzado2 '11111111111','2010','01','09','02','0','9999999999',null
GO

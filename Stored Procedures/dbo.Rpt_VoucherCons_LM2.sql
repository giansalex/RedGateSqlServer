SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_VoucherCons_LM2]
--exec Rpt_VoucherCons_LM2 '20428875282','2011','00','11','01','''CB'',''LD'',''RC'',''RV''','10.4.1.30','10.4.1.30',NULL
--exec Rpt_VoucherCons_LM2 '11111111111','2012','08','08','01','''CB'',''LD'',''RC'',''RV''','','',''
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
if not exists(select * from voucher where RucE=@RucE and Ejer=@Ejer and Prdo between @PrdoIni and @PrdoFin and Cd_Fte IN ('RV','RC','LD','CB') and NroCta >= @Rango1 and NroCta <= @Rango2 and IB_Anulado<>1)
	begin
print 'entrada 1'
		select top 1
		@RucE as RucE,
		Empresa.RSocial as RSocial,
		case(@Moneda) when '01' then 'En Nuevos Soles' else 'En Dolares Americanos' end as TipoMoneda,
		@PrdoIni +' al '+ @PrdoFin+' del '+ @Ejer as Periodo
		from voucher v
		inner join Empresa on v.RucE = Empresa.Ruc
		Where v.RucE=@RucE and v.Ejer=@Ejer

		select top 1
		@RucE as RucE,
		Empresa.RSocial as RSocial,
		'--' as NroCta,
		'--' as Prdo,
		'--' as FechaReg,
		'--' as RegCtb,		
		'--' as Cd_Aux,
		'--' as NomAux,
		'--' as TD,
		'--' as DCTO,
		'** SIN OPERACIONES **' as Glosa,
		case(@Moneda) when '01' then 0.00 else 0.00 end as Debe,
		case(@Moneda) when '01' then 0.00 else 0.00 end as Haber,
		0.00 as TipCamb		
		from voucher v
		inner join Empresa on v.RucE = Empresa.Ruc
		Where v.RucE=@RucE and v.Ejer=@Ejer

		select top 1
		@RucE as RucE,
		'--' as NroCta,
		0.00 as MtoD,
		0.00 as MtoH,
		0.00 as SaldoAnt
		from voucher
		Where RucE=@RucE and Ejer=@Ejer
	end
else
begin
print 'entrada 2'
DECLARE @SQL1 nvarchar(4000)
DECLARE @SQL2 nvarchar(4000)
DECLARE @SQL3 nvarchar(4000)

--***************************************************************************************************************************************
--CABECERA-------------------------------------------------------------------------------------------------------------------------------
--***************************************************************************************************************************************
SET @SQL1 = '
	select
		vou.RucE, emp.RSocial,
		case('''+@Moneda+''') when '+'''01'''+' then '+'''En Nuevos Soles'''+' else '+'''En DÃ³lares Americanos'''+' end as TipoMoneda,
		'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
	from Voucher vou
	left join Empresa emp on emp.Ruc=vou.RucE
	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in ('+@Tipos+')'+' and vou.NroCta >= '''+@Rango1+''' and vou.NroCta <= '''+@Rango2+''''+' /*and vou.IB_Anulado<>1 */


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
		case(isnull(len(vou.Cd_Clt),0)) when 0 then p.Cd_Prv else c.Cd_Clt end as Cd_Aux,
		case(isnull(len(vou.Cd_Clt),0)) when 0 then p.NDoc else c.NDoc end as NomAux,
		vou.Cd_TD as TD, isnull(vou.NroSre+''-'','''')+isnull(vou.NroDoc,'''') as DCTO,
		Case when vou.IB_Anulado=1 then ''(ANULADO) '' else '''' end + vou.Glosa AS Glosa,
		vou.NroChke,
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
		Case when vou.IB_Anulado=1 then 0.00 else 
			Case('''+@Moneda+''') when ''01'' then vou.MtoD								      
				   	      		  else vou.MtoD_ME
			end
		End as Debe,
		Case when vou.IB_Anulado=1 then 0.00 else 
			Case('''+@Moneda+''') when ''01'' then vou.MtoH 
					 		  else vou.MtoH_ME
			end
		End as Haber
	
	------------------------------------------------------------------------
	from Voucher vou
	left join Empresa emp on emp.Ruc=vou.RucE
	left join Cliente2 c on vou.RucE= c.RucE and vou.Cd_Clt = c.Cd_Clt
	left join PRoveedor2 p on vou.RucE= p.RucE and vou.Cd_Prv = p.Cd_Prv
	left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' 
	and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' 
	and vou.Cd_Fte in ('+@Tipos+')'+' 
	and vou.NroCta >= '''+@Rango1+''' 
	and vou.NroCta <= '''+@Rango2+'''  
	/*and vou.IB_Anulado<>1*/ 
	ORDER BY vou.NroCta,vou.Prdo'	

--	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in ('+@Tipos+')'+' and vou.NroCta between '''+@Rango1+''' and '''+@Rango2+''' ORDER BY vou.NroCta,vou.Prdo'	
	
PRINT @SQL2
EXEC sp_executesql @SQL2

--***************************************************************************************************************************************
--SALDO ANTERIORES-------------------------------------------------------------------------------------------------------------------------------
--***************************************************************************************************************************************

SET @SQL3 = '
	  select 
		vou.RucE,vou.NroCta,
		--sum(Case('''+@Moneda+''') when ''01'' then vou.MtoD else vou.MtoD_ME end) as MtoD, sum(Case('''+@Moneda+''') when ''01'' then vou.MtoH else vou.MtoH_ME end) as MtoH,Sum(Case('''+@Moneda+''') when ''01'' then vou.MtoD-vou.MtoH else vou.MtoD_ME-vou.MtoH_ME end) SaldoAnt 
		sum(Case('''+@Moneda+''') when ''01'' then case when isnull(vou.IB_Anulado,0) = 0 then vou.MtoD else 0.0 end  else case when isnull(vou.IB_Anulado,0) = 0 then vou.MtoD_Me else 0.0 end end) as MtoD, 
		sum(Case('''+@Moneda+''') when ''01'' then case when isnull(vou.IB_Anulado,0) = 0 then vou.MtoH else 0.0 end  else case when isnull(vou.IB_Anulado,0) = 0 then vou.MtoH_Me else 0.0 end end) as MtoH, 
		sum(Case('''+@Moneda+''') when ''01'' then case when isnull(vou.IB_Anulado,0) = 0 then vou.MtoD else 0.0 end  else case when isnull(vou.IB_Anulado,0) = 0 then vou.MtoD_Me else 0.0 end end) - sum(Case('''+@Moneda+''') when ''01'' then case when isnull(vou.IB_Anulado,0) = 0 then vou.MtoH else 0.00 end  else case when isnull(vou.IB_Anulado,0) = 0 then vou.MtoH_Me else 0.0 end end) SaldoAnt 

	  from voucher vou
	  where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo < '''+@PrdoIni+''' and vou.Cd_Fte in ('+@Tipos+')'+' and vou.NroCta >= '''+@Rango1+''' and vou.NroCta <= '''+@Rango2+''' /*and vou.IB_Anulado<>1*/  Group by RucE,NroCta
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
		/*and v.IB_Anulado<>1*/ 
	  Group by v.RucE,v.NroCta 
	  Order by NroCta'

PRINT @SQL3
EXEC sp_executesql @SQL3
end
--Jesus -> 06/07/2010 : Modificado -> Se agrego la condicion para que 'marque' el Ruc,Prdo cuando no haya registros
--CAM -> 22/09/2010
--Diego -> 14/12/2010 : Modificado -> Mostrar cero en el caso que el registro se encuentre anuladoy colocando (ANULADO) en la glosa
--Diego -> 21/02/2011 : Modificado -> Se agrego ruc a las left join de Cliente2 y Proveedor2
--JA: -> 06/10/2011 : Modificado -> Se cambio el no tiene informacion con "SIN OPERACIONES"
--Ejemplos:

--sp_help Rpt_VoucherCons_LM2
--exec Rpt_VoucherCons_LM2 '11111111111','2012','01','09','01','''LD''','10.0.0.01','9999999999',''
GO

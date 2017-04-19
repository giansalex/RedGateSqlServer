SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exec Rpt_VoucherCons_CB3 '11111111111','2012','01','09','02','0','9999999999',null
CREATE procedure [dbo].[Rpt_VoucherCons_CB3]
@RucE nvarchar(11),--Reg.Unico de Contribuyentes de la Empr.
@Ejer nvarchar(4),--Ejercicio(2009,2010..)
@PrdoIni nvarchar(2),--Periodo inicial de la consulta (01,02,03..)
@PrdoFin nvarchar(2),--Periodo final de la consulta (01,02,03..)
@Moneda nvarchar(2),--Codigo de la Moneda (01,02...)
@Rango1 nvarchar(5),--Rango de Nro.Cta 1 (10.0.1.10,...)
@Rango2 nvarchar(5),--Rango de Nro.Cta 2 (99999..)
@msj varchar(100) output

as
--select * from Empresa where RSocial like '%Bafur%'

--set @RucE = '20100977037'
--set @Ejer = '2012'
--set @PrdoIni = '01'
--set @PrdoFin = '07'
--set @Moneda = '01'
--set @Rango1 = ''
--set @Rango2 = ''
--set @msj = null



IF(isnull(len(@Rango1),0) = 0 and isnull(len(@Rango2),0) = 0)
BEGIN
	set @Rango1 = '00000'
	set @Rango2 = '99999'
END

DECLARE @SQL1 nvarchar(4000)
DECLARE @SQL2 nvarchar(4000)
DECLARE @SQL3 nvarchar(4000)
DECLARE @SQL4 nvarchar(4000)
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
		'--' as RSocial,
		'** SIN OPERACIONES **' as RegCtb,
		'--' as Prdo,
		'--' as FechaReg,
		'--' as NroCta,
		'--' as NomCta,
		'--' as Cd_Aux,
		'--' as NomAux,
		'--' as TD,
		'--' as DCTO,
		'--' as Glosa,
		case(@Moneda) when '01' then 0.00 else 0.00 end as Debe,
		case(@Moneda) when '01' then 0.00 else 0.00 end as Haber
		,'--' as TipOper
		,'--' as Nrocheque
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
		case('''+@Moneda+''') when '+'''01'''+' then '+'''En Nuevos Soles'''+' else '+'''En Dólares Americanos'''+' end as TipoMoneda,
		'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
	from Voucher vou
	left join Empresa emp on emp.Ruc=vou.RucE
	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte = ''CB'' and right(vou.RegCtb,5) between '''+@Rango1+''' and '''+@Rango2+''''+' and vou.IB_Anulado<>1
	Group by vou.RucE, emp.RSocial'
--***************************************************************************************************************************************
--DETALLE-------------------------------------------------------------------------------------------------------------------------------
--***************************************************************************************************************************************
SET @SQL3= '
		if('''+@PrdoIni+'''<>''00'')
		begin
		select
		'''' as RucE,
		'''' as RSocial,
		'''' as RegCtb,
		'''' as Prdo,
		'''' as FechaReg,
		'''' as Cd_TMP,
		'''' as NCortoTMP,
		'''' as NroCta,
		'''' as NomCta,
		'''' as Cd_Aux,
		'''' as NomAux,
		'''' as TD,
		'''' as DCTO,
		''SALDO INICIAL'' as Glosa,
		isnull(Case('''+@Moneda+''') when ''01'' then sum(vou.MtoD)  else sum(vou.MtoD_ME) end, 0.0) as Debe,
		isnull(Case('''+@Moneda+''') when ''01'' then sum(vou.MtoH)  else sum(vou.MtoH_ME) end, 0.0) as Haber
		,'''' as TipOper
		,'''' as Nrocheque
		from Voucher vou
		left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
		where 
		vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' 
		and vou.Prdo = case when Convert(int,'''+@PrdoIni+''') = 0 then ''00'' when Convert(int,'''+@PrdoIni+''') <= 10 then ''0''+Convert(nvarchar,Convert(int,'''+@PrdoIni+''')-1)	when Convert(int,'''+@PrdoIni+''') > 10 then Convert(nvarchar,Convert(int,'''+@PrdoIni+''')-1) end 
		and vou.Cd_Fte = ''CB'' and vou.IB_Anulado<>1 and right(vou.RegCtb,5) between ''00000'' and ''99999''
		union all
		'

SET @SQL2= '
	select
		vou.RucE, emp.RSocial,
		vou.RegCtb,
		vou.Prdo,
		Convert(varchar,vou.FecMov,103) as FechaReg,
		mp.Cd_TMP,
		mp.NomCorto as NCortoTMP, 
		vou.NroCta,cta.NomCta,
		--vou.Cd_Aux, --<<-- Modificado en linea 89 
		--aux.NDoc as NomAux, --<<-- Modificado en linea 90

		case(isnull(len(vou.Cd_Clt),0)) when 0 then p.Cd_Prv else c.Cd_Clt end as Cd_Aux,
		--case(isnull(len(vou.Cd_Clt),0)) when 0 then p.NDoc else c.NDoc end as NomAux,
		case(isnull(len(vou.Cd_Clt),0)) when 0 then isnull(p.RSocial,isnull(p.ApPat,'''')+'' ''+isnull(p.ApMat,'''')+'' ''+isnull(p.Nom,'''')) else isnull(c.RSocial,isnull(c.ApPat,'''')+'' ''+isnull(c.ApMat,'''')+'' ''+isnull(c.Nom,'''')) end as NomAux,

		vou.Cd_TD as TD, vou.NroSre+''-''+vou.NroDoc as DCTO,
		vou.Glosa,
		Case('''+@Moneda+''') when ''01'' then vou.MtoD								      
			   	      		  else vou.MtoD_ME
		end as Debe,

		Case('''+@Moneda+''') when ''01'' then vou.MtoH 
				 		  else vou.MtoH_ME
		end as Haber
		,isnull(vou.TipOper,'''') as TipOper
		,isnull(vou.NroChke,'''') as NroCheque

	------------------------------------------------------------------------
	from Voucher vou
	left join Empresa emp on emp.Ruc=vou.RucE
	--left join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux --<<-- Modificado en linea 129 y 130
	left join Cliente2 c on c.RucE=vou.RucE and vou.Cd_Clt = c.Cd_Clt --<<-- Nueva
    left join Proveedor2 p on p.RucE=vou.RucE and vou.Cd_Prv = p.Cd_Prv --<<-- Nuevava
	left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
	left join MedioPago mp on mp.Cd_TMP = vou.Cd_TMP 
	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte = ''CB'' and vou.IB_Anulado<>1 and right(vou.RegCtb,5) between '''+@Rango1+''' and '''+@Rango2+'''
	end
	'
set @SQL4=
	'else
	begin
		select
		vou.RucE, emp.RSocial,
		vou.RegCtb,
		vou.Prdo,
		Convert(varchar,vou.FecMov,103) as FechaReg,
		mp.Cd_TMP,
		mp.NomCorto as NCortoTMP,
		vou.NroCta,cta.NomCta,
		--vou.Cd_Aux, --<<-- Modificado en linea 89 
		--aux.NDoc as NomAux, --<<-- Modificado en linea 90

		case(isnull(len(vou.Cd_Clt),0)) when 0 then p.Cd_Prv else c.Cd_Clt end as Cd_Aux,
		case(isnull(len(vou.Cd_Clt),0)) when 0 then p.NDoc else c.NDoc end as NomAux,

		vou.Cd_TD as TD, vou.NroSre+''-''+vou.NroDoc as DCTO,
		vou.Glosa,
		Case('''+@Moneda+''') when ''01'' then vou.MtoD								      
			   	      		  else vou.MtoD_ME
		end as Debe,

		Case('''+@Moneda+''') when ''01'' then vou.MtoH 
				 		  else vou.MtoH_ME
		end as Haber
		,isnull(vou.TipOper,'''') as TipOper
		,isnull(vou.NroChke,'''') as NroCheque
	------------------------------------------------------------------------
	from Voucher vou
	left join Empresa emp on emp.Ruc=vou.RucE
	--left join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux --<<-- Modificado en linea 129 y 130
	left join Cliente2 c on c.RucE=vou.RucE and vou.Cd_Clt = c.Cd_Clt --<<-- Nueva
    left join Proveedor2 p on p.RucE=vou.RucE and vou.Cd_Prv = p.Cd_Prv --<<-- Nuevava
	left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
	left join MedioPago mp on mp.Cd_TMP = vou.Cd_TMP 
	where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte = ''CB'' and vou.IB_Anulado<>1 and right(vou.RegCtb,5) between '''+@Rango1+''' and '''+@Rango2+'''
	end
	'
PRINT @SQL1
PRINT (@SQL3+@SQL2+@SQL4)

EXEC (@SQL1)
EXEC (@SQL3+@SQL2+@SQL4)
end
--<Creacion>
--JA -> 23/08/2012 Modificado : Le puse SIN OPERACIONES!

--Ejemplo :
--exec Rpt_VoucherCons_CB3 '11111111111','2012','10','10','02','0','9999999999',null
GO

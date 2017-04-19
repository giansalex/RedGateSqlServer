SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_VoucherCons_LD2_SD]
--exec Rpt_VoucherCons_LD2_SD '11111111111','2009','01','02','01','1','0','0','0','0','0','0','0','','',null
@RucE nvarchar(11),
@Ejer nvarchar(4),
@PrdoIni nvarchar(2),
@PrdoFin nvarchar(2),
@Moneda nvarchar(2),
@InfCB bit,
@InfLD bit,
@InfRV bit,
@InfRC bit,
@DetCB bit,
@DetLD bit,
@DetRV bit,
@DetRC bit,
@Rango1 nvarchar(5),
@Rango2 nvarchar(5),
@msj varchar(100) output

as
/*
Set @RucE = '11111111111'
Set @Ejer = '2009'
Set @PrdoIni = '01'
Set @PrdoFin = '02'
Set @Moneda = '01'

Set @InfCB = '1'
Set @InfLD = '1'
Set @InfRC = '1'
Set @InfRV = '1'

Set @DetCB = '0'
Set @DetLD = '0'
Set @DetRC = '1'
Set @DetRV = '1'

Set @Rango1 = ''
Set @Rango2 = ''
*/

Declare @Registros nvarchar(100)
Set @Registros = ''
IF(isnull(len(@Rango1),0) <> 0 and isnull(len(@Rango2),0) <> 0)
BEGIN
	set @Registros = ' and right(vou.RegCtb,5) between '''+@Rango1+''' and '''+@Rango2+''' '
END

DECLARE @CB_Cab nvarchar(4000)
Set @CB_Cab = ''

IF(@InfCB = 1)
begin
	IF(@DetCB = 1)
	begin
		Set @CB_Cab = '
				select
					vou.RucE, emp.RSocial,
					vou.Cd_Fte,
					''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000'' as RegCtb,
					''En Nuevos Soles y Dólares Americanos'' as TipoMoneda,
					'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''CB'')'+@Registros+' and vou.IB_Anulado<>1
				Group by vou.RucE, emp.RSocial,vou.Cd_Fte,''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000''
			      '
	end
	ElSE
	begin	
		Set @CB_Cab = '
				select
					vou.RucE, emp.RSocial,
					vou.Cd_Fte,
					vou.RegCtb,
					''En Nuevos Soles y Dólares Americanos'' as TipoMoneda,
					'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''CB'')'+@Registros+' and vou.IB_Anulado<>1
				Group by vou.RucE, emp.RSocial,vou.Cd_Fte,vou.RegCtb
			      '
	end
end


DECLARE @LD_Cab nvarchar(4000)
Set @LD_Cab = ''

IF(@InfLD = 1)
begin
	IF(@InfCB = 1) Set @LD_Cab = ' Union All '
	IF(@DetLD = 1)
	begin
		Set @LD_Cab = +@LD_Cab+'
				select
					vou.RucE, emp.RSocial,
					vou.Cd_Fte,
					''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000'' as RegCtb,
					''En Nuevos Soles y Dólares Americanos'' as TipoMoneda,
					'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''LD'')'+@Registros+' and vou.IB_Anulado<>1
				Group by vou.RucE, emp.RSocial,vou.Cd_Fte,''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000''
			      '
	end
	ElSE
	begin	
		Set @LD_Cab = +@LD_Cab+'
				select
					vou.RucE, emp.RSocial,
					vou.Cd_Fte,
					vou.RegCtb,
					''En Nuevos Soles y Dólares Americanos'' as TipoMoneda,
					'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''LD'')'+@Registros+' and vou.IB_Anulado<>1
				Group by vou.RucE, emp.RSocial,vou.Cd_Fte,vou.RegCtb
			      '
	end
end


DECLARE @RC_Cab nvarchar(4000)
Set @RC_Cab = ''

IF(@InfRC = 1)
begin
	IF(@InfCB = 1 or @InfLD = 1) Set @RC_Cab = ' Union All '
	IF(@DetRC = 1)
	begin
		Set @RC_Cab = +@RC_Cab+'
				select
					vou.RucE, emp.RSocial,
					vou.Cd_Fte,
					''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000'' as RegCtb,
					''En Nuevos Soles y Dólares Americanos'' as TipoMoneda,
					'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''RC'')'+@Registros+' and vou.IB_Anulado<>1
				Group by vou.RucE, emp.RSocial,vou.Cd_Fte,''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000''
			      '
	end
	ElSE
	begin	
		Set @RC_Cab = +@RC_Cab+'
				select
					vou.RucE, emp.RSocial,
					vou.Cd_Fte,
					vou.RegCtb,
					''En Nuevos Soles y Dólares Americanos'' as TipoMoneda,
					'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''RC'')'+@Registros+' and vou.IB_Anulado<>1
				Group by vou.RucE, emp.RSocial,vou.Cd_Fte,vou.RegCtb
			      '
	end
end

DECLARE @RV_Cab nvarchar(4000)
Set @RV_Cab = ''

IF(@InfRV = 1)
begin
	IF(@InfCB = 1 or @InfLD = 1 or @InfRC = 1) Set @RV_Cab = ' Union All '
	IF(@DetRV = 1)
	begin
		Set @RV_Cab = +@RV_Cab+'
				select
					vou.RucE, emp.RSocial,
					vou.Cd_Fte,
					''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000'' as RegCtb,
					''En Nuevos Soles y Dólares Americanos'' as TipoMoneda,
					'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''RV'')'+@Registros+' and vou.IB_Anulado<>1
				Group by vou.RucE, emp.RSocial,vou.Cd_Fte,''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000''
			      '
	end
	ElSE
	begin	
		Set @RV_Cab = +@RV_Cab+'
				select
					vou.RucE, emp.RSocial,
					vou.Cd_Fte,
					vou.RegCtb,
					''En Nuevos Soles y Dólares Americanos'' as TipoMoneda,
					'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''RV'')'+@Registros+' and vou.IB_Anulado<>1
				Group by vou.RucE, emp.RSocial,vou.Cd_Fte,vou.RegCtb
			      '
	end
end

PRINT @CB_Cab
PRINT @LD_Cab
PRINT @RC_Cab
PRINT @RV_Cab


DECLARE @CB_Det nvarchar(4000)
Set @CB_Det = ''

IF(@InfCB = 1)
begin
	IF(@DetCB = 1)
	begin
		Set @CB_Det = ' select
					vou.RucE, emp.RSocial,
					vou.Cd_Fte,
					''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000'' as RegCtb,
					vou.Prdo,
					--convert(varchar,dateadd( month,1,''01/''+right(''00''+Month(vou.FecMov),2)+''/'+@Ejer+''')-1,103) as FecReg,
					Case(vou.Prdo) when ''00'' then ''31/00/''+'''+@Ejer+''' else convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) end as FecReg,
					vou.NroCta,cta.NomCta,
					'''' as Cd_Aux,'''' as NomAux,
					'''' as TD, '''' as DCTO,
					''Centra. mes ''+right(''00''+Month(vou.FecMov),2) Glosa,
					
					Sum(vou.MtoD) as DebeMN,
                			Sum(vou.MtoH) as HaberMN,
					Sum(vou.MtoD_ME) as DebeME,
			                Sum(vou.MtoH_ME) as HaberME
					
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				left join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux
				left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''CB'') and vou.IB_Anulado<>1 
				'+@Registros+'
				Group by vou.RucE,emp.RSocial,vou.Cd_Fte,''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000'',
				vou.Prdo,Case(vou.Prdo) when ''00'' then ''31/00/''+'''+@Ejer+''' else convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) end,
				vou.NroCta,cta.NomCta,''Centra. mes ''+right(''00''+Month(vou.FecMov),2)

			      '
	end
	ELSE
	begin
		Set @CB_Det = '
				select
					vou.RucE, emp.RSocial,
					vou.Cd_Fte,
					vou.RegCtb,
					vou.Prdo,
					Convert(varchar,vou.FecMov,103) as FecReg,
					vou.NroCta,cta.NomCta,
					vou.Cd_Aux,aux.NDoc as NomAux,
					vou.Cd_TD as TD, vou.NroSre+''-''+vou.NroDoc as DCTO,
					vou.Glosa,
					
					(vou.MtoD) as DebeMN,
                			(vou.MtoH) as HaberMN,
					(vou.MtoD_ME) as DebeME,
			                (vou.MtoH_ME) as HaberME
					
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				left join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux
				left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''CB'') and vou.IB_Anulado<>1 
				'+@Registros+'
			      '
	end
end


DECLARE @LD_Det nvarchar(4000)
Set @LD_Det = ''

IF(@InfLD = 1)
begin
	IF(@InfCB = 1) Set @LD_Det = ' Union All '
	IF(@DetLD = 1)
	begin
		Set @LD_Det = @LD_Det+' select
					vou.RucE, emp.RSocial,
					vou.Cd_Fte,
					''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000'' as RegCtb,
					vou.Prdo,
					--convert(varchar,dateadd( month,1,''01/''+right(''00''+Month(vou.FecMov),2)+''/'+@Ejer+''')-1,103) as FecReg,
					Case(vou.Prdo) when ''00'' then ''31/00/''+'''+@Ejer+''' else convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) end as FecReg,
					vou.NroCta,cta.NomCta,
					'''' as Cd_Aux,'''' as NomAux,
					'''' as TD, '''' as DCTO,
					''Centra. mes ''+right(''00''+Month(vou.FecMov),2) Glosa,
					
					Sum(vou.MtoD) as DebeMN,
                			Sum(vou.MtoH) as HaberMN,
					Sum(vou.MtoD_ME) as DebeME,
			                Sum(vou.MtoH_ME) as HaberME
					
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				left join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux
				left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''LD'') and vou.IB_Anulado<>1 
				'+@Registros+'
				Group by vou.RucE,emp.RSocial,vou.Cd_Fte,''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000'',
				vou.Prdo,Case(vou.Prdo) when ''00'' then ''31/00/''+'''+@Ejer+''' else convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) end,
				vou.NroCta,cta.NomCta,''Centra. mes ''+right(''00''+Month(vou.FecMov),2)
			      '
	end
	ELSE
	begin
		Set @LD_Det = @LD_Det+'
				select
					vou.RucE, emp.RSocial,
					vou.Cd_Fte,
					vou.RegCtb,
					vou.Prdo,
					Convert(varchar,vou.FecMov,103) as FecReg,
					vou.NroCta,cta.NomCta,
					vou.Cd_Aux,aux.NDoc as NomAux,
					vou.Cd_TD as TD, vou.NroSre+''-''+vou.NroDoc as DCTO,
					vou.Glosa,
					
					(vou.MtoD) as DebeMN,
                			(vou.MtoH) as HaberMN,
					(vou.MtoD_ME) as DebeME,
			                (vou.MtoH_ME) as HaberME
					
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				left join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux
				left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''LD'') and vou.IB_Anulado<>1 
				'+@Registros+'
			      '
	end
end

DECLARE @RC_Det nvarchar(4000)
Set @RC_Det = ''

IF(@InfRC = 1)
begin
	IF(@InfCB = 1 or @InfLD = 1) Set @RC_Det = ' Union All '
	IF(@DetRC = 1)
	begin
		Set @RC_Det = @RC_Det+' select
					vou.RucE, emp.RSocial,
					vou.Cd_Fte,
					''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000'' as RegCtb,
					vou.Prdo,
					--convert(varchar,dateadd( month,1,''01/''+right(''00''+Month(vou.FecMov),2)+''/'+@Ejer+''')-1,103) as FecReg,
					Case(vou.Prdo) when ''00'' then ''31/00/''+'''+@Ejer+''' else convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) end as FecReg,
					vou.NroCta,cta.NomCta,
					'''' as Cd_Aux,'''' as NomAux,
					'''' as TD, '''' as DCTO,
					''Centra. mes ''+right(''00''+Month(vou.FecMov),2) Glosa,
					
					Sum(vou.MtoD) as DebeMN,
                			Sum(vou.MtoH) as HaberMN,
					Sum(vou.MtoD_ME) as DebeME,
			                Sum(vou.MtoH_ME) as HaberME
					
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				left join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux
				left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''RC'') and vou.IB_Anulado<>1 
				'+@Registros+'
				Group by vou.RucE,emp.RSocial,vou.Cd_Fte,''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000'',
				vou.Prdo,Case(vou.Prdo) when ''00'' then ''31/00/''+'''+@Ejer+''' else convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) end,
				vou.NroCta,cta.NomCta,''Centra. mes ''+right(''00''+Month(vou.FecMov),2)
			      '
	end
	ELSE
	begin
		Set @RC_Det = @RC_Det+'
				select
					vou.RucE, emp.RSocial,
					vou.Cd_Fte,
					vou.RegCtb,
					vou.Prdo,
					Convert(varchar,vou.FecMov,103) as FecReg,
					vou.NroCta,cta.NomCta,
					vou.Cd_Aux,aux.NDoc as NomAux,
					vou.Cd_TD as TD, vou.NroSre+''-''+vou.NroDoc as DCTO,
					vou.Glosa,
					
					(vou.MtoD) as DebeMN,
                			(vou.MtoH) as HaberMN,
					(vou.MtoD_ME) as DebeME,
			                (vou.MtoH_ME) as HaberME
					
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				left join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux
				left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''RC'') and vou.IB_Anulado<>1 
				'+@Registros+'
			      '
	end
end

DECLARE @RV_Det nvarchar(4000)
Set @RV_Det = ''

IF(@InfRV = 1)
begin
	IF(@InfCB = 1 or @InfLD = 1 or @InfRC = 1) Set @RV_Det = ' Union All '
	IF(@DetRV = 1)
	begin
		Set @RV_Det = @RV_Det+' select
					vou.RucE, emp.RSocial,
					vou.Cd_Fte,
					''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000'' as RegCtb,
					vou.Prdo,
					--convert(varchar,dateadd( month,1,''01/''+right(''00''+Month(vou.FecMov),2)+''/'+@Ejer+''')-1,103) as FecReg,
					Case(vou.Prdo) when ''00'' then ''31/00/''+'''+@Ejer+''' else convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) end as FecReg,
					vou.NroCta,cta.NomCta,
					'''' as Cd_Aux,'''' as NomAux,
					'''' as TD, '''' as DCTO,
					''Centra. mes ''+right(''00''+Month(vou.FecMov),2) Glosa,
					
					Sum(vou.MtoD) as DebeMN,
                			Sum(vou.MtoH) as HaberMN,
					Sum(vou.MtoD_ME) as DebeME,
			                Sum(vou.MtoH_ME) as HaberME
					
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				left join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux
				left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''RV'') and vou.IB_Anulado<>1 
				'+@Registros+'
				Group by vou.RucE,emp.RSocial,vou.Cd_Fte,''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000'',
				vou.Prdo,Case(vou.Prdo) when ''00'' then ''31/00/''+'''+@Ejer+''' else convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) end,
				vou.NroCta,cta.NomCta,''Centra. mes ''+right(''00''+Month(vou.FecMov),2)
			      '
	end
	ELSE
	begin
		Set @RV_Det = @RV_Det+'
				select
					vou.RucE, emp.RSocial,
					vou.Cd_Fte,
					vou.RegCtb,
					vou.Prdo,
					Convert(varchar,vou.FecMov,103) as FecReg,
					vou.NroCta,cta.NomCta,
					vou.Cd_Aux,aux.NDoc as NomAux,
					vou.Cd_TD as TD, vou.NroSre+''-''+vou.NroDoc as DCTO,
					vou.Glosa,
					
					(vou.MtoD) as DebeMN,
                			(vou.MtoH) as HaberMN,
					(vou.MtoD_ME) as DebeME,
			                (vou.MtoH_ME) as HaberME
					
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				left join Auxiliar aux on aux.RucE=vou.RucE and aux.Cd_Aux=vou.Cd_Aux
				left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''RV'') and vou.IB_Anulado<>1 
				'+@Registros+'
			      '
	end


PRINT @CB_Det
PRINT @LD_Det
PRINT @RC_Det
PRINT @RV_Det


Exec (@CB_Cab+@LD_Cab+@RC_Cab+@RV_Cab+'Order by 3,4')
Exec (@CB_Det+@LD_Det+@RC_Det+@RV_Det+'Order by 3,4,7')
end
------CODIGO DE MODIFICACION--------
--CM=MG01
GO

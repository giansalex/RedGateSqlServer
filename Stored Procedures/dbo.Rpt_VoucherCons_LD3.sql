SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
--exec Rpt_VoucherCons_LD3 '11111111111','2012','01','12','01',1,1,1,1,1,1,1,1,'','',null
CREATE Procedure [dbo].[Rpt_VoucherCons_LD3]
@RucE nvarchar(11),--Reg.Unico de Contribuyentes de la Empr.
@Ejer nvarchar(4),--Ejercicio(2009,2010..)
@PrdoIni nvarchar(2),--Periodo inicial de la consulta (01,02,03..)
@PrdoFin nvarchar(2),--Periodo final de la consulta (01,02,03..)
@Moneda nvarchar(2),--Codigo de la Moneda (01,02...)
@InfCB bit,-- Realiza un union all?
@InfLD bit,-- Realiza un union all?
@InfRV bit,-- Realiza un union all?
@InfRC bit,-- Realiza un union all?
@DetCB bit,-- si elije CB
@DetLD bit,-- si elije LD
@DetRV bit,-- si elije RV
@DetRC bit,-- si elije RC
@Rango1 nvarchar(5),--Rango de Nro.Cta 1 (10.0.1.10,...)
@Rango2 nvarchar(5),--Rango de Nro.Cta 2 (99999..)
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



if not exists(select * from voucher where RucE=@RucE and Ejer=@Ejer and Prdo between @PrdoIni and @PrdoFin )
	begin
		select top 1
		@RucE as RucE,
		Rsocial as RSocial,
		'--' as RegCtb,
		case(@Moneda) when '01' then 'En Nuevos Soles' else 'En Dólares Americanos' end as TipoMoneda,
		@PrdoIni +' al '+ @PrdoFin+' del '+ @Ejer as Periodo
		--from voucher
		from Empresa
		Where Ruc=@RucE-- and Ejer=@Ejer

		select top 1
		@RucE as RucE,
		Rsocial as RSocial,
		'--' as RegCtb,
		'--' as Prdo,
		'--' as FechaReg,
		'--' as NroCta,
		'--' as Cd_Aux,
		'--' as NomAux,
		'--' as TD,
		'--' as DCTO,
		'** SIN OPERACIONES **' as Glosa,
		case(@Moneda) when '01' then 0.00 else 0.00 end as Debe,
		case(@Moneda) when '01' then 0.00 else 0.00 end as Haber		
		--from Voucher
		from Empresa
		where Ruc=@RucE-- and Ejer=@Ejer
	end
else
begin

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
					case('''+@Moneda+''') when '+'''01'''+' then '+'''En Nuevos Soles'''+' else '+'''En Dólares Americanos'''+' end as TipoMoneda,
					'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''CB'')'+@Registros+' --and vou.IB_Anulado<>1
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
					case('''+@Moneda+''') when '+'''01'''+' then '+'''En Nuevos Soles'''+' else '+'''En Dólares Americanos'''+' end as TipoMoneda,
					'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''CB'')'+@Registros+' --and vou.IB_Anulado<>1
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
					case('''+@Moneda+''') when '+'''01'''+' then '+'''En Nuevos Soles'''+' else '+'''En Dólares Americanos'''+' end as TipoMoneda,
					'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''LD'')'+@Registros+' --and vou.IB_Anulado<>1
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
					case('''+@Moneda+''') when '+'''01'''+' then '+'''En Nuevos Soles'''+' else '+'''En Dólares Americanos'''+' end as TipoMoneda,
					'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''LD'')'+@Registros+' --and vou.IB_Anulado<>1
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
					case('''+@Moneda+''') when '+'''01'''+' then '+'''En Nuevos Soles'''+' else '+'''En Dólares Americanos'''+' end as TipoMoneda,
					'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''RC'')'+@Registros+' --and vou.IB_Anulado<>1
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
					case('''+@Moneda+''') when '+'''01'''+' then '+'''En Nuevos Soles'''+' else '+'''En Dólares Americanos'''+' end as TipoMoneda,
					'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''RC'')'+@Registros+' --and vou.IB_Anulado<>1
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
					case('''+@Moneda+''') when '+'''01'''+' then '+'''En Nuevos Soles'''+' else '+'''En Dólares Americanos'''+' end as TipoMoneda,
					'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''RV'')'+@Registros+' --and vou.IB_Anulado<>1
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
					case('''+@Moneda+''') when '+'''01'''+' then '+'''En Nuevos Soles'''+' else '+'''En Dólares Americanos'''+' end as TipoMoneda,
					'''+@PrdoIni+'''+'+''' al '''+'+'''+@PrdoFin+'''+'+''' del '''+'+'''+@Ejer+''' as Periodo
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''RV'')'+@Registros+' --and vou.IB_Anulado<>1
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
					--convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) as FecReg,
					Case(vou.Prdo) when ''00'' then ''31/00/''+'''+@Ejer+''' else convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) end as FecReg,
					--convert(nvarchar,vou.FecReg,103) as FecReg,
					vou.NroCta,cta.NomCta,
					'''' as Cd_Aux,'''' as NomAux,
					'''' as TD, '''' as DCTO,
					Case when vou.IB_Anulado=1 then ''(ANULADO)'' else '''' end + 
					''Centra. mes ''+vou.Prdo as Glosa,
					
					Case when vou.IB_Anulado=1 then 0.00 else
						Sum(Case('''+@Moneda+''') when ''01'' then vou.MtoD								      
				   	      		  else vou.MtoD_ME
						end) 
					end as Debe,
					
					Case when vou.IB_Anulado=1 then 0.00 else
						Sum(Case('''+@Moneda+''') when ''01'' then vou.MtoH 
								 		  else vou.MtoH_ME
						end) 
					end as Haber
										
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				left join Cliente2 c on c.RucE=vou.RucE and vou.Cd_Clt = c.Cd_Clt
				left join Proveedor2 p on p.RucE=vou.RucE and vou.Cd_Prv = p.Cd_Prv
				
				left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''CB'') --and vou.IB_Anulado<>1 
				'+@Registros+'
				Group by vou.RucE,emp.RSocial,vou.Cd_Fte,''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000'',
				vou.Prdo,
				--Case(vou.Prdo) when ''00'' then ''31/00/''+'''+@Ejer+''' else convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) end,
				convert(nvarchar,vou.FecReg,103),
				vou.NroCta,cta.NomCta,''Centra. mes ''+vou.Prdo,vou.IB_Anulado

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
					--Se cambio la tabla auxiliar por ciente2 y proveedor2
					case(isnull(len(vou.Cd_Clt),0)) when 0 then p.Cd_Prv else c.Cd_Clt end as Cd_Aux,
					case(isnull(len(vou.Cd_Clt),0)) when 0 then p.NDoc else c.NDoc end as NomAux,
					
					vou.Cd_TD as TD, vou.NroSre+''-''+vou.NroDoc as DCTO,
					Case when vou.IB_Anulado=1 then ''(ANULADO)'' else '''' end + 
					vou.Glosa as Glosa,
					
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

				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				left join Cliente2 c on c.RucE=vou.RucE and vou.Cd_Clt = c.Cd_Clt
				left join Proveedor2 p on p.RucE=vou.RucE and vou.Cd_Prv = p.Cd_Prv
				
				left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''CB'') --and vou.IB_Anulado<>1 
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
					--convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) as FecReg,
					Case(vou.Prdo) when ''00'' then ''31/00/''+'''+@Ejer+''' else convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) end as FecReg,
					--convert(nvarchar,vou.FecReg,103) as FecReg,
					vou.NroCta,cta.NomCta,
					'''' as Cd_Aux,'''' as NomAux,
					'''' as TD, '''' as DCTO,
					Case when vou.IB_Anulado=1 then ''(ANULADO)'' else '''' end + 
					''Centra. mes ''+vou.Prdo as Glosa,
					
					Case when vou.IB_Anulado=1 then 0.00 else
						Sum(Case('''+@Moneda+''') when ''01'' then vou.MtoD								      
				   	      		  else vou.MtoD_ME
						end)
					End as Debe,
			
					Case when vou.IB_Anulado=1 then 0.00 else
						Sum(Case('''+@Moneda+''') when ''01'' then vou.MtoH 
								 		  else vou.MtoH_ME
						end)
					End as Haber
					
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				left join Cliente2 c on c.RucE=vou.RucE and vou.Cd_Clt = c.Cd_Clt
				left join Proveedor2 p on p.RucE=vou.RucE and vou.Cd_Prv = p.Cd_Prv
				
				left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''LD'') --and vou.IB_Anulado<>1 
				'+@Registros+'
				Group by vou.RucE,emp.RSocial,vou.Cd_Fte,''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000'',
				vou.Prdo,
				--Case(vou.Prdo) when ''00'' then ''31/00/''+'''+@Ejer+''' else convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) end,
				convert(nvarchar,vou.FecReg,103),
				vou.NroCta,cta.NomCta,''Centra. mes ''+vou.Prdo,vou.IB_Anulado
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
					--Se cambio la tabla auxiliar por ciente2 y proveedor2
					case(isnull(len(vou.Cd_Clt),0)) when 0 then p.Cd_Prv else c.Cd_Clt end as Cd_Aux,
					case(isnull(len(vou.Cd_Clt),0)) when 0 then p.NDoc else c.NDoc end as NomAux,
					
					vou.Cd_TD as TD, vou.NroSre+''-''+vou.NroDoc as DCTO,
					Case when vou.IB_Anulado=1 then ''(ANULADO)'' else '''' end + 
					vou.Glosa as Glosa,
					
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

				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				left join Cliente2 c on c.RucE=vou.RucE and vou.Cd_Clt = c.Cd_Clt
				left join Proveedor2 p on p.RucE=vou.RucE and vou.Cd_Prv = p.Cd_Prv
				left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''LD'') --and vou.IB_Anulado<>1 
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
					--convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) as FecReg,
					Case(vou.Prdo) when ''00'' then ''31/00/''+'''+@Ejer+''' else convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) end as FecReg,
					--convert(nvarchar,vou.FecReg,103) as FecReg,
					vou.NroCta,cta.NomCta,
					'''' as Cd_Aux,'''' as NomAux,
					'''' as TD, '''' as DCTO,
					Case when vou.IB_Anulado=1 then ''(ANULADO)'' else '''' end + 
					''Centra. mes ''+vou.Prdo as Glosa,
					
					Case when vou.IB_Anulado=1 then 0.00 else
						Sum(Case('''+@Moneda+''') when ''01'' then vou.MtoD								      
				   	      		  else vou.MtoD_ME
						end)
					End as Debe,

					Case when vou.IB_Anulado=1 then 0.00 else				
						Sum(Case('''+@Moneda+''') when ''01'' then vou.MtoH 
								 		  else vou.MtoH_ME
						end)
					End as Haber
					
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				left join Cliente2 c on c.RucE=vou.RucE and vou.Cd_Clt = c.Cd_Clt
				left join Proveedor2 p on p.RucE=vou.RucE and vou.Cd_Prv = p.Cd_Prv
				left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''RC'') --and vou.IB_Anulado<>1 
				'+@Registros+'
				Group by vou.RucE,emp.RSocial,vou.Cd_Fte,''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000'',
				vou.Prdo,
				--Case(vou.Prdo) when ''00'' then ''31/00/''+'''+@Ejer+''' else convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) end,
				convert(nvarchar,vou.FecReg,103),
				vou.NroCta,cta.NomCta,''Centra. mes ''+vou.Prdo,vou.IB_Anulado
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
					--Se cambio la tabla auxiliar por ciente2 y proveedor2
					case(isnull(len(vou.Cd_Clt),0)) when 0 then p.Cd_Prv else c.Cd_Clt end as Cd_Aux,
					case(isnull(len(vou.Cd_Clt),0)) when 0 then p.NDoc else c.NDoc end as NomAux,
					
					vou.Cd_TD as TD, vou.NroSre+''-''+vou.NroDoc as DCTO,
					Case when vou.IB_Anulado=1 then ''(ANULADO)'' else '''' end + 
					vou.Glosa as Glosa,
					
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
					
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				left join Cliente2 c on c.RucE=vou.RucE and vou.Cd_Clt = c.Cd_Clt
				left join Proveedor2 p on p.RucE=vou.RucE and vou.Cd_Prv = p.Cd_Prv
				
				left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''RC'') --and vou.IB_Anulado<>1 
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
					--convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) as FecReg,
					Case(vou.Prdo) when ''00'' then ''31/00/''+'''+@Ejer+''' else convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) end as FecReg,
					--Convert(nvarchar,vou.FecReg,103) as FecReg,
					vou.NroCta,cta.NomCta,
					'''' as Cd_Aux,'''' as NomAux,
					'''' as TD, '''' as DCTO,
					Case when vou.IB_Anulado=1 then ''(ANULADO)'' else '''' end + 
					''Centra. mes ''+vou.Prdo as Glosa,
					
					Case when vou.IB_Anulado=1 then 0.00 else	
						Sum(Case('''+@Moneda+''') when ''01'' then vou.MtoD								      
				   	      		  else vou.MtoD_ME
						end)
					End as Debe,
					
					Case when vou.IB_Anulado=1 then 0.00 else	
						Sum(Case('''+@Moneda+''') when ''01'' then vou.MtoH 
								 		  else vou.MtoH_ME
						end)
					End as Haber
					
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				left join Cliente2 c on c.RucE=vou.RucE and vou.Cd_Clt = c.Cd_Clt
				left join Proveedor2 p on p.RucE=vou.RucE and vou.Cd_Prv = p.Cd_Prv
				left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''RV'') --and vou.IB_Anulado<>1 
				'+@Registros+'
				Group by vou.RucE,emp.RSocial,vou.Cd_Fte,''CTGE_''+substring(vou.RegCtb,6,2)+vou.Prdo+''-00000'',
				vou.Prdo,
				--Case(vou.Prdo) when ''00'' then ''31/00/''+'''+@Ejer+''' else convert(varchar,dateadd( month,1,''01/''+vou.Prdo+''/'+@Ejer+''')-1,103) end,
				Convert(nvarchar,vou.FecReg,103),
				vou.NroCta,cta.NomCta,''Centra. mes ''+vou.Prdo,vou.IB_Anulado
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
					--se cambio la tabla auxiliar por cliente2 y proveedor2
					case(isnull(len(vou.Cd_Clt),0)) when 0 then p.Cd_Prv else c.Cd_Clt end as Cd_Aux,
					case(isnull(len(vou.Cd_Clt),0)) when 0 then p.NDoc else c.NDoc end as NomAux,
					
					vou.Cd_TD as TD, vou.NroSre+''-''+vou.NroDoc as DCTO,
					Case when vou.IB_Anulado=1 then ''(ANULADO)'' else '''' end + 
					vou.Glosa as Glosa,
					
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
					
				from Voucher vou
				left join Empresa emp on emp.Ruc=vou.RucE
				left join Cliente2 c on c.RucE=vou.RucE and vou.Cd_Clt = c.Cd_Clt
				left join Proveedor2 p on p.RucE=vou.RucE and vou.Cd_Prv = p.Cd_Prv
				left join PlanCtas cta on cta.RucE=vou.RucE and cta.NroCta=vou.NroCta and cta.Ejer=vou.Ejer 
				where vou.RucE='''+@RucE+''' and vou.Ejer='''+@Ejer+''' and vou.Prdo between '''+@PrdoIni+''' and '''+@PrdoFin+''''+' and vou.Cd_Fte in (''RV'') --and vou.IB_Anulado<>1 
				'+@Registros+'
			      '
	end
end

PRINT @CB_Det
PRINT @LD_Det
PRINT @RC_Det
PRINT @RV_Det


Exec (@CB_Cab+@LD_Cab+@RC_Cab+@RV_Cab+'Order by 3,4')
declare @ConsIni varchar(1000)
declare @ConsFin varchar(1000)

Exec (@CB_Det+@LD_Det+@RC_Det+@RV_Det+'Order by 3,4,7')
end
--Jesus -> 06/07/2010 : Modificado -> Se agrego la condicion para que 'marque' el Ruc,Prdo cuando no haya registros
-- PP : 2010-07-08 12:25:18.127	: <Solucione tu mariconada CHUCHUSO del procedimiento almacenado emer :"Oye animal como te as podido olvidar als demas fuentes no todo es CB">
-- PP : 2010-07-08 23:23:54.732	: <Solucione tu mariconada CHUCHUSO del procedimiento almacenado como te vas a malogra los anulados">
-- DI : 2010-12-14 00:00:00.000 : <Mostrar cero en registros anulados y mostrar Texto Anulado en la glosa>
-- JA : 2011-10-06 : <Modificado>  --> Cambie el auxiliar por cliente2 y proveedor2 
-- JA : 2011-16-10 : <Modificado> : Cambie el contenido del texto cuando no presenta informacion a SIN OPERACIONES
--Ejemplos:
--exec Rpt_VoucherCons_LD3 '11111111111','2010','01','12','01','1','0','0','0','0','0','0','0','','',null--S/. Con Reg.
--exec Rpt_VoucherCons_LD3 '11111111111','2010','11','12','01','1','0','0','0','0','0','0','0','','',null--S/. Sin Reg.
--exec Rpt_VoucherCons_LD3 '11111111111','2010','01','12','02','1','0','0','0','0','0','0','0','','',null--$USS Con Reg.
--exec Rpt_VoucherCons_LD3 '11111111111','2010','11','12','02','1','0','0','0','0','0','0','0','','',null--$USS Sin Reg.
GO

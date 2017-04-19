SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--pvo.Ctb_AsientoAutomatico '20512141022 ', '2012', 'PPPP_RV03-00174', '007','VT00000353', null



CREATE procedure [pvo].[Ctb_AsientoAutomatico]
@RucE nvarchar(11),
@Ejer nvarchar(4), 
@RegCtb nvarchar(15),
@Cd_MIS char(3),
@Cod varchar(15), 
@msj varchar(100) output

as
declare @Cd_TM char(2), @Val_Obt varchar(50), @Val_Cal numeric(13,2), @IC_DetCab char(1), @NomCol varchar(50), @Glosa_Fmla varchar(200)

declare @NomTabla varchar(50), @NomTablaDet varchar(50), @colCodTab varchar(50), @colCodTabDet varchar(50)

select @Cd_TM = Cd_TM from MtvoIngSal where RucE=@RucE and Cd_MIS=@Cd_MIS
print 'Tabla a usar: ' + @Cd_TM

if (@Cd_TM='01')
begin	
	if not exists (select * from Venta where RucE=@RucE and Cd_Vta=@Cod)
		set @msj = 'Venta no existe. No se pudo generar voucher contable'
end
else if (@Cd_TM='02')
begin
	if not exists (select * from Compra where RucE=@RucE and Cd_Com=@Cod)
		set @msj = 'Compra no existe. No se pudo generar voucher contable'
end
else if (@Cd_TM='05')
begin
	if not exists (select * from Inventario where RucE=@RucE and Ejer=@Ejer and RegCtb=@Cod)
		set @msj = 'Movimiento de inventario no existe. No se pudo generar voucher contable'
end
else if (@Cd_TM='08')
begin
	if not exists (select * from CanjePago where RucE=@RucE and Cd_Cnj=@Cod)
		set @msj = 'Movimiento de Canje de letra no existe. No se pudo generar voucher contable'
end
else if (@Cd_TM='09')
begin
	if not exists (select * from Canje where RucE=@RucE and Cd_Cnj=@Cod)
		set @msj = 'Movimiento de Canje de letra no existe. No se pudo generar voucher contable'
end
else if (@Cd_TM='14')
begin
	if not exists (select * from Liquidacion where RucE=@RucE and Cd_Liq=@Cod)
		set @msj = 'Movimiento de Liquidacion no existe. No se pudo generar voucher contable'
end

if exists (select * from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
begin
	set @msj = 'IMPOSIBLE MAYORIZAR. Ya exite voucher con este Reg. Contable, elimine asiento y vuelva a registrar'
	print @msj
	return
end

declare
@Cta	char(10),
@CtaME char(10),
@IC_JDCtaPA char(1),
@IC_CaAb char(1),
@IN_TipoCta int,
@Cd_IV	char(3),
@Porc	numeric(5,2),
@Fmla	varchar(200),
@IC_PFI	char(1),
@Glosa	varchar(100),
@IC_VFG	char(1),
@Cd_CC	nvarchar(8),
@Cd_SC	nvarchar(8),
@Cd_SS	nvarchar(8),
@IC_JDCC char(1),
@IB_Aux	bit,
@IB_EsDes bit,
@IB_JalaAmr bit,
@Cd_IA char(1),
@IC_ES char(1),
@Prdo		nvarchar(2),
@Cd_Fte	varchar(2) = right(left(@RegCtb,7),2),
@FecMov	smalldatetime,
@FecCbr	smalldatetime,
@NroCta	nvarchar(12),
@CtaAsoc nvarchar(12),
@Cd_Clt	char(10),
@Cd_Prv	char(7),
@Cd_TD	nvarchar(2),
@NroSre	nvarchar(4),
@NroDoc	nvarchar(15),
@FecED	smalldatetime,
@FecVD	smalldatetime,
@MtoOr	numeric(13,2) = 0,
@MtoD		numeric(13,2),
@MtoH		numeric(13,2),
@Cd_MdOr 	nvarchar(2) = '01',
@Cd_MdRg 	nvarchar(2),
@CamMda 	numeric(6,3),
@Cd_Area 	nvarchar(6),
@Cd_MR	nvarchar(2),
@NroChke 	varchar(30),
@Cd_TG	nvarchar(2) = '01',
@IC_CtrMd	varchar(1) = 'a',
@UsuCrea 	nvarchar(10),
@IB_Anulado 	bit,
@SaldoMN	decimal(13,2),
@SaldoME	decimal(13,2),
@TipMov		varchar(1) = 'M',
@IC_TipAfec 	varchar(1),
@TipOper 	varchar(4),
@Grdo	 	varchar(100),
@RegOrg		nvarchar(15),
@IC_Crea	varchar(1) = 'I', 
@IB_PgTot	bit = 1, 
@IB_EsProv	bit = 1, 
@DR_FecED	smalldatetime,
@DR_CdTD	nvarchar(2),
@DR_NSre	nvarchar(4),
@DR_NDoc	nvarchar(15),
@DR_NCND	varchar(15),
@DR_NroDet	varchar(15),
@DR_FecDet	smalldatetime,
@NroCta_Temp nvarchar(12),
@IC_Tipo char(1) = (select IC_Tipo from MtvoIngSal where RucE = @RucE and Cd_MIS = @Cd_Mis)

if (@Cd_TM='01')
begin
	set @Cd_MR='01' 
	set @NomTabla = 'Venta'
	set @NomTablaDet = 'VentaDet'
	set @colCodTab = 'Cd_Vta' 
	set @colCodTabDet = 'Nro_RegVdt'

	select @Prdo=Prdo, @FecMov=FecMov, @FecCbr=FecCbr, @Cd_TD=Cd_TD, @NroSre=NroSre,
	@FecED=FecED, @FecVD=FecVD, @Cd_MdRg=Cd_Mda, @CamMda=CamMda, @Cd_Area=Cd_Area,@UsuCrea=UsuCrea, @NroDoc=NroDoc,
	@DR_FecED=DR_FecED, @DR_CdTD=DR_CdTD, @DR_NSre=DR_NSre, @DR_NDoc=DR_NDoc, @IB_Anulado = IB_Anulado
	from venta where RucE=@RucE and Cd_Vta = @Cod
	
	print 'sacamos valor de venta'
end
else if (@Cd_TM='02') 
begin
	set @Cd_MR='02' 
	set @NomTabla = 'Compra'
	set @NomTablaDet = 'CompraDet'
	set @colCodTab = 'Cd_Com' 
	set @colCodTabDet = 'Item'

	select @Prdo=Prdo, @FecMov=FecMov, @FecCbr=FecAPag, @Cd_TD=Cd_TD, @NroSre=NroSre, @NroDoc=NroDoc,@FecED=FecED, 
	@FecVD=FecVD, @Cd_MdRg=Cd_Mda, @CamMda=CamMda,  @Cd_Area=Cd_Area, @UsuCrea=UsuCrea, @DR_NCND=DR_NCND, @DR_NroDet=DR_NroDet, @DR_FecDet=DR_FecDet,
	@DR_FecED=DR_FecED, @DR_CdTD=DR_CdTD, @DR_NSre=DR_NSre, @DR_NDoc=DR_NDoc, @IB_Anulado = IB_Anulado
	from Compra where RucE=@RucE and Cd_Com = @Cod
	
	print 'sacamos valor de compra'
end
else if (@Cd_TM='05') 
begin
	set @Cd_MR='05' 
	set @NomTabla = 'Inventario'
	set @NomTablaDet = 'Inventario' 
	set @colCodTab = 'Ejer = '''+@Ejer+''' and RegCtb' 
	set @colCodTabDet = 'Cd_Inv'

	select  top 1
	@Prdo=left(convert(varchar,FecMov,1),2), @FecMov=FecMov, @Cd_Area=Cd_Area, @Cd_MdRg=Cd_Mda, @UsuCrea=UsuCrea 
	from Inventario where RucE=@RucE and Ejer=@Ejer and RegCtb = @Cod 

	print 'sacamos valor de Inventario'
end
else if (@Cd_TM ='08') 
begin
	set @Cd_MR='08'
	set @NomTabla = 'CanjePago'
	set @colCodTab = 'Cd_Cnj' 
	
	select  top 1
	@Prdo=Prdo, @FecMov=FecMov, @Cd_Area=Cd_Area, @Cd_MdRg=Cd_Mda, @UsuCrea=UsuReg 
	from Canje where RucE=@RucE and Cd_Cnj = @Cod

	print 'sacamos valor de Letras de Pago'
end
else if (@Cd_TM ='09') 
begin
	set @Cd_MR='09' 
	set @NomTabla = 'Canje'
	set @colCodTab = 'Cd_Cnj' 
	
	select  top 1
	@Prdo=Prdo, @FecMov=FecMov, @Cd_Area=Cd_Area, @Cd_MdRg=Cd_Mda, @UsuCrea=UsuReg 
	from Canje where RucE=@RucE and Cd_Cnj = @Cod

	print 'sacamos valor de Letras'
end 
else if (@Cd_TM='14')
begin
	set @Cd_MR='14' 
	set @NomTabla = 'Liquidacion'
	set @NomTablaDet = 'LiquidacionDet'
	set @colCodTab = 'Cd_Liq' 
	set @colCodTabDet = 'Item'

	select @Prdo=left(right(RegCtb,8),2), @FecMov=FechaAper, @Cd_MdRg=Cd_Mda, @CamMda=CamMda, @Cd_Area=Cd_Area,@UsuCrea=UsuAper
	from Liquidacion where RucE=@RucE and Cd_Liq = left(@Cod,10)
	
	print 'sacamos valor de Liquidacion'
end

if @FecED is null
   set @FecED = @FecMov

if isnull(@CamMda,0)<= 0 
begin
	set @CamMda = (select isnull(TCVta, 1) from TipCam where convert(varchar,FecTC,103) = convert(varchar,@FecMov,103) )
	print 'Tipo Cambio: ' + convert(varchar,@CamMda)
end

print '---- INICIO CURSOR ASIENTO ----'	
declare Cur_Asiento cursor for select Cta, CtaME, IC_JDCtaPA, IC_CaAb, IN_TipoCta, Cd_IV, Porc, Fmla, IC_PFI, Glosa, IC_VFG, Cd_CC, Cd_SC, Cd_SS, IC_JDCC, IB_Aux, IB_EsDes, IB_JalaAmr, Cd_IA, IC_ES from Asiento where RucE=@RucE and Cd_MIS=@Cd_MIS and Ejer=@Ejer and Cd_TM = @Cd_TM
	open Cur_Asiento		   --JalaDefineCta_ProdAux
		fetch Cur_Asiento into @Cta, @CtaME, @IC_JDCtaPA, @IC_CaAb, @IN_TipoCta, @Cd_IV, @Porc, @Fmla, @IC_PFI, @Glosa_Fmla, @IC_VFG, @Cd_CC, @Cd_SC, @Cd_SS, @IC_JDCC, @IB_Aux, @IB_EsDes, @IB_JalaAmr, @Cd_IA, @IC_ES
		while (@@fetch_status=0)
		begin

			if @Cd_MdRg='01'
				set @NroCta_Temp = @Cta
			else --if @Cd_MdRg='02'
				set @NroCta_Temp = @CtaME
			set @NroCta = @NroCta_Temp

			declare @sql nvarchar(2000)
			select @NomCol=NomCol, @IC_DetCab=IC_DetCab from IndicadorValor where Cd_IV=@Cd_IV and Cd_TM = @Cd_TM
			print 'Parametros Cursor cabecera: ' + @Cta +' - '+ @CtaME +' - '+  @NomCol +' - '+ @IC_DetCab +' - GlosaFM: '+ @Glosa_Fmla +' - '+ @IC_VFG +' - '+ isnull(@Cd_IA, '')

			if @IB_Aux = 1
			begin
				if (@Cd_TM='01') -- si es venta:
					select @Cd_Clt=Cd_Clt from venta where RucE=@RucE and Cd_Vta = @cod 
				else if (@Cd_TM='02') -- si es compra:
					select @Cd_Prv=Cd_Prv from Compra where RucE=@RucE and Cd_Com = @cod
				else if (@Cd_TM='05') -- si es Inventario:
					select @Cd_Prv=Cd_Prv, @Cd_Clt=Cd_Clt from Inventario where RucE=@RucE and Ejer=@Ejer and RegCtb = @Cod 
				else if (@Cd_TM='08') -- si es Letra:
					select @Cd_Prv=Cd_Prv from CanjePago where RucE=@RucE and Cd_Cnj = @cod
				else if (@Cd_TM='09') -- si es Letra:
					select @Cd_Clt=Cd_Clt from Canje where RucE=@RucE and Cd_Cnj = @cod
			
			
				print 'Cliente: '+ @Cd_Clt
				print 'Proveedor: '+ @Cd_Prv
			end
			else 
			begin	
				print '--- NOOOOO TIENE AUXILIAR ---'
				set @Cd_Clt = null
				set @Cd_Prv = null
			end 

			if (@IC_DetCab='d') -- si es detalle(d):
			begin
				print  '------ INICIO SUB_CURSOR ' +@NomTabla+ ' DETALLE ------'	
				declare @Cod_Item varchar(30)

				if (@Cd_TM='01') -- si es venta:
					declare Cur_TabDet cursor for select Nro_RegVdt from VentaDet where RucE=@RucE and Cd_Vta=@Cod 
				else if (@Cd_TM='02') -- si es compra:
					declare Cur_TabDet cursor for select Item from CompraDet where RucE=@RucE and Cd_Com=@Cod 
				else if (@Cd_TM='05') -- si es Inventarios:
				begin
					if(@IC_ES = 'A')
						declare Cur_TabDet cursor for select Cd_Inv from Inventario where RucE=@RucE and Ejer=@Ejer and RegCtb=@Cod
					else
						declare Cur_TabDet cursor for select Cd_Inv from Inventario where RucE=@RucE and Ejer=@Ejer and RegCtb=@Cod and IC_ES = @IC_ES							
				end
				else if (@Cd_TM='08' and  exists (select * from IndicadorValor where Cd_IV = @Cd_IV and Descrip like '%Det. Doc.%')) -- si es Letras:
				begin
					declare Cur_TabDet cursor for select Item from CanjePagoDet where RucE=@RucE and Cd_Cnj=@Cod 
					set @NomTablaDet = 'CanjePagoDet' --TODO
					set @colCodTabDet = 'Item' --TODO
				end
				else if (@Cd_TM='08' and  exists (select * from IndicadorValor where Cd_IV = @Cd_IV and Descrip like '%Det. Let.%')) -- si es Letras:
				begin
					declare Cur_TabDet cursor for select Cd_Ltr from Letra_Pago where RucE=@RucE and Cd_Cnj=@Cod
					set @NomTablaDet = 'Letra_Pago' --TODO
					set @colCodTabDet = 'Cd_Ltr' --TODO
				end
				else if (@Cd_TM='09' and  exists (select * from IndicadorValor where Cd_IV = @Cd_IV and Descrip like '%Det. Doc.%')) -- si es Letras:
				begin
					declare Cur_TabDet cursor for select Item from CanjeDet where RucE=@RucE and Cd_Cnj=@Cod 
					set @NomTablaDet = 'CanjeDet' --TODO
					set @colCodTabDet = 'Item' --TODO
				end
				else if (@Cd_TM='09' and  exists (select * from IndicadorValor where Cd_IV = @Cd_IV and Descrip like '%Det. Let.%')) -- si es Letras:
				begin
					declare Cur_TabDet cursor for select Cd_Ltr from Letra_Cobro where RucE=@RucE and Cd_Cnj=@Cod
					set @NomTablaDet = 'Letra_Cobro' --TODO
					set @colCodTabDet = 'Cd_Ltr' --TODO
				end
				else if (@Cd_TM='14') -- si es Liquidacion:
					if(@IC_Tipo = 'D')
						declare Cur_TabDet cursor for select Item from LiquidacionDet where RucE=@RucE and Cd_Liq=@Cod 
					else
						declare Cur_TabDet cursor for select Item from LiquidacionDet where RucE=@RucE and Cd_Liq=@Cod 
					
						open Cur_TabDet
							fetch Cur_TabDet into @Cod_Item
							while (@@fetch_status=0)
							begin
								if (@Cd_TM='09')
								begin
									declare @Cd_Doc varchar(10)
									if(@NomTablaDet = 'CanjeDet')
									begin
										set @IB_EsProv = 0
										select @Cd_Doc = isnull(Cd_Vta, isnull(convert(varchar, Cd_Vou), 'L'+convert(varchar, Cd_Ltr))) from CanjeDet where RucE = @RucE and Cd_cnj = @Cod and Item = @Cod_Item
										if(left(@Cd_Doc,2) = 'VT')
											select @Cd_TD = Cd_TD, @NroSre = NroSre, @NroDoc = NroDoc from Venta where RucE = @RucE and Cd_Vta = @Cd_Doc
										else if (left(@Cd_Doc,1) = 'L')
											select @Cd_TD = Cd_TD, @NroSre = null, @NroDoc = isnull(NroRenv, '')+ NroLtr from Letra_Cobro where RucE = @RucE and Cd_Ltr = right(@Cd_Doc, len(@Cd_Doc)-1)
										else
											select @Cd_TD = Cd_TD, @NroSre = null, @NroDoc = NroDoc from Voucher where RucE = @RucE and Cd_Vou = @Cd_Doc
									end
									else -- if(@NomTablaDet = 'Letra_Cobro')
										select @Cd_TD = Cd_TD, @NroSre = null, @NroDoc = isnull(NroRenv, '')+ NroLtr from Letra_Cobro where RucE = @RucE and Cd_cnj = @Cod and Cd_Ltr = @Cod_Item
									if (@NomTablaDet = 'Letra_Cobro')
										select @FecVD =  convert(smalldatetime, FecVenc) from Letra_Cobro where RucE=@RucE and Cd_Cnj=@Cod and Cd_Ltr = @Cod_Item									
								end									
								else if (@Cd_TM='08')
								begin
									if(@NomTablaDet = 'CanjePagoDet')
									begin
										set @IB_EsProv = 0
										select @Cd_Doc = isnull(Cd_Com, isnull(convert(varchar, Cd_Vou), 'L'+convert(varchar, Cd_Ltr))) from CanjePagoDet where RucE = @RucE and Cd_cnj = @Cod and Item = @Cod_Item
										if(left(@Cd_Doc,2) = 'CM')
											select @Cd_TD = Cd_TD, @NroSre = NroSre, @NroDoc = NroDoc from Compra where RucE = @RucE and Cd_Com = @Cd_Doc
										else if (left(@Cd_Doc,2) = 'L')
											select @Cd_TD = Cd_TD, @NroSre = null, @NroDoc = isnull(NroRenv, '')+ NroLtr from Letra_Pago where RucE = @RucE and Cd_Ltr = right(@Cd_Doc, len(@Cd_Doc)-1)
										else
											select @Cd_TD = Cd_TD, @NroSre = null, @NroDoc = NroDoc from Voucher where RucE = @RucE and Cd_Vou = @Cd_Doc
									end
									else -- if(@NomTablaDet = 'Letra_Pago')
										select @Cd_TD = Cd_TD, @NroSre = null, @NroDoc = isnull(NroRenv, '')+ NroLtr from Letra_Pago where RucE = @RucE and Cd_cnj = @Cod and Cd_Ltr = @Cod_Item
									if (@NomTablaDet = 'Letra_Pago')
										select @FecVD =  convert(smalldatetime, FecVenc) from Letra_Pago where RucE=@RucE and Cd_Cnj=@Cod and Cd_Ltr = @Cod_Item									
								end															
								else if(@Cd_TM='14')
									select @Cd_TD=Cd_TD, @NroSre=NroSre, @NroDoc=NroDoc,@FecED=FecED, @FecVD=FecVD, @Cd_MdRg=Cd_Mda, @CamMda=CamMda,  @Cd_Area=Cd_Area, @UsuCrea=UsuCrea									
										from LiquidacionDet where RucE=@RucE and Cd_Liq = @Cod and Item = @Cod_Item
								
								print 'nro de reg detalle: ' + convert(varchar, @Cod_Item)
								declare @CodProd varchar(10)
								
								if @IC_JDCtaPA = 'p' 
								begin 
									print 'Primero sacamos codigo Producto o Servicio de '+@NomTablaDet+' (Detalle) y registrasmos en la variable @CodProd'
									if (@Cd_TM='01') -- si es venta:
										select @CodProd = isnull(Cd_Prod,Cd_Srv) from VentaDet where RucE=@RucE and Cd_Vta=@Cod and Nro_RegVdt = @Cod_Item
									else if (@Cd_TM='02') -- si es compra:
										select @CodProd = isnull(Cd_Prod,Cd_Srv) from CompraDet where RucE=@RucE and Cd_Com=@Cod and Item = @Cod_Item
									else if (@Cd_TM='05') -- si es Inventarios:
										select @CodProd = Cd_Prod from Inventario where RucE=@RucE and Ejer=@Ejer and RegCtb=@Cod and Cd_Inv = @Cod_Item
									Print 'Codigo Prod: ' + @CodProd

									if @CodProd is not null or @CodProd != ''
									begin
										if left(@CodProd,1) = 'P' --Si es Producto
										begin
											if @IN_TipoCta = '1' 
												select @NroCta_Temp = Cta1 from Producto2 where RucE=@RucE and Cd_Prod=@CodProd
											else if @IN_TipoCta = '2' 
												select @NroCta_Temp = Cta2 from Producto2 where RucE=@RucE and Cd_Prod=@CodProd
											else if @IN_TipoCta = '3' 
												select @NroCta_Temp = Cta3 from Producto2 where RucE=@RucE and Cd_Prod=@CodProd
											else if @IN_TipoCta = '4' 
												select @NroCta_Temp = Cta4 from Producto2 where RucE=@RucE and Cd_Prod=@CodProd
											else if @IN_TipoCta = '5' 
												select @NroCta_Temp = Cta5 from Producto2 where RucE=@RucE and Cd_Prod=@CodProd
											else if @IN_TipoCta = '6' 
												select @NroCta_Temp = Cta6 from Producto2 where RucE=@RucE and Cd_Prod=@CodProd
											else if @IN_TipoCta = '7' 
												select @NroCta_Temp = Cta7 from Producto2 where RucE=@RucE and Cd_Prod=@CodProd
											else if @IN_TipoCta = '8' 
												select @NroCta_Temp = Cta8 from Producto2 where RucE=@RucE and Cd_Prod=@CodProd
										end 
										else	--Si es Servicio
										begin
											if @IN_TipoCta = '1' 
												select @NroCta_Temp = Cta1 from Servicio2 where RucE=@RucE and Cd_Srv=@CodProd
											else if @IN_TipoCta = '2' 
												select @NroCta_Temp = Cta2 from Servicio2 where RucE=@RucE and Cd_Srv=@CodProd
											else if @IN_TipoCta = '3' 
												select @NroCta_Temp = Cta3 from Servicio2 where RucE=@RucE and Cd_Srv=@CodProd
											else if @IN_TipoCta = '4' 
												select @NroCta_Temp = Cta4 from Servicio2 where RucE=@RucE and Cd_Srv=@CodProd
											else if @IN_TipoCta = '5' 
												select @NroCta_Temp = Cta5 from Servicio2 where RucE=@RucE and Cd_Srv=@CodProd
											else if @IN_TipoCta = '6' 
												select @NroCta_Temp = Cta6 from Servicio2 where RucE=@RucE and Cd_Srv=@CodProd
											else if @IN_TipoCta = '7' 
												select @NroCta_Temp = Cta7 from Servicio2 where RucE=@RucE and Cd_Srv=@CodProd
											else if @IN_TipoCta = '8' 
												select @NroCta_Temp = Cta8 from Servicio2 where RucE=@RucE and Cd_Srv=@CodProd
										end
									end
								end 
								else if @IC_JDCtaPA = 'A'
								begin
									if (@Cd_Clt is null  or @Cd_Clt = '') and (@Cd_Prv is null  or @Cd_Prv = '')
									begin
										if (@Cd_TM='01') -- si es venta:
											select @Cd_Clt=Cd_Clt from venta where RucE=@RucE and Cd_Vta = @cod 
										else if (@Cd_TM='02') -- si es compra:
											select @Cd_Prv=Cd_Prv from Compra where RucE=@RucE and Cd_Com = @cod											
										else if (@Cd_TM='05') -- si es Inventario:
											select @Cd_Prv=Cd_Prv, @Cd_Clt=Cd_Clt from Inventario where RucE=@RucE and Ejer=@Ejer and RegCtb = @Cod and Cd_Inv = @Cod_Item
										else if (@Cd_TM='09') -- si es Letra:
											select @Cd_Clt=Cd_Clt from Canje where RucE=@RucE and Cd_Cnj = @cod
										else if (@Cd_TM='14') -- si es Inventario:
											select @Cd_Prv=Cd_Prv, @Cd_Clt=Cd_Clt from LiquidacionDet where RucE=@RucE and Cd_Liq = @Cod and Item = @Cod_Item
									end										
									if @Cd_Clt is null  or @Cd_Clt = '' --es Proveedor
										select @NroCta_Temp = CtaCtb from Proveedor2 where RucE=@RucE and Cd_Prv=@Cd_Prv
									else
										select @NroCta_Temp = CtaCtb from Cliente2 where RucE=@RucE and Cd_Clt=@Cd_Clt									
								end
								else if @IC_JDCtaPA = 'B' --Banco
								begin						
									if (@Cd_TM='14') -- si es Inventario:
									begin
										declare @Itm_BC varchar(10)
										select @Itm_BC = Itm_BC from LiquidacionDet where RucE=@RucE and Cd_Liq = @Cod and Item = @Cod_Item									
										select @NroCta_Temp = NroCta from Banco where RucE=@RucE and Itm_BC = @Itm_BC
									end
								end
							
								if @NroCta_Temp is null or @NroCta_Temp=''
									begin
										if @Cd_MdRg='01'
											set @NroCta_Temp = @Cta
										else --if @Cd_MdRg='02'
											set @NroCta_Temp = @CtaME										
									end
								if @NroCta_Temp is null or @NroCta_Temp=''
									set @NroCta_Temp = '999999999'
								set @NroCta = @NroCta_Temp
								Print 'Nro Cta: ' + @NroCta

								if @IC_VFG='f'
								begin
									set @sql = 'select @Glsa_fmDet = '+@Glosa_Fmla+' from '+@NomTablaDet+' where RucE= '''+@RucE+''' and '+@colCodTab+'= '''+@Cod + ''' and '+@colCodTabDet+'= '''+convert(varchar,@Cod_Item)+''''
									exec sp_executesql @sql, N'@Glsa_fmDet varchar(200) output', @Glosa output
								end							
								else --if @IC_VFG='v'
									set @Glosa = @Glosa_Fmla 
								print  'Glosa: ' + @Glosa

								if @IC_JDCC = 'J'
								begin
									if (@Cd_TM='09')or(@Cd_TM='08')
										set @sql = 'select top 1 @CC_obt = Cd_CC, @SC_obt = Cd_SC, @SS_obt = Cd_SS from ' +@NomTabla+ ' where RucE= '''+@RucE+''' and '+@colCodTab+'= '''+@Cod + ''''
									else
										set @sql = 'select top 1 @CC_obt = Cd_CC, @SC_obt = Cd_SC, @SS_obt = Cd_SS from ' +@NomTablaDet+ ' where RucE= '''+@RucE+''' and '+@colCodTab+'= '''+@Cod + ''' and '+@colCodTabDet+'= '''+convert(varchar,@Cod_Item)+''''
									exec sp_executesql @sql, N'@CC_obt nvarchar(8) output, @SC_obt nvarchar(8) output, @SS_obt nvarchar(8) output', @Cd_CC output, @Cd_SC output, @Cd_SS output
								end
								if @Cd_CC is null or @Cd_CC = ''
									set @Cd_CC = '01010101'
								if @Cd_SC is null or @Cd_SC = ''
									set @Cd_SC = '01010101'
								if @Cd_SS is null or @Cd_SS = ''
									set @Cd_SS = '01010101'
								print 'CC: ' + @Cd_CC + ' - '+ + @Cd_SC + ' - '+ + @Cd_SS

								if (@Cd_TM='01') -- si es venta:
									select @IC_TipAfec = Cd_IAV from VentaDet where RucE=@RucE and Cd_Vta=@Cod and Nro_RegVdt = @Cod_Item
								else if (@Cd_TM='02') -- si es compra:
									select @IC_TipAfec = Cd_IA from CompraDet where RucE=@RucE and Cd_Com=@Cod and Item = @Cod_Item
								else 
									set @IC_TipAfec = null
									
								if (@Cd_TM='05') 
									select @CamMda=isnull(CamMda, 1) from Inventario where RucE=@RucE and Ejer=@Ejer and RegCtb=@Cod and Cd_Inv = @Cod_Item
								if (@Cd_TM='01' and @NomCol = 'Costo')	
									select @CamMda = case(isnull(Costo,0)) when 0 then 1 else  Costo / isnull(Costo_ME,Costo) end from VentaDet where RucE= @RucE and Cd_Vta= @Cod and Nro_RegVdt= @Cod_Item
								print 'Tipo Cambio: ' + convert(varchar,@CamMda)
								
								if @IC_PFI='f'
								begin
									declare @FmlaAux varchar(100)
									set @FmlaAux = @Fmla
									if (@Cd_TM='01' and @Fmla like '%Costo%' and @Cd_MdRg = '02')
										set @FmlaAux = replace(@FmlaAux, 'Costo', 'Costo_ME')
									if(@Cd_TM='05' and @Fmla like '%CosUnt%' and @Cd_MdRg = '02')
										set @FmlaAux = replace(@FmlaAux, 'CosUnt', 'CosUnt_ME')
									if(@Cd_TM='05' and @Fmla like '%Total%' and @Cd_MdRg = '02')
										set @FmlaAux = replace(@FmlaAux, 'Total', 'Total_ME')
									if(@Cd_TM='05' and @Fmla like '%CProm%' and @Cd_MdRg = '02')
										set @FmlaAux = replace(@FmlaAux, 'CProm', 'CProm_ME')
									if(@Cd_TM='05' and @Fmla like '%SCT%' and @Cd_MdRg = '02')
										set @FmlaAux = replace(@FmlaAux, 'SCT', 'SCT_ME')
									set @sql = 'select @Val_FmDet = '+@FmlaAux+' from '+@NomTablaDet+' where RucE= '''+@RucE+''' and '+@colCodTab+'= '''+@Cod + ''' and '+@colCodTabDet+'= '''+convert(varchar,@Cod_Item)+''''
									exec sp_executesql @sql, N'@Val_FmDet numeric(13,2) output', @Val_Cal output
								end
								else 
								begin
									declare @ME varchar(3)
									set @ME = ''
									if ((@Cd_TM='01' and @NomCol = 'Costo' and @Cd_MdRg = '02') or (@Cd_TM='05' and (@NomCol = 'CosUnt' or @NomCol = 'Total' or @NomCol = 'CProm' or @NomCol = 'SCT') and @Cd_MdRg = '02'))
										set @ME = '_ME'
									set @sql = 'select @Val_RetDet = '+@NomCol+@ME+' from '+@NomTablaDet+' where RucE= '''+@RucE+''' and '+@colCodTab+'= '''+@Cod + ''' and '+@colCodTabDet+'= '''+convert(varchar,@Cod_Item)+''''
									print @sql
									exec sp_executesql @sql, N'@Val_RetDet varchar(50) output', @Val_Obt output							
									set @Val_Cal = convert( numeric(13,2), @Val_Obt) * @Porc/100									
								end						
								set @Val_Cal = isnull(abs(@Val_Cal),0)
								print  'valor : ' + convert(varchar,@Val_Cal)	
																	
								if @IC_CaAb='C'
								begin	
									set @MtoD = @Val_Cal
									set @MtoH = 0.00
								end
								else --if @IC_CaAb='A'
								begin	
									set @MtoD = 0.00
									set @MtoH = @Val_Cal
								end
								
								if(@MtoD<0)
								begin
									set @MtoH = abs(@MtoD)
									set @MtoD = 0
								end
								if(@MtoH<0)
								begin
									set @MtoD = abs(@MtoH)
									set @MtoH = 0
								end
								print 'Debe: ' + str(@MtoD)
								print 'Haber: ' + str(@MtoH)
								
								declare @IB_DifCAux bit = (select IB_DifC from PlanCtas where RucE = @RucE and Ejer = @Ejer and NroCta = @NroCta)
								update PlanCtas set IB_DifC = 0 where RucE = @RucE and Ejer = @Ejer and NroCta = @NroCta
								
								if @Val_Cal != 0.00 
									exec pvo.Ctb_VoucherCrea12 
										@RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, @CtaAsoc, @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD,	@Glosa,	@MtoOr, @MtoD, @MtoH, 
										@Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS, @Cd_Area, @Cd_MR,	@NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, @SaldoMN output, @SaldoME output, @TipMov, @IC_TipAfec, 
										@TipOper, @Grdo, @RegOrg, @IC_Crea, @IB_PgTot, @IB_EsProv, @DR_FecED, @DR_CdTD, @DR_NSre, @DR_NDoc, @DR_NCND, @DR_NroDet, @DR_FecDet, @IB_JalaAmr, @msj output
										
								update PlanCtas set IB_DifC = @IB_DifCAux where RucE = @RucE and Ejer = @Ejer and NroCta = @NroCta
								set @IB_EsProv = 1
								set @IC_Crea = 'T'
							
								set @IC_TipAfec = null
								print @Msj
							fetch Cur_TabDet into @Cod_Item 
							end
						close Cur_TabDet
					deallocate Cur_TabDet
				print  '------ FIN SUB_CURSOR '+@NomTabla+' DETALLE ------'	
			end
			else  -- si es cabecera(c) :
			begin

				set @IC_TipAfec = @Cd_IA 
				if @IC_VFG='f'
				begin
					set @sql = 'select top 1 @Glsa_Fm = '+@Glosa_Fmla+' from ' +@NomTabla+ ' where RucE= '''+@RucE+''' and '+@colCodTab+'= '''+@Cod + ''''
					exec sp_executesql @sql, N'@Glsa_Fm varchar(200) output', @Glosa output
				end
				else --if @IC_VFG='v'
					set @Glosa = @Glosa_Fmla 
				print  'Glosa: ' + @Glosa
				
				if @IC_JDCtaPA = 'A'
				begin
					if (@Cd_Clt is null  or @Cd_Clt = '') and (@Cd_Prv is null  or @Cd_Prv = '')
					begin
						if (@Cd_TM='01') -- si es venta:
							select @Cd_Clt=Cd_Clt from venta where RucE=@RucE and Cd_Vta = @cod 
						else if (@Cd_TM='02') -- si es compra:
							select @Cd_Prv=Cd_Prv from Compra where RucE=@RucE and Cd_Com = @cod								
						else if (@Cd_TM='05') -- si es Inventario:
							select @Cd_Prv=Cd_Prv, @Cd_Clt=Cd_Clt from Inventario where RucE=@RucE and Ejer=@Ejer and RegCtb = @Cod and Cd_Inv = @Cod_Item
						else if (@Cd_TM='08') -- si es Letra:
							select @Cd_Prv=Cd_Prv from CanjePago where RucE=@RucE and Cd_Cnj = @cod
						else if (@Cd_TM='09') -- si es Letra:
							select @Cd_Clt=Cd_Clt from Canje where RucE=@RucE and Cd_Cnj = @cod
					end
					if @Cd_Clt is null  or @Cd_Clt = '' --es Proveedor
						select @NroCta_Temp = CtaCtb from Proveedor2 where RucE=@RucE and Cd_Prv=@Cd_Prv
					else
						select @NroCta_Temp = CtaCtb from Cliente2 where RucE=@RucE and Cd_Clt=@Cd_Clt
					
					if @NroCta_Temp is null or @NroCta_Temp=''
						begin
							if @Cd_MdRg='01'
								set @NroCta_Temp = @Cta
							else --if @Cd_MdRg='02'
								set @NroCta_Temp = @CtaME										
						end
					if @NroCta_Temp is null or @NroCta_Temp=''
						set @NroCta_Temp = '999999999'
					set @NroCta = @NroCta_Temp
					Print 'Nro Cta: ' + @NroCta
				end
				
				if @IC_JDCC = 'J'--1 -- jalar
				begin
					set @sql = 'select top 1 @CC_obt = Cd_CC, @SC_obt = Cd_SC, @SS_obt=Cd_SS from ' +@NomTabla+ ' where RucE= '''+@RucE+''' and '+@colCodTab+'= '''+@Cod + ''''
					exec sp_executesql @sql, N'@CC_obt nvarchar(8) output, @SC_obt nvarchar(8) output, @SS_obt nvarchar(8) output', @Cd_CC output, @Cd_SC output, @Cd_SS output
				end
				if @Cd_CC is null or @Cd_CC = ''
					set @Cd_CC = '01010101'
				if @Cd_SC is null or @Cd_SC = ''
					set @Cd_SC = '01010101'
				if @Cd_SS is null or @Cd_SS = ''
					set @Cd_SS = '01010101'
				print 'CC: ' + @Cd_CC + ' - '+ + @Cd_SC + ' - '+ + @Cd_SS
								
				if @IC_PFI='f'
				begin
					declare @NomTablaVal varchar(50)
					if (@NomCol='CFD') -- Cabecera Formula con datos de Detalle
						set @NomTablaVal = @NomTablaDet
					else --if (@NomCol='CFC')
						set @NomTablaVal = @NomTabla
					
					set @sql = 'select top 1 @Val_Ret = '+@Fmla+' from ' +@NomTablaVal+ ' where RucE= '''+@RucE+''' and '+@colCodTab+'= '''+@Cod + '''' --TODO
					exec sp_executesql @sql, N'@Val_Ret numeric(13,2) output', @Val_Cal output
				end
				else 
				begin
					if(@Cd_TM='02' and @NomCol = 'ImpDetr' and @Cd_MdRg = '02')
						set @NomCol = 'ImpDetr_ME'
					set @sql = 'select top 1 @Val_Ret = '+@NomCol+' from ' +@NomTabla+ ' where RucE= '''+@RucE+''' and '+@colCodTab+'= '''+@Cod + ''''
					print @sql
					exec sp_executesql @sql, N'@Val_Ret varchar(50) output', @Val_Obt output
					set @Val_Cal = convert( numeric(13,2), isnull(abs(@Val_Obt),0)) * @Porc/100
				end
				print  'valor : ' + convert(varchar,@Val_Cal)
				
				if @IC_CaAb='C'
				begin	
					set @MtoD = @Val_Cal
					set @MtoH = 0.00
				end
				else --if @IC_CaAb='A'
				begin	
					set @MtoD = 0.00
					set @MtoH = @Val_Cal
				end
				
				if(@MtoD<0)
				begin
					set @MtoH = abs(@MtoD)
					set @MtoD = 0
				end
				if(@MtoH<0)
				begin
					set @MtoD = abs(@MtoH)
					set @MtoH = 0
				end
				print 'Debe: ' + str(@MtoD)
				print 'Haber: ' + str(@MtoH)
				
				if @Val_Cal != 0.00
					exec pvo.Ctb_VoucherCrea12 --Modificacion: 10
						@RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, @CtaAsoc, @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD,	@Glosa,	@MtoOr, @MtoD, @MtoH, @Cd_MdOr, 
						@Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS, @Cd_Area, @Cd_MR,	@NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, @SaldoMN output, @SaldoME output, @TipMov, @IC_TipAfec, @TipOper, @Grdo, @RegOrg,												@IC_Crea, @IB_PgTot, @IB_EsProv, 						@DR_FecED, @DR_CdTD, @DR_NSre, @DR_NDoc,											@DR_NCND, @DR_NroDet, @DR_FecDet,						@IB_JalaAmr, 						@msj output							
				set @IC_Crea = 'T'

				set @IC_TipAfec = null
				print  '------ FIN LLAMA REGISTRO ' +@NomTabla+ ' ------'					
			end
			fetch Cur_Asiento into @Cta, @CtaME,  @IC_JDCtaPA, @IC_CaAb, @IN_TipoCta, @Cd_IV, @Porc, @Fmla, @IC_PFI, @Glosa_Fmla, @IC_VFG, @Cd_CC, @Cd_SC, @Cd_SS, @IC_JDCC, @IB_Aux, @IB_EsDes, @IB_JalaAmr, @Cd_IA, @IC_ES
		end
	close Cur_Asiento
deallocate Cur_Asiento
-- FIN CURSOR ASIENTO
if @IB_Anulado = 1
	update voucher set IB_Anulado = 1 where RucE=@RucE and Ejer=@Ejer and RegCtb = @RegCtb


declare @Mto numeric(13,2)
declare @Mto_ME numeric(13,2)
declare @Cd_Mda char(2)

select @Mto = sum(MtoD - MtoH) , @Mto_ME  =sum(MtoD_ME - MtoH_ME), @Cd_Mda = Max(Cd_MdOr) from Voucher where RucE = @RucE and RegCtb = @RegCtb and Ejer = @Ejer 
group by RucE, RegCtb, Ejer

print 'Mto :'+convert(char,@Mto)
print 'Mto_ME :'+convert(char,@Mto_ME)
 
if (@Mto <>0 or @Mto_ME <>0)
	exec pvo.Ctb_AjustaXConversion_cnDst @RucE, @Ejer, @RegCtb, @Mto, @Mto_ME, @msj output


if((select count(*) from Voucher as V inner join PlanCtas as C on V.RucE = C.RucE and V.Ejer = C.Ejer and V.NroCta = C.NroCta where V.RucE = @RucE and V.Ejer = @Ejer and V.RegCtb = @RegCtb) >1)
begin
	declare @RegCtbA char(15) = (select RegCtb from Compra where RucE = @RucE and Cd_Com = @Cod and RegCtb != @RegCtb)
	if(@RegCtbA is not null)
		update Voucher set IB_EsProv = 0 where RucE = @RucE and Ejer = @Ejer and RegCtb = @RegCtb and  NroCta in (select NroCta from Voucher where RucE = @RucE and Ejer = @Ejer and RegCtb = @RegCtbA)
end

print @msj
GO

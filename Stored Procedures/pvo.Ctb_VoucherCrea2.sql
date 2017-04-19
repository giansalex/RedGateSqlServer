SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Ctb_VoucherCrea2]
@RucE		nvarchar(11),
--@Cd_Vou	int,
@Ejer		nvarchar(4),
@Prdo		nvarchar(2),
@RegCtb	nvarchar(15),
@Cd_Fte	varchar(2),
@FecMov	smalldatetime,
@FecCbr	smalldatetime,
@NroCta	nvarchar(10),
@CtaAsoc nvarchar(12),  --> cta definida en Clientes/Proveedores
@Cd_Aux	nvarchar(7),
@Cd_TD	nvarchar(2),
@NroSre	nvarchar(4),
@NroDoc	nvarchar(15),
@FecED	smalldatetime,
@FecVD	smalldatetime,
@Glosa		varchar(200),
@MtoOr	numeric(13,2),
@MtoD		numeric(13,2),
@MtoH		numeric(13,2),
@Cd_MdOr 	nvarchar(2),
@Cd_MdRg 	nvarchar(2),
@CamMda 	numeric(6,3),
@Cd_CC	nvarchar(8),
@Cd_SC	nvarchar(8),
@Cd_SS	nvarchar(8),
@Cd_Area 	nvarchar(6),
@Cd_MR	nvarchar(2),
@NroChke 	varchar(30),
@Cd_TG	nvarchar(2),
@IC_CtrMd	varchar(1),
--FecReg 	datetime,
--FecMdf 	datetime,
@UsuCrea 	nvarchar(10),
--UsuModf 	nvarchar(10),
--@IB_Anulado 	bit
@SaldoMN	decimal(13,2) output,
@SaldoME	decimal(13,2) output,
@TipMov		varchar(1), --> M: Manual, A: Automatico
------------------------------
@IC_TipAfec 	varchar(1),
@TipOper 	varchar(4),
@Grdo	 	varchar(100),
@RegOrg		nvarchar(15),  --> Para saber que provicion estamos cancelando
------------------------------
@IC_Crea	varchar(1), --> I:Inicio, T:Transicion, F:Fin  <-- Indicador del estado de creacion

@msj 		varchar(100) output

with encryption
as



if @IC_Crea='I'
	if exists (select * from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
	begin	set @msj = 'Ya existe un voucher con el mismo numero de Registro Contable'
		print @msj
		return
	end
/*
else
begin
*/

	declare @Mto numeric(13,2), @Tipo varchar(1)

	if @TipMov = 'M'
	begin

	exec pvo.Ctb_VoucherInsert2 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, @Cd_Aux, @Cd_TD, @NroSre,
				   @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @MtoD, @MtoH, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
				   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
				   @IC_TipAfec, @TipOper, @Grdo, @msj output

	if @msj <> ''
	   return

	end



	if(@MtoD>0) 
	begin	set @Mto=@MtoD
		set @Tipo='D'
	end
	else
	begin 	set @Mto=@MtoH 
		set @Tipo='H'
	end



	-- ASIENTO AUTOMATICO ---------------------------------------------------------------

	if @TipMov = 'A'
	begin
--		select * from Tasas
		declare @igv numeric(5,2), @MtoIGV numeric(13,2), @CtaIGV nvarchar(12)

		set @CtaIGV = ( select IGV from PlanCtasDef where RucE=@RucE )
		set @igv = (select Tasa from Tasas where Cd_Ts = 'T01')
		--set @Mto=@Mto*@igv/100 --> Agrega IGV
		set @Mto=@Mto/(@igv/100+1) --> Quita IGV

		if(@Cd_Fte='RC')
		begin

			exec pvo.Ctb_VoucherInsert2 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaAsoc, @Cd_Aux, @Cd_TD, @NroSre,
						   @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @Mto, 0.00, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
						   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
						   @IC_TipAfec, @TipOper, @Grdo, @msj output

			--set @Mto = 0
			set @MtoIGV = @MtoH - @Mto
			
			exec pvo.Ctb_VoucherInsert2 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaIGV, @Cd_Aux, @Cd_TD, @NroSre,
						   @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @MtoIGV, 0.00, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
						   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
						   @IC_TipAfec, @TipOper, @Grdo, @msj output


			exec pvo.Ctb_VoucherInsert2 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, @Cd_Aux, @Cd_TD, @NroSre,
						   @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 0.00, @MtoH, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
						   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
						   @IC_TipAfec, @TipOper, @Grdo, @msj output
		end		
		else if(@Cd_Fte='RV')
		begin

			exec pvo.Ctb_VoucherInsert2 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaAsoc, @Cd_Aux, @Cd_TD, @NroSre,
						   @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 0.00, @Mto, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
						   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
						   @IC_TipAfec, @TipOper, @Grdo, @msj output

			set @MtoIGV = @MtoD - @Mto
			
			exec pvo.Ctb_VoucherInsert2 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaIGV, @Cd_Aux, @Cd_TD, @NroSre,
						   @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 0.00, @MtoIGV, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
						   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
						   @IC_TipAfec, @TipOper, @Grdo, @msj output



			exec pvo.Ctb_VoucherInsert2 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, @Cd_Aux, @Cd_TD, @NroSre,
						   @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @MtoD, 0.00, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
						   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
						   @IC_TipAfec, @TipOper, @Grdo, @msj output
		end		


		set @NroCta = @CtaAsoc
 	end





	-- BUSCAMOS AMARRE CUENTAS ----------------------------------------------------------


	if(select IB_CtaD from PlanCtas where RucE=@RucE and NroCta=@NroCta)=1
	begin
		declare @CtaD nvarchar(10), @CtaH nvarchar(10), @Porc numeric(5,2), @MtoDest numeric(13,2)
		--set @Mto = 0
		
		declare Cur_CtaDet cursor for select CtaD, CtaH, Porc from AmarreCta where RucE=@RucE and NroCta=@NroCta
		open Cur_CtaDet	
		     fetch Cur_CtaDet into @CtaD, @CtaH, @Porc
			-- mientras haya datos
			while (@@fetch_status=0)
			begin
				print @CtaD
				print @CtaH
				print @Porc

--				if(@MtoD>0) set @Mto=@MtoD
--				else set @Mto=@MtoH
				set @MtoDest = 0				
				set @MtoDest=@Mto*@Porc/100

				--AGREGAMOS CUENTA DESTINO DEBE
				if not exists (select NroCta from Voucher where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaD )
				begin
					exec pvo.Ctb_VoucherInsert2 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaD, @Cd_Aux, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 
								   @MtoDest, 0.00, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
								   @IC_TipAfec, @TipOper, @Grdo, @msj output
					if @msj <> '' return
				end
				else  begin update Voucher set MtoD=MtoD+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaD end



				--AGREGAMOS CUENTA DESTINO HABER
				if not exists (select NroCta from Voucher where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaH )
				begin
					exec pvo.Ctb_VoucherInsert2 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaH, @Cd_Aux, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 
								   0.00, @MtoDest, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
								   @IC_TipAfec, @TipOper, @Grdo, @msj output
					if @msj <> '' return
				end
				else  begin update Voucher set MtoH=MtoH+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaH end
			
		
			fetch Cur_CtaDet into @CtaD, @CtaH, @Porc
			END
		close Cur_CtaDet
		deallocate Cur_CtaDet
	end





	-------------------------------------------------------------------------------------








	declare @MtoD_MN numeric(16,5),  @MtoH_MN numeric(16,5)
	declare @MtoD_ME numeric(16,5),  @MtoH_ME numeric(16,5)
--	declare @MtoD_MN numeric(13,2),  @MtoH_MN numeric(13,2)
--	declare @MtoD_ME numeric(13,2),  @MtoH_ME numeric(13,2)
	declare @MtoD_ME2 numeric(16,5),  @MtoH_ME2 numeric(16,5)


	set @MtoD_MN=0	set @MtoH_MN=0
	set @MtoD_ME=0	set @MtoH_ME=0


	select @MtoD_MN = isnull(sum(MtoD),0), @MtoH_MN = isnull(sum(MtoH),0),
	       @MtoD_ME = isnull(sum(MtoD/CamMda),0), @MtoH_ME = isnull(sum(MtoH/CamMda),0) 
	from Voucher where RucE=@RucE and RegCtb = @RegCtb and Cd_MdRg='01'



	print '----- Sumas Debe y Haber -----'
	print '*Soles en Soles:'
	print '   Debe Soles: ' + convert(varchar,@MtoD_MN) print '   Haber Soles: ' + convert(varchar,@MtoH_MN)
	print '*Soles en Dolares:'
	print '   Debe Dolares: ' + convert(varchar,@MtoD_ME) print '   Haber Dolares: ' + convert(varchar,@MtoH_ME)
--	set @MtoD_ME = @MtoD_ME + isnull((null),0)
--	set @MtoH_ME = @MtoH_ME + isnull((null),0)
--	print @MtoD_ME print @MtoH_ME


	
	select @MtoD_MN = @MtoD_MN + isnull(sum(MtoD*CamMda),0), @MtoH_MN = @MtoH_MN + isnull(sum(MtoH*CamMda),0), 
--	       @MtoD_ME = @MtoD_ME + isnull(sum(MtoD),0), @MtoH_ME = @MtoH_ME + isnull(sum(MtoH),0)
	       @MtoD_ME2 = isnull(sum(MtoD),0), @MtoH_ME2 = isnull(sum(MtoH),0)
	from Voucher where RucE=@RucE and RegCtb = @RegCtb and Cd_MdRg='02'


	print ''
	print '----- Sumas Debe y Haber US$ -----'
	print '*Dolares en Soles:'
	print '   Debe Soles: ' + convert(varchar,@MtoD_ME2) print '   Haber Soles: ' + convert(varchar,@MtoH_ME2)



	set @MtoD_ME = @MtoD_ME + @MtoD_ME2
	set @MtoH_ME = @MtoH_ME + @MtoH_ME2


	print ''
	print '----- Sumas Debe y Haber SOLES + DOALRES -----'
	print @MtoD_MN print @MtoH_MN
	print @MtoD_ME print @MtoH_ME



	set @SaldoMN = round((@MtoD_MN - @MtoH_MN),2)
	set @SaldoME = round((@MtoD_ME - @MtoH_ME),2) --@SaldoMN/@CamMda

	print ''
	print '----- SALDOS -----'
	print @SaldoMN
	print @SaldoME





	if(@Cd_Fte='CB')
	begin

	    if (select count(RegCtb) from Voucher where RucE=@RucE and RegCtb=@RegCtb)>1
	    begin --> Aplicamos Dif. de Camb. x Mov. segun perdida o ganancia

		declare @Cta_DCPer nvarchar(12), @Cta_DCGan nvarchar(12)
		select  @Cta_DCPer = DCPer, @Cta_DCGan = DCGan from PlanCtasDef where RucE=@RucE

		set @Cd_Aux = null
		set @Cd_TD = null
		set @NroSre = null
		set @NroDoc = null

		if (@SaldoME!=0)
		begin 
     		     set @Mto = abs(@SaldoME)

		     if(@SaldoME<0)
		     begin
			set @SaldoME = abs(@SaldoME)
			set @IC_CtrMd = '$'
			set @Cd_MdRg = '02'
			exec pvo.Ctb_VoucherInsert2 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @Cta_DCPer, null/*@Cd_Aux*/, null/*@Cd_TD*/, null/*@NroSre*/,
			     null/*@NroDoc*/, @FecED, @FecVD, @Glosa, @MtoOr, @SaldoME, 0.00, @Cd_MdOr, '02', @CamMda, @Cd_CC,
			     @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, '$', @UsuCrea, @IC_TipAfec, @TipOper, @Grdo, @msj output
			set @NroCta = @Cta_DCPer
		     end
		     else
		     begin
			exec pvo.Ctb_VoucherInsert2 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @Cta_DCGan, null/*@Cd_Aux*/, null/*@Cd_TD*/, null/*@NroSre*/,
			     null/*@NroDoc*/, @FecED, @FecVD, @Glosa, @MtoOr, 0.00, @SaldoME, @Cd_MdOr, '02', @CamMda, @Cd_CC,
			     @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, '$', @UsuCrea, @IC_TipAfec, @TipOper, @Grdo, @msj output
			set @NroCta = @Cta_DCGan
		     end
		end
		else if (@SaldoMN!=0)
		begin
		     set @Mto = abs(@SaldoMN)
		     set @IC_CtrMd = 's'
		     set @Cd_MdRg = '01'
		     if(@SaldoMN<0)
		     begin
			set @SaldoMN = abs(@SaldoMN)
			exec pvo.Ctb_VoucherInsert2 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @Cta_DCPer, null/*@Cd_Aux*/, null/*@Cd_TD*/, null/*@NroSre*/,
			     null/*@NroDoc*/, @FecED, @FecVD, @Glosa, @MtoOr, @SaldoMN, 0.00, @Cd_MdOr, '01', @CamMda, @Cd_CC,
			     @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, 's', @UsuCrea, @IC_TipAfec, @TipOper, @Grdo, @msj output
			set @NroCta = @Cta_DCPer
		     end
		     else
		     begin
			exec pvo.Ctb_VoucherInsert2 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @Cta_DCGan, null/*@Cd_Aux*/, null/*@Cd_TD*/, null/*@NroSre*/,
			     null/*@NroDoc*/, @FecED, @FecVD, @Glosa, @MtoOr, 0.00, @SaldoMN, @Cd_MdOr, '01', @CamMda, @Cd_CC,
			     @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, 's', @UsuCrea, @IC_TipAfec, @TipOper, @Grdo, @msj output
			set @NroCta = @Cta_DCGan
		     end
		end


	    --Ponemos saldos en 0.00 xq ya se aplico Dif. de Camb.
	    set @SaldoME = 0.00
	    set @SaldoMN = 0.00
		
	    end	--> FIN: Aplicamos Dif. de Camb. x Mov. segun perdida o ganancia




--	end --FIN if(@Cd_Fte='CB')  (MAS ABAJO)


		-- VOLVEMOS A BUSCAR AMARRE CUENTAS ----------------------------------------------------------
	
	
		if(select IB_CtaD from PlanCtas where RucE=@RucE and NroCta=@NroCta)=1
		begin
			--declare @CtaD nvarchar(10), @CtaH nvarchar(10), @Porc numeric(5,2), @MtoDest numeric(13,2)
			set @CtaD = '' 
			set @CtaH = ''
			set @Porc = 0
			set @MtoDest = 0
			--set @Mto = 0
			
			declare Cur_CtaDet2 cursor for select CtaD, CtaH, Porc from AmarreCta where RucE=@RucE and NroCta=@NroCta
			open Cur_CtaDet2	
			     fetch Cur_CtaDet2 into @CtaD, @CtaH, @Porc
				-- mientras haya datos
				while (@@fetch_status=0)
				begin
					print @CtaD
					print @CtaH
					print @Porc
	
	--				if(@MtoD>0) set @Mto=@MtoD
	--				else set @Mto=@MtoH
					set @MtoDest = 0				
					set @MtoDest=@Mto*@Porc/100
	
					--AGREGAMOS CUENTA DESTINO DEBE
					if not exists (select NroCta from Voucher where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaD )
					begin
						exec pvo.Ctb_VoucherInsert2 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaD, @Cd_Aux, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 
									   @MtoDest, 0.00, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
									   @IC_TipAfec, @TipOper, @Grdo, @msj output
						if @msj <> '' return
					end
					else  begin update Voucher set MtoD=MtoD+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaD end
	
	
	
					--AGREGAMOS CUENTA DESTINO HABER
					if not exists (select NroCta from Voucher where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaH )
					begin
						exec pvo.Ctb_VoucherInsert2 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaH, @Cd_Aux, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 
									   0.00, @MtoDest, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
									   @IC_TipAfec, @TipOper, @Grdo, @msj output
						if @msj <> '' return
					end
					else  begin update Voucher set MtoH=MtoH+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaH end
				
			
				fetch Cur_CtaDet2 into @CtaD, @CtaH, @Porc
				END
			close Cur_CtaDet2
			deallocate Cur_CtaDet2
		end


	end --FIN if(@Cd_Fte='CB')



--end
print @msj
--PV: Jue 29/01/09
--PV: Jue 26/02/09 --> Agregue Dif. de Camb.
--PV: Vie 27/02/09 --> Arregle Dif. de Camb.
--PV: Vie 19/03/09 --> Agregue 4 campos
GO

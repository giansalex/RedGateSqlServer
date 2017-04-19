SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Ctb_VoucherCrea8] --Modificacion: 8
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
@IB_PgTot	bit, --> 0:Parcial, 1:Total  <-- Indicador Pago Total
@IB_EsProv	bit, --> Indicador Es Provicion
------------------------------
@DR_FecED	smalldatetime,
@DR_CdTD	nvarchar(2),
@DR_NSre	nvarchar(4),
@DR_NDoc	nvarchar(15),

@msj 		varchar(100) output

with encryption
as
print 'BREAK_1'



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

	declare @Mto numeric(13,2), @TipoIng varchar(1)

	if @TipMov = 'M'
	begin
		print  '------ ASIENTO MANUAL ---------------------------------------'
		print  '--- (Insertamos registro) -----------------------------------'
		exec pvo.Ctb_VoucherInsert5 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, @Cd_Aux, @Cd_TD, @NroSre,
					   @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @MtoD, @MtoH, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
					   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
					   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @DR_FecED, @DR_CdTD, @DR_NSre, @DR_NDoc, @msj output
		
		set @IC_TipAfec = null --Solo se guarda en el registro necesario (BIM)
	
		if @msj <> ''
		   return
	end


	print 'BREAK_2'

	print 'Monto Debe --> ' + convert(varchar, @MtoD)
	print 'Monto Haber --> ' + convert(varchar, @MtoH)


	if(@MtoD>0) --> obtenemos Mto General
	begin	set @Mto=@MtoD
		set @TipoIng='D'
	end
	else
	begin 	set @Mto=@MtoH 
		set @TipoIng='H'
	end



	print 'BREAK_3'

	-- ASIENTO AUTOMATICO ---------------------------------------------------------------

	if @TipMov = 'A'
	begin
	print '-- ASIENTO AUTOMATICO ---------------------------------------------------------------'

--		select * from Tasas
		declare @igv numeric(5,2), @MtoIGV numeric(13,2), @CtaIGV nvarchar(12)
		set @CtaIGV = ( select IGV from PlanCtasDef where RucE=@RucE )
		set @igv = (select Tasa from Tasas where Cd_Ts = 'T01')
		--set @Mto=@Mto*@igv/100 --> Agrega IGV

		print 'BREAK_4'
		print 'Cta IGV: ' + @CtaIGV
		print 'Tasa IGV: ' + convert(varchar,@igv)
		
		set @MtoIGV = 0

		--DESCOMPONEMOS MONTO
		if(@Cd_Fte='RC')
		begin	if @IC_TipAfec != 'F' and @IC_TipAfec != 'N'
			begin 	set @Mto=@Mto/(@igv/100+1) --> Quita IGV 
				set @MtoIGV = (@MtoD+@MtoH) - @Mto
			end
		end
		else if(@Cd_Fte='RV') 	
			if @IC_TipAfec != 'I' and @IC_TipAfec != 'E' --and @IC_TipAfec != 'V'
			begin 	set @Mto=@Mto/(@igv/100+1) --> Quita IGV 
				set @MtoIGV = (@MtoD+@MtoH) - @Mto

			end

		print 'BREAK_5'
		print 'BIM: ' + convert(varchar,@Mto)
		print 'Mto IGV: ' + convert(varchar,@MtoIGV)


		--Analizamos donde ira la BIM e IGV segun lugar Mto. ingreso (Deb/Hab)

		declare @BIM_D numeric(13,2), @BIM_H numeric(13,2), @IGV_D numeric(13,2), @IGV_H numeric(13,2)

		if(@TipoIng='H') --> Puede ser un RC o RV_Invertido(Nota de credito)
		begin	set @BIM_D = @Mto --> se asigna BIM calculada ya se afecta o inafecta
			set @BIM_H = 0.00
			set @IGV_D = @MtoIGV --> se asigna Monto IGV si es que hubiera
			set @IGV_H = 0.00
		end 
		else	--> Puede ser un RV o RC_Invertido(Extorno)
		begin	set @BIM_D = 0.00
			set @BIM_H = @Mto --> se asigna BIM calculada ya se afecta o inafecta
			set @IGV_D = 0.00
			set @IGV_H = @MtoIGV --> se asigna Monto IGV si es que hubiera
		end



		if(@Cd_Fte='RC')
			print '-- REGISTRO COMPRAS AUTOMATICO -------------------------------------'
		else if(@Cd_Fte='RV')
			print '-- REGISTRO VENTAS AUTOMATICO -------------------------------------'


		-- Registramos BIM --
		print '-- Registramos BIM --'
		exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaAsoc, @Cd_Aux, @Cd_TD, @NroSre,
					 --@NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @Mto, 0.00, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
					   @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @BIM_D, @BIM_H, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
					   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
					   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output

		--Registramos IGV (si es que hubiera)
		if @MtoIGV > 0 
		begin	print '-- Registramos IGV --' 
			exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaIGV, @Cd_Aux, @Cd_TD, @NroSre,
						   @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @IGV_D, @IGV_H, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
						   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
						   /*@IC_TipAfec*/null, @TipOper, @Grdo, @IB_EsProv, @msj output
		end


		--Registramos provision auxiliar RC/RV (CtasxPag/CtasXCbr)
		print '-- Registramos Provision --'
		set @IC_TipAfec = null --Solo se guarda en el registro necesario (BIM)
		exec pvo.Ctb_VoucherInsert5 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, @Cd_Aux, @Cd_TD, @NroSre,
					 --@NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @MtoD, 0.00, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
					   @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @MtoD, @MtoH, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
					   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
					   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @DR_FecED, @DR_CdTD, @DR_NSre, @DR_NDoc, @msj output

		set @NroCta = @CtaAsoc


 	end -- FIN: if @TipMov = 'A'


	print 'BREAK_9'

	print 'MSJ: ' + @msj


	-- BUSCAMOS AMARRE CUENTAS ----------------------------------------------------------
	print '-- BUSCAMOS AMARRE CUENTAS ---------------------------------------------------'

	declare @IB_InvertAmr bit

	if @Cd_Fte = 'RC' or @Cd_Fte = 'LD'  --> debe estar discriminado por Fte?
		if @TipMov = 'M'
			if(@MtoD>0) --> cuando es 'M' el monto ingresado es la BIM y va al Debe Ejem: 63.1.0.01   100
				set @IB_InvertAmr = 0 --> es normal
			else 	set @IB_InvertAmr = 1 --> Invertimos
		else if @TipMov = 'A'
			if(@MtoH>0)  --> cuando es 'A' el monto ingresado va al Haber Ejem: 42.1.0.01   119
				set @IB_InvertAmr = 0 --> es normal
			else 	set @IB_InvertAmr = 1 --> Invertimos

	--else if @Cd_Fte = 'RC'  -FALTARIA PARA RV?  ¿RV LLEVA AMARRES? - PREGUNTAR  ¿Y LD?


	if(select IB_CtaD from PlanCtas where RucE=@RucE and NroCta=@NroCta)=1
	begin
		declare @CtaD nvarchar(10), @CtaH nvarchar(10), @Porc numeric(5,2), @MtoDest numeric(13,2), @CtaTemp nvarchar(10) --(para invertir Amr)
		--set @Mto = 0
		
		declare Cur_CtaDet cursor for select CtaD, CtaH, Porc from AmarreCta where RucE=@RucE and NroCta=@NroCta
		open Cur_CtaDet	
		     fetch Cur_CtaDet into @CtaD, @CtaH, @Porc
			-- mientras haya datos
			while (@@fetch_status=0)
			begin

				--Lo normal que si es RC:
				--CtaAsoc Ejm 63.1.0.01 va al debe
				--Ejm:  
				-- 63.1.0.01	100
				-- 40.1.0.01	 19
				-- 42.1.0.01		119
				-- 94.1.0.01	 60
				-- 95.1.0.01	 40
				-- 19.1.0.01		100
				--SI ES EXTORNO SE REGISTRA AL REVES(siendo RC):

				if (@IB_InvertAmr = 1)
				begin
					set @CtaTemp = @CtaD
					set @CtaD = @CtaH
					set @CtaH = @CtaTemp
					PRINT '--- ¡¡¡SE INVIRTIO AMARRE!!! ---'
				end
		

				print 'NroCta: (Cta Analizada) --> ' + @NroCta
				print '-----'
				print 'CtaD: ' + @CtaD
				print 'CtaH: ' + @CtaH
				print 'Porc: ' + convert(varchar,@Porc)  + ' %'


--				if(@MtoD>0) set @Mto=@MtoD
--				else set @Mto=@MtoH
				set @MtoDest = 0				
				set @MtoDest=@Mto*@Porc/100
				print 'Monto Dest. --> ' + convert(varchar,@MtoDest)

				--AGREGAMOS CUENTA DESTINO DEBE
				if not exists (select NroCta from Voucher where RucE=@RucE and Ejer=@Ejer and Prdo=@Prdo and RegCtb=@RegCtb and NroCta=@CtaD )
				begin
					print 'Insertamos amarre DEB ' + @CtaD
					exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaD, @Cd_Aux, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 
								   @MtoDest, 0.00, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
								   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output
					if @msj <> '' return
				end
				else  --begin update Voucher set MtoD=MtoD+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaD end
				begin 	print 'Modificamos amarre DEB (Acumulamos) ' + @CtaD
					exec pvo.Ctb_VoucherMdf_Mto @RucE,@Ejer,@Prdo,@RegCtb,@MtoDest,0.00,@CtaD,@Cd_MdRg,@CamMda,@IC_CtrMd,@Msj output 
				end




				--AGREGAMOS CUENTA DESTINO HABER
				if not exists (select NroCta from Voucher where RucE=@RucE and Ejer=@Ejer and Prdo=@Prdo and RegCtb=@RegCtb and NroCta=@CtaH )
				begin
					print 'Insertamos amarre HAB ' + @CtaH
					exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaH, @Cd_Aux, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 
								   0.00, @MtoDest, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
								   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output
					if @msj <> '' return
				end
				else  --begin update Voucher set MtoH=MtoH+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaH end
				begin 	print 'Modificamos amarre HAB (Acumulamos) ' + @CtaH
					exec pvo.Ctb_VoucherMdf_Mto @RucE,@Ejer,@Prdo,@RegCtb,0.00,@MtoDest,@CtaH,@Cd_MdRg,@CamMda,@IC_CtrMd,@Msj output 
				end
			
		
			fetch Cur_CtaDet into @CtaD, @CtaH, @Porc
			END
		close Cur_CtaDet
		deallocate Cur_CtaDet
	end





	-------------------------------------------------------------------------------------

	print 'MSJ: ' + @msj


	print 'BREAK_10'






--	declare @MtoD_MN numeric(16,5),  @MtoH_MN numeric(16,5)
--	declare @MtoD_ME numeric(16,5),  @MtoH_ME numeric(16,5)
--	declare @MtoD_ME2 numeric(16,5),  @MtoH_ME2 numeric(16,5)
	declare @MtoD_MN numeric(13,2),  @MtoH_MN numeric(13,2)
	declare @MtoD_ME numeric(13,2),  @MtoH_ME numeric(13,2)
	declare @MtoD_ME2 numeric(13,2),  @MtoH_ME2 numeric(13,2)



	set @MtoD_MN=0	set @MtoH_MN=0
	set @MtoD_ME=0	set @MtoH_ME=0

/*
	select @MtoD_MN = isnull(sum(MtoD),0), @MtoH_MN = isnull(sum(MtoH),0),
	       @MtoD_ME = isnull(sum(MtoD/CamMda),0), @MtoH_ME = isnull(sum(MtoH/CamMda),0) 
	from Voucher where RucE=@RucE and RegCtb = @RegCtb and Cd_MdRg='01'



	print '----- Sumas Debe y Haber -----'
	print '*Soles en Soles:'
	print '   Debe Soles: ' + convert(varchar,@MtoD_MN) print '   Haber Soles: ' + convert(varchar,@MtoH_MN)
	print '*Soles en Dolares:'
	print '   Debe Dolares: ' + convert(varchar,@MtoD_ME) print '   Haber Dolares: ' + convert(varchar,@MtoH_ME)
--	set @MtoD_ME = @MtoD_ME + isnull((null),0)
,--	set @MtoH_ME = @MtoH_ME + isnull((null),0)
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
*/

	print 'BREAK_11'


	select @MtoD_MN = isnull(sum(MtoD),0),    @MtoH_MN = isnull(sum(MtoH),0),
	       @MtoD_ME = isnull(sum(MtoD_ME),0), @MtoH_ME = isnull(sum(MtoH_ME),0) 
	from Voucher where RucE=@RucE and RegCtb = @RegCtb


	print ''
	print '----- Sumas Debe y Haber SOLES + DOALRES -----'
	print 'Debe: ' + convert(varchar,@MtoD_MN) + '  Haber: ' + convert(varchar,@MtoH_MN)
	print 'D_ME: ' + convert(varchar,@MtoD_ME) + '  Ha_ME: ' + convert(varchar,@MtoH_ME)



	set @SaldoMN = round((@MtoD_MN - @MtoH_MN),2)
	set @SaldoME = round((@MtoD_ME - @MtoH_ME),2) --@SaldoMN/@CamMda

	print ''
	print '----- SALDOS -----'
	print @SaldoMN
	print @SaldoME




	print 'MSJ: ' + @msj

	
	print 'BREAK_12'


	--COMPROBAMOS SI HAY DIF DE CAMBIO	

	if(@Cd_Fte='CB' or @Cd_Fte='LD')  --> tb se puede cancelar por LD Ejem: 42 a la 46 (Normalmente es 42 a la 10) <-- se pone LD xq  46 no es un banco (no sale la plata de la caja/banco de la empresa )
	begin
	print 'BREAK_13'	    
	print	@IB_PgTot

		if(select IB_DifC from PlanCtas where RucE=@RucE and NroCta=@NroCta) = 1 --> Solo se aplica Dif de Camb a las ctas marcadas
		BEGIN

		    if (select count(RegCtb) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)>1 and @IB_PgTot=1 --> Y si es un pago Total
		    begin --> Aplicamos Dif. de Camb. x Mov. segun perdida o ganancia
	
			print 'BREAK_14'
	
			declare @Cta_DCPer nvarchar(12), @Cta_DCGan nvarchar(12)
			select  @Cta_DCPer = DCPer, @Cta_DCGan = DCGan from PlanCtasDef where RucE=@RucE
	
			set @Cd_Aux = null
			set @Cd_TD = null
			set @NroSre = null
			set @NroDoc = null
	
			if (@SaldoME!=0)
			begin 
	     		     set @Mto = abs(@SaldoME)
			     set @IC_CtrMd = '$'
			     set @Cd_MdRg = '02'
			     
			     if(@SaldoME<0)
			     begin
				set @SaldoME = abs(@SaldoME)
				--set @IC_CtrMd = '$'
				--set @Cd_MdRg = '02'
				exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @Cta_DCPer, null/*@Cd_Aux*/, null/*@Cd_TD*/, null/*@NroSre*/,
				     null/*@NroDoc*/, @FecED, @FecVD, @Glosa, @MtoOr, @SaldoME, 0.00, @Cd_MdOr, '02', @CamMda, @Cd_CC,
				     @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, '$', @UsuCrea, @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output
				set @NroCta = @Cta_DCPer
			     end
			     else
			     begin
				exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @Cta_DCGan, null/*@Cd_Aux*/, null/*@Cd_TD*/, null/*@NroSre*/,
				     null/*@NroDoc*/, @FecED, @FecVD, @Glosa, @MtoOr, 0.00, @SaldoME, @Cd_MdOr, '02', @CamMda, @Cd_CC,
				     @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, '$', @UsuCrea, @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output
				set @NroCta = @Cta_DCGan
			     end

			end

			--else if (@SaldoMN!=0) 
			if (@SaldoMN!=0) -- Tb debemos comprobar si es que esta cuadrando en la otra moneda (por eso se comento la linea anterior)
			begin
			     set @Mto = abs(@SaldoMN)
			     set @IC_CtrMd = 's'
			     set @Cd_MdRg = '01'

			     if(@SaldoMN<0)
			     begin
				set @SaldoMN = abs(@SaldoMN)
				exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @Cta_DCPer, null/*@Cd_Aux*/, null/*@Cd_TD*/, null/*@NroSre*/,
				     null/*@NroDoc*/, @FecED, @FecVD, @Glosa, @MtoOr, @SaldoMN, 0.00, @Cd_MdOr, '01', @CamMda, @Cd_CC,
				     @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, 's', @UsuCrea, @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output
				set @NroCta = @Cta_DCPer
			     end
			     else
			     begin
				exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @Cta_DCGan, null/*@Cd_Aux*/, null/*@Cd_TD*/, null/*@NroSre*/,
				     null/*@NroDoc*/, @FecED, @FecVD, @Glosa, @MtoOr, 0.00, @SaldoMN, @Cd_MdOr, '01', @CamMda, @Cd_CC,
				     @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, 's', @UsuCrea, @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output
				set @NroCta = @Cta_DCGan
			     end
			end
	
			print 'BREAK_15'
	

		    	--Ponemos saldos en 0.00 xq ya se aplico Dif. de Camb.
			set @SaldoME = 0.00
		    	set @SaldoMN = 0.00
			
		    end	--> FIN: if (select count(RegCtb)...  Aplicamos Dif. de Camb. x Mov. segun perdida o ganancia






			print 'MSJ: ' + @msj

			-- VOLVEMOS A BUSCAR AMARRE CUENTAS --------------------------------------- ¿xq se vuelve a buscar?
			print '-- VOLVEMOS A BUSCAMOS AMARRE CUENTAS ---------------------------------------------------'
		
			--declare @IB_InvertAmr bit
			set @IB_InvertAmr = 0
		
/*
			if @Cd_Fte = 'RC' or @Cd_Fte = 'LD'  --> debe estar discriminado por Fte?
				if @TipMov = 'M'
					if(@MtoD>0) --> cuando es 'M' el monto ingresado es la BIM y va al Debe Ejem: 63.1.0.01   100
						set @IB_InvertAmr = 0 --> es normal
					else 	set @IB_InvertAmr = 1 --> Invertimos
				else if @TipMov = 'A'
					if(@MtoH>0)  --> cuando es 'A' el monto ingresado va al Haber Ejem: 42.1.0.01   119
						set @IB_InvertAmr = 0 --> es normal
					else 	set @IB_InvertAmr = 1 --> Invertimos
		
			--else if @Cd_Fte = 'RC'  -FALTARIA PARA RV?  ¿RV LLEVA AMARRES? - PREGUNTAR  ¿Y LD?
*/
			print 'BREAK_16'
	
	
			if(select IB_CtaD from PlanCtas where RucE=@RucE and NroCta=@NroCta)=1
			begin
				--declare @CtaD nvarchar(10), @CtaH nvarchar(10), @Porc numeric(5,2), @MtoDest numeric(13,2), @CtaTemp nvarchar(10) --(para invertir Amr)
				set @CtaD = '' 
				set @CtaH = ''
				set @CtaTemp = ''
				set @Porc = 0
				set @MtoDest = 0
				--set @Mto = 0
				--solo se debe registrar en la moneda que se produjo la dif de cambio (segun Rafael)
				--set @IC_CtrMd = 'a' --> resuelve el problema del lado de CtaD cuando es perdida ¿? ver este tema

				declare Cur_CtaDet2 cursor for select CtaD, CtaH, Porc from AmarreCta where RucE=@RucE and NroCta=@NroCta
				open Cur_CtaDet2	
				     fetch Cur_CtaDet2 into @CtaD, @CtaH, @Porc
					-- mientras haya datos
					while (@@fetch_status=0)
					begin
		
						--Lo normal que si es RC:
						--CtaAsoc Ejm 63.1.0.01 va al debe
						--Ejm:  
						-- 63.1.0.01	100
						-- 40.1.0.01	 19
						-- 42.1.0.01		119
						-- 94.1.0.01	 60
						-- 95.1.0.01	 40
						-- 19.1.0.01		100
						--SI ES EXTORNO SE REGISTRA AL REVES(siendo RC):
		
						if (@IB_InvertAmr = 1)
						begin
							set @CtaTemp = @CtaD
							set @CtaD = @CtaH
							set @CtaH = @CtaTemp
							PRINT '--- ¡¡¡SE INVIRTIO AMARRE!!! ---'
						end
				
		
						print 'NroCta: (Cta Analizada) --> ' + @NroCta --77
						print '-----'
						print 'CtaD: ' + @CtaD --97
						print 'CtaH: ' + @CtaH --79
						print 'Porc: ' + convert(varchar,@Porc)  + ' %' --100%

		
		--				if(@MtoD>0) set @Mto=@MtoD
		--				else set @Mto=@MtoH
						set @MtoDest = 0				
						set @MtoDest=@Mto*@Porc/100  --(saldo ya se asigno a Mto en el Analisis de Dif. Camb.)
						print 'Monto Dest. --> ' + convert(varchar,@MtoDest)
		
						--AGREGAMOS CUENTA DESTINO DEBE
						if not exists (select NroCta from Voucher where RucE=@RucE and Ejer=@Ejer and Prdo=@Prdo and RegCtb=@RegCtb and NroCta=@CtaD )
						begin
							print 'Insertamos amarre DEB ' + @CtaD
							exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaD, @Cd_Aux, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 
										   @MtoDest, 0.00, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
										   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output
							if @msj <> '' return
						end
						else  --begin update Voucher set MtoD=MtoD+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaD end
						begin 	print 'Modificamos amarre DEB (Acumulamos) ' + @CtaD
							exec pvo.Ctb_VoucherMdf_Mto @RucE,@Ejer,@Prdo,@RegCtb,@MtoDest,0.00,@CtaD,@Cd_MdRg,@CamMda,@IC_CtrMd,@Msj output 
						end
		
		
		
		
						--AGREGAMOS CUENTA DESTINO HABER
						if not exists (select NroCta from Voucher where RucE=@RucE and Ejer=@Ejer and Prdo=@Prdo and RegCtb=@RegCtb and NroCta=@CtaH )
						begin
							print 'Insertamos amarre HAB ' + @CtaH
							exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaH, @Cd_Aux, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 
										   0.00, @MtoDest, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
										   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output
							if @msj <> '' return
						end
						else  --begin update Voucher set MtoH=MtoH+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaH end
						begin 	print 'Modificamos amarre HAB (Acumulamos) ' + @CtaH
							exec pvo.Ctb_VoucherMdf_Mto @RucE,@Ejer,@Prdo,@RegCtb,0.00,@MtoDest,@CtaH,@Cd_MdRg,@CamMda,@IC_CtrMd,@Msj output 
						end
					
				
					fetch Cur_CtaDet2 into @CtaD, @CtaH, @Porc
					END
				close Cur_CtaDet2
				deallocate Cur_CtaDet2
			end


			-- FIN -- VOLVEMOS A BUSCAR AMARRE CUENTAS --------------------------------------- ¿xq se vuelve a buscar?





		
		END --> FIN: if(select IB_DifC from PlanCtas where RucE=@RucE and NroCta=@NroCta) = 1 ...




--	end --FIN if(@Cd_Fte='CB')  (MAS ABAJO)

		-- VOLVEMOS A BUSCAR AMARRE CUENTAS --------------------------------------- ¿xq se vuelve a buscar?

	end --FIN if(@Cd_Fte='CB' or @Cd_Fte='LD')


	print 'BREAK_17'

--end
print @msj
--PV: Jue 29/01/09
--PV: Jue 26/02/09 --> Agregue Dif. de Camb.
--PV: Vie 27/02/09 --> Arregle Dif. de Camb.
--PV: Vie 19/03/09 --> Agregue 4 campos
--PV: LUN 11/05/09 --> Creado --> se descuadraba mtos de ctas de amarre en Mtos_ME
--PV: VIE 26/06/09 --> Modf --> que se cancele tb por LD
--PV: VIE 22/07/09 --> Modf --> Cta Dest. Dif de Camb.
--PV: LUN 28/07/09 --> Modf --> Se agregaron campos de Doc. Ref.

GO

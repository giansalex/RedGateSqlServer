SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [pvo].[Ctb_VoucherCrea13] --Modificacion: 13
@RucE		nvarchar(11),
--@Cd_Vou	int,
@Ejer		nvarchar(4),
@Prdo		nvarchar(2),
@RegCtb	nvarchar(15),
@Cd_Fte	varchar(2),
@FecMov	smalldatetime,
@FecCbr	smalldatetime,
@NroCta	nvarchar(10),	
@CtaAsoc nvarchar(12),  --> cta definida en Clientes/Proveedores (60,70)
--@Cd_Aux	nvarchar(7),
----------------------
@Cd_Clt	char(10),
@Cd_Prv	char(7),
----------------------
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
@CamMda 	numeric(10,7),
@Cd_CC	nvarchar(8),
@Cd_SC	nvarchar(8),
@Cd_SS	nvarchar(8),
@Cd_Area 	nvarchar(6),
@Cd_MR	nvarchar(2),
@NroChke 	varchar(30),
@Cd_TG	nvarchar(2),
@IC_CtrMd	varchar(1), --> s: Soles, $: Dolares, a: Ambas
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
------------------------------
@DR_NCND	varchar(15),	-- NULL  Nro Comprobante No Domiciliado
@DR_NroDet	varchar(15),	-- NULL  Nro Detraccion
@DR_FecDet	smalldatetime,	-- NULL  Fecha Detraccion
------------------------------
--ya no van a ser necesarios:
--@IC_MdaDcdNat	char(1) output, --> s:soles, d:Dolares, x:No Hay Descuadre --> Indicador Moneda Descuadre en Naturaleza
--@IC_MdaDcdDst	char(1) output, --> s:soles, d:Dolares, x:No Hay Descuadre --> Indicador Moneda Descuadre en Destinos
------------------------------
@IB_JalaAmr 	bit,		-- Indicador Jala Amarre
------------------------------
@Cd_TMP 	char(3),		-- Codigo Tipo Medio Pago
------------------------------

@msj 		varchar(100) output

--with encryption
as
print 'BREAK_1'

--(Soluc 1)  -- Desencadeno un error que no devolviera los saldos a la hora de registrar el voucher (VER XQ)
--SET ANSI_NULLS OFF  -- Para que se pueda igualar a NULL (NroSre = @NroSre)
--if @NroSre = ''   -- Por si acaso
--   set @NroSre = null

--(Soluc 2)
if @NroSre=null or @NroSre is null 
begin
   set @NroSre = ''
end


--(Soluc 1)
--	if exists (select * from Voucher where RucE=@RucE and Cd_TD=@Cd_TD and NroSre = @NroSre and NroDoc=@NroDoc and Cd_Aux=@Cd_Aux and Cd_Fte=@Cd_Fte) and @Cd_Fte!='CB' and @Cd_Fte!='LD'

--(Soluc 2)
/*Ya no se hace de esta forma
	--if exists (select * from Voucher where RucE=@RucE and Cd_TD=@Cd_TD and isnull(NroSre,'') = @NroSre and NroDoc=@NroDoc and Cd_Aux=@Cd_Aux and Cd_Fte=@Cd_Fte) and @Cd_Fte!='CB' and @Cd_Fte!='LD'
	if exists (select * from Voucher where RucE=@RucE and Cd_TD=@Cd_TD and isnull(NroSre,'') = @NroSre and NroDoc=@NroDoc and / *Cd_Aux=@Cd_Aux* / Cd_Clt=@Cd_Clt and Cd_Prv=@Cd_Prv and Cd_Fte=@Cd_Fte) and @Cd_Fte!='CB' and @Cd_Fte!='LD'
	begin	--set @msj = 'Ya existe un registro con el mismo tipo, serie y numero de documento para dicho auxiliar.'
		set @msj = 'Ya existe un registro con el mismo tipo, serie y numero de documento para dicho ' + Case(isnull(@Cd_Clt,0)) when 0 then 'Proveedor' else 'Cliente' end
		print @msj
		return
	end
*/

	--Posible solucion
	--select * from Voucher where RucE='11111111111' and Cd_TD='01' and NroDoc='901070' and Case(isnull(@Cd_Clt,0)) when 0 then Cd_Prv else @Cd_Clt end = isnull(@Cd_Clt,@Cd_Prv)


--select  IB_CtasXCbr from PlanCtas where RucE='20504743561' and Ejer='2011' and NroCta='70.4.1.10'

--if exists (select * from Voucher v, PlanCtas p where v.RucE='20504743561' and v.RucE=p.RucE and p.Ejer='2011'and p.NroCta=v.NroCta and p.NroCta='12.1.2.10' and p.IB_CtasXCbr=1 and v.Cd_TD='01' and isnull(v.NroSre,'') = '001' and v.NroDoc='0003316' and v.Cd_Fte='RV') and 'RV'!='CB' and 'RV'!='LD' -- cuando sea una cancelacion no comprobamos nrodoc ya que pueden haber varias cancelaciones | and @EsCtaxCbr xq solo validamos Nro de Doc cuando la cuenta sea Cuenta por Cobrar
--print 'hay'

	if @Cd_Clt is not null
	begin

		--IB_CtaxCbr=1 xq solo validamos Nro de Doc cuando la cuenta sea Cuenta por Cobrar

		--if exists (select * from Voucher where RucE=@RucE and Cd_TD=@Cd_TD and isnull(NroSre,'') = @NroSre and NroDoc=@NroDoc and Cd_Fte='RV') and @Cd_Fte!='CB' and @Cd_Fte!='LD' and @EsCtaxCbr=1 -- cuando sea una cancelacion no comprobamos nrodoc ya que pueden haber varias cancelaciones 
		if exists (select * from Voucher v, PlanCtas p where v.RucE=@RucE and v.RucE=p.RucE and p.Ejer=@Ejer and p.NroCta=@NroCta and p.NroCta=v.NroCta and p.IB_CtasXCbr=1 and v.Cd_TD=@Cd_TD and isnull(v.NroSre,'') = @NroSre and v.NroDoc=@NroDoc and v.Cd_Fte='RV') and @Cd_Fte!='CB' and @Cd_Fte!='LD' -- cuando sea una cancelacion no comprobamos nrodoc ya que pueden haber varias cancelaciones 
		begin	--set @msj = 'Ya existe un registro con el mismo tipo, serie y numero de documento para dicho auxiliar.'
			set @msj = 'Ya existe un Registro de Venta con el mismo tipo, serie y numero de documento.'
			print @msj
			return
		end
	end
	else --if @Cd_Prv is not null
	begin

		--IB_CtaxPag=1 xq solo validamos Nro de Doc cuando la cuenta sea Cuenta por Pagar

		--if exists (select * from Voucher where RucE=@RucE and Cd_TD=@Cd_TD and isnull(NroSre,'') = @NroSre and NroDoc=@NroDoc and Cd_Fte='RC' and Cd_Prv=@Cd_Prv) and @Cd_Fte!='CB' and @Cd_Fte!='LD' -- cuando sea una cancelacion no comprobamos nrodoc ya que pueden haber varias cancelaciones 
		if exists (select * from Voucher v, PlanCtas p where v.RucE=@RucE and v.RucE=p.RucE and p.Ejer=@Ejer and p.NroCta=@NroCta and p.NroCta=v.NroCta and p.IB_CtasXPag=1 and v.Cd_TD=@Cd_TD and isnull(v.NroSre,'') = @NroSre and v.NroDoc=@NroDoc and v.Cd_Fte='RC' and v.Cd_Prv=@Cd_Prv) and @Cd_Fte!='CB' and @Cd_Fte!='LD' -- cuando sea una cancelacion no comprobamos nrodoc ya que pueden haber varias cancelaciones 
		begin	--set @msj = 'Ya existe un registro con el mismo tipo, serie y numero de documento para dicho auxiliar.'
			set @msj = 'Ya existe un Registro de Compra con el mismo tipo, serie y numero de documento para dicho proveedor'
			print @msj
			return
		end
	end


/* NO SE PUEDE UTILIZAR ESTE METODO XQ NO TODOS LOS NUMERO DE DOCUMENTO SON NUMERICOS

	if exists (select * from Voucher where RucE=@RucE and Cd_TD=@Cd_TD and NroSre=@NroSre and cast(NroDoc as int)= cast(@NroDoc as int) and Cd_Aux=@Cd_Aux and Cd_Fte=@Cd_Fte) and @Cd_Fte!='CB' and @Cd_Fte!='LD'
	begin	set @msj = 'Existe un número de documento parecido, verificar.'
		print @msj
		return
	end
*/	


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
	declare @Cd_Vou int -- Agregado temporalmente (este deberia ser devuelto en un output en los pvo.Ctb_VoucherInsert4,5 )
	
	--declare @MtoD_MN numeric(13,2),  @MtoH_MN numeric(13,2)
	--declare @MtoD_ME numeric(13,2),  @MtoH_ME numeric(13,2)


	if @TipMov = 'M'
	begin


		--Temporal
		set @Cd_Vou = dbo.Cod_Vou(@RucE) -- codigo que se insertará


		print  '------ ASIENTO MANUAL ---------------------------------------'
		print  '--- (Insertamos registro) -----------------------------------'
		exec pvo.Ctb_VoucherInsert8 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, /*@Cd_Aux*/ @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre,
					   @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @MtoD, @MtoH, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
					   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
					   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @DR_FecED, @DR_CdTD, @DR_NSre, @DR_NDoc, @Cd_TMP, @msj output
		
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
										--Mdf exclusiva para V2
		set @CtaIGV = ( select IGV from PlanCtasDef where RucE=@RucE and Ejer=@Ejer )
		set @igv = (select Tasa from Tasas where Cd_Ts = 'T01')
		set @igv = User321.DameIGVPrc(convert(varchar,@FecMov,103)) --Ahora jalamos el IGV segun la funcion ya q este puede variar segun la fecha de movimiento

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
			set @BIM_H = @Mto --> se asigna BIM calculada ya sea afecta o inafecta
			set @IGV_D = 0.00
			set @IGV_H = @MtoIGV --> se asigna Monto IGV si es que hubiera
		end



		if(@Cd_Fte='RC')
			print '-- REGISTRO COMPRAS AUTOMATICO -------------------------------------'
		else if(@Cd_Fte='RV')
			print '-- REGISTRO VENTAS AUTOMATICO -------------------------------------'

		--Temporal
		set @Cd_Vou = dbo.Cod_Vou(@RucE) -- codigo que se insertará

		-- Registramos BIM --
		print '-- Registramos BIM --'
		exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaAsoc, /*@Cd_Aux*/ @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre,
					 --@NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @Mto, 0.00, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
					   @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @BIM_D, @BIM_H, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
					   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
					   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output

		--Registramos IGV (si es que hubiera)
		if @MtoIGV > 0 
		begin	print '-- Registramos IGV --' 
			exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaIGV, /*@Cd_Aux*/ @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre,
						   @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @IGV_D, @IGV_H, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
						   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
						   /*@IC_TipAfec*/null, @TipOper, @Grdo, @IB_EsProv, @msj output
		end


		--Registramos provision auxiliar RC/RV (CtasxPag/CtasXCbr)
		print '-- Registramos Provision --'
		set @IC_TipAfec = null --Solo se guarda en el registro necesario (que es el BIM), aca no se guarda
		exec pvo.Ctb_VoucherInsert8 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, /*@Cd_Aux*/ @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre,
					 --@NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @MtoD, 0.00, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
					   @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @MtoD, @MtoH, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
					   @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
					   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @DR_FecED, @DR_CdTD, @DR_NSre, @DR_NDoc, @Cd_TMP, @msj output

		set @NroCta = @CtaAsoc


 	end -- FIN: if @TipMov = 'A'  ------------ FIN ASIENTO AUTOMATICO ----------------------------------------


	print 'BREAK_9'

	print 'MSJ: ' + @msj


	-- BUSCAMOS AMARRE CUENTAS ----------------------------------------------------------
	print '-- BUSCAMOS AMARRE CUENTAS ---------------------------------------------------'

	declare @IB_InvertAmr bit

	if @Cd_Fte = 'RC' or @Cd_Fte = 'LD' or @Cd_Fte = 'CB' --> debe estar discriminado por Fte?
		if @TipMov = 'M'
			if(@MtoD>0) --> cuando es 'M' el monto ingresado es la BIM y va al Debe Ejem: 63.1.0.01   100
				set @IB_InvertAmr = 0 --> es normal
			else 	set @IB_InvertAmr = 1 --> Invertimos
		else if @TipMov = 'A'
			if(@MtoH>0)  --> cuando es 'A' el monto ingresado va al Haber Ejem: 42.1.0.01   119
				set @IB_InvertAmr = 0 --> es normal
			else 	set @IB_InvertAmr = 1 --> Invertimos

	--else if @Cd_Fte = 'RC'  -FALTARIA PARA RV?  ¿RV LLEVA AMARRES? - PREGUNTAR  ¿Y LD?


	-- Suma de Destinos Antes de aplicar Destinos		
	declare @SmDADMtoD_MN numeric(13,2),  @SmDADMtoH_MN numeric(13,2)
	declare @SmDADMtoD_ME numeric(13,2),  @SmDADMtoH_ME numeric(13,2)

							-- Mdf exclusiva para V2
	if(select IB_CtaD from PlanCtas where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta)=1 and @IB_JalaAmr=1
	begin
		declare @CtaD nvarchar(10), @CtaH nvarchar(10), @Porc numeric(5,2), @MtoDest numeric(13,2), @CtaTemp nvarchar(10) --(para invertir Amr)
		--set @Mto = 0

-----------------------------------------------------------
		--GUARDAMOS la Suma de Destinos Antes de aplicar Destinos	
		select @SmDADMtoD_MN = isnull(sum(MtoD),0), @SmDADMtoH_MN = isnull(sum(MtoH),0), @SmDADMtoD_ME = isnull(sum(MtoD_ME),0), @SmDADMtoH_ME = isnull(sum(MtoH_ME),0)
		from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @RegCtb and IB_EsDes = 1
		print '          --------------'
		print '          SUMAS DESTINOS ANTES DE DESTINOS: (a sumar) ' +  'a Mda ' + @Cd_MdRg + ' (debe estar cuadrada en ambas monedas con sus bases)' --Suma en mda de registro pero chanca en la conversion
		print '          @SmDADMtoD_MN: ' + convert(varchar,@SmDADMtoD_MN)
		print '          @SmDADMtoH_MN: ' + convert(varchar,@SmDADMtoH_MN)
		print '          @SmDADMtoD_ME: ' + convert(varchar,@SmDADMtoD_ME)
		print '          @SmDADMtoH_ME: ' + convert(varchar,@SmDADMtoH_ME)
		print '          --------------'
-----------------------------------------------------------

												-- Mdf Pendiente para V2
		declare Cur_CtaDet cursor for select CtaD, CtaH, Porc from AmarreCta where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta
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
				
				print '-----'
				print '@Cd_MdRg: ' + @Cd_MdRg 
				print '@IC_CtrMd: ' + @IC_CtrMd


--				if(@MtoD>0) set @Mto=@MtoD
--				else set @Mto=@MtoH
				set @MtoDest = 0				
				set @MtoDest=@Mto*@Porc/100
				print 'Monto Dest. --> ' + convert(varchar,@MtoDest)

				--AGREGAMOS CUENTA DESTINO DEBE
				if not exists (select NroCta from Voucher where RucE=@RucE and Ejer=@Ejer and Prdo=@Prdo and RegCtb=@RegCtb and NroCta=@CtaD )
				begin
					print 'Insertamos amarre DEB ' + @CtaD
					exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaD, /*@Cd_Aux*/ @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 
								   @MtoDest, 0.00, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
								   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output

					--Decimos que la cuenta agregada es de destino (Mejorar este proceso)
					update voucher set IB_EsDes=1 where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@CtaD

					if @msj <> '' return
				end
				else  --begin update Voucher set MtoD=MtoD+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaD end
				begin 	print 'Modificamos amarre DEB (Acumulamos) ' + @CtaD
					exec pvo.Ctb_VoucherMdf_Mto_AcumRem @RucE,@Ejer,@Prdo,@RegCtb,@MtoDest,0.00,@CtaD,@Cd_MdRg,@CamMda,@IC_CtrMd,@Msj output 

				end


				--AGREGAMOS CUENTA DESTINO HABER
				if not exists (select NroCta from Voucher where RucE=@RucE and Ejer=@Ejer and Prdo=@Prdo and RegCtb=@RegCtb and NroCta=@CtaH )
				begin
					print 'Insertamos amarre HAB ' + @CtaH
					exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaH, /*@Cd_Aux*/ @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 
								   0.00, @MtoDest, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
								   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output

					--Decimos que la cuenta agregada es de destino (Mejorar este proceso)
					update voucher set IB_EsDes=1 where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@CtaH

					if @msj <> '' return
				end
				else  --begin update Voucher set MtoH=MtoH+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaH end
				begin 	print 'Modificamos amarre HAB (Acumulamos) ' + @CtaH
					exec pvo.Ctb_VoucherMdf_Mto_AcumRem @RucE,@Ejer,@Prdo,@RegCtb,0.00,@MtoDest,@CtaH,@Cd_MdRg,@CamMda,@IC_CtrMd,@Msj output 
				end


			
		
			fetch Cur_CtaDet into @CtaD, @CtaH, @Porc
			END
		close Cur_CtaDet
		deallocate Cur_CtaDet



-----------------------------------------------------------
		--Print '-- Comprabamos que los destinos hayan sido grabados con el 100% exacto -- (1ra Vez)'
		Print '-- SP: Llamamos a Ctb_Voucher_CompDst_enCrea -- (1ra Vez)'
		exec pvo.Ctb_Voucher_CompDst_enCrea @RucE,@Cd_Vou,@Ejer,@Prdo,@RegCtb,/*@NroCta,*/@Cd_MdRg,@CamMda,@IC_CtrMd, @Mto,@SmDADMtoD_MN,@SmDADMtoH_MN,@SmDADMtoD_ME,@SmDADMtoH_ME,@Msj output 
		--Print '-- FIN: Comprabamos que los destinos hayan sido grabados con el 100% exacto --'
-----------------------------------------------------------




	end





	-------------------------------------------------------------------------------------

	print 'MSJ: ' + @msj


	print 'BREAK_10'






	--Ahora los declaramos mas arriba
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
	from Voucher where RucE=@RucE and RegCtb = @RegCtb and Ejer=@Ejer


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
								-- Mdf exclusiva para V2
		if(select IB_DifC from PlanCtas where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta) = 1 --> Solo se aplica Dif de Camb a las ctas marcadas
		BEGIN

		    if (select count(RegCtb) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)>1 and @IB_PgTot=1 --> Y si es un pago Total
		    begin --> Aplicamos Dif. de Camb. x Mov. segun perdida o ganancia
	
			print 'BREAK_14'
	
			declare @Cta_DCPer nvarchar(12), @Cta_DCGan nvarchar(12)
													--Mdf exclusiva para V2
			select  @Cta_DCPer = DCPer, @Cta_DCGan = DCGan from PlanCtasDef where RucE=@RucE and Ejer=@Ejer
	
			--set @Cd_Aux = null
			set @Cd_Clt = null
			set @Cd_Prv = null
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
				exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @Cta_DCPer, null,null/*@Cd_Aux*/, null/*@Cd_TD*/, null/*@NroSre*/,
				     null/*@NroDoc*/, @FecED, @FecVD, @Glosa, @MtoOr, @SaldoME, 0.00, @Cd_MdOr, '02', @CamMda, @Cd_CC,
				     @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, '$', @UsuCrea, @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output
				set @NroCta = @Cta_DCPer
			     end
			     else
			     begin
				exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @Cta_DCGan, null, null/*@Cd_Aux*/, null/*@Cd_TD*/, null/*@NroSre*/,
				     null/*@NroDoc*/, @FecED, @FecVD, @Glosa, @MtoOr, 0.00, @SaldoME, @Cd_MdOr, '02', @CamMda, @Cd_CC,
				     @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, '$', @UsuCrea, @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output
				set @NroCta = @Cta_DCGan
			     end






				print 'MSJ: ' + @msj

				--Esto deberia llamar otro sp ya que se repite varias veces
				-- VOLVEMOS A BUSCAR AMARRE CUENTAS (POR 2DA VEZ) --------------------------------------- ¿xq se vuelve a buscar?
				print '-- VOLVEMOS A BUSCAMOS AMARRE CUENTAS (POR 2DA VEZ) ---------------------------------------------------'
			
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
		
										-- Mdf exclusiva para V2
				if(select IB_CtaD from PlanCtas where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta)=1 and @IB_JalaAmr=1
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
	
			-----------------------------------------------------------
					--GUARDAMOS la Suma de Destinos Antes de aplicar Destinos POR 2DA VEZ
					set @SmDADMtoD_MN = 0 set @SmDADMtoH_MN = 0
					set @SmDADMtoD_ME = 0 set @SmDADMtoH_ME = 0
					select @SmDADMtoD_MN = isnull(sum(MtoD),0), @SmDADMtoH_MN = isnull(sum(MtoH),0), @SmDADMtoD_ME = isnull(sum(MtoD_ME),0), @SmDADMtoH_ME = isnull(sum(MtoH_ME),0)
					from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @RegCtb and IB_EsDes = 1
					print '          --------------'
					print '          SUMAS DESTINOS ANTES DE DESTINOS (2da Vez): (a sumar) ' +  'a Mda ' + @Cd_MdRg + ' (debe estar cuadrada en ambas monedas con sus bases)' --Suma en mda de registro pero chanca en la conversion
					print '          @SmDADMtoD_MN: ' + convert(varchar,@SmDADMtoD_MN)
					print '          @SmDADMtoH_MN: ' + convert(varchar,@SmDADMtoH_MN)
					print '          @SmDADMtoD_ME: ' + convert(varchar,@SmDADMtoD_ME)
					print '          @SmDADMtoH_ME: ' + convert(varchar,@SmDADMtoH_ME)
					print '          --------------'
			-----------------------------------------------------------
															-- Mdf Pendiente para V2
					declare Cur_CtaDet2 cursor for select CtaD, CtaH, Porc from AmarreCta where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta
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
	
			
					--		if(@MtoD>0) set @Mto=@MtoD
					--		else set @Mto=@MtoH
							set @MtoDest = 0				
							set @MtoDest=@Mto*@Porc/100  --(saldo ya se asigno a Mto en el Analisis de Dif. Camb.)
							print 'Monto Dest. --> ' + convert(varchar,@MtoDest)
			
							--AGREGAMOS CUENTA DESTINO DEBE
							if not exists (select NroCta from Voucher where RucE=@RucE and Ejer=@Ejer and Prdo=@Prdo and RegCtb=@RegCtb and NroCta=@CtaD )
							begin
								print 'Insertamos amarre DEB ' + @CtaD
								exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaD, /*@Cd_Aux*/ @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 
											   @MtoDest, 0.00, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
											   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output

								--Decimos que la cuenta agregada es de destino (Mejorar este proceso)
								update voucher set IB_EsDes=1 where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@CtaD

								if @msj <> '' return
							end
							else  --begin update Voucher set MtoD=MtoD+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaD end
							begin 	print 'Modificamos amarre DEB (Acumulamos) ' + @CtaD
								exec pvo.Ctb_VoucherMdf_Mto_AcumRem @RucE,@Ejer,@Prdo,@RegCtb,@MtoDest,0.00,@CtaD,@Cd_MdRg,@CamMda,@IC_CtrMd,@Msj output 
							end
			
			
			
			
							--AGREGAMOS CUENTA DESTINO HABER
							if not exists (select NroCta from Voucher where RucE=@RucE and Ejer=@Ejer and Prdo=@Prdo and RegCtb=@RegCtb and NroCta=@CtaH )
							begin
								print 'Insertamos amarre HAB ' + @CtaH
								exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaH, /*@Cd_Aux*/ @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 
											   0.00, @MtoDest, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
											   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output

								--Decimos que la cuenta agregada es de destino (Mejorar este proceso)
								update voucher set IB_EsDes=1 where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@CtaH

								if @msj <> '' return
							end
							else  --begin update Voucher set MtoH=MtoH+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaH end
							begin 	print 'Modificamos amarre HAB (Acumulamos) ' + @CtaH
								exec pvo.Ctb_VoucherMdf_Mto_AcumRem @RucE,@Ejer,@Prdo,@RegCtb,0.00,@MtoDest,@CtaH,@Cd_MdRg,@CamMda,@IC_CtrMd,@Msj output 
							end
						
					
						fetch Cur_CtaDet2 into @CtaD, @CtaH, @Porc
						END
					close Cur_CtaDet2
					deallocate Cur_CtaDet2

			-----------------------------------------------------------
					--Print '-- Comprabamos que los destinos hayan sido grabados con el 100% exacto -- (1ra Vez)'
					Print '-- SP: Llamamos a Ctb_Voucher_CompDst_enCrea -- (2da Vez)'
					exec pvo.Ctb_Voucher_CompDst_enCrea @RucE,@Cd_Vou,@Ejer,@Prdo,@RegCtb,/*@NroCta,*/@Cd_MdRg,@CamMda,@IC_CtrMd, @Mto,@SmDADMtoD_MN,@SmDADMtoH_MN,@SmDADMtoD_ME,@SmDADMtoH_ME,@Msj output 
					--Print '-- FIN: Comprabamos que los destinos hayan sido grabados con el 100% exacto --'
			-----------------------------------------------------------


				end
	
	
				-- FIN -- VOLVEMOS A BUSCAR AMARRE CUENTAS --------------------------------------- ¿xq se vuelve a buscar?










			end --FIN: if (@SaldoME!=0) -->si se encontro saldo en ME

			--Ponemos saldos en 0.00 xq ya se aplico Dif. de Camb.
			set @SaldoME = 0.00
		    	--set @SaldoMN = 0.00






------------------------------------------------- (LO COPIAMOS MAS ABAJO) --> PARA QUE SE COMPRUEBA PARA CADA CUENTA DE DIF DE CAMB SI TIENE AMARRE
/*			--else if (@SaldoMN!=0) 
			if (@SaldoMN!=0) -- Tb debemos comprobar si es que esta cuadrando en la otra moneda (por eso se comento la linea anterior)
			begin
			     set @Mto = abs(@SaldoMN)
			     set @IC_CtrMd = 's'
			     set @Cd_MdRg = '01'

			     if(@SaldoMN<0)
			     begin
				set @SaldoMN = abs(@SaldoMN)
				exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @Cta_DCPer, null/ *@Cd_Aux* /, null/ *@Cd_TD* /, null/ *@NroSre* /,
				     null/ *@NroDoc* /, @FecED, @FecVD, @Glosa, @MtoOr, @SaldoMN, 0.00, @Cd_MdOr, '01', @CamMda, @Cd_CC,
				     @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, 's', @UsuCrea, @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output
				set @NroCta = @Cta_DCPer
			     end
			     else
			     begin
				exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @Cta_DCGan, null/ *@Cd_Aux* /, null/ *@Cd_TD* /, null/ *@NroSre* /,
				     null/ *@NroDoc* /, @FecED, @FecVD, @Glosa, @MtoOr, 0.00, @SaldoMN, @Cd_MdOr, '01', @CamMda, @Cd_CC,
				     @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, 's', @UsuCrea, @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output
				set @NroCta = @Cta_DCGan
			     end
			end
	
			print 'BREAK_15'
	

		    	--Ponemos saldos en 0.00 xq ya se aplico Dif. de Camb.
			set @SaldoME = 0.00
		    	set @SaldoMN = 0.00
			
		    end	--> FIN: if (select count(RegCtb)...  Aplicamos Dif. de Camb. x Mov. segun perdida o ganancia
-------------------------------------------------*/



			






------------------------------------------------- 
			--else if (@SaldoMN!=0) 
			if (@SaldoMN!=0) -- Tb debemos comprobar si es que esta cuadrando en la otra moneda (por eso se comento la linea anterior)
			begin
			     set @Mto = abs(@SaldoMN)
			     set @IC_CtrMd = 's'
			     set @Cd_MdRg = '01'

			     if(@SaldoMN<0)
			     begin
				set @SaldoMN = abs(@SaldoMN)
				exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @Cta_DCPer, null, null/*@Cd_Aux*/, null/*@Cd_TD*/, null/*@NroSre*/,
				     null/*@NroDoc*/, @FecED, @FecVD, @Glosa, @MtoOr, @SaldoMN, 0.00, @Cd_MdOr, '01', @CamMda, @Cd_CC,
				     @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, 's', @UsuCrea, @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output
				set @NroCta = @Cta_DCPer
			     end
			     else
			     begin
				exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @Cta_DCGan, null, null/*@Cd_Aux*/, null/*@Cd_TD*/, null/*@NroSre*/,
				     null/*@NroDoc*/, @FecED, @FecVD, @Glosa, @MtoOr, 0.00, @SaldoMN, @Cd_MdOr, '01', @CamMda, @Cd_CC,
				     @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, 's', @UsuCrea, @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output
				set @NroCta = @Cta_DCGan
			     end






				--Por si hubo dif de camb en soles tb comprobamos amarre de cuentas
				-- VOLVEMOS A BUSCAR AMARRE CUENTAS (POR 3RA VEZ)--------------------------------------- ¿xq se vuelve a buscar?
				print '-- VOLVEMOS A BUSCAMOS AMARRE CUENTAS (POR 3RA VEZ)----------------¡¡ NO ES LO MISMO QUE EL 2DO !!-----------------------------------'
			
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
		
										-- Mdf exclusiva para V2
				if(select IB_CtaD from PlanCtas where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta)=1 and @IB_JalaAmr=1
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

			-----------------------------------------------------------
					--GUARDAMOS la Suma de Destinos Antes de aplicar Destinos POR 3RA VEZ
					set @SmDADMtoD_MN = 0 set @SmDADMtoH_MN = 0
					set @SmDADMtoD_ME = 0 set @SmDADMtoH_ME = 0
					select @SmDADMtoD_MN = isnull(sum(MtoD),0), @SmDADMtoH_MN = isnull(sum(MtoH),0), @SmDADMtoD_ME = isnull(sum(MtoD_ME),0), @SmDADMtoH_ME = isnull(sum(MtoH_ME),0)
					from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @RegCtb and IB_EsDes = 1
					print '          --------------'
					print '          SUMAS DESTINOS ANTES DE DESTINOS (3ra Vez): (a sumar) ' +  'a Mda ' + @Cd_MdRg + ' (debe estar cuadrada en ambas monedas con sus bases)' --Suma en mda de registro pero chanca en la conversion
					print '          @SmDADMtoD_MN: ' + convert(varchar,@SmDADMtoD_MN)
					print '          @SmDADMtoH_MN: ' + convert(varchar,@SmDADMtoH_MN)
					print '          @SmDADMtoD_ME: ' + convert(varchar,@SmDADMtoD_ME)
					print '          @SmDADMtoH_ME: ' + convert(varchar,@SmDADMtoH_ME)
					print '          --------------'
			-----------------------------------------------------------
															  -- Mdf Pendiente para V2
					declare Cur_CtaDet2 cursor for select CtaD, CtaH, Porc from AmarreCta where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta
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
	
			
					--		if(@MtoD>0) set @Mto=@MtoD
					--		else set @Mto=@MtoH
							set @MtoDest = 0				
							set @MtoDest=@Mto*@Porc/100  --(saldo ya se asigno a Mto en el Analisis de Dif. Camb.)
							print 'Monto Dest. --> ' + convert(varchar,@MtoDest)
			
							--AGREGAMOS CUENTA DESTINO DEBE
							if not exists (select NroCta from Voucher where RucE=@RucE and Ejer=@Ejer and Prdo=@Prdo and RegCtb=@RegCtb and NroCta=@CtaD and IC_CtrMd='s' ) -- se agrego and IC_CtrMd='s' 
							begin
								print 'Insertamos amarre DEB ' + @CtaD
								exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaD, /*@Cd_Aux*/ @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 
											   @MtoDest, 0.00, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
											   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output

								--Decimos que la cuenta agregada es de destino (Mejorar este proceso)
								update voucher set IB_EsDes=1 where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@CtaD

								if @msj <> '' return
							end
							else  --begin update Voucher set MtoD=MtoD+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaD end
							begin 	print 'Modificamos amarre DEB (Acumulamos) ' + @CtaD
								exec pvo.Ctb_VoucherMdf_Mto_AcumRem @RucE,@Ejer,@Prdo,@RegCtb,@MtoDest,0.00,@CtaD,@Cd_MdRg,@CamMda,@IC_CtrMd,@Msj output 
							end
			
			
			
			
							--AGREGAMOS CUENTA DESTINO HABER
							if not exists (select NroCta from Voucher where RucE=@RucE and Ejer=@Ejer and Prdo=@Prdo and RegCtb=@RegCtb and NroCta=@CtaH and IC_CtrMd='s' ) -- se agrego and IC_CtrMd='s' 
							begin
								print 'Insertamos amarre HAB ' + @CtaH
								exec pvo.Ctb_VoucherInsert4 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaH, /*@Cd_Aux*/ @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 
											   0.00, @MtoDest, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
											   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @msj output

								--Decimos que la cuenta agregada es de destino (Mejorar este proceso)
								update voucher set IB_EsDes=1 where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@CtaH

								if @msj <> '' return
							end
							else  --begin update Voucher set MtoH=MtoH+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaH end
							begin 	print 'Modificamos amarre HAB (Acumulamos) ' + @CtaH
								exec pvo.Ctb_VoucherMdf_Mto_AcumRem @RucE,@Ejer,@Prdo,@RegCtb,0.00,@MtoDest,@CtaH,@Cd_MdRg,@CamMda,@IC_CtrMd,@Msj output 
							end
						
					
						fetch Cur_CtaDet2 into @CtaD, @CtaH, @Porc
						END
					close Cur_CtaDet2
					deallocate Cur_CtaDet2

			-----------------------------------------------------------
					--Print '-- Comprabamos que los destinos hayan sido grabados con el 100% exacto -- (1ra Vez)'
					Print '-- SP: Llamamos a Ctb_Voucher_CompDst_enCrea -- (3ra Vez)'
					exec pvo.Ctb_Voucher_CompDst_enCrea @RucE,@Cd_Vou,@Ejer,@Prdo,@RegCtb,/*@NroCta,*/@Cd_MdRg,@CamMda,@IC_CtrMd, @Mto,@SmDADMtoD_MN,@SmDADMtoH_MN,@SmDADMtoD_ME,@SmDADMtoH_ME,@Msj output 
					--Print '-- FIN: Comprabamos que los destinos hayan sido grabados con el 100% exacto --'
			-----------------------------------------------------------
				end
	
	
				-- FIN -- VOLVEMOS A BUSCAR AMARRE CUENTAS --------------------------------------- ¿xq se vuelve a buscar?
	







			end --FIN: if (@SaldoMN!=0) --> si se encontro saldo en MN
	
			print 'BREAK_15'
	

		    	--Ponemos saldos en 0.00 xq ya se aplico Dif. de Camb. (AHORA YA NO) --> SINO SE CIERRA EL VOUCHER
			--set @SaldoME = 0.00
		    	set @SaldoMN = 0.00
			
		    end	--> FIN: if (select count(RegCtb)...  Aplicamos Dif. de Camb. x Mov. segun perdida o ganancia
-------------------------------------------------








		
		END --> FIN: if(select IB_DifC from PlanCtas where RucE=@RucE and NroCta=@NroCta) = 1 ...




--	end --FIN if(@Cd_Fte='CB')  (MAS ABAJO)

		-- VOLVEMOS A BUSCAR AMARRE CUENTAS --------------------------------------- ¿xq se vuelve a buscar?




	end --FIN if(@Cd_Fte='CB' or @Cd_Fte='LD')


	print 'BREAK_17'



	print  '------------ DETRACCION --------------------------------' --Preguntamos si hay nro de detraccion

	if ( @DR_NroDet is not null or @DR_NroDet = '')
	begin
		-- Buscamos provision RC para colocarle el nro de detraccion:
		/*
		declare @Cd_TD	nvarchar(2), @NroSre	nvarchar(4), @NroDoc	nvarchar(15), @RucE nvarchar(11), @DR_NroDet varchar(15), @DR_FecDet smalldatetime
		set @RucE='11111111111'
		set @Cd_TD = '01'
		set @NroSre = '002'
		set @NroDoc = '9090'
		set @DR_NroDet = 'DET00431'
		select * from voucher where RucE=@RucE and Cd_Fte='RC' and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc
		*/
		if(select count(RucE) from voucher where RucE=@RucE and Cd_Fte='RC' and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc)>1
		begin	set @msj = 'No se registro nro de detraccion, esta podria afectar a más de un documento. Verificar'
--			return
		end
		else
		begin
			print 'Agregamos nro de detraccion al documento provision'
			update voucher set DR_NroDet=@DR_NroDet, DR_FecDet=@DR_FecDet where RucE=@RucE and Cd_Fte='RC' and Cd_TD=@Cd_TD and NroSre=@NroSre and NroDoc=@NroDoc

		end 
		/*@DR_NCND,
		@DR_NroDet,
		@DR_FecDet,*/

	end -- if(@DR_NroDet is not null or @DR_NroDet == '')
	print  '--- Fin busqueda doc detraccion -----------------------'



	print ''


	/* Ya no vamos a necesitar esta comprobacion, xq en teoria los destinos siempre van a estar cuadrados
	print  '------------ Comprobamos descuadre en destinos ----------------------' 


	--Ahora estan definidos mas arriba (YA NO)
	declare @Sldo_MN_Nat numeric(13,2),  @Sldo_MN_Dst numeric(13,2)
	declare @Sldo_ME_Nat numeric(13,2),  @Sldo_ME_Dst numeric(13,2)

	set @Sldo_MN_Nat=0  set @Sldo_MN_Dst=0
	set @Sldo_ME_Nat=0  set @Sldo_ME_Dst=0


	select @Sldo_MN_Nat = isnull(sum(MtoD-MtoH),0), @Sldo_ME_Nat = isnull(sum(MtoD_ME-MtoH_ME),0)
	from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @RegCtb and isnull(IB_EsDes,0) = 0  -- Es bit y solo puede tomar valor 1 ó 0          ----- IB_EsDes != 1 (asi no sale)

	select @Sldo_MN_Dst = isnull(sum(MtoD-MtoH),0), @Sldo_ME_Dst = isnull(sum(MtoD_ME-MtoH_ME),0)
	from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @RegCtb and IB_EsDes = 1


	print 'Sldo_MN_Nat: ' + convert(varchar,@Sldo_MN_Nat) + '  Sldo_ME_Nat: ' + convert(varchar,@Sldo_ME_Nat)
	print 'Sldo_MN_Dst: ' + convert(varchar,@Sldo_MN_Dst) + '  Sldo_ME_Dst: ' + convert(varchar,@Sldo_ME_Dst)

	--OJO: dependiendo de este descuadre se debe llamar a pvo.Ctb_AjustaXConversion
		-- al parecer no es necesario hacer un sp "pvo.Ctb_AjustaXConversion_Dstnos" solo hacer que en el ya existente 
		-- ajuste bien y en la cuenta que se le indica (para esto debe salir una pantalla avisando donde esta el descuadre 
		-- entonces si sirven los indicadores)

	if @Sldo_MN_Nat != 0
		set @IC_MdaDcdNat = 's'
	else if @Sldo_ME_Nat != 0
		set @IC_MdaDcdNat = 'd'
	else set @IC_MdaDcdNat = 'x'

	if @Sldo_MN_Dst != 0
		set @IC_MdaDcdDst = 's'
	else if @Sldo_ME_Dst != 0
		set @IC_MdaDcdDst = 'd'
	else set @IC_MdaDcdDst = 'x'


	print ''
	print '----- Descuadres encontrados: -----'
	print 'Descuadre Naturaleza en: ' + @IC_MdaDcdNat
	print 'Descuadre Destino en: ' + @IC_MdaDcdDst

	print ''
	print  'FIN : ------------ Comprobamos descuadre en destinos ----------------------' 
	*/




--end
print @msj

set @msj=''

----------------------------------
-- PRUEBAS --
/*
--exec pvo.Ctb_VoucherCrea9 '11111111111','2010','03','CTGE_RC03-00124','RC','23/03/2010',NULL,'63.0.0.01','', 'CLT0001','01','001','2361',NULL,NULL,'glosa', 0.00,  0.00,  100.00, '01','01', 3.030, '01010101', '01010101', '01010101', '010101', '03', NULL, '01','a', 'admin', NULL, NULL,'M','S',null, null, null, 'I',1,0, NULL
exec pvo.Ctb_VoucherCrea9 '11111111111','2010','03','CTGE_RC03-00124','RC','23/03/2010',NULL,'63.0.0.01','', '','','','',NULL,NULL,'glosa', 0.00,  200.00,  0.00, '02','02', 2.877, '01010101', '01010101', '01010101', '010101', '03', NULL, '01','$', 'admin', NULL, NULL,'M','S',null, null, null, 'I',1,0, NULL, NULL, NULL, NULL, NULL
exec pvo.Ctb_VoucherCrea9 '11111111111','2010','03','CTGE_RC03-00124','RC','23/03/2010',NULL,'63.0.0.01','', '','','','',NULL,NULL,'glosa', 0.00,  200.00,  0.00, '02','02', 2.877, '01010101', '01010101', '01010101', '010101', '03', NULL, '01','$', 'admin', NULL, NULL,'M','S',null, null, null, 'T',1,0, NULL, NULL, NULL, NULL, NULL
exec pvo.Ctb_VoucherCrea9 '11111111111','2010','03','CTGE_RC03-00124','RC','23/03/2010',NULL,'63.0.0.01','', '','','','',NULL,NULL,'glosa', 0.00,  200.00,  0.00, '02','02', 2.877, '01010101', '01010101', '01010101', '010101', '03', NULL, '01','s', 'admin', NULL, NULL,'M','S',null, null, null, 'T',1,0, NULL, NULL, NULL, NULL, NULL

select * from voucher where RucE='11111111111' and RegCtb='CTGE_RC03-00124'
delete Voucher where RucE='11111111111' and RegCtb='CTGE_RC03-00124'

exec pvo.Ctb_VoucherCrea10 '11111111111','2010','07','CTGE_CB07-00002','CB','21/07/2010',NULL,'42.1.0.01','', 'CLT0001','01','002','9090',NULL,NULL,'glosa', 0.00,  0.00,   50.00, '01','01', 2.877, '01010101', '01010101', '01010101', '010101', '03', NULL, '01','s', 'admin', NULL, NULL,'M','S',null, null, null, 'T',1,0, NULL, NULL, NULL, NULL, NULL, 'DET_9821', '21/07/2010', NULL

--exec pvo.Ctb_VoucherCrea10 '11111111111','2010','09','CTGE_RC09-01000','RC','24/09/2010',NULL,'63.0.0.01','', 'CLT0001','01','002','9090',NULL,NULL,'glosa', 0.00,  0.00,   500.97, '01','02', 2.79, '01010101', '01010101', '01010101', '010101', '03', NULL, '01','a', 'admin', NULL, NULL,'M','S',null, null, null, 'T',1,0, NULL, NULL, NULL, NULL, NULL, 'DET_9821', '21/07/2010', NULL, NULL, NULL
exec pvo.Ctb_VoucherCrea10 '11111111111','2010','09','CTGE_RC09-01000','RC','24/09/2010',NULL,'42.1.0.01','63.0.0.01', 'CLT0001','01','002','9090',NULL,NULL,'glosa', 0.00,  0.00,   500.97, '01','02', 2.79, '01010101', '01010101', '01010101', '010101', '03', NULL, '01','a', 'admin', NULL, NULL,'A','S',null, null, null, 'T',1,1, NULL, NULL, NULL, NULL, NULL, 'DET_9821', '21/07/2010', NULL, NULL, NULL
select * from voucher where RucE='11111111111' and RegCtb='CTGE_RC09-01000'


*/




--PV: Jue 29/01/09
--PV: Jue 26/02/09 --> Agregue Dif. de Camb.
--PV: Vie 27/02/09 --> Arregle Dif. de Camb.
--PV: Vie 19/03/09 --> Agregue 4 campos
--PV: LUN 11/05/09 --> Creado --> se descuadraba mtos de ctas de amarre en Mtos_ME
--PV: VIE 26/06/09 --> Modf --> que se cancele tb por LD
--PV: VIE 22/07/09 --> Modf --> Cta Dest. Dif de Camb.
--PV: LUN 28/07/09 --> Modf --> Se agregaron campos de Doc. Ref.
--PV: DOM 11/10/09 --> Modf --> Se arreglo que no cuadraba la dif. cambio en la otra moneda (soles)
--PV: VIE 20/11/09 --> Modf --> A la hora de consultar el saldo del voucher no tomaba encuenta el @Ejer
---------------------------
--PV: VIE 29/01/2010 --> Modf --> se agrego validacion de numero de documento
--PV: MIE 24/03/2010 --> Modf --> se agrego Print´s @IC_CtrMd y @Cd_MdRg
--PV: JUE 20/05/2010 --> Modf --> se agrego para que tb se extornen los destinos en  CB (a solicitud de Rafael)
--PV: MIE 21/07/2010 --> Modf --> se agrego campos campos de Detraccion (y su registro de numero)
--PV: LUN 20/09/2010 --> Modf --> se agrego para que se registre IB_EsDes a la hora de insertar una cuenta de amarre (asi reconocemos los destinos luego)			    
--PV: VIE 24/09/2010 --> Modf --> se agrego indicadores para descuadres en naturaleza/destino
--PV: MAR 30/11/2010 --> Modf --> se agrego validacion de duplicidad de documentos de compra con el mismo proveedor
--PV: MAR 25/01/2011 --> Modf --> se agrego "and @IB_JalaAmr=1" para que solo se genere destinos si se desea

--PV: MAR 08/02/2011 --> FALTA!!! --> ....... Modf que se hizo en la 1ra version en esta fecha

--PV: MAR 17/02/2011 --> Modf --> se agrego "IB_CtaxCbr=1 xq solo validamos Nro de Doc cuando la cuenta sea Cuenta por Cobrar" ...y tb por Pagar
--PV: MAR 01/03/2011 --> Modf --> Se hizo el cambio para respetar el IGV segun fecha. Funcion: User321.DameIGVPrc()
--PV: MAR 03/03/2012 --> Modf --> se agrego decimales a @CamMda (10,7)
--PV: Vie 24/08/2012 - Mdf: se agregaron campos @Cd_TMP


GO

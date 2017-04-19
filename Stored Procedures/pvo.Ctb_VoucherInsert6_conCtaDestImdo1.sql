SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Ctb_VoucherInsert6_conCtaDestImdo1]
@RucE		nvarchar(11),
--@Cd_Vou	int,
@Ejer		nvarchar(4),
@Prdo		nvarchar(2),
@RegCtb	nvarchar(15),
@Cd_Fte	varchar(2),
@FecMov	smalldatetime,
@FecCbr	smalldatetime,
@NroCta	nvarchar(10),
@Cd_CC	nvarchar(8),
@Cd_SC	nvarchar(8),
@Cd_SS	nvarchar(8),
@Cd_Area 	nvarchar(6),
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
@Cd_MR	nvarchar(2),
@NroChke 	varchar(30),
@Cd_TG	nvarchar(2),
@UsuCrea 	nvarchar(10),
@IC_CtrMd	varchar(1),
@IC_TipAfec 	varchar(1),
@TipOper 	varchar(4),
@Grdo	 	varchar(100),
----------------------
@Cd_Prv	char(7),
@Cd_Clt	char(10),
----------------------
@IB_EsProv	bit,
------------------------------
@DR_FecED	smalldatetime,
@DR_CdTD	nvarchar(2),
@DR_NSre	nvarchar(4),
@DR_NDoc	nvarchar(15),
------------------------------
@TipMov		varchar(1), --> M: Manual, A: Automatico
------------------------------
@IB_Anulado bit,
@msj 		varchar(100) output
as

print '---- Entramos a SP: Ctb_VoucherInsert6_conCtaDestImdo1 -----'

/*
--POR AHORA CREAMOS ESTAS VARIABLES SIN NINGUN VALOR
----------------------
declare
@Cd_Clt	char(10),
@Cd_Prv	char(7)
----------------------
*/	


-- ESTO ES PARA AMARRE DE CUENTAS
	declare @Mto numeric(13,2)

	if(@MtoD>0) --> obtenemos Mto General
	begin	set @Mto=@MtoD
		--set @TipoIng='D'
	end
	else
	begin 	set @Mto=@MtoH 
		--set @TipoIng='H'
	end
	PRINT 'MONTO GENERAL: (D o H)'
	PRINT @Mto

-- FIN: ESTO ES PARA AMARRE DE CUENTAS



declare @Cd_Vou int
set @Cd_Vou = dbo.Cod_Vou(@RucE) -- Sacamos el Cod_Vou con que se registrara: max(cod_vou)+1

declare @Cd_Vou_Base int
SET @Cd_Vou_Base = @Cd_Vou -- GUARDAMOS EL CODIGO BASE

declare @MtoD_ME numeric(13,2), @MtoH_ME numeric(13,2)

set @MtoD_ME = 0
set @MtoH_ME = 0


--CONVERSION A LA OTRA MONEDA:
if @Cd_MdRg='01'
begin
    if @IC_CtrMd='$' or @IC_CtrMd='a'
    begin
		set @MtoD_ME = @MtoD/@CamMda
		set @MtoH_ME = @MtoH/@CamMda

		if @IC_CtrMd='$' -- si es exclusivamente en dolares -->> (se registra al cambio de moneda solamente en dolares)
		begin
			set @MtoD = 0
			set @MtoH = 0
		end
    end
  /*else --if @IC_CtrMd='s' -- si es exclusivamente en soles -->> (se mantiene el monto de entrada (que es la variable para soles) y no es necesario hacer 0.00 los Montos_ME )
    begin
	set @MtoD_ME = 0
	set @MtoH_ME = 0
    end
  */

end
else --if @Cd_MdRg='02'
begin
    set @MtoD_ME = @MtoD
    set @MtoH_ME = @MtoH

    if @IC_CtrMd='s' or @IC_CtrMd='a'
    begin 
		set @MtoD = @MtoD_ME*@CamMda
		set @MtoH = @MtoH_ME*@CamMda

		if @IC_CtrMd='s' -- si es exclusivamente en soles -->> (se registra al cambio de moneda solamente en soles)
		begin
			set @MtoD_ME = 0
			set @MtoH_ME = 0
		end
	end
	else --if @IC_CtrMd='$' -- si es exclusivamente en Dolares -->> (Nos aseguramos que el monto de entrada (variable para soles) quede en 0.00 )
	begin
		set @MtoD = 0.00
		set @MtoH = 0.00
    end

end


--Si cuenta NO debe llevar auxiliar:
if(select IB_Aux from PlanCtas where RucE=@RucE and NroCta=@NroCta and Ejer=@Ejer)=0
begin
	--set @Cd_Aux = null
	set @Cd_Clt = null
	set @Cd_Prv = null
	----------------------
end

--Si cuenta NO debe llevar documento:
if(select IB_NDoc from PlanCtas where RucE=@RucE and NroCta=@NroCta and Ejer=@Ejer)=0
begin
	set @Cd_TD = null
	set @NroSre = null
	set @NroDoc = null
	set @IB_EsProv = null
	---------------------
	set @DR_FecED = null
	set @DR_CdTD = null
	set @DR_NSre = null
	set @DR_NDoc = null
end

/*print '          --------------'
print '          MONTOS: (a insertar) -->Insert5' 
print '          @MtoD: ' + convert(varchar,@MtoD)
print '          @MtoH: ' + convert(varchar,@MtoH)
print '          @MtoD_ME: ' + convert(varchar,@MtoD_ME)
print '          @MtoH_ME: ' + convert(varchar,@MtoH_ME)
print '          --------------' 
*/

insert into Voucher ( RucE, Cd_Vou, Ejer, Prdo, RegCtb, Cd_Fte, FecMov, FecCbr, NroCta, /*Cd_Aux,*/ Cd_Clt, Cd_Prv, Cd_TD, NroSre,
		      NroDoc, FecED, FecVD, Glosa, MtoOr, MtoD, MtoH, MtoD_ME, MtoH_ME, Cd_MdOr, Cd_MdRg, CamMda, Cd_CC,
		      Cd_SC, Cd_SS,  Cd_Area, Cd_MR, Cd_TG, IC_CtrMd, IC_TipAfec, TipOper, NroChke, Grdo, IB_EsProv, FecReg, UsuCrea, IB_Anulado,
		      DR_FecED, DR_CdTD, DR_NSre, DR_NDoc )

		values( @RucE, @Cd_Vou, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @NroCta, /*@Cd_Aux,*/ @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre,
			@NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, @MtoD, @MtoH, @MtoD_ME, @MtoH_ME, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC,
			@Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @Cd_TG, @IC_CtrMd, @IC_TipAfec, @TipOper, @NroChke, @Grdo, @IB_EsProv, getdate(), @UsuCrea, @IB_Anulado, 
			@DR_FecED, @DR_CdTD, @DR_NSre, @DR_NDoc )

	if @@rowcount<=0
	   set @msj = 'Voucher no pudo ser registrado'
	else
	   insert into VoucherRM (RucE, NroReg, RegCtb, Ejer, Cd_Vou, NroCta, Cd_TD, NroDoc, Debe, Haber, Cd_Mda, Cd_Area, Cd_MR, Usu, FecMov, Cd_Est)
	   			 values (@RucE, dbo.Nro_RegVouRM(@RucE), @RegCtb, @Ejer, @Cd_Vou, @NroCta, @Cd_TD, @NroDoc, @MtoD, @MtoH, @Cd_MdRg, @Cd_Area, 'IM', @UsuCrea, getdate(), '01')
	 --insert into VoucherRM values (@RucE, dbo.Nro_RegVouRM(@RucE), @Cd_Vou, @Cd_TD, @NroDoc, @MtoD, @MtoH, @Cd_MdRg, @Cd_Area, @Cd_MR, @UsuCrea, getdate(), '01')








-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------



	-- BUSCAMOS AMARRE CUENTAS ----------------------------------------------------------
	print '-- BUSCAMOS AMARRE CUENTAS ---------------------------------------------------'

	--set @Glosa = 'Amarre Cta. Dest.' 

	declare @IB_InvertAmr bit

	if @Cd_Fte = 'RC' or @Cd_Fte = 'LD'  --> debe estar discriminado por Fte?
		if @TipMov = 'M'
			if(@MtoD>0 or @MtoD_ME>0) --> cuando es 'M' el monto ingresado es la BIM y va al Debe Ejem: 63.1.0.01   100
				set @IB_InvertAmr = 0 --> es normal
			else 	set @IB_InvertAmr = 1 --> Invertimos
		else if @TipMov = 'A'
			if(@MtoH>0 or @MtoH_ME>0)  --> cuando es 'A' el monto ingresado va al Haber Ejem: 42.1.0.01   119
				set @IB_InvertAmr = 0 --> es normal
			else 	set @IB_InvertAmr = 1 --> Invertimos

	--else if @Cd_Fte = 'RC'  -FALTARIA PARA RV?  ¿RV LLEVA AMARRES? - PREGUNTAR  ¿Y LD?


	if(select IB_CtaD from PlanCtas where RucE=@RucE and NroCta=@NroCta and Ejer=@Ejer)=1
	begin
		declare @CtaD nvarchar(10), @CtaH nvarchar(10), @Porc numeric(5,2), @MtoDest numeric(13,2), @CtaTemp nvarchar(10) --(para invertir Amr)
		--set @Mto = 0
		set @IC_TipAfec = null
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

				PRINT 'MENSAJE ACTUAL: ' + @msj

				--AGREGAMOS CUENTA DESTINO DEBE
				if not exists (select NroCta from Voucher where RucE=@RucE and Ejer=@Ejer and Prdo=@Prdo and RegCtb=@RegCtb and NroCta=@CtaD and Cd_Vou>=@Cd_Vou_Base)
				begin
					print 'Insertamos amarre DEB ' + @CtaD
					exec pvo.Ctb_VoucherInsert4Imdo1 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaD, /*@Cd_Aux,*/ @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 
								   @MtoDest, 0.00, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
								   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @IB_Anulado, @msj output
					if @msj <> '' return
				end
				else  --begin update Voucher set MtoD=MtoD+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaD end
				begin 	print 'Modificamos amarre DEB (Acumulamos) ' + @CtaD
					--exec pvo.Ctb_VoucherMdf_Mto @RucE,@Ejer,@Prdo,@RegCtb,@MtoDest,0.00,@CtaD,@Cd_MdRg,@CamMda,@IC_CtrMd,@Msj output 
					--Mandamos @Cd_Vou base para que no tenga problemas en modificar Ctas. Dest. anteriores
					exec pvo.Ctb_VoucherMdf_Mto2 @RucE,@Ejer,@Prdo,@RegCtb,@MtoDest,0.00,@CtaD,@Cd_MdRg,@CamMda,@IC_CtrMd, @Cd_Vou_Base, @Msj output 
				end



				--AGREGAMOS CUENTA DESTINO HABER
				if not exists (select NroCta from Voucher where RucE=@RucE and Ejer=@Ejer and Prdo=@Prdo and RegCtb=@RegCtb and NroCta=@CtaH and Cd_Vou>=@Cd_Vou_Base )
				begin
					print 'Insertamos amarre HAB ' + @CtaH
					exec pvo.Ctb_VoucherInsert4Imdo1 @RucE, @Ejer, @Prdo, @RegCtb, @Cd_Fte, @FecMov, @FecCbr, @CtaH, /*@Cd_Aux,*/ @Cd_Clt, @Cd_Prv, @Cd_TD, @NroSre, @NroDoc, @FecED, @FecVD, @Glosa, @MtoOr, 
								   0.00, @MtoDest, @Cd_MdOr, @Cd_MdRg, @CamMda, @Cd_CC, @Cd_SC, @Cd_SS,  @Cd_Area, @Cd_MR, @NroChke, @Cd_TG, @IC_CtrMd, @UsuCrea, 
								   @IC_TipAfec, @TipOper, @Grdo, @IB_EsProv, @IB_Anulado, @msj output
					if @msj <> '' return
				end
				else  --begin update Voucher set MtoH=MtoH+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaH end
				begin 	print 'Modificamos amarre HAB (Acumulamos) ' + @CtaH
					--Mandamos @Cd_Vou base para que no tenga problemas en modificar Ctas. Dest. anteriores
					exec pvo.Ctb_VoucherMdf_Mto2 @RucE,@Ejer,@Prdo,@RegCtb,0.00,@MtoDest,@CtaH,@Cd_MdRg,@CamMda,@IC_CtrMd, @Cd_Vou_Base, @Msj output 
				end
			
		
			fetch Cur_CtaDet into @CtaD, @CtaH, @Porc
			END
		close Cur_CtaDet
		deallocate Cur_CtaDet
	end

update voucher set IB_Imdo=1 where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb 



	-------------------------------------------------------------------------------------

	print 'MSJ: ' + @msj


	--print 'BREAK_10'










--PV: Mdf Lun 18/05/2009  ---> Es exclusivamente Dolares
--PV: Mdf Lun 28/09/2009  ---> Se agregaron campos de Doc. Referencia
--PV: Lun 21/12/2009  ---> Creado Y MDF @Cd_Vou_Base
--PV: Mdf Vie 19/03/2010  ---> Campos VoucherRM
--PV: Mie 24/03/2010 - Mdf: En los IF, No se respetaba cuando era exclusivamente s ó $
--PV: Jue 05/05/2011 - Mdf: se crearo variables @Cd_Clt, @Cd_Prv (temporalmente) - Falta que se creen como parametro y reciban valor
--PV: MAR 10/05/2011 --> Mdf: se agregó tema @Cd_Clt, @Cd_Prv

---------------------- NO TOCAR ESTE SP -------------------- (PV)
GO

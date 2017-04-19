SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--****** PV: POR FAVOR SI HACEN ALGUNA MODIFICACION DOCUMENTAR AL FINAL ****

CREATE procedure [pvo].[Ctb_Voucher_CompDst_enCrea] -- Comprueba los destinos cuando se esta creando una cuenta con amarre en el voucher
@RucE		nvarchar(11),
@Cd_Vou		int,
@Ejer		nvarchar(4),
@Prdo		nvarchar(2),
@RegCtb		nvarchar(15),
--@NroCta	nvarchar(10),
@Cd_MdRg 	nvarchar(2),	
@CamMda 	numeric(6,3),
@IC_CtrMd	varchar(1), --> s: Soles, $: Dolares, a: Ambas
---------------------------
@Mto numeric(13,2),
-- Suma de Destinos Antes de aplicar Destinos		
@SmDADMtoD_MN numeric(13,2),  
@SmDADMtoH_MN numeric(13,2),
@SmDADMtoD_ME numeric(13,2),  
@SmDADMtoH_ME numeric(13,2),
---------------------------
@msj 		varchar(100) output

--with encryption
as


		Print '-- Comprabamos que los destinos hayan sido grabados con el 100% exacto --'
		Print ''
		print '          Codigo Cta. Base: ' + convert(varchar,@Cd_Vou) + ', Mto Cta Base: ' + convert(varchar,@Mto)
		declare @SmD_MtoD_MN numeric(13,2),  @SmD_MtoH_MN numeric(13,2)
		declare @SmD_MtoD_ME numeric(13,2),  @SmD_MtoH_ME numeric(13,2)

		set @SmD_MtoD_MN=0	set @SmD_MtoH_MN=0
		set @SmD_MtoD_ME=0	set @SmD_MtoH_ME=0

		--SUMA de Destinos despues de haber aplicado nuevos destinos (en el caso que esta fuera una segunda cuenta con destinos)
		select @SmD_MtoD_MN = isnull(sum(MtoD),0), @SmD_MtoH_MN = isnull(sum(MtoH),0), @SmD_MtoD_ME = isnull(sum(MtoD_ME),0), @SmD_MtoH_ME = isnull(sum(MtoH_ME),0)
		-- Esto solo lo hariamos si las ctas destino no se acumularan
		--from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @RegCtb and Cd_Vou>@Cd_Vou and IB_EsDes = 1
		from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @RegCtb and IB_EsDes = 1

		print '          --------------'
		print '          SUMAS DESTINOS DESPUES DE DESTINOS: (a cuadrar)' 
		print '          @SmD_MtoD_MN: ' + convert(varchar,@SmD_MtoD_MN)
		print '          @SmD_MtoH_MN: ' + convert(varchar,@SmD_MtoH_MN)
		print '          @SmD_MtoD_ME: ' + convert(varchar,@SmD_MtoD_ME)
		print '          @SmD_MtoH_ME: ' + convert(varchar,@SmD_MtoH_ME)
		print '          --------------'

		declare @Cd_VouMdf int, @CtaMdf varchar(15), @MtoMdf numeric(13,2), @MtoBase numeric(13,2), @MtoBase_Cnv numeric(13,2)
		print '          @MtoBase Entrante (@Mto): ' + convert(varchar,@Mto)

		if @Cd_MdRg = '02' -- el monto en US$ de la cta base debe ser exactamente igual a la suma (100%) de los destinos  en US$
		begin	      
			print ''
			print '	Moneda es: US$'
			-- Podria sumarle cualquier (DóH) @SmDADMto[]_ME ya que estos deben estar cuadrados con la base
			set @MtoBase = @Mto + @SmDADMtoD_ME -- El monto base sera el monto actual + la Suma de los Destinos Antes de aplicar Destinos
			print '          @MtoBase D_ME Acumulado: ' + convert(varchar,@MtoBase)


			print '          if ' +convert(varchar,@MtoBase)+' != '+ convert(varchar,@SmD_MtoD_ME) + ' (@SmD_MtoD_ME)'
			if @MtoBase != @SmD_MtoD_ME --(suma Debe US$)
			begin
			    print '          Ajustamos el max debe US$ mayor a 0 para que la suma de igual al @Mto base'
			    select @Cd_VouMdf=Cd_Vou, @CtaMdf=NroCta from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoD_ME>0 and IB_EsDes = 1)
			    print '          Codigo max. Cta Dst Debe US$:' + convert(varchar,@Cd_VouMdf)
			    --Mejor utilizamos el Ctb_VoucherMdf_Mto para que se replique en la otra moneda
			    --update voucher set MtoD_ME = MtoD_ME+(@Mto-@MtoD_ME) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_VouMdf -- Agregamos a quitamos la diferencia para que sea el 100%
			    select @MtoMdf = MtoD_ME+(@MtoBase-@SmD_MtoD_ME) from voucher where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_VouMdf -- Agregamos a quitamos la diferencia para que sea el 100%
			    print '          Ajustamos MtoD_ME destino con Base US$'
			    exec pvo.Ctb_VoucherMdf_Mto_NoAcum @RucE,@Ejer,@Prdo,@RegCtb,@MtoMdf,0.00,@CtaMdf,@Cd_MdRg,@CamMda,@IC_CtrMd,@Msj output 

				-- Luego de haber cuadrado Mto base con montos destino Deb en U$$, verifico que cuadre tb en Deb S/. (Mto base con mtos destinos)
				select @SmD_MtoD_MN = isnull(sum(MtoD),0) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @RegCtb and IB_EsDes = 1
				print '          volvemos a sacar la suma destinos Deb S/.: @SmD_MtoD_MN -->' + convert(varchar,@SmD_MtoD_MN)
				print ''


			end

			-- Podria sumarle cualquier (DóH) @SmDADMto[]_ME ya que estos deben estar cuadrados con la base -- (Solo dejo el de arriba)
			--set @MtoBase = @Mto + @SmDADMtoH_ME -- El monto base sera el monto actual + la Suma de los Destinos Antes de aplicar Destinos
			--print '		@MtoBase H_ME Acumulado: ' + convert(varchar,@MtoBase)

			print '          if ' +convert(varchar,@MtoBase)+' != '+ convert(varchar,@SmD_MtoH_ME) + ' (@SmD_MtoH_ME)'
			if @MtoBase != @SmD_MtoH_ME
			begin
			    print '          Ajustamos el max Haber US$ mayor a 0 para que la suma de igual al @Mto base'
			    select @Cd_VouMdf=Cd_Vou, @CtaMdf=NroCta from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoH_ME>0 and IB_EsDes = 1)
			    print '          Codigo max. Cta Dst Debe US$:' + convert(varchar,@Cd_VouMdf)
			    --Mejor utilizamos el Ctb_VoucherMdf_Mto para que se replique en la otra moneda
			    --update voucher set MtoH_ME = MtoH_ME+(@Mto-@MtoH_ME) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_VouMdf -- Agregamos a quitamos la diferencia para que sea el 100%
			    select @MtoMdf = MtoH_ME+(@MtoBase-@SmD_MtoH_ME) from voucher where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_VouMdf -- Agregamos a quitamos la diferencia para que sea el 100%
			    print '          Ajustamos MtoH_ME destino con Base US$'
			    exec pvo.Ctb_VoucherMdf_Mto_NoAcum @RucE,@Ejer,@Prdo,@RegCtb,0.00,@MtoMdf,@CtaMdf,@Cd_MdRg,@CamMda,@IC_CtrMd,@Msj output 

				-- Luego de haber cuadrado Mto base con montos destino Hab en U$$, verifico que cuadre tb en Hab S/. (Mto base con mtos destinos)
				select @SmD_MtoH_MN = isnull(sum(MtoH),0) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @RegCtb and IB_EsDes = 1
				print '          volvemos a sacar la suma destinos Hab S/.: @SmD_MtoH_MN -->' + convert(varchar,@SmD_MtoH_MN)
				print ''

			end

			print ''

			if @IC_CtrMd='s' or @IC_CtrMd='a' --solo si el monto base se registro en ambas monedas o en S/., comprobamos que @MtoBase_Cnv != @SmD_MtoD_MN | @SmD_MtoH_MN para tomar accion de ajustar
			begin

				-- Podria sumarle cualquier (DóH) @SmDADMto[]_MN ya que estos deben estar cuadrados con la base
				set @MtoBase_Cnv = @Mto*@CamMda + @SmDADMtoD_MN -- El monto base convertido sera el monto actual + la Suma de los Destinos Antes de aplicar Destinos
				print '          @MtoBase_Cnv D_MN Acumulado: ' + convert(varchar,@MtoBase_Cnv) --Monto base convertido
	
				--Esto ya no se hace asi:
				--set @MtoBase_Cnv = @MtoBase*@CamMda --convertimos para saber el mto base en la otra moneda (MtoBase puede ser la suma de varios montos base)
				--print '          @MtoBase_Cnv S/. Acumulado: ' + convert(varchar,@MtoBase_Cnv)
	
				print '          if ' +convert(varchar,@MtoBase_Cnv)+' != '+ convert(varchar,@SmD_MtoD_MN) + ' (@SmD_MtoD_MN)'
				if @MtoBase_Cnv != @SmD_MtoD_MN
				begin
				    --solo ajustamos en esta moneda (no convertimos la modificacion en la otra moneda) 
				    select @Cd_VouMdf=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoD>0 and IB_EsDes = 1)
				    print '          Ajustamos MtoD destino con Base_Cnv S/. (solo en esta moneda)'
				    update voucher set MtoD = MtoD+(@MtoBase_Cnv-@SmD_MtoD_MN) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_VouMdf -- Agregamos a quitamos la diferencia para que sea el 100% (solo en esta moneda)
				end
	
				-- Podria sumarle cualquier (DóH) @SmDADMto[]_MN ya que estos deben estar cuadrados con la base -- (Solo dejo el de arriba)
				--set @MtoBase_Cnv = @Mto*@CamMda + @SmDADMtoH_MN -- El monto base sera el monto actual + la Suma de los Destinos Antes de aplicar Destinos
				--print '		 @MtoBase_Cnv H_MN Acumulado: ' + convert(varchar,@MtoBase_Cnv)
	
				print '          if ' +convert(varchar,@MtoBase_Cnv)+' != '+ convert(varchar,@SmD_MtoH_MN) + ' (@SmD_MtoH_MN)'
				if @MtoBase_Cnv != @SmD_MtoH_MN
				begin
				    --solo ajustamos en esta moneda (no convertimos la modificacion en la otra moneda)
				    select @Cd_VouMdf=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoH>0 and IB_EsDes = 1)
				    print '          Ajustamos MtoH destino con Base_Cnv S/. (solo en esta moneda)'
				    update voucher set MtoH = MtoH+(@MtoBase_Cnv-@SmD_MtoH_MN) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_VouMdf -- Agregamos a quitamos la diferencia para que sea el 100% (solo en esta moneda)
				end	

			end -- if @IC_CtrMd='s' or @IC_CtrMd='a'



		end --------------------------------------------------------------------------------------------------------------------------------------------




		else if @Cd_MdRg = '01' -- el monto en S/. de la cta base debe ser exactamente igual a la suma (100%) de los destinos  en S/.
		begin		
			print ''
			print '	Moneda es: S/.'

			--print '          @MtoBase Entrante (@Mto): ' + convert(varchar,@Mto)
			-- Podria sumarle cualquier (DóH) @SmDADMto[]_MN ya que estos deben estar cuadrados con la base
			set @MtoBase = @Mto + @SmDADMtoD_MN -- El monto base sera el monto actual + la Suma de los Destinos Antes de aplicar Destinos
			print '          @MtoBase D_MN Acumulado: ' + convert(varchar,@MtoBase)


			--if @Mto != @SmD_MtoD_MN
			print '          if ' +convert(varchar,@MtoBase)+' != '+ convert(varchar,@SmD_MtoD_MN) + ' (@SmD_MtoD_MN)'
			if @MtoBase != @SmD_MtoD_MN
			begin
			    print '          Ajustamos el max debe S/. mayor a 0 para que la suma de igual al @Mto base'
			    select @Cd_VouMdf=Cd_Vou, @CtaMdf=NroCta from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoD>0 and IB_EsDes = 1)
			    print '          Codigo max. Cta Dst Debe S/.:' + convert(varchar,@Cd_VouMdf)
			    --Mejor utilizamos el Ctb_VoucherMdf_Mto para que se replique en la otra moneda
			    --update voucher set MtoD_ME = MtoD_ME+(@Mto-@MtoD_ME) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_VouMdf -- Agregamos a quitamos la diferencia para que sea el 100%
			    select @MtoMdf = MtoD+(@MtoBase-@SmD_MtoD_MN) from voucher where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_VouMdf -- Agregamos a quitamos la diferencia para que sea el 100%
			    exec pvo.Ctb_VoucherMdf_Mto_NoAcum @RucE,@Ejer,@Prdo,@RegCtb,@MtoMdf,0.00,@CtaMdf,@Cd_MdRg,@CamMda,@IC_CtrMd,@Msj output 

				-- Luego de haber cuadrado Mto base con montos destino Deb en S/., verifico que cuadre tb en Deb US$ (Mto base con mtos destinos)
				select @SmD_MtoD_ME = isnull(sum(MtoD_ME),0) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @RegCtb and IB_EsDes = 1
				print '          volvemos a sacar la suma destinos Deb US$: @SmD_MtoD_ME -->' + convert(varchar,@SmD_MtoD_ME)

			end
			
			-- Podria sumarle cualquier (DóH) @SmDADMto[]_MN ya que estos deben estar cuadrados con la base -- (Solo dejo el de arriba)
			--set @MtoBase = @Mto + @SmDADMtoH_MN -- El monto base sera el monto actual + la Suma de los Destinos Antes de aplicar Destinos
			--print '	@MtoBase H_MN Acumulado: ' + convert(varchar,@MtoBase)

			print '          if ' +convert(varchar,@MtoBase)+' != '+ convert(varchar,@SmD_MtoH_MN) + ' (@SmD_MtoH_MN)'
			if @MtoBase != @SmD_MtoH_MN
			begin
			    print '          Ajustamos el max Haber S/. mayor a 0 para que la suma de igual al @Mto base'
			    select @Cd_VouMdf=Cd_Vou, @CtaMdf=NroCta from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoH>0 and IB_EsDes = 1)
			    print '          Codigo max. Cta Dst Debe US$:' + convert(varchar,@Cd_VouMdf)
			    --Mejor utilizamos el Ctb_VoucherMdf_Mto para que se replique en la otra moneda
			    --update voucher set MtoH_ME = MtoH_ME+(@Mto-@MtoH_ME) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_VouMdf -- Agregamos a quitamos la diferencia para que sea el 100%
			    select @MtoMdf = MtoH+(@MtoBase-@SmD_MtoH_MN) from voucher where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_VouMdf -- Agregamos a quitamos la diferencia para que sea el 100%
			    exec pvo.Ctb_VoucherMdf_Mto_NoAcum @RucE,@Ejer,@Prdo,@RegCtb,0.00,@MtoMdf,@CtaMdf,@Cd_MdRg,@CamMda,@IC_CtrMd,@Msj output 


				-- Luego de haber cuadrado Mto base con montos destino Hab en S/., verifico que cuadre tb en Hab US$ (Mto base con mtos destinos)
				select @SmD_MtoH_ME = isnull(sum(MtoH_ME),0) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @RegCtb and IB_EsDes = 1
				print '          volvemos a sacar la suma destinos Hab US$: @SmD_MtoH_ME -->' + convert(varchar,@SmD_MtoH_ME)

			end

--			if @@rowcount>0
--			begin
				-- Luego de haber cuadrado Mto base con montos destino en S/., verifico que cuadre tb en US$ (Mto base con mtos destinos)
--				select @SmD_MtoD_ME = isnull(sum(MtoD_ME),0), @SmD_MtoH_ME = isnull(sum(MtoH_ME),0) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb = @RegCtb and IB_EsDes = 1
--				print 'volvemos a sacar la suma destinos US$'
--			end 

			print ''

			if @IC_CtrMd='$' or @IC_CtrMd='a' --solo si el monto base se registro en ambas monedas o en US$, comprobamos que @MtoBase_Cnv != @SmD_MtoD_ME | @SmD_MtoH_ME para tomar accion de ajustar
			begin
				-- Podria sumarle cualquier (DóH) @SmDADMto[]_ME ya que estos deben estar cuadrados con la base
				set @MtoBase_Cnv = @Mto/@CamMda + @SmDADMtoD_ME -- El monto base convertido sera el monto actual + la Suma de los Destinos Antes de aplicar Destinos
				print '          @MtoBase_Cnv D_ME Acumulado: ' + convert(varchar,@MtoBase_Cnv) --Monto base convertido
	
				--Esto ya no se hace asi:
				--set @MtoBase_Cnv = @MtoBase/@CamMda --convertimos para saber el mto base en la otra moneda (MtoBase puede ser la suma de varios montos base)
				--print '          @MtoBase_Cnv US$ Acumulado: ' + convert(varchar,@MtoBase_Cnv)
	
				print '          if ' +convert(varchar,@MtoBase_Cnv)+' != '+ convert(varchar,@SmD_MtoD_ME) + ' (@SmD_MtoD_ME)'
				if @MtoBase_Cnv != @SmD_MtoD_ME
				begin
				    --solo ajustamos en esta moneda (no convertimos la modificacion en la otra moneda)
				    select @Cd_VouMdf=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoD_ME>0 and IB_EsDes = 1)
				    print '          Ajustamos MtoD_ME destino contra Base_Cnv US$ (solo en esta moneda)'
				    update voucher set MtoD_ME = MtoD_ME+(@MtoBase_Cnv-@SmD_MtoD_ME) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_VouMdf -- Agregamos a quitamos la diferencia para que sea el 100% (solo en esta moneda)
				end
	
				-- Podria sumarle cualquier (DóH) @SmDADMto[]_ME ya que estos deben estar cuadrados con la base -- (Solo dejo el de arriba)
				--set @MtoBase_Cnv = @Mto/@CamMda + @SmDADMtoH_ME -- El monto base sera el monto actual + la Suma de los Destinos Antes de aplicar Destinos
				--print '		 @MtoBase_Cnv H_ME Acumulado: ' + convert(varchar,@MtoBase_Cnv)
	
				print '          if ' +convert(varchar,@MtoBase_Cnv)+' != '+ convert(varchar,@SmD_MtoH_ME) + ' (@SmD_MtoH_ME)'
				if @MtoBase_Cnv != @SmD_MtoH_ME
				begin
				    --solo ajustamos en esta moneda (no convertimos la modificacion en la otra moneda)
				    select @Cd_VouMdf=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoH_ME>0 and IB_EsDes = 1)
				    print '          Ajustamos MtoH_ME destino contra Base_Cnv US$ (solo en esta moneda)'
				    update voucher set MtoH_ME = MtoH_ME+(@MtoBase_Cnv-@SmD_MtoH_ME) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_VouMdf -- Agregamos a quitamos la diferencia para que sea el 100% (solo en esta moneda)
				end	

			end --if @IC_CtrMd='$' or @IC_CtrMd='a'

		end 
		Print ''
		Print '-- FIN: Comprabamos que los destinos hayan sido grabados con el 100% exacto --'




--PV: VIE 22/10/2010 --> Creado --> se separo de pvo.Ctb_VoucherCrea10 --Modificacion: 10d
--PV: MAR 08/03/2011 --> Mdf --> se arreglo que " if @IC_CtrMd='$' or @IC_CtrMd='a' " para que tenga en cuenta el control de moneda a la hora de ajustar s,$

--****** PV: POR FAVOR SI HACEN ALGUNA MODIFICACION DOCUMENTAR ACA ****
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--****** PV: POR FAVOR SI HACEN ALGUNA MODIFICACION DOCUMENTAR AL FINAL ****

CREATE proc [pvo].[Ctb_AjustaXConversion_cnDst] -- --Modificacion: 1b
@RucE		nvarchar(11),
@Ejer		nvarchar(4),
@RegCtb		nvarchar(15),
@SaldoMN	decimal(13,2) output,
@SaldoME	decimal(13,2) output,
@msj 		varchar(100) output

--with encryption
as

if (select count(*) from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)<=0
begin 	set @msj='Registro contable no existe'
	print @msj
	return
end	


/* Ya no lo hacemos asi
declare
@DebMN decimal(13,2), @HabMN decimal(13,2),
@DebME decimal(13,2), @HabME decimal(13,2),
--@Sldo decimal(3,2) -- Nunca se uso


--select * from voucher where RucE='11111111111' and RegCtb='CTST_RV02-00001'
select @DebMN=sum(MtoD), @HabMN=Sum(MtoH), @DebME=sum(MtoD_ME), @HabME=sum(MtoH_ME) from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
--select @DebMN=sum(MtoD), @HabMN=Sum(MtoH), @DebME=sum(MtoD_ME), @HabME=sum(MtoH_ME) from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
*/


--declare  @Cd_MdRg nvarchar(2)
--select @Cd_MdRg = Cd_MdRg from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
declare @Cd_Vou int--, @saldo numeric(13,2)



----------------------------------------------
	print  '------------ Comprobamos descuadre en destinos ----------------------' 


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

----------------------------------------------




declare @IN_DigCls int, @valor numeric(13,2), @NroCta varchar(15)
								--Mdf exlusiva para V2
select @IN_DigCls=IN_DigCls from PlanCtasDef where RucE=@RucE and Ejer=@Ejer --(Esto es para V.2)



	if @Sldo_MN_Nat!=0 or @Sldo_ME_Nat!=0 -- si hay descuadre en el asiento por naturaleza ya sea MN o ME
	begin

	    --Buscamos las cuentas de resultado dependiendo si se esta digitando con la clase 6 ó 9 -- estas cuentas seran las ajustadas
	    if @IN_DigCls=6
			select @Cd_Vou=Cd_Vou, @valor=isnull(MtoD-MtoH,0), @NroCta=NroCta from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and left(NroCta,1) in ('6','7') and isnull(IB_EsDes,0) = 0  /*-- Es bit y solo puede tomar valor 1 ó 0 -- IB_EsDes != 1 (asi no sale) */ )
	    else --if @IN_DigCls=9
			select @Cd_Vou=Cd_Vou, @valor=isnull(MtoD-MtoH,0), @NroCta=NroCta from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and left(NroCta,1) in ('9','7') and isnull(IB_EsDes,0) = 0  /*-- Es bit y solo puede tomar valor 1 ó 0 -- IB_EsDes != 1 (asi no sale) */ )

	    print 'Codigo Cta Result:' + convert(varchar,@Cd_Vou)
	    print 'Numero Cta Result:' + convert(varchar,@NroCta)
	    print 'Valor Cta: Result:' + convert(varchar,@valor) -- OJO: Este valor no indicará si la cuenta es en el Deb o Hab ya que el @Sldo_MN_Nat puede ser resulta de la suma de varias cuentas en el Deb y en el Hab (Extorno)

	    if @Cd_Vou is not null -- Si se encontro una cta de resultado (entonces se ajustara esa cta, este en el Debe o en el Haber)
	    begin



		if @Sldo_MN_Nat != 0 -- Hay Descuadre en Naturaleza MN
		begin	

			if @Sldo_MN_Nat < 0 -- Hay menos en el Debe MN Naturaleza
				if @valor > 0 -- Valor esta en el Debe
			    		update voucher set MtoD = MtoD+abs(@Sldo_MN_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou -- Sumo en el Debe
				else --if @valor < 0 -- Valor esta en el Haber
			    		update voucher set MtoH = MtoH-abs(@Sldo_MN_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou -- Resto en el Haber
	
			else --if @Sldo_MN_Nat > 0 -- Hay menos en el Haber MN Naturaleza
				if @valor > 0 -- Valor esta en el Debe
			    		update voucher set MtoD = MtoD-abs(@Sldo_MN_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou -- Resto en el Debe
				else --if @valor < 0 -- Valor esta en el Haber
			    		update voucher set MtoH = MtoH+abs(@Sldo_MN_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou -- Sumo en el Haber
					
					
									--Mdf exclusiva para V2 (Ejer)
			if(select IB_CtaD from PlanCtas where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta)=1 -- Comprobamos si esta cuenta tiene destinos
			begin
			    --Como ya sabemos que tiene destinos, asumiremos que los destinos han sido registrados y cuadrados correctamente
																															  -- Con estos nos aseguramos que la cuenta de destino que se agarre pertenesca a la base								--Mdf Pendiente para V2
			    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoD>0 and IB_EsDes = 1 and NroCta in (select CtaD as NroCta from AmarreCta where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta union select CtaH as NroCta from AmarreCta where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta) )
			    print 'Codigo max. Cta Dst Debe:' + convert(varchar,@Cd_Vou)
			    --Ajustamos en la cta de destino de la base que se encuentra en el Deb MN
			    if (@Sldo_MN_Nat < 0 and @valor > 0) or (@Sldo_MN_Nat > 0 and @valor < 0)	-- OJO AHORA: Restamos o sumamos segun se haya modificado la base. ANTES: simpre sumamos xq en los decimales se suele perder el importe.
					update voucher set MtoD = MtoD+abs(@Sldo_MN_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou 
				else update voucher set MtoD = MtoD-abs(@Sldo_MN_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou 
					
																															  -- Con estos nos aseguramos que la cuenta de destino que se agarre pertenesca a la base								--Mdf Pendiente para V2
			    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoH>0 and IB_EsDes = 1 and NroCta in (select CtaD as NroCta from AmarreCta where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta union select CtaH as NroCta from AmarreCta where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta) )
			    print 'Codigo max. Cta Dst Haber:' + convert(varchar,@Cd_Vou)
			    
			    --Ajustamos en la cta de destino de la base que se encuentra en el Hab MN
			    if (@Sldo_MN_Nat < 0 and @valor > 0) or (@Sldo_MN_Nat > 0 and @valor < 0)	-- OJO AHORA: Restamos o sumamos segun se haya modificado la base. ANTES: simpre sumamos xq en los decimales se suele perder el importe.
	    			update voucher set MtoH = MtoH+abs(@Sldo_MN_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou -- OJO simpre sumamos xq en los decimales se suele perder el importe
				else update voucher set MtoH = MtoH-abs(@Sldo_MN_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou -- OJO simpre sumamos xq en los decimales se suele perder el importe	    			

			end

		end




		if @Sldo_ME_Nat != 0 -- Hay Descuadre en Naturaleza ME
		begin	

			if @Sldo_ME_Nat < 0 -- Hay menos en el Debe ME Naturaleza
				if @valor > 0 -- Valor esta en el Debe
			    		update voucher set MtoD_ME = MtoD_ME+abs(@Sldo_ME_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou
				else --if @valor < 0 -- Valor esta en el Haber
			    		update voucher set MtoH_ME = MtoH_ME-abs(@Sldo_ME_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou
	
			else --if @Sldo_ME_Nat > 0 -- Hay menos en el Haber ME Naturaleza
				if @valor > 0 -- Valor esta en el Debe
			    		update voucher set MtoD_ME = MtoD_ME-abs(@Sldo_ME_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou
				else --if @valor < 0 -- Valor esta en el Haber
			    		update voucher set MtoH_ME = MtoH_ME+abs(@Sldo_ME_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou
			
									--Mdf exclusiva para V2
			if(select IB_CtaD from PlanCtas where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta)=1 -- Comprobamos si esta cuenta tiene destinos
			begin
			    --Como ya sabemos que tiene destinos, asumiremos que los destinos han sido registrados y cuadrados correctamente
																															  -- Con estos nos aseguramos que la cuenta de destino que se agarre pertenesca a la base									--Mdf Pendiente en V2
			    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoD_ME>0 and IB_EsDes = 1 and NroCta in (select CtaD as NroCta from AmarreCta where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta union select CtaH as NroCta from AmarreCta where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta) )
			    print 'Codigo max. Cta Dst Debe ME:' + convert(varchar,@Cd_Vou)
			    --Ajustamos en la cta de destino de la base que se encuentra en el Deb ME
			    if (@Sldo_MN_Nat < 0 and @valor > 0) or (@Sldo_MN_Nat > 0 and @valor < 0)	-- OJO AHORA: Restamos o sumamos segun se haya modificado la base. ANTES: simpre sumamos xq en los decimales se suele perder el importe.
				    update voucher set MtoD_ME = MtoD_ME+abs(@Sldo_ME_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou -- OJO simpre sumamos xq en los decimales se suele perder el importe
			    else update voucher set MtoD_ME = MtoD_ME-abs(@Sldo_ME_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou -- OJO simpre sumamos xq en los decimales se suele perder el importe
																															  -- Con estos nos aseguramos que la cuenta de destino que se agarre pertenesca a la base									--Mdf Pendiente en V2
			    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoH_ME>0 and IB_EsDes = 1 and NroCta in (select CtaD as NroCta from AmarreCta where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta union select CtaH as NroCta from AmarreCta where RucE=@RucE and Ejer=@Ejer and NroCta=@NroCta) )
			    print 'Codigo max. Cta Dst Haber ME:' + convert(varchar,@Cd_Vou)
			    --Ajustamos en la cta de destino de la base que se encuentra en el Hab ME
			    if (@Sldo_MN_Nat < 0 and @valor > 0) or (@Sldo_MN_Nat > 0 and @valor < 0)	-- OJO AHORA: Restamos o sumamos segun se haya modificado la base. ANTES: simpre sumamos xq en los decimales se suele perder el importe.
	    		    update voucher set MtoH_ME = MtoH_ME+abs(@Sldo_ME_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou -- OJO simpre sumamos xq en los decimales se suele perder el importe
	   		    else update voucher set MtoH_ME = MtoH_ME-abs(@Sldo_ME_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou -- OJO simpre sumamos xq en los decimales se suele perder el importe

			end

		end



		-----------------------------------------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------------------------------------------------------------------------------------------------
	    
	    
	    end --FIN: if @Cd_Vou is not null -----------------------------------------------------------------------------------------------------------------------

	    else -- si no se encuentra ni una cta de resultados -- entonces se ajusta cualquier cuenta (la ultima de naturaleza) -- (OJO: La 1ra NO xq puede ser un asiento largo y si hubieran varios descuadres se ajustarian ahi) 
	    begin


		if @Sldo_MN_Nat < 0 -- Hay menos en el Debe MN Naturaleza
		begin
		    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoD>0 and isnull(IB_EsDes,0) = 0  /*-- Es bit y solo puede tomar valor 1 ó 0 -- IB_EsDes != 1 (asi no sale) */ )
		    print 'Codigo max. Cta Debe:' + convert(varchar,@Cd_Vou)
		    update voucher set MtoD = MtoD+abs(@Sldo_MN_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou
		end
		else if @Sldo_MN_Nat > 0 -- Hay menos en el Haber MN Naturaleza
		begin
		    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoH>0 and isnull(IB_EsDes,0) = 0  /*-- Es bit y solo puede tomar valor 1 ó 0 -- IB_EsDes != 1 (asi no sale) */ )
		    print 'Codigo max. Cta Haber:' + convert(varchar,@Cd_Vou)
    		    update voucher set MtoH = MtoH+abs(@Sldo_MN_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou -- OJO simpre sumamos xq en los decimales se suele perder el importe
		end
		

		if @Sldo_ME_Nat < 0 -- Hay menos en el Debe ME Naturaleza
		begin
		    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoD_ME>0 and isnull(IB_EsDes,0) = 0  /*-- Es bit y solo puede tomar valor 1 ó 0 -- IB_EsDes != 1 (asi no sale) */ )
		    print 'Codigo max. Cta Debe ME:' + convert(varchar,@Cd_Vou)
		    update voucher set MtoD_ME = MtoD_ME+abs(@Sldo_ME_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou
		end
		else if @Sldo_ME_Nat > 0 -- Hay menos en el Haber ME Naturaleza
		begin
		    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoH_ME>0 and isnull(IB_EsDes,0) = 0  /*-- Es bit y solo puede tomar valor 1 ó 0 -- IB_EsDes != 1 (asi no sale) */ )
		    print 'Codigo max. Cta Haber ME:' + convert(varchar,@Cd_Vou)
    		    update voucher set MtoH_ME = MtoH_ME+abs(@Sldo_ME_Nat) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou  -- OJO simpre sumamos xq en los decimales se suele perder el importe (¿para division seria el mismo caso? ya que este es el caso de una conversion soles a dolares)
		end


	    end --FIN: sino se encuentra ni una cta de resultados

	

	end --FIN: @Sldo_MN_Nat!=0 or @Sldo_ME_Nat!=0 ---------------------------------------------










	-- COMPROBACION DESTINOS: (Estos ya no se deberian ajustar, ya que supuestamente siempre quedaran ajustados con la base al momento de crear el voucher, y si se modificara la base tb se tiene que volver a ajustar los destinos, pero esto no tendria que hacerse aqui)

	if @Sldo_MN_Dst!=0  -- si hay descuadre en el asiento por Destino MN
	begin

		if @Sldo_MN_Dst < 0 -- Hay menos en el Debe MN Destino
		begin
		    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoD>0 and IB_EsDes = 1)
		    print 'Codigo max. Cta Dst Debe:' + convert(varchar,@Cd_Vou)
		    update voucher set MtoD = MtoD+abs(@Sldo_MN_Dst) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou -- OJO simpre sumamos xq en los decimales se suele perder el importe
		end
		else --if @Sldo_MN_Dst > 0 -- Hay menos en el Haber MN Destino  (aca ya no es necesario el if)
		begin
		    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoH>0 and IB_EsDes = 1)
		    print 'Codigo max. Cta Dst Haber:' + convert(varchar,@Cd_Vou)
    		    update voucher set MtoH = MtoH+abs(@Sldo_MN_Dst) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou -- OJO simpre sumamos xq en los decimales se suele perder el importe
		end

	end

	if @Sldo_ME_Dst!=0  -- si hay descuadre en el asiento por destino ME
	begin

		--PRINT 'falta'	
		if @Sldo_ME_Dst < 0 -- Hay menos en el Debe ME Destino
		begin
		    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoD_ME>0 and IB_EsDes = 1)
		    print 'Codigo max. Cta Dst Debe_ME:' + convert(varchar,@Cd_Vou)
		    update voucher set MtoD_ME = MtoD_ME+abs(@Sldo_ME_Dst) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou -- OJO simpre sumamos xq en los decimales se suele perder el importe
		end
		else --if @Sldo_ME_Dst > 0 -- Hay menos en el Haber ME Destino  (aca ya no es necesario el if)
		begin
		    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoH_ME>0 and IB_EsDes = 1)
		    print 'Codigo max. Cta Dst Haber_ME:' + convert(varchar,@Cd_Vou)
    		    update voucher set MtoH_ME = MtoH_ME+abs(@Sldo_ME_Dst) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou -- OJO simpre sumamos xq en los decimales se suele perder el importe
		end


	end






/*

	if @saldo>0
	begin -- Hay menos en el HABER_MN
	    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoH>0)
	    print @Cd_Vou
	    update voucher set MtoH = MtoH+@saldo where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou
	end
	else
	begin -- Hay menos en el DEBE_ME
	    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoD>0)
	    print @Cd_Vou
	    update voucher set MtoD = MtoD+abs(@saldo) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou
	end



if(@Cd_MdRg='01')
begin
	print 'Ajustamos U$S'	
	set @saldo = @DebME-@HabME
	print @saldo
	
	if @saldo=0
	begin print 'NO FUE NECESARIO AJUSTAR SALDO US$'
	      return
	end
	
	
	if @saldo<0
	begin -- Hay mas en el HABER_ME
	    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoH_ME>0)
	    print @Cd_Vou
	    update voucher set MtoH_ME = MtoH_ME-abs(@saldo) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou
	end
	else
	begin -- Hay mas en el DEBE_ME
	    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoD_ME>0)
	    print @Cd_Vou
	    update voucher set MtoD_ME = MtoD_ME-@saldo where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou
	end

end
else
	begin
	print 'Ajustamos S/.'
	
	set @saldo = @DebMN-@HabMN
	print @saldo
	
	if @saldo=0
	begin print 'NO FUE NECESARIO AJUSTAR SALDO S/.'
	      return
	end
	
	
	if @saldo>0
	begin -- Hay menos en el HABER_MN
	    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoH>0)
	    print @Cd_Vou
	    update voucher set MtoH = MtoH+@saldo where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou
	end
	else
	begin -- Hay menos en el DEBE_ME
	    select @Cd_Vou=Cd_Vou from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and MtoD>0)
	    print @Cd_Vou
	    update voucher set MtoD = MtoD+abs(@saldo) where RucE=@RucE and Ejer=@Ejer and Cd_Vou=@Cd_Vou
	end



end


*/


print ''
print '---------'
/*print @DebMN
print @HabMN
print @DebME
print @HabME
*/
--Prueba: exec pvo.Ctb_AjustaXConversion '11111111111','2009','CTST_RV02-00001',0,0,null


--PV: 02/04/2009 JUE --> Creado
--PV: 03/04/2009 VIE --> Modificado mejorado
--PV: 22/10/2010 VIE --> Mdf: y Creado nuevamente
--PV: 19/03/2011 LUN --> Mdf: Ejer en amarre y que sume y reste en dst segun sea el caso, antes solo sumaba.

--****** PV: POR FAVOR SI HACEN ALGUNA MODIFICACION DOCUMENTAR ACA ****
GO

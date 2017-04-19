SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--****** PV: POR FAVOR SI HACEN ALGUNA MODIFICACION DOCUMENTAR AL FINAL ****

CREATE procedure [pvo].[Ctb_VoucherMdf_Mto_AcumRem] --c  Acumula en la moneda de registro y remplaza en la otra
@RucE		nvarchar(11),
--@Cd_Vou	int,
@Ejer		nvarchar(4),
@Prdo		nvarchar(2),
@RegCtb	nvarchar(15),
@MtoD		numeric(13,2),
@MtoH		numeric(13,2),
@NroCta	nvarchar(10),
@Cd_MdRg 	nvarchar(2),
@CamMda 	numeric(6,3),
@IC_CtrMd	varchar(1),
@msj 		varchar(100) output

--with encryption
as

/*
print 'VARIABLES RECIBIDAS'
print @RucE
print @Ejer
print @Prdo
print @RegCtb
print @MtoD
print @MtoH
print @NroCta
print @Cd_MdRg
print @CamMda 
print @IC_CtrMd
print 'FIN VARIABLES RECIBIDAS'
*/



--declare @Cd_Vou int
--set @Cd_Vou = dbo.Cod_Vou(@RucE)

declare @MtoD_MN numeric(13,2), @MtoH_MN numeric(13,2)
declare @MtoD_ME numeric(13,2), @MtoH_ME numeric(13,2)

set @MtoD_MN = 0
set @MtoH_MN = 0
set @MtoD_ME = 0
set @MtoH_ME = 0



if @Cd_MdRg='01'
begin

    if @IC_CtrMd='$' or @IC_CtrMd='a'
    begin
	--set @MtoD_ME = @MtoD/@CamMda
	--set @MtoH_ME = @MtoH/@CamMda

	--Ahora ya no acumulamos en la otra moneda, chancamos la conversion total en US$
	if @MtoD>0
	begin
		--select @MtoD_ME=(MtoD+@MtoD)/@CamMda from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta
		select @MtoD_MN=(MtoD+@MtoD) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta --(Nuevo MtoD) Acumulamos en la moneda de registro
		set @MtoD_ME = @MtoD_MN/@CamMda -- y convertimos el total en la otra moneda para chancarlo
	end
	else 
	begin
		--select @MtoH_ME=(MtoH+@MtoH)/@CamMda from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta
		select @MtoH_MN=(MtoH+@MtoH) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta --(Nuevo MtoH) Acumulamos en la moneda de registro
		set @MtoH_ME = @MtoH_MN/@CamMda -- y convertimos el total en la otra moneda para chancarlo
	end

	print '@MtoD_ME: ' + convert(varchar,@MtoD_ME)
	print '@MtoH_ME: ' + convert(varchar,@MtoH_ME)

	if @IC_CtrMd='$' -- si es exclusivamente en dolares -->> (se registra al cambio de moneda solamente en dolares)
	begin
		--set @MtoD = 0
		--set @MtoH = 0
		set @MtoD_MN = @MtoD -- esto quiere decir que no se acumulara nada en la moneda de registro (sigue siendo el mismo)
		set @MtoH_MN = @MtoH -- esto quiere decir que no se acumulara nada en la moneda de registro (sigue siendo el mismo)
	end

    end
  else --if @IC_CtrMd='s' -- si es exclusivamente en soles -->> ya no esto: (se mantiene el monto de entrada (que es la variable para soles) y no es necesario hacer 0.00 los Montos_ME )
    begin
	--set @MtoD_ME = 0
	--set @MtoH_ME = 0

	if @MtoD>0
		select @MtoD_MN=(MtoD+@MtoD), @MtoD_ME=MtoD_ME from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta --(Nuevo MtoD) Acumulamos en la moneda de registro y la otra mda se mantiene con el mismo monto
	else 	select @MtoH_MN=(MtoH+@MtoH), @MtoH_ME=MtoH_ME from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta --(Nuevo MtoH) Acumulamos en la moneda de registro y la otra mda se mantiene con el mismo monto

    end
  

end
else --if @Cd_MdRg='02'
begin
 
    set @MtoD_ME = @MtoD
    set @MtoH_ME = @MtoH

    if @IC_CtrMd='s' or @IC_CtrMd='a'
    begin 
	--set @MtoD = @MtoD*@CamMda
	--set @MtoH = @MtoH*@CamMda

	--Ahora ya no acumulamos en la otra moneda, chancamos la conversion total en S/.
	if @MtoD_ME>0
	begin
		--select @MtoD=(MtoD_ME+@MtoD_ME)*@CamMda from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta
		select @MtoD_ME=(MtoD_ME+@MtoD) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta --(Nuevo MtoD_ME) Acumulamos en la moneda de registro
		set @MtoD_MN = @MtoD_ME*@CamMda -- y convertimos el total en la otra moneda para chancarlo
	end
	else 
	begin
		--select @MtoH=(MtoH_ME+@MtoH_ME)*@CamMda from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta
		select @MtoH_ME=(MtoH_ME+@MtoH) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta --(Nuevo MtoH_ME) Acumulamos en la moneda de registro
		set @MtoH_MN = @MtoH_ME*@CamMda -- y convertimos el total en la otra moneda para chancarlo
	end

	print '@MtoD_MN: ' + convert(varchar,@MtoD_MN)
	print '@MtoH_MN: ' + convert(varchar,@MtoH_MN)


	if @IC_CtrMd='s' -- si es exclusivamente en soles -->> (se registra al cambio de moneda solamente en soles)
	begin
		--set @MtoD_ME = 0
		--set @MtoH_ME = 0
		set @MtoD_ME = @MtoD -- esto quiere decir que no se acumulara nada en la moneda de registro (sigue siendo el mismo)
		set @MtoH_ME = @MtoH -- esto quiere decir que no se acumulara nada en la moneda de registro (sigue siendo el mismo)
	end
    end

    else --if @IC_CtrMd='$' -- si es exclusivamente en Dolares -->> (Nos aseguramos que el monto de entrada (variable para soles) quede en 0.00 )
    begin
	--set @MtoD = 0
	--set @MtoH = 0

	if @MtoD>0
		select @MtoD_ME=(MtoD_ME+@MtoD), @MtoD_MN=MtoD from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta --(Nuevo MtoD_ME) Acumulamos en la moneda de registro y la otra mda se mantiene con el mismo monto
	else 	select @MtoH_ME=(MtoH_ME+@MtoH), @MtoH_MN=MtoH from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta --(Nuevo MtoH_ME) Acumulamos en la moneda de registro y la otra mda se mantiene con el mismo monto


    end


end

print '          --------------'
print '          MONTOS: (a sumar) ' +  'a Mda ' + @Cd_MdRg --Suma en mda de registro pero chanca en la conversion
print '          @MtoD: ' + convert(varchar,@MtoD_MN) + case @Cd_MdRg when '01' then '-- Acumula' else '-- chanca' end
print '          @MtoH: ' + convert(varchar,@MtoH_MN)
print '          @MtoD_ME: ' + convert(varchar,@MtoD_ME) + case @Cd_MdRg when '02' then '-- Acumula' else '-- chanca' end
print '          @MtoH_ME: ' + convert(varchar,@MtoH_ME)
print '          --------------'

if @MtoD>0 or @MtoD_ME>0
--begin update Voucher set MtoD=MtoD+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaD end
	--update Voucher set MtoD=MtoD+@MtoD, MtoD_ME=MtoD_ME+@MtoD_ME  where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta
	update Voucher set MtoD=@MtoD_MN, MtoD_ME=@MtoD_ME  where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta
else
	--update Voucher set MtoH=MtoH+@MtoH, MtoH_ME=MtoH_ME+@MtoH_ME  where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta
	update Voucher set MtoH=@MtoH_MN, MtoH_ME=@MtoH_ME  where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta

--Nota importante: si queremos que no se actualice (chanque) en la misma cuenta deberiamos tener tb en el where el @cd_Vou (esto es lo que debe hacer el sp: pvo.Ctb_VoucherMdf_Mto2)

	if @@rowcount<=0
	   set @msj = 'No se pudo actualizar monto'



--PV: Mie 24/03/2010 - Mdf: En los IF, No se respetaba cuando era exclusivamente s ó $
--PV: Mie 24/03/2010 - Mdf: Tampoco acumulaba en exclusivamente dolares
--PV: Lun 11/10/2010 - Mdf: para que no acumule la mda de conversion (solo el origen)
--PV: Lun 12/10/2010 - Mdf: terminando procedimiento del dia anterior

--****** PV: POR FAVOR SI HACEN ALGUNA MODIFICACION DOCUMENTAR ACA ****
GO

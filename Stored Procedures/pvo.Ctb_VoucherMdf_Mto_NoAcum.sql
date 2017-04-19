SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--****** PV: POR FAVOR SI HACEN ALGUNA MODIFICACION DOCUMENTAR AL FINAL ****

CREATE procedure [pvo].[Ctb_VoucherMdf_Mto_NoAcum] -- No acumula la modificacion
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

declare @MtoD_ME numeric(13,2), @MtoH_ME numeric(13,2)

set @MtoD_ME = 0
set @MtoH_ME = 0



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
	set @MtoD = @MtoD*@CamMda
	set @MtoH = @MtoH*@CamMda

	if @IC_CtrMd='s' -- si es exclusivamente en soles -->> (se registra al cambio de moneda solamente en soles)
	begin
		set @MtoD_ME = 0
		set @MtoH_ME = 0
	end
    end

    else --if @IC_CtrMd='$' -- si es exclusivamente en Dolares -->> (Nos aseguramos que el monto de entrada (variable para soles) quede en 0.00 )
    begin
	set @MtoD = 0
	set @MtoH = 0
    end


end

print '          --------------'
print '          MONTOS: (a Modificar) - Chanca en ambas monedas' 
print '          @MtoD: ' + convert(varchar,@MtoD) 
print '          @MtoH: ' + convert(varchar,@MtoH)
print '          @MtoD_ME: ' + convert(varchar,@MtoD_ME)
print '          @MtoH_ME: ' + convert(varchar,@MtoH_ME)
print '          --------------'

if @MtoD>0 or @MtoD_ME>0
--begin update Voucher set MtoD=MtoD+@MtoDest where RucE=@RucE and RegCtb=@RegCtb and NroCta=@CtaD end
	update Voucher set MtoD=/*MtoD+*/@MtoD, MtoD_ME=/*MtoD_ME+*/@MtoD_ME  where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta
else
	update Voucher set MtoH=/*MtoH+*/@MtoH, MtoH_ME=/*MtoH_ME+*/@MtoH_ME  where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and NroCta=@NroCta

--Nota importante: si queremos que no se actualice (chanque) en la misma cuenta deberiamos tener tb en el where el @cd_Vou (esto es lo que debe hacer el sp: pvo.Ctb_VoucherMdf_Mto2)

	if @@rowcount<=0
	   set @msj = 'No se pudo actualizar monto'



--PV: Mie 24/03/2010 - Mdf: En los IF, No se respetaba cuando era exclusivamente s ó $
--PV: Mie 24/03/2010 - Mdf: Tampoco acumulaba en exclusivamente dolares

--PV: Lun 11/10/2010 - Creado

--****** PV: POR FAVOR SI HACEN ALGUNA MODIFICACION DOCUMENTAR ACA ****
GO

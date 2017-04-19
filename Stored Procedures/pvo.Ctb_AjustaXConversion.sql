SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [pvo].[Ctb_AjustaXConversion]
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



declare
@DebMN decimal(13,2), @HabMN decimal(13,2),
@DebME decimal(13,2), @HabME decimal(13,2),
@Sldo decimal(3,2)


--select * from voucher where RucE='11111111111' and RegCtb='CTST_RV02-00001'
select @DebMN=sum(MtoD), @HabMN=Sum(MtoH), @DebME=sum(MtoD_ME), @HabME=sum(MtoH_ME) from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
--select @DebMN=sum(MtoD), @HabMN=Sum(MtoH), @DebME=sum(MtoD_ME), @HabME=sum(MtoH_ME) from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb and Cd_Vou = (select max(Cd_Vou) from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)

declare  @Cd_MdRg nvarchar(2)

select @Cd_MdRg = Cd_MdRg from voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb


declare @Cd_Vou int, @saldo numeric(13,2)

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





print ''
print '---------'
print @DebMN
print @HabMN
print @DebME
print @HabME

--Prueba: exec pvo.Ctb_AjustaXConversion '11111111111','2009','CTST_RV02-00001',0,0,null


--PV: 02/04/2009 JUE --> Creado
--PV: 03/04/2009 VIE --> Modificado mejorado

GO

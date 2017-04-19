SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Ctb_VoucherAnula]
@RucE nvarchar(11),
--@Ejer nvarchar(4),  FALTA COLOCARRRRRRRRRRRRRRRRRRRRRRRRRRRRR!!!!!!!!!!!!!!!!!!!!!!!!
@RegCtb nvarchar(15),
@UsuMdf nvarchar(10),
@msj varchar(100) output
as
--if not exists (select * from Voucher where RucE=@RucE and RegCtb=@RegCtb)
	--set @msj = 'Voucher no existe'


/*---------NO
else if(User123.VPrdo(@RucE,@Ejer,SubString(@RegCtb,8,2) = 1)
	set @msj = 'Voucher no puede ser anulado, el periodo '+User123.DamePeriodo(SubString(@RegCtb,8,2))+' no encuentra disponible'
------*/


--else
--begin
	/*-------------- NO
	declare @Cd_Vou varchar(10)
	set @Cd_Vou = (select Cd_Vou from Voucher where RucE=@RucE and RegCtb=@RegCtb)
	------------------*/


	/*update Voucher set FecMdf=getdate(), IB_Anulado=1 
	where RucE=@RucE and RegCtb=@RegCtb

	if @@rowcount <= 0
	begin
		set @msj = 'Voucher no pudo ser anulado'
		return
	end*/
	


	/*-----------------NO
	--DECLARANDO VALORES PARA REGISTRAR EL MOVIMIENTO EN VOUCHERMR
	------------------------------------------------------------------------
	Declare @NroReg int, @Cd_TD nvarchar(2), @NroDoc nvarchar(15)
	Declare @Debe decimal(13,2), @Haber decimal(13,2), @Cd_Mda nvarchar(2)
	Declare @Cd_Area nvarchar(6), @Cd_MR nvarchar(2)
	
	set @NroReg = (select isnull(max(NroReg),0)+1 from VoucherRM where RucE=@RucE)
	select @Cd_TD=Cd_TD, @NroDoc=NroDoc, @Debe=MtoD, @Haber=MtoH, @Cd_Mda=Cd_MdRg,
	       @Cd_Area=Cd_Area, @Cd_MR=Cd_MR 
	from   Voucher
	where RucE=@RucE and Cd_Vou=@Cd_Vou

	--INSERTANDO MOVIMIENTO DE REGISTRO--
	-----------------------------------------------------------------------------------
	insert into VoucherRM(RucE,NroReg,Cd_Vou,Cd_TD,NroDoc,Debe,Haber,Cd_Mda,Cd_Area,Cd_MR,Usu,FecMov)
		       Values(@RucE,@NroReg,@Cd_Vou,@Cd_TD,@NroDoc,@Debe,@Haber,@Cd_Mda,@Cd_Area,@Cd_MR,@UsuMdf,getdate())
	-----------------------------------------------------------------------------------	
	------------NO*/
--end
set @msj = 'Para anular un voucher, Debe actualizar el sistema'
--PV: Vie 30/01/09
--PV: Mar 17/02/09
--DI: Vie 20/02/09
--DI: Jue 12/11/09 Modificacion colocar el proceso de verificacion de cierre de periodo (en este momento se encuentra bloqueado)

--J : VIE 12/03/10 -> FRAGMENTOS DE CODIGO Q DICEN NO ES PORQUE YA ESTABAN COMENTADOS ANTERIORMENTE(NO SE USABAN) A LOS QUE COMENTE AHORA
GO

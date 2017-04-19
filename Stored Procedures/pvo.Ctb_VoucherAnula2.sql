SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [pvo].[Ctb_VoucherAnula2]
@RucE nvarchar(11),
@Ejer nvarchar(4),  --FALTA COLOCARRRRRRRRRRRRRRRRRRRRRRRRRRRRR!!!!!!!!!!!!!!!!!!!!!!!!
@RegCtb nvarchar(15),
@UsuMdf nvarchar(10),
@msj varchar(100) output
as


if not exists (select * from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
	set @msj = 'Voucher no existe'
/*
else if(User123.VPrdo(@RucE,@Ejer,SubString(@RegCtb,8,2) = 1)
	set @msj = 'Voucher no puede ser anulado, el periodo '+User123.DamePeriodo(SubString(@RegCtb,8,2))+' no encuentra disponible'
*/
else
begin

	/*
	declare @Cd_Vou varchar(10)
	set @Cd_Vou = (select Cd_Vou from Voucher where RucE=@RucE and RegCtb=@RegCtb)
	*/
	update Voucher set FecMdf=getdate(), IB_Anulado=1, UsuModf=@UsuMdf
	where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
	
	
	if @@rowcount > 0
	Begin
		if(substring(@RegCtb,6,2) = 'RV')
		begin
			update Venta set IB_Anulado = 1, FecMdf=getdate(), UsuModf=@UsuMdf where RucE=@RucE and Eje=@Ejer and RegCtb=@RegCtb
		end
	End
	Else
	begin
		set @msj = 'Voucher no pudo ser anulado'
		return
	end

--	else
--	begin
--		declare @Cd_MR varchar(2)
--		set @Cd_MR='XX'  --No se ha definido (SE DEBERIA TRAER)		
--		   insert into VoucherRM (RucE, NroReg, RegCtb, Ejer, /*Cd_Vou, NroCta, Cd_TD, NroDoc, Debe, Haber, Cd_Mda, Cd_Area,*/ Cd_MR, Usu, FecMov, Cd_Est)
--		   			 values (@RucE, dbo.Nro_RegVouRM(@RucE), @RegCtb, @Ejer, /*@Cd_Vou, @NroCta, @Cd_TD, @NroDoc, @MtoD, @MtoH, @Cd_MdRg, @Cd_Area,*/ @Cd_MR, @UsuMdf, getdate(), '04')
--	end







	/*
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
	*/
end
print @msj
--PV: Vie 30/01/09
--PV: Mar 17/02/09
--DI: Vie 20/02/09
--DI: Jue 12/11/09 Modificacion colocar el proceso de verificacion de cierre de periodo (en este momento se encuentra bloqueado)
--J : Jue 11/03/10 Se "agregó"(descomento) el campo Ejer ya que se anulaban voucher con el mismo registro pero diferente periodo
--PV: Mdf Vie 19/03/2010  ---> Campos VoucherRM
--DI: Mdf Jue 06/05/2010  ---> Se modifico para que pueda eliminar tanto en VOUCHER como en VENTA
GO

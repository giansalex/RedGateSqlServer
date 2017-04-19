SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_VentaElim]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@UsuModf nvarchar(10),
@msj varchar(100) output
as

if not exists (select * from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @msj = 'Venta no existe'
else
begin
	if(@UsuModf<>'eleon')
	Begin
		if (@UsuModf != (select UsuCrea from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta ))
		begin 	set @msj = 'No tiene permisos para eliminar esta venta'
			return
		end
	End


	if exists (select * from Cobro where RucE = @RucE and Cd_Vta = @Cd_Vta)
	begin	
		set @msj='Venta a sido cobrada'
		return
	end

	if exists (select * from Inventario where  RucE=@RucE and Cd_Vta=@Cd_Vta) --PV
	begin 	set @msj = 'Venta no puede ser eliminada xq esta siendo referenciada por un mov. de inventario'
		return
	end




	--OBTENIENDO INFORMACION PARA REGISTRAR MOVIMIENTO
	-----------------------------------------------------------------------------------
	declare @Cd_TD nvarchar(2), @NroDoc nvarchar(15), @Cd_Area nvarchar(6),@Cd_MR nvarchar(2), @Cd_Mda nvarchar(2), @Total decimal(13,2)
	declare @RegCtb varchar(15), @Ejer nvarchar(4)

	select @RegCtb=RegCtb, @Ejer=Eje, @Cd_TD=Cd_TD, @NroDoc=NroDoc, @Cd_Area=Cd_Area, @Cd_MR=Cd_MR, @Cd_Mda=Cd_Mda, @Total=Total from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta

	-----------------------------------------------------------------------------------
	--Sacamos Reg Contable y Ejer. para eliminar voucher en contabilidad
	--select @RegCtb=RegCtb, @Ejer=Eje from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta

	-----------------------------------------------------------------------------------
	
	--delete Cobro where RucE=@RucE and Cd_Vta=@Cd_Vta
	--delete CampoV where RucE=@RucE and Cd_Vta=@Cd_Vta
	delete  VentaDet where RucE=@RucE and Cd_Vta=@Cd_Vta
	delete  Venta where RucE=@RucE and Cd_Vta=@Cd_Vta
	
	if @@rowcount <= 0
	begin
	   set @msj = 'Venta no pudo ser eliminada'
	   return
	end
	else
	begin
		declare @MovVtaCtb bit
		select @MovVtaCtb = IB_MovVtaCtbLin from CfgGeneral where RucE =@RucE
		if (@MovVtaCtb=1)
			if exists (select * from Voucher where  RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)  --Esta validacion siempre debe estar afuera --PV
				exec pvo.Ctb_VoucherElim2 @RucE,@Ejer,@RegCtb,@UsuModf,@msj output
		if @msj is not null
			rollback transaction
	end
	----------------------------------





	--INSERTANDO MOVIMIENTO DE REGISTRO
	-----------------------------------------------------------------------------------
	declare @NroReg int
	set @NroReg = (select isnull(max(NroReg),0)+1 from VentaRM where RucE=@RucE)
	insert into VentaRM(NroReg,RucE,Cd_Vta,Cd_TD,NroDoc,Total,Cd_Mda,FecMov,Cd_Area,Cd_MR,Usu,Cd_Est)
		     Values(@NroReg,@RucE,@Cd_Vta,@Cd_TD,@NroDoc,@Total,@Cd_Mda,getdate(),@Cd_Area,@Cd_MR,@UsuModf,'03')
	-----------------------------------------------------------------------------------
end
print @msj
--DI : Lun 23/01/09
--PV : JUE 04/06/09 : se agrego elim. voucher
--PV: VIE 26/03/2010 Mdf:  que llame a Ctb_VoucherElim2
--PV: JUE 25/11/2010 Mdf: validacion con inventario



GO

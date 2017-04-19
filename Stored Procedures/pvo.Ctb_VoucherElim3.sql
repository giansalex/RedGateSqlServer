SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*Este SP se creo para que, cuando se edite una CP, estando la eliminacion en linea activa. no se elimine la CP al volver a generar el voucher */
CREATE procedure [pvo].[Ctb_VoucherElim3]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@RegCtb nvarchar(15),
@UsuMdf nvarchar(10),
@msj varchar(100) output,
@IC_Accion char -- M: Modificar, E: Eliminar
as

if not exists (select * from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
	set @msj = 'Voucher no existe'
else if(User123.VPrdo(@RucE,@Ejer,SubString(@RegCtb,8,2)) = 1)
	set @msj = 'Voucher no puede ser eliminado, el periodo '+User123.DamePeriodo(SubString(@RegCtb,8,2))+' no se encuentra habilitado'
else
begin
begin transaction
	
	--declare @Cd_Vou varchar(10)
	--set @Cd_Vou = (select Cd_Vou from Voucher where RucE=@RucE and RegCtb=@RegCtb)
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

	print @NroReg
	print @Cd_TD
	print @NroDoc
	print @Debe
	print @Haber
	print @Cd_Mda
	print @Cd_Area
	print @Cd_MR	
	*/

	--INSERTANDO MOVIMIENTO DE REGISTRO--
	Declare row cursor for 
	select Cd_Vou,NroCta,Cd_TD, NroDoc, MtoD, MtoH,Cd_MdRg, Cd_Area, Cd_MR from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
	
		Declare @Cd_Vou int,@Cd_TD nvarchar(2), @NroDoc nvarchar(15)
		Declare @NroCta nvarchar(10)
		Declare @Debe decimal(13,2), @Haber decimal(13,2), @Cd_Mda nvarchar(2)
		Declare @Cd_Area nvarchar(6), @Cd_MR nvarchar(2)
		Set @NroCta=null
		Set @Cd_TD=null Set @NroDoc=null
		Set @Debe=0.00 Set @Haber=0.00 Set @Cd_Mda=null
		Set @Cd_Area=null Set @Cd_MR=null
	
		Declare @NroReg int		
	
	OPEN row
		FETCH NEXT from row INTO @Cd_Vou,@NroCta,@Cd_TD,@NroDoc,@Debe,@Haber,@Cd_Mda,@Cd_Area,@Cd_MR
		WHILE @@FETCH_STATUS = 0
			BEGIN	
				Set @NroReg=(select isnull(Max(NroReg),0)+1 from VoucherRM where RucE=@RucE)
				
				Insert into VoucherRM(RucE,NroReg,RegCtb,Ejer,Cd_Vou,NroCta,Cd_TD,NroDoc,Debe,Haber,Cd_MDa,Cd_Area,Cd_MR,Usu,FecMov,Cd_Est)
				     values(@RucE,@NroReg,@RegCtb,@Ejer,@Cd_Vou,@NroCta,@Cd_TD,@NroDoc,@Debe,@Haber,@Cd_MDa,@Cd_Area,@Cd_MR,@UsuMdf,getdate(),'03')
				
				if @@rowcount <= 0
				begin
					set @msj = 'Hubo problemas en la eliminacion'
					print @msj
					rollback transaction
					return
				end

				FETCH NEXT from row INTO @Cd_Vou,@NroCta,@Cd_TD,@NroDoc,@Debe,@Haber,@Cd_Mda,@Cd_Area,@Cd_MR
			END
	CLOSE row
	DEALLOCATE row

	delete from Voucher where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
	if @@rowcount <= 0
	begin
		set @msj = 'Voucher no pudo ser eliminado'
		rollback transaction
		return
	end
	else
	/*
	--INSERTANDO MOVIMIENTO DE REGISTRO--
	-----------------------------------------------------------------------------------
	insert into VoucherRM(RucE,NroReg,Cd_Vou,Cd_TD,NroDoc,Debe,Haber,Cd_Mda,Cd_Area,Cd_MR,Usu,FecMov,Cd_Est)
		       Values(@RucE,@NroReg,@Cd_Vou,@Cd_TD,@NroDoc,@Debe,@Haber,@Cd_Mda,@Cd_Area,@Cd_MR,@UsuMdf,getdate(),'03')
	-----------------------------------------------------------------------------------	
	*/
	--ELIMINANDO MOVIMINETO EN VENTA
	declare @ElmCtbVta bit,@ElmCtbCom bit,@ElmCtbInv bit, @PreFijo char(2)
	
	select
		@ElmCtbVta = IB_ElmCtbVtaLin,
		@ElmCtbCom = IB_ElmCtbComLin,
		@ElmCtbInv = IB_ElmCtbInvLin from CfgGeneral where RucE = @RucE
	set @PreFijo = left(@RegCtb,2)
	
	----------------------------------------------------------------------------------------------------------------------------
	if (@ElmCtbVta=1 and @PreFijo = 'VT')
		if(@IC_Accion = 'E')--SOLO ELIMINAR VENTA, SI EL INDICADOR ES "ELIMINAR"
		begin
			if exists (select * from Venta where RucE=@RucE and Eje=@Ejer and RegCtb=@RegCtb)
				exec Vta_VentaElim_X_NDNR2 @RucE,@Ejer,'','',@RegCtb,@UsuMdf, @msj output
		end
	
	----------------------------------------------------------------------------------------------------------------------------
	if (@ElmCtbCom=1 and @PreFijo = 'CP')
		if(@IC_Accion = 'E')--SOLO ELIMINAR COMPRA, SI EL INDICADOR ES "ELIMINAR"
		begin
			if exists(Select * from Compra where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
			begin
				declare @Cd_Com char(10)
				Select @Cd_Com = Cd_Com from Compra where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb
				exec Com_CompraElim @RucE, @Ejer,@Cd_Com, @RegCtb, @UsuMdf, @msj output
			end
		end
	----------------------------------------------------------------------------------------------------------------------------
	if (@ElmCtbInv=1 and @PreFijo = 'IN')
		if(@IC_Accion = 'E')--SOLO ELIMINAR COMPRA, SI EL INDICADOR ES "ELIMINAR"
		begin
			if exists (select * from Inventario where RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)
				exec Inv_InventarioElim @RucE, @RegCtb, @msj output, @Ejer
		end
	----------------------------------------------------------------------------------------------------------------------------
	if @msj is not null
		rollback transaction
	commit transaction
end
print @msj
--PV: Vie 30/01/09
--PV: Mar 17/02/09
--DI: Vie 20/02/09
--DI: Jue 12/11/09 Modificacion colocar el proceso de verificacion de cierre de periodo (en este momento se encuentra bloqueado)
--DI: Lun 11/03/2010 Mdf: para registro de voucherRM
--PV: VIE 26/03/2010 Mdf:  que llame a Vta_VentaElim_X_NDNR2
--MP: MIE 24/11/2010 Mdf: Modificacion del procedimiento almacenado (se agrego eliminacion de compra)
--PP: JUE 03/02/2010 Mdf: Modificaion deacuerdo a la configuracion
--CAM: LUN 09/01/2012 crea: validacion de IC_Accion



GO

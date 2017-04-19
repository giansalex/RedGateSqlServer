SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_CompraElim]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Cd_Com char(10),
@RegCtb nvarchar(15),
@UsuModf nvarchar(10),
@msj varchar(100) output

as

	if not exists (select * from Compra where RucE=@RucE and Cd_Com=@Cd_Com)
	begin
		set @msj = 'Compra no existe'
	end
	else if(User123.VPrdo(@RucE,(select Ejer from compra where ruce=@RucE and Cd_Com=@Cd_Com),SubString((select RegCtb from compra where ruce=@RucE and Cd_Com=@Cd_Com),8,2)) = 1)
	begin
		set @msj = 'Compra no puede ser eliminada, el periodo '+User123.DamePeriodo(SubString((select regctb from compra where ruce=@RucE and Cd_Com=@Cd_Com),8,2))+' no se encuentra habilitado'
	end
	else if exists (select *from inventario where RucE=@RucE and Cd_Com=@Cd_Com)
	begin
		set @msj='Compra Tiene Inventario relacionado'
	end
	else if exists (select *from DocsCom where  RucE=@RucE and Cd_Com=@Cd_Com)
	begin
		set @msj='Compra Tiene documentos relacionados'
	end
	else if(@UsuModf != (select UsuCrea from Compra where RucE=@RucE and Cd_Com=@Cd_Com))
	begin
		set @msj = 'No puede eliminar la Compra registrada por otro usuario'
	end
	else
	begin
		begin transaction
		if @RegCtb is null
			select @RegCtb = RegCtb from Compra where RucE=@RucE and Cd_Com=@Cd_Com 
		delete from CompraDet where RucE=@RucE and Cd_Com=@Cd_Com 
		delete from Compra where RucE=@RucE and Cd_Com=@Cd_Com
		if @@rowcount <= 0
			begin
			set @msj = 'Compra no pudo ser eliminado'
			rollback transaction
			end
		else
			begin
			declare @MovComCtb bit
			select @MovComCtb = IB_MovComCtbLin from CfgGeneral where RucE =@RucE
			if (@MovComCtb=1)
				if exists (select * from Voucher where  RucE=@RucE and Ejer=@Ejer and RegCtb=@RegCtb)					exec pvo.Ctb_VoucherElim2 @RucE,@Ejer,@RegCtb,@UsuModf,@msj output
			if @msj is not null
				rollback transaction
			end
		commit transaction
	end
print @msj
--MP: 2010-11-25 : <Modificacion del procedimiento almacenado>
--J: 2011-01-05 : <Modificacion del procedimiento almacenado>
--CE: 20/08/2012 Mdf: Antes de eliminar verificar si el periodo esta habilitado en el cierre de periodo


--exec dbo.Com_CompraElim '11111111111','2010','CM00000027','CPGE_RC12-00023','coqueliz',null





GO

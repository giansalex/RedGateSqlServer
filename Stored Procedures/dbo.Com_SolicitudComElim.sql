SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudComElim]
@RucE nvarchar(11),
@Cd_SCo char(10),
@UsuCrea varchar(15),
@msj varchar(100) output
as
	if not exists (select * from SolicitudCom where RucE=@RucE and Cd_SCo=@Cd_SCo)
	begin
		set @msj = 'Solicitud de Compra no existe'
	end
	else if exists (select * from OrdCompra where RucE=@RucE and Cd_SCo=@Cd_SCo)
	begin
		set @msj='Solicitud de Compra tiene Orden de Compra Relacionada'
		
	end
	else if exists (select * from SCxProv where RucE=@RucE and Cd_SCo=@Cd_SCo)
	begin
		set @msj='No puede eliminar Solicitud de Compra porque tiene asociado información de Proveedores'
		
	end
	else if(@UsuCrea != (select  UsuCrea from SolicitudCom where RucE=@RucE and Cd_SCo=@Cd_SCo))
	begin
		set @msj = 'No puede eliminar la Solicitud de Compra creada por otro usuario'
	end
	else
	begin
		begin transaction
		--delete from SCxProv where RucE=@RucE and Cd_SCo=@Cd_SCo
		delete from SolicitudComDet where RucE=@RucE and Cd_SC=@Cd_SCo
		delete from SolicitudCom
		where RucE=@RucE and Cd_SCo=@Cd_SCo
		if @@rowcount <= 0
		begin	   set @msj = 'Solicitud de Compra no pudo ser eliminado'
		   rollback transaction
		end
		commit transaction
	end

print @msj
-- Leyenda --
-- J : 2010-08-11 : <Creacion del procedimiento almacenado>
-- J : 2010-01-05 : <Modificacion del procedimiento almacenado>
--exec dbo.Com_SolicitudComElim '11111111111','SC00000010','jesus',null
GO

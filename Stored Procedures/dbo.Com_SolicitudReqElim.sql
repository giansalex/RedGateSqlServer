SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudReqElim]
@RucE nvarchar(11),
@Cd_SR char(10),
@UsuCrea varchar(10),
@msj varchar(100) output
as
	if not exists (select * from SolicitudReq where RucE=@RucE and Cd_SR=@Cd_SR)
	begin
		set @msj = 'Solicitud de Requerimientos no existe'
		return
	end
	else
	begin
		declare @Id_EstSR char(2), @Id_EstSRS char(2)
		select @Id_EstSR = Id_EstSR, @Id_EstSRS = Id_EstSRS
		from SolicitudReq where RucE = @RucE and Cd_SR = @Cd_SR

		if((@Id_EstSR != '04' and @Id_EstSR != '08') or (@Id_EstSRS != '01' and @Id_EstSRS != '10'))
		begin
			set @msj = 'Solicitud de Requerimientos tiene un movimiento relacionado'
			return
		end
	end
	if exists (select * from SolicitudCom where RucE=@RucE and Cd_SR=@Cd_SR)
	begin
		set @msj= 'Solicitud de Requerimientos tiene una solicitud de compra relacionada'
		--return
	end
	/*else if(@UsuCrea!= (select ElaboradoPor from SolicitudReq Where Ruce=@RucE and Cd_SR=@Cd_SR))
	begin
		set @msj = 'No puede eliminar la solicitud de requerimientos elaborada por otro usuario'
		--return
	end*/
	else if(@UsuCrea!= (select UsuCrea from SolicitudReq Where Ruce=@RucE and Cd_SR=@Cd_SR))
	begin
		set @msj = 'No puede eliminar la solicitud de requerimientos creada por otro usuario'
		--return
	end
	else
	begin
		begin transaction
		delete from AutSR where RucE=@RucE and Cd_SR=@Cd_SR
		delete from SolicitudReqDet where RucE=@RucE and Cd_SR=@Cd_SR
		--exec dbo.Com_SolicitudReqDetElim @RucE,@Cd_SR,@msj out
		delete from SolicitudReq where RucE=@RucE and Cd_SR=@Cd_SR
		if @@rowcount <= 0
		begin	   set @msj = 'Solicitud de Requerimientos no pudo ser eliminada'
		   rollback transaction
		end
		commit transaction
	end

print @msj
-- Leyenda --
-- J : 09-09-2010 : <Creacion del procedimiento almacenado>
-- JJ : 21-12-2010 : <Modificacion del procedimiento almacenado>
-- J : 05-12-2010 :  <Modificacion del procedimiento almacenado>
-- MM : 12-08-2011 : <Modificacion del SP - Se valido la relacion de los productos con otros movimientos>
/*
exec dbo.Com_SolicitudReqElim '11111111111','SR00000011','jesus',null
*/

GO

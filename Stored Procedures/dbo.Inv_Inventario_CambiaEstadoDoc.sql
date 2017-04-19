SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Inventario_CambiaEstadoDoc]
@RucE nvarchar(11),
@Cd_OC nvarchar(10),
@Cd_OP nvarchar(10),
@Cd_SR char(10),
@Estado int,
@msj varchar(100) output
as
set @msj = 'Inv_Inventario_CambiaEstadoDoc no esta en uso'
/*
------------- O R D E N     DE    C O M P R A --------------
if(@Cd_OC != '' or @Cd_OC is not null)
begin
	if(@Estado = 1)--'Pendiente por Recibir	'
	begin
		update OrdCompra set Id_EstOC = '01' where RucE = @RucE and Cd_OC = @Cd_OC
	end else
	if(@Estado = 2)--'Parcialmente Recibida	'
	begin
		update OrdCompra set Id_EstOC = '02' where RucE = @RucE and Cd_OC = @Cd_OC
	end else
	if(@Estado = 3)--'Recibida'
	begin
		update OrdCompra set Id_EstOC = '03' where RucE = @RucE and Cd_OC = @Cd_OC
	end	
end
else
------------- O R D E N    D E    P E D I D O ----------
if(@Cd_OP != '' or @Cd_OP is not null)
begin
	if(@Estado = 1)--'Pendiente de Atencion'
	begin
		update OrdPedido set Id_EstOP = '01' where RucE = @RucE and Cd_OP = @Cd_OP
	end else
	if(@Estado = 2)--'Parcialmente Entregada'
	begin
		update OrdPedido set Id_EstOP = '02' where RucE = @RucE and Cd_OP = @Cd_OP
	end else
	if(@Estado = 3)--'Entregada'
	begin
		update OrdPedido set Id_EstOP = '03' where RucE = @RucE and Cd_OP = @Cd_OP
	end	
end
------------- S O L I C I T U D    D E   R E Q U E R I M I E N T O ----------
else if(@Cd_SR != '' or @Cd_SR is not null)
begin
	if(@Estado = 1)--'Pendiente de Atencion'
	begin
		update SolicitudReq set Id_EstSR = '04' where RucE = @RucE and Cd_SR = @Cd_SR
	end else
	if(@Estado = 2)--'Parcialmente Atendida'
	begin
		update SolicitudReq set Id_EstSR = '05' where RucE = @RucE and Cd_SR = @Cd_SR
	end else
	if(@Estado = 3)--'Atendida'
	begin
		update SolicitudReq set Id_EstSR = '06' where RucE = @RucE and Cd_SR = @Cd_SR
	end	
end
------------------------------------------------------------------------------
else
begin
	set @msj = 'No se puede identificar el codigo de documento ingresado o no existe documento.'
end
*/
-- CAM <Fecha: 26/01/2011><Creacion del sp>
-- 1: Pendiente
-- PARA ORDEN DE COMPRA
-- exec Inv_Inventario_CambiaEstadoDoc '11111111111','OC00000032',null,null,1,''
-- PARA ORDEN DE PEDIDO
-- exec Inv_Inventario_CambiaEstadoDoc '11111111111',null,'OP00000030',null,1,''
-- PARA SOLICITUD DE REQUERIMIENTO
-- exec Inv_Inventario_CambiaEstadoDoc '11111111111',null,null,'SR00000027',1,''

GO

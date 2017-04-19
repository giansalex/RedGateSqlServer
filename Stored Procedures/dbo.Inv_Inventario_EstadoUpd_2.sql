SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  procedure [dbo].[Inv_Inventario_EstadoUpd_2]
@RucE nvarchar(11),
@Cd_Com nvarchar(10),--Por el momento no se usa
@Cd_Vta nvarchar(10),--Por el momento no se usa
@Cd_OC nvarchar(10),
@Cd_OP nvarchar(10),
@Cd_SR char(10),
@Cd_GR char(10),--Por el momento no se usa
@Cd_SCo char(10),
@Cd_Cot char(10),
@Estado int,
/* Leyenda de @Estado
1:Sin Atencion, Pendiente de Atencion, Pendiente por Recibir, etc
2:Parcialamente Atendid@ o Entregado
3:Atendido o Entregado completamente*/
/********************************************************************************************************/
--OJO: Los valores de los campos Id_EstOC, Id_EstOP, Id_EstSR depende de sus respectivas llaves foraneas
/********************************************************************************************************/

@msj varchar(100) output
as
set @msj = 'Debe actualizar el sistema para realizar esta actualizacion.'
/*
--SOLO PARA CP, VT, OC, OP, SR
-----------------------  C O M P R A   ----------------------
if(@Cd_Com != '' or @Cd_Com is not null)
begin
	set @msj = 'El SP no esta implementado para Codigos de Compra'
	print @msj
end
else
------------------------- V E N T A -------------------------
if(@Cd_Vta != '' or @Cd_Vta is not null)
begin
	set @msj = 'El SP no esta implementado para Codigos de Venta'
	print @msj
end
else
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
------------------------- G U I A   DE   R E M I S I O N  -------------------------
else if(@Cd_GR != '' or @Cd_GR is not null)
begin
	set @msj = 'El SP no esta implementado para Codigos de GuÃ­a de RemisiÃ³n'
	print @msj
end
---------------- S O L I C I T U D     D E     C O M P R A  -----------------------
else if(@Cd_SCo != '' or @Cd_SCo is not null)
begin
	if(@Estado = 1)--'Pendiente de Envio'
	begin
		update SolicitudCom set Id_EstSC = '01' where RucE = @RucE and Cd_SCo = @Cd_SCo
	end else
	if(@Estado = 2)--'Enviada a PDF'
	begin
		update SolicitudCom set Id_EstSC = '02' where RucE = @RucE and Cd_SCo = @Cd_SCo
	end else
	if(@Estado = 3)--'Enviada a Imprimir'
	begin
		update SolicitudCom set Id_EstSC = '03' where RucE = @RucE and Cd_SCo = @Cd_SCo
	end else 
	if(@Estado = 4)--'Enviada por Correo'
	begin
		update SolicitudCom set Id_EstSC = '04' where RucE = @RucE and Cd_SCo = @Cd_SCo
	end else
	if(@Estado = 5)--'Atendida'
	begin
		update SolicitudCom set Id_EstSC = '05' where RucE = @RucE and Cd_SCo = @Cd_SCo
	end else
	if(@Estado = 6)--'Atendida por Todos los Proveedores'
	begin
		update SolicitudCom set Id_EstSC = '06' where RucE = @RucE and Cd_SCo = @Cd_SCo
	end else
	if(@Estado = 7)--'Aprobada c/Proveedor'
	begin
		update SolicitudCom set Id_EstSC = '07' where RucE = @RucE and Cd_SCo = @Cd_SCo
	end else
	if(@Estado = 8)--'Procesada parcialmente en OC'
	begin
		update SolicitudCom set Id_EstSC = '08' where RucE = @RucE and Cd_SCo = @Cd_SCo
	end else
	if(@Estado = 9)--'Procesada en OC'
	begin
		update SolicitudCom set Id_EstSC = '09' where RucE = @RucE and Cd_SCo = @Cd_SCo
	end	else
	if(@Estado = 10)--'Cancelada'
	begin
		update SolicitudCom set Id_EstSC = '10' where RucE = @RucE and Cd_SCo = @Cd_SCo
	end	
----
end
-----------------------------------------------------------------------------------
else
begin
	set @msj = 'No se puede identificar el codigo de documento ingresado o no existe documento.'
end
*/
-- CAM <Fecha: 15/02/2011><Creacion del sp>
-- 1: Pendiente
-- PARA ORDEN DE COMPRA
-- exec Inv_Inventario_EstadoUpd_2 '11111111111',null,null,'OC00000032',null,null,null,nul1,null,1,''
-- PARA ORDEN DE PEDIDO
-- exec Inv_Inventario_EstadoUpd_2 '11111111111',null,null,null,'OP00000030',null,null,null,null,1,''
-- PARA SOLICITUD DE REQUERIMIENTO
-- exec Inv_Inventario_EstadoUpd_2 '11111111111',null,null,null,null,'SR00000029',null,null,null,3,''

--select * from OrdCompra where RucE = '11111111111' and Cd_OC = 'OC00000032'


GO

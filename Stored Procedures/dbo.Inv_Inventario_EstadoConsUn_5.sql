SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Inventario_EstadoConsUn_5]
--Se usan para saber el estado en <descripcion> del documento
--Se usan en DaoInventario
--Devuelve la fila si esta apta para ser llamada y ser atendida/recibida/entregada,etc
@RucE nvarchar(11),
@Cd_Com nvarchar(10),--Por el momento no se usa
@Cd_Vta nvarchar(10),--Por el momento no se usa
@Cd_OC nvarchar(10),
@Cd_OP nvarchar(10),
@Cd_SR char(10),
@Cd_GR char(10),--Por el momento no se usa
@Cd_SCo char(10),
@Cd_Cot char(10),--Por el momento no se usa
@Cd_OF char(10),
@msj varchar(100) output
as

-----------------------------  C O M P R A   --------------------------
if(@Cd_Com != '' or @Cd_Com is not null)
begin
	set @msj = 'El SP no esta implementado para Codigos de Compra'
	print @msj
end
else
-------------------------------- V E N T A -------------------------
if(@Cd_Vta != '' or @Cd_Vta is not null)
begin
	set @msj = 'El SP no esta implementado para Codigos de Venta'
	print @msj
end
else
------------------------- O R D E N     DE    C O M P R A --------------------
-- SOLO SE USA EN INVENTARIO:
if(@Cd_OC != '' or @Cd_OC is not null)
begin
	select * from OrdCompra where RucE = @RucE and Cd_OC = @Cd_OC and Id_EstOC in ('01','02','04','05','07','08')
	if(@@ROWCOUNT = 0)
	begin
		set @msj = 'No se puede llamar la Orden de Compra debido a que ya fue Atendida en Inventario'
	end
end
else
------------------------ O R D E N    D E    P E D I D O ---------------------
if(@Cd_OP != '' or @Cd_OP is not null)
begin
	select * from OrdPedido where RucE = @RucE and Cd_OP = @Cd_OP and Id_EstOP in ('01','02')
	if(@@ROWCOUNT = 0)
	begin
		set @msj = 'No se puede llamar la Orden de Pedido debido a que ya fue Entregada'
	end
end
------------- S O L I C I T U D    D E   R E Q U E R I M I E N T O ----------
else if(@Cd_SR != '' or @Cd_SR is not null)
begin
	select * from SolicitudReq where RucE = @RucE and Cd_SR = @Cd_SR and Id_EstSR in ('04','05')
	if(@@ROWCOUNT = 0)
	begin
		set @msj = 'No se puede llamar la Solicitud de Req. debido a que ya fue Atendida'
		print @msj
	end
end
else
--------------------------- G U I A   R E M I S I O N -------------------------
if(@Cd_GR != '' or @Cd_GR is not null)
begin
	set @msj = 'El SP no esta implementado para Codigos de Guia de Remision'
	print @msj
end
else
------------------ S O L I C I T U D   D E   C O M P R A   --------------------
if(@Cd_SCo != '' or @Cd_SCo is not null)
begin
	declare @Id_EstSC char(2)
	select * from SolicitudCom where RucE = @RucE and Cd_SCo = @Cd_SCo and Id_EstSC in ('07')-- ES Aprobada c/ Proveedor
	if(@@ROWCOUNT = 0)
	begin
	select @Id_EstSC = Id_EstSC from SolicitudCom where RucE = @RucE and Cd_SCo = @Cd_SCo
	if(@Id_EstSC = '01')begin set @msj = 'No se puede llamar la Solicitud de Compra debido a que tiene estado Pendiente de Envio' end
	if(@Id_EstSC = '02')begin set @msj = 'No se puede llamar la Solicitud de Compra debido a que tiene estado Enviada a PDF'	end
	if(@Id_EstSC = '03')begin set @msj = 'No se puede llamar la Solicitud de Compra debido a que tiene estado Enviada a Imprimir'end
	if(@Id_EstSC = '04')begin set @msj = 'No se puede llamar la Solicitud de Compra debido a que tiene estado Enviada por correo'	end
	--if(@Id_EstSC = '08')begin set @msj = 'No se puede llamar la Solicitud de Compra debido a que tiene estado Procesada Parcialmente en OC'end
	if(@Id_EstSC = '09')begin set @msj = 'No se puede llamar la Solicitud de Compra debido a que tiene estado Procesada en Orden de Compra'end
	if(@Id_EstSC = '10')begin set @msj = 'No se puede llamar la Solicitud de Compra debido a que tiene estado Cancelada'end
	end
	print @msj
end
--select * from EstadoSC where IB_Activo = '1'
--or Id_EstSC = '03' or Id_EstSC = '04'
else
--------------------------   C O T I Z A C I O N  ------------------------------
if(@Cd_Cot != '' or @Cd_Cot is not null)
begin
	--select count(*) as Filas from Cotizacion where RucE = @RucE and Cd_Cot = @Cd_Cot and Id_EstC = '07'-- ES Aprobada c/ Proveedor
	--select * from EstadoCot
	set @msj = 'El SP no esta implementado para Cotizacion'
	print @msj
end
--------------   O R D E N   D E  F A B R I C A C I O N  ---------------------
if(@Cd_OF != '' or @Cd_OF is not null)
begin
	select * from OrdFabricacion where RucE = @RucE and Cd_OF = @Cd_OF and Id_EstOF in ('01','03')-- ES Pendiente de Fabricacion (1) / Fabricado (3)
	if(@@ROWCOUNT = 0)
	begin
		set @msj = 'No se puede llamar la Orden de Fabricacion debido a que esta en produccion'
	end
end
--LEYENDA:
-- CAM <Fecha: 11/07/2011><Creacion del sp>

-- sp_help Inv_Inventario_EstadoConsUn_5
-- PARA COMPRAS
-- exec Inv_Inventario_EstadoConsUn_5 '11111111111','CM00000113',null,null,null,null,null,null,null,null,''
-- PARA VENTAS
-- exec Inv_Inventario_EstadoConsUn_5 '11111111111',null,'VT00000349',null,null,null,null,null,null,null,''
-- PARA ORDEN DE COMPRA
-- exec Inv_Inventario_EstadoConsUn_5 '11111111111',null,null,'OC00000091',null,null,null,null,null,null,''
-- PARA ORDEN DE PEDIDO
-- exec Inv_Inventario_EstadoConsUn_5 '11111111111',null,null,null,'OP00000030',null,null,null,null,null,''
-- PARA SOLICITUD DE REQUERIMIENTO
-- exec Inv_Inventario_EstadoConsUn_5 '11111111111',null,null,null,null,'SR00000029',null,null,null,null,''
-- PARA SOLICITUD DE COMPRA
-- exec Inv_Inventario_EstadoConsUn_5 '11111111111',null,null,null,null,null,null,'SC00000123',null,null,''

GO

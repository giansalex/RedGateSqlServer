SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Inventario_EstadoConsUn_SC_Web]
--Se usan para saber el estado en <descripcion> del documento
--Se usan en DaoInventario
--Devuelve la fila si esta apta para ser llamada y ser atendida/recibida/entregada,etc
@RucE nvarchar(11),
@Cd_SCo char(10),
@Cd_SCoEnv int,
@msj varchar(100) output
as

if(@Cd_SCo != '' or @Cd_SCo is not null)
begin
	declare @Id_EstSC char(2)
	select * from SCxProv where RucE = @RucE and Cd_SCo = @Cd_SCo and Cd_SCoEnv = @Cd_SCoEnv and Id_EstSCResp in ('02','04')-- ES Seleccionado / Parcialmente en oc
	if(@@ROWCOUNT = 0)
	begin
		select @Id_EstSC = Id_EstSC from SolicitudCom where RucE = @RucE and Cd_SCo = @Cd_SCo
		if(@Id_EstSC is null or @Id_EstSC = '')begin set @msj = 'No se puede llamar la Solicitud de Compra debido a que todavia no hay respuesta del proveedor.' end
		if(@Id_EstSC = '01')begin set @msj = 'No se puede llamar la Solicitud de Compra debido a que tiene estado Seleccionado. Falta el analisis.' end
		if(@Id_EstSC = '03')begin set @msj = 'No se puede llamar la Solicitud de Compra debido a que tiene estado Rechazada.'end
		if(@Id_EstSC = '05')begin set @msj = 'No se puede llamar la Solicitud de Compra debido a que tiene estado Procesada en OC.'end
	end
	print @msj
end
else
begin
	set @msj = 'No hay codigo de solicitud de compra.'
end
print @msj
-- Leyenda
-- CAM <Fecha: 25/06/2012><Creacion del sp>
-- exec Inv_Inventario_EstadoConsUn_SC_Web '11111111111','SC00000243','86',''
GO

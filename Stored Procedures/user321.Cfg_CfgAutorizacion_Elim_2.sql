SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Cfg_CfgAutorizacion_Elim_2]
@Id_Aut int,
@TipoDoc int,
@msj varchar(100) output
as
------------------------------------------------------------------------------
declare @cadena nvarchar(250)
declare @Tabla nvarchar(20)
declare @cont int
declare @tipoSolicitud nvarchar(30)
------------------------------------------------------------------------------
if(@TipoDoc = 0)
begin
	set @Tabla = 'OrdCompra'
	set @tipoSolicitud = 'ordenes de compra'
end
else if(@TipoDoc = 1)
begin
	set @Tabla = 'OrdPedido'
	set @tipoSolicitud = 'ordenes de pedido'
end
else if(@TipoDoc = 2)
begin
	set @Tabla = 'SolicitudCom'
	set @tipoSolicitud = 'solicitudes de compra'
end
else if(@TipoDoc = 3)
begin
	set @Tabla = 'SolicitudReq'
	set @tipoSolicitud = 'solicitudes de requerimiento'
end
else if(@TipoDoc = 4)
begin
	set @Tabla = 'OrdFabricacion'
	set @tipoSolicitud = 'ordenes de fabricacion'
end
else if(@TipoDoc = 4)
begin
	set @Tabla = 'Cotizacion'
	set @tipoSolicitud = 'cotizaciones'
end
------------------------------------------------------------------------------
begin transaction
	if not exists (select * from CfgAutorizacion where Id_Aut = @Id_Aut)
		set @msj = 'No existe la autorizacion'
	else
	begin
		set @cadena = 'select @contador = count(*) from cfgautorizacion a join '+@Tabla+' b 
				on a.Id_Aut = '+Convert(nvarchar,@Id_Aut)+' and a.tipo = b.tipAut and a.RucE = b.RucE'
		exec sp_executesql @cadena, N'@contador int output', @cont output
		if(@cont>0)
		begin
			set @msj = 'No se puede eliminar la autorizacion. Existen '+@tipoSolicitud+' asociadas'
			rollback transaction
			return
		end

		if exists (select * from CfgNivelAut where Id_Aut = @Id_Aut)
		begin
			delete from CfgNivelAut where Id_Aut = @Id_Aut
			if @@rowcount <=0
			begin
				set @msj = 'Error al eliminar los niveles de la autorizacion'
				rollback transaction
				return	
			end
		end
		delete from CfgAutorizacion where Id_Aut = @Id_Aut
		if @@rowcount <=0
		begin
			set @msj =  'Error al eliminar los niveles de la autorizacion'
			rollback transaction
			return
		end
	end
commit transaction

-- Leyenda --
-- MM : 2010-01-05    : <Creacion del procedimiento almacenado>

GO

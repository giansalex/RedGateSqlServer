SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_OrdCompra_ActualizaEstadoOC_AtenderServicio]
@RucE nvarchar(11),
@Cd_OC nvarchar(10),
@msj varchar(100) output

as
declare @Id_EstOCS char(2)
select @Id_EstOCS = Id_EstOCS from OrdCompra where RucE = @RucE and Cd_OC = @Cd_OC

if exists (select * from OrdCompra where RucE=@RucE and Cd_OC = @Cd_OC)
begin
	----------------------------------- CONTROL DE ESTADOS OC SERVICIOS --------------------------------------
	--Contar Servicios
	declare @CantServiciosTotal decimal(13,6) 
	select @CantServiciosTotal = count(*) from OrdCompraDet where RucE = @RucE and Cd_OC = @Cd_OC and Cd_SRV is not null
	print 'Cantidad de Servicos Totales: ' + convert(nvarchar(13),@CantServiciosTotal)

	--Cantidad Servicios Atendidos
	declare @CantServiciosAtentidos decimal(13,6) 
	select @CantServiciosAtentidos = count(*) from OrdCompra oc left join OrdCompraDet ocd on 
	oc.RucE = ocd.RucE and oc.Cd_OC = ocd.Cd_OC 
	where oc.RucE = @RucE and oc.Cd_OC = @Cd_OC and ocd.Cd_SRV is not null and IB_AtSrv = 1
	print 'Cantidad de Servicos Atendidos: ' + convert(nvarchar(13),@CantServiciosAtentidos)

	declare @CantServiciosPendientesDeAtencion decimal(13,6) 
	set @CantServiciosPendientesDeAtencion = @CantServiciosTotal - @CantServiciosAtentidos
	print 'Cantidad de Servicos Pendientes de Atencion: ' + convert(nvarchar(13),@CantServiciosPendientesDeAtencion)
	--------------------------------------------------------------------------------------------------------
	if(@Id_EstOCS = '01')
	begin
		if(@CantServiciosPendientesDeAtencion = 0)
		begin
			update OrdCompra set Id_EstOCS = '03' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 01 a 03'
		end
		else if(@CantServiciosPendientesDeAtencion > 0)
		begin
			update OrdCompra set Id_EstOCS = '02' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 01 a 02'
		end
	end else
	if(@Id_EstOCS = '02')
	begin
		if(@CantServiciosPendientesDeAtencion = 0)
		begin
			update OrdCompra set Id_EstOCS = '03' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 02 a 03'
		end
		else if(@CantServiciosPendientesDeAtencion > 0)
		begin
			update OrdCompra set Id_EstOCS = '02' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 02 a 02'
		end
	end
	---------------------------------------- ------ -----------------------------------------------
	if(@Id_EstOCS = '04')
	begin
		if(@CantServiciosPendientesDeAtencion = 0)
		begin
			update OrdCompra set Id_EstOCS = '06' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 04 a 06'
		end
		else if(@CantServiciosPendientesDeAtencion > 0)
		begin
			update OrdCompra set Id_EstOCS = '05' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 04 a 05'
		end
	end else
	if(@Id_EstOCS = '05')
	begin
		if(@CantServiciosPendientesDeAtencion = 0)
		begin
			update OrdCompra set Id_EstOCS = '06' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 05 a 06'
		end
		else if(@CantServiciosPendientesDeAtencion > 0)
		begin
			update OrdCompra set Id_EstOCS = '05' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 05 a 05'
		end
	end
	---------------------------- ------------------------------ ---------------------------------
	if(@Id_EstOCS = '07')
	begin
		if(@CantServiciosPendientesDeAtencion = 0)
		begin
			update OrdCompra set Id_EstOCS = '09' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 07 a 09'
		end
		else if(@CantServiciosPendientesDeAtencion > 0)
		begin
			update OrdCompra set Id_EstOCS = '08' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 07 a 08'
		end
	end else
	if(@Id_EstOCS = '08')
	begin
		if(@CantServiciosPendientesDeAtencion = 0)
		begin
			update OrdCompra set Id_EstOCS = '09' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 08 a 09'
		end
		else if(@CantServiciosPendientesDeAtencion > 0)
		begin
			update OrdCompra set Id_EstOCS = '08' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 08 a 08'
		end
	end
end
else
begin
	set @msj = 'No se encontro Orden de Compra con ese codigo'
end
-- LEYENDA
-- CAM <19/08/2011><Creacion de SP>
	
-- select * from EstadoOC_Srv
/*
-- PRUEBAS
--Contar Servicios
declare @CantServiciosTotal decimal(13,6) 
select @CantServiciosTotal = count(*) from OrdCompraDet where RucE = '11111111111' and Cd_OC = 'OC00000167' and Cd_SRV is not null
print 'Cantidad de Servicos Totales: ' + convert(nvarchar(13),@CantServiciosTotal)

--Cantidad Servicios Atendidos
declare @CantServiciosAtentidos decimal(13,6) 
select @CantServiciosAtentidos = count(*) from OrdCompra oc left join OrdCompraDet ocd on 
oc.RucE = ocd.RucE and oc.Cd_OC = ocd.Cd_OC 
where oc.RucE = '11111111111' and oc.Cd_OC = 'OC00000167' and ocd.Cd_SRV is not null and IB_AtSrv = 1
print 'Cantidad de Servicos Atendidos: ' + convert(nvarchar(13),@CantServiciosAtentidos)

declare @CantServiciosPendientesDeAtencion decimal(13,6) 
set @CantServiciosPendientesDeAtencion = @CantServiciosTotal - @CantServiciosAtentidos
print 'Cantidad de Servicos Pendientes de Atencion: ' + convert(nvarchar(13),@CantServiciosPendientesDeAtencion)



-- COMPROBACION 2
select * from OrdCompraDet where RucE = '11111111111' and Cd_OC = 'OC00000167'
exec Com_OrdCompra_ActualizaEstadoOC_Servicio '11111111111','OC00000166',''
*/


GO

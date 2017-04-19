SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_OrdCompra_ActualizaEstadoOC_Servicio]
@RucE nvarchar(11),
@Cd_OC nvarchar(10),
@msj varchar(100) output

as
declare @Id_EstOCS char(2)
select @Id_EstOCS = Id_EstOCS from OrdCompra where RucE = @RucE and Cd_OC = @Cd_OC

if exists (select * from OrdCompra where RucE=@RucE and Cd_OC = @Cd_OC)
begin
	----------------------------------- CONTROL DE ESTADOS OC SERVICIOS --------------------------------------
	declare @facturado decimal(13,6) 
	select @facturado = isnull(sum(Cant),0) from CompraDet det where RucE = @RucE and Cd_Com in 
	(select Cd_Com from Compra where RucE = det.RucE and Cd_OC =@Cd_OC)  and Cd_Srv is not null
	print @facturado

	declare @totalcant decimal(13,6)
	select @totalcant = isnull(sum(Cant),0) from OrdCompraDet where RucE = @RucE and Cd_OC = @Cd_OC  and Cd_Srv is not null
	print @totalcant

	declare @totalpend decimal(13,6)
	set @totalpend = @totalcant - @facturado
	print @totalpend
	--------------------------------------------------------------------------------------------------------
	--declare @Id_EstOCS char(2) 
	if(@Id_EstOCS = '01')
	begin
		if(@totalpend = 0)
		begin
			update OrdCompra set Id_EstOCS = '04' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 01 a 04'
		end
		else if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOCS = '07' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 01 a 07'
		end
	end else
	if(@Id_EstOCS = '02')
	begin
		if(@totalpend = 0)
		begin
			update OrdCompra set Id_EstOCS = '05' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 02 a 05'
		end
		else if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOCS = '08' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 02 a 08'
		end
	end else
	if(@Id_EstOCS = '03')
	begin
		if(@totalpend = 0)
		begin
			update OrdCompra set Id_EstOCS = '06' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 03 a 06'
		end
		else if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOCS = '09' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 03 a 09'
		end
	end
	---------------------------------------- ELIMINACIONES -----------------------------------------------
	if(@Id_EstOCS = '04')
	begin
		if(@totalpend = 0)
		begin
			update OrdCompra set Id_EstOCS = '01' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 04 a 01'
		end
		else if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOCS = '07' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 04 a 07'
		end
	end else
	if(@Id_EstOCS = '05')
	begin
		if(@totalpend = 0)
		begin
			update OrdCompra set Id_EstOCS = '02' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 05 a 02'
		end
		else if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOCS = '08' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 05 a 08'
		end
	end else
	if(@Id_EstOCS = '06')
	begin
		if(@totalpend = 0)
		begin
			update OrdCompra set Id_EstOCS = '03' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 06 a 03'
		end
		else if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOCS = '09' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 06 a 09'
		end
	end
	---------------------------- DESDE REGISTRADA PARCIALMENTE EN COMPRA ---------------------------------
	if(@Id_EstOCS = '07')--ELIMINACION
	begin
		if(@totalpend = @totalcant)
		begin
			update OrdCompra set Id_EstOCS = '01' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 07 a 01'
		end else
		if(@totalpend = 0)
		begin
			update OrdCompra set Id_EstOCS = '04' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 07 a 04'
		end
		else if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOCS = '07' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 07 a 07'
		end
	end else
	if(@Id_EstOCS = '08')
	begin
		if(@totalpend = @totalcant)
		begin
			update OrdCompra set Id_EstOCS = '02' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 08 a 02'
		end else
		if(@totalpend = 0)
		begin
			update OrdCompra set Id_EstOCS = '05' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 08 a 05'
		end
		else if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOCS = '08' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 08 a 08'
		end
	end else
	if(@Id_EstOCS = '09')
	begin
		if(@totalpend = @totalcant)
		begin
			update OrdCompra set Id_EstOCS = '03' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 09 a 03'
		end else
		if(@totalpend = 0)
		begin
			update OrdCompra set Id_EstOCS = '06' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 09 a 06'
		end
		else if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOCS = '09' where RucE=@RucE and Cd_OC = @Cd_OC
			print 'Cambio de 09 a 09'
		end
	end
end
else
begin
	set @msj = 'No se encontro Orden de Compra con ese codigo'
end
-- LEYENDA
-- CAM <16/08/2011><Creacion de SP>
--					<Agregue estado 3 a mas>
	
-- select * from EstadoOC_Srv
/*

declare @facturado decimal(13,6) 
	select @facturado = isnull(sum(Cant),0) from CompraDet det where RucE = '11111111111' and Cd_Com in 
	(select Cd_Com from Compra where RucE = det.RucE and Cd_OC ='OC00000167')  and Cd_Srv is not null
	print @facturado

	declare @totalcant decimal(13,6)
	select @totalcant = isnull(sum(Cant),0) from OrdCompraDet where RucE = '11111111111' and Cd_OC = 'OC00000167'  and Cd_Srv is not null
	print @totalcant

	declare @totalpend decimal(13,6)
	set @totalpend = @totalcant - @facturado
	print @totalpend
	
select * from Compra where RucE = '11111111111' and Cd_OC ='OC00000167'
select * from CompraDet where RucE = '11111111111' and Cd_Com ='CM00000305'
*/
GO

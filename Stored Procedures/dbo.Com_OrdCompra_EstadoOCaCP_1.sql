SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_OrdCompra_EstadoOCaCP_1]
@RucE nvarchar(11),
@Cd_OC char(10),
@msj varchar(100) output

as
declare @Id_EstOC char(2)
select @Id_EstOC = Id_EstOC from OrdCompra where RucE = @RucE and Cd_OC = @Cd_OC
----------------------------------- CONTROL DE ESTADOS OC ------------------------------------------
declare @facturado decimal(13,6) 
select @facturado = isnull(sum(Cant),0) from CompraDet det where RucE = @RucE and Cd_Com in 
(select Cd_Com from Compra where RucE = det.RucE and Cd_OC =@Cd_OC)  and Cd_Prod is not null
print @facturado

declare @totalcant decimal(13,6)
select @totalcant = isnull(sum(Cant),0) from OrdCOmpraDet where RucE = @RucE and Cd_OC = @Cd_OC  and Cd_Prod is not null
print @totalcant

declare @totalpend decimal(13,6)
set @totalpend = @totalcant - @facturado
print @totalpend
----------------------------------------------------------------------------------------------------
if (@Id_EstOC is not null)
begin
	if(@Id_EstOC = '01') 
	begin
		if(@totalpend = 0)
		begin
			update OrdCompra set Id_EstOC = '04' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 01 a Estado 04'
		end
		else
		if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOC = '07' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 01 a Estado 07'
		end
	end
	if(@Id_EstOC = '02') 
	begin
		if(@totalpend = 0)
		begin
			update OrdCompra set Id_EstOC = '05' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 02 a Estado 05'
		end
		else
		if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOC = '08' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 02 a Estado 08'
		end
	end
	if(@Id_EstOC = '03') 
	begin
		if(@totalpend = 0)
		begin
			update OrdCompra set Id_EstOC = '06' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 03 a Estado 06'
		end
		else
		if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOC = '09' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 03 a Estado 09'
		end
	end
	----------------------------- PARA ELIMINACIONES ----------------------------------
	if(@Id_EstOC = '04') 
	begin
		if(@totalpend = @totalcant)
		begin
			update OrdCompra set Id_EstOC = '01' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 04 a Estado 01'
		end
		else
		if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOC = '07' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 04 a Estado 07'
		end
	end
	if(@Id_EstOC = '05') 
	begin
		if(@totalpend = @totalcant)
		begin
			update OrdCompra set Id_EstOC = '02' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 05 a Estado 02'
		end
		else
		if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOC = '08' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 05 a Estado 08'
		end
	end
	if(@Id_EstOC = '06') 
	begin
		if(@totalpend = @totalcant)
		begin
			update OrdCompra set Id_EstOC = '03' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 06 a Estado 03'
		end
		else
		if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOC = '09' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 06 a Estado 09'
		end
	end
	-------------------------------------------------------------------------------------
	if(@Id_EstOC = '07') 
	begin
		if(@totalpend = @totalcant)
		begin
			update OrdCompra set Id_EstOC = '01' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 07 a Estado 01'
		end
		else
		if(@totalpend = 0)
		begin
			update OrdCompra set Id_EstOC = '04' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 07 a Estado 04'
		end
		else
		if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOC = '07' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 07 a Estado 07'
		end
	end
	if(@Id_EstOC = '08') 
	begin
		if(@totalpend = @totalcant)
		begin
			update OrdCompra set Id_EstOC = '02' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 08 a Estado 02'
		end
		else
		if(@totalpend = 0)
		begin
			update OrdCompra set Id_EstOC = '05' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 08 a Estado 05'
		end
		else
		if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOC = '08' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 08 a Estado 08'
		end
	end
	if(@Id_EstOC = '09') 
	begin
		if(@totalpend = @totalcant)
		begin
			update OrdCompra set Id_EstOC = '03' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 08 a Estado 03'
		end
		else
		if(@totalpend = 0)
		begin
			update OrdCompra set Id_EstOC = '06' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 08 a Estado 06'
		end
		else
		if(@totalpend > 0)
		begin
			update OrdCompra set Id_EstOC = '09' where RucE = @RucE and Cd_OC = @Cd_OC
			print 'Estado 08 a Estado 09'
		end
	end
	------------------------------------------------------------------------------------
end
else
begin
	set @msj = 'No se puede cambiar el estado a la Orden de Compra'
	print @msj
end

-- LEYENDA
-- CAM <25/07/2011><Creacion del SP>

--exec dbo.Com_OrdCompra_EstadoOCaCP_1 '11111111111','OC00000150',''
--select RucE, Cd_OC, Id_EstOC from OrdCompra  where RucE = '11111111111' and Cd_OC = 'OC00000150' 
--update OrdCompra set Id_EstOC = '01' where RucE = '11111111111' and Cd_OC = 'OC00000153' 
/*
select RucE, Cd_Com, Cd_Prod, Descrip, Cant from CompraDet det where RucE = '11111111111' and Cd_Com in 
(select Cd_Com from Compra where RucE = det.RucE and Cd_OC ='OC00000153' )
*/

-- select Id_EstOC from OrdCompra where RucE = '11111111111' and Cd_OC ='OC00000153'
/*
declare @facturado decimal(13,6) 
select @facturado = isnull(sum(Cant),0) from CompraDet det where RucE = '11111111111' and Cd_Com in 
(select Cd_Com from Compra where RucE = det.RucE and Cd_OC ='OC00000153') and Cd_Prod is not null
print 'Facturado: '
print @facturado

declare @totalcant decimal(13,6)
select @totalcant = isnull(sum(Cant),0) from OrdCOmpraDet where RucE = '11111111111' and Cd_OC = 'OC00000153' and Cd_Prod is not null
print 'Total Cantidad: '
print @totalcant

declare @totalpend decimal(13,6)
set @totalpend = @totalcant - @facturado
print 'Total Pendiente: '
print @totalpend
*/
GO

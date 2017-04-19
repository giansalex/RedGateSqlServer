SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_OrdCompra_VerificaEstadoOC_Servicio]
@RucE nvarchar(11),
@Cd_OC nvarchar(10),
@Id_EstOC_Srv char(2) output,
@msj varchar(100) output

as
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
	if(@totalpend = 0)
	begin
		set @Id_EstOC_Srv = '03'
		print '03'
	end else
	if(@facturado = 0)
	begin
		set @Id_EstOC_Srv = '01'
		print '01'
	end else
	if(@facturado > 0)
	begin
		set @Id_EstOC_Srv = '02'
		print '02'
	end
end
else
begin
	set @msj = 'No se encontro Orden de Compra con ese código'
end
-- LEYENDA
-- CAM <02/08/2011><Creacion de SP><Devuelve la >

-- select * from EstadoOC_Srv
/*

declare @facturado decimal(13,6) 
select @facturado = isnull(sum(Cant),0) from CompraDet det where RucE = '11111111111' and Cd_Com in 
(select Cd_Com from Compra where RucE = det.RucE and Cd_OC = 'OC00000156')  and Cd_Srv is not null
print @facturado

declare @totalcant decimal(13,6)
select @totalcant = isnull(sum(Cant),0) from OrdCompraDet where RucE = '11111111111' and Cd_OC =  'OC00000156'  and Cd_Srv is not null
print @totalcant

declare @totalpend decimal(13,6)
set @totalpend = @totalcant - @facturado
print @totalpend
*/
GO

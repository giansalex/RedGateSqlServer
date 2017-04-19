SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_OrdCompra_EstadoOCaCP]
@RucE nvarchar(11),
@Cd_OC char(10),
@msj varchar(100) output
as
declare @Id_EstOC char(2)
select @Id_EstOC = Id_EstOC from OrdCompra where RucE = @RucE and Cd_OC = @Cd_OC

if (@Id_EstOC is not null)
begin
	if(@Id_EstOC = '01') update OrdCompra set Id_EstOC = '04' where RucE = @RucE and Cd_OC = @Cd_OC
	if(@Id_EstOC = '02') update OrdCompra set Id_EstOC = '05' where RucE = @RucE and Cd_OC = @Cd_OC
	if(@Id_EstOC = '03') update OrdCompra set Id_EstOC = '06' where RucE = @RucE and Cd_OC = @Cd_OC
end
else
begin
	set @msj = 'No se puede cambiar el estado a la orden de compra'
	print @msj
end

-- LEYENDA
-- CAM <12/07/2011><Creacion del SP>

--exec dbo.Com_OrdCompra_EstadoOCaCP '11111111111','OC00000147',''
--select Id_EstOC from OrdCOmpra where RucE = '11111111111' and Cd_OC = 'OC00000147'
--update OrdCompra set Id_EstOC = '02' where RucE = '11111111111' and Cd_OC = 'OC00000147'
GO

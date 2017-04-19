SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_OrdCompra_VerificaEstadoOC_2]
@RucE nvarchar(11),
@Cd_OC nvarchar(10),
@msj varchar(100) output
as
if(@Cd_OC != '' or @Cd_OC is not null)
begin
	select * from OrdCompra where RucE = @RucE and Cd_OC = @Cd_OC and Id_EstOC in ('01','02','03','07','08','09')
	if(@@ROWCOUNT = 0)
	begin
		set @msj = 'Todos los productos de la Orden de Compra ya han sido facturados'
	end
end

-- LEYENDA
-- CAM <26/07/2011><Creacion de SP>
GO

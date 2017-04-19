SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_OrdCompra_VerificaEstadoOC]
@RucE nvarchar(11),
@Cd_OC nvarchar(10),
@msj varchar(100) output
as
if(@Cd_OC != '' or @Cd_OC is not null)
begin
	select * from OrdCompra where RucE = @RucE and Cd_OC = @Cd_OC and Id_EstOC in ('01','02','03')
	if(@@ROWCOUNT = 0)
	begin
		set @msj = 'No se puede llamar la Orden de Compra debido a que ya fue Recibida'
	end
end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Consultar_Com_x_OC]
@RucE varchar(11),
@Cd_OC char(10),
@msj varchar(100) output
as
if not exists (select * from OrdCompra where RucE = @RucE and Cd_OC = @Cd_OC)
begin
	set @msj = 'La orden de compra con codigo ' + @Cd_OC + ' no existe.'
	return
end
select * from CompraDet
where RucE=@RucE and Cd_Com in(select Cd_Com from Compra where RucE=@RucE and Cd_OC=@Cd_OC)
GO

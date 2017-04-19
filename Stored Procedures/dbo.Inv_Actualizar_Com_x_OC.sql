SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Actualizar_Com_x_OC]
@RucE varchar(11),
@Cd_OC char(10),
@Cd_Prod char(7),
@Cd_Srv char(7),
@ID_UMP int,
@ItemOC int,
@msj varchar(100) output
as
if not exists (select * from OrdCompra where RucE = @RucE and Cd_OC = @Cd_OC)
begin
	set @msj = 'La orden de compra con codigo ' + @Cd_OC + ' no existe.'
	return
end

if(@Cd_Prod is null or @Cd_Prod='')
begin
update CompraDet
set ItemOC=@ItemOC
where RucE=@RucE and Cd_Com in(select Cd_Com from Compra where RucE=@RucE and Cd_OC=@Cd_OC)
and Cd_Srv=@Cd_Srv
end

if(@Cd_Srv is null or @Cd_Srv='')
begin
update CompraDet
set ItemOC=@ItemOC
where RucE=@RucE and Cd_Com in(select Cd_Com from Compra where RucE=@RucE and Cd_OC=@Cd_OC)
and Cd_Prod=@Cd_Prod and ID_UMP=@ID_UMP
end
GO

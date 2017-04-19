SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [user321].[Inv_SolicitudReq_CambiarEstado]
@RucE nvarchar(11),
@Cd_SR char(10),
@Estado varchar(100),
@msj varchar(100) output
as
if(@Estado = 'Pendiente de Atención')
begin
	update SolicitudReq set Id_EstSR = '04' where RucE = @RucE and Cd_SR = @Cd_SR
end else
if(@Estado = 'Parcialmente Atendida')
begin
	update SolicitudReq set Id_EstSR = '05' where RucE = @RucE and Cd_SR = @Cd_SR
end else
if(@Estado = 'Atendida')
begin
	update SolicitudReq set Id_EstSR = '06' where RucE = @RucE and Cd_SR = @Cd_SR
end
-- LEYENDA
-- CAM <25/01/2011><Creación del SP>
GO

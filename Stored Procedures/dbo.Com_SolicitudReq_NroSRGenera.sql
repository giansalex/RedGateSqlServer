SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudReq_NroSRGenera]
@RucE nvarchar(11),
@Cd_SR nvarchar(10) output,
@Nro_SR nvarchar(15) output,
@msj varchar(100) output

as

set @Cd_SR = user123.Cd_SR(@RucE)--Funcion que genera el codigo de la solicitud de requerimientos
set @Nro_SR = user123.Nro_SR(@RucE)--Funcion que genera el numero de la solicitud de requerimientos

select @Cd_SR as Cd_SR,@Nro_SR as NroSR
-- Leyenda --
-- J : 2010-09-16<Creacion del procedimiento>
--Ejemplo--
/*
Declare @Cd_SCo nvarchar(10),@NroSC nvarchar(15)
exec Com_SolicitudReq_NroSRGenera '11111111111',@Cd_SR out,@Nro_SR out,null
print @Cd_SR
print @Nro_SR
*/
GO

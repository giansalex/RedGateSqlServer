SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Com_SolicitudReq2_NroSRGenera]
@RucE nvarchar(11),
@Cd_SR nvarchar(10) output,
@Nro_SR nvarchar(15) output,
@msj varchar(100) output

as

set @Cd_SR = User123.Cd_SR2(@RucE)--Funcion que genera el codigo de la solicitud de requerimientos
set @Nro_SR = User123.Nro_SR2(@RucE)--Funcion que genera el numero de la solicitud de requerimientos

select @Cd_SR as Cd_SR,@Nro_SR as NroSR
GO

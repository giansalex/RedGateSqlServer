SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ValidaSolicitudReq]
@RucE nvarchar(11),
@NroSR nvarchar(15),
@Cd_SR nvarchar(10) output,
@FecEmi smalldatetime output,
@msj varchar(100) output
as
if not exists(select * from SolicitudReq where RucE=@RucE and NroSR=@NroSR)
		set @msj = 'No existe la solicitud de requerimiento ' + @NroSR
else 
	select @Cd_SR=Cd_SR,@FecEmi=FecEmi from SolicitudReq where RucE=@RucE  and NroSR=@NroSR 

print @msj
print @Cd_SR
print @FecEmi
-- Leyenda --
-- J : 13-12-2010 : <Creacion del procedimiento almacenado>
--Declare @Cd_SR nvarchar(10),@FecEmi smalldatetime
--exec dbo.Com_ValidaSolicitudReq '11111111111','NRO-00000000001',@Cd_SR out,@FecEmi out,null
GO

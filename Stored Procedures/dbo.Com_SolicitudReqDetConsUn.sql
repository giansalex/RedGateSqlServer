SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_SolicitudReqDetConsUn]
@RucE nvarchar(11),
@Cd_SR char(10),
@Item int,
@msj varchar(100) output

as
if not exists(select * from SolicitudReqDet where RucE=@RucE and Cd_SR=@Cd_SR and Item=@Item)
	set @msj = 'Detalle de solicitud de requerimientos no existe'
else
begin
	select	*
	from SolicitudReqDet 
	where RucE=@RucE and Cd_SR=@Cd_SR and Item=@Item
end

-- Leyenda --
--J -> 09-09-2010 <Creacion del procedimiento almacenado>
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Com_SolicitudReqDet2Elim]
@RucE nvarchar(11),
@Cd_SR char(10),
@msj varchar(100) output
as
if not exists(select * from SolicitudReqDet2 where RucE=@RucE and Cd_SR=@Cd_SR)
	set @msj = 'Detalle de solicitud de requerimientos no existe'
else
begin 
	Delete from SolicitudReqDet2 
	where RucE=@RucE and Cd_SR=@Cd_SR

	if @@rowcount <= 0
	begin
		set @msj = 'Detalle de Solicitud de requerimientos no pudo ser eliminado'
	end

end
print @msj
GO

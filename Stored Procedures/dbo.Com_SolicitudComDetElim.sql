SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_SolicitudComDetElim]
@RucE nvarchar(11),
@Cd_SC char(10),
--@Item int,
@msj varchar(100) output
as
if not exists(select * from SolicitudComDet where RucE=@RucE and Cd_SC=@Cd_SC) --and Item=@Item)
	set @msj = 'Detalle de solicitud de compra no existe'
else
begin 
	Delete from SolicitudComDet 
	where RucE=@RucE and Cd_SC=@Cd_SC-- and Item=@Item	


	if @@rowcount <= 0
	begin
		set @msj = 'Detalle de Solicitud de compra no pudo ser eliminado'
	end

end
print @msj
--J -> 05-05-2010 <Creacion del procedimiento almacenado>
GO

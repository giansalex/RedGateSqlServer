SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_SolicitudComDetConsUn]
@RucE nvarchar(11),
@Cd_SC char(10),
@Item int,
@msj varchar(100) output

as
if not exists(select * from SolicitudComDet where RucE=@RucE and Cd_SC=@Cd_SC and Item=@Item)
	set @msj = 'Detalle de solicitud de compra no existe'
else
begin
	select	*
	from SolicitudComDet 
	where RucE=@RucE and Cd_SC=@Cd_SC and Item=@Item
end

-- Leyenda --
--J -> 05-05-2010 <Creacion del procedimiento almacenado>
GO

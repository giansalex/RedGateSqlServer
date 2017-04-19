SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ValidarDocumento]
@RucE nvarchar(11),
@Cd_SCo char(10),
@msj varchar(100) output
as
if not exists (select * from SolicitudCom where RucE=@RucE and Cd_SCo=@Cd_SCo)
	Set @msj = 'No existe Solicitud de Compra'
else
begin	
	select oc.Cd_SCo from ordCompra oc
	inner join solicitudCom sc on sc.RucE=oc.RucE and sc.Cd_SCo=oc.Cd_SCo
	where sc.RucE=@RucE and sc.Cd_SCo=@Cd_SCo group by oc.Cd_SCo
end
print @msj
GO

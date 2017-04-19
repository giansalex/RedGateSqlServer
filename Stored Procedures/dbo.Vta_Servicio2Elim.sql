SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Servicio2Elim]
@RucE nvarchar(11),
@Cd_Srv char(7),
@msj varchar(100) output
as
if not exists (select * from Servicio2 where RucE=@RucE and Cd_Srv = @Cd_Srv)
	set @msj = 'Servicio no existe'
else
begin
	delete from Servicio2 where RucE=@RucE and Cd_Srv = @Cd_Srv
	
	if @@rowcount <= 0
	set @msj = 'Servicio no pudo ser eliminado'	
end
print @msj
GO

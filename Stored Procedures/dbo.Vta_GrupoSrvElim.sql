SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_GrupoSrvElim]
@RucE nvarchar(11),
@Cd_GS nvarchar(6),
@msj varchar(100) output
as
if not exists (select * from GrupoSrv where RucE=@RucE and Cd_GS=@Cd_GS)
	set @msj = 'Grupo Servicio no existe'
else
begin
	delete from GrupoSrv where RucE=@RucE and Cd_GS=@Cd_GS
	if @@rowcount <= 0
	   set @msj = 'Grupo Servicio no pudo ser eliminado'
end
print @msj
GO

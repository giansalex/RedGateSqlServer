SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_GrupoSrvConsUn]
@RucE nvarchar(11),
@Cd_GS nvarchar(6),
@msj varchar(100) output
as
if not exists (select * from GrupoSrv where RucE=@RucE and Cd_GS=@Cd_GS)
	set @msj = 'Grupo Servicio no existe'
else	select * from GrupoSrv where RucE=@RucE and Cd_GS=@Cd_GS
print @msj
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_GrupoSrvMdf]
@RucE nvarchar(11),
@Cd_GS nvarchar(6),
@Descrip varchar(50),
@NCorto varchar(6),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from GrupoSrv where RucE=@RucE and Cd_GS=@Cd_GS)
	set @msj = 'Grupo Servicio no existe'
else
begin
	update GrupoSrv set Descrip=@Descrip, NCorto=@NCorto, Estado=@Estado
	where RucE=@RucE and Cd_GS=@Cd_GS
	if @@rowcount <= 0
	   set @msj = 'Grupo Servicio no pudo ser modificado'
end
print @msj
GO

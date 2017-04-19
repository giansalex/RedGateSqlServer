SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_GrupoSrvCrea]
@RucE nvarchar(11),
@Cd_GS nvarchar(6),
@Descrip varchar(50),
@NCorto varchar(6),
--@Estado bit,
@msj varchar(100) output
as
if exists (select * from GrupoSrv where RucE=@RucE and Cd_GS=@Cd_GS)
	set @msj = 'Ya existe Grupo de servicio con el mismo codigo'
else
begin
	insert into GrupoSrv(RucE,Cd_GS,Descrip,NCorto,Estado)
	              values(@RucE,@Cd_GS,@Descrip,@NCorto,1)
	if @@rowcount <= 0
	   set @msj = 'Grupo Servicio no pudo ser registrado'
end
print @msj
GO

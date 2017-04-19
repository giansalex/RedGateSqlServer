SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_EnvioSolComElim]
@RucE nvarchar(11),
@Cd_CESCo int,
@msj varchar(100) output
as
begin
begin transaction
if exists ( select *from CfgEnvSC where RucE=@RucE and Cd_CESCo=@Cd_CESCo)
begin
	delete from CfgEnvSC where RucE=@RucE and Cd_CESCo=@Cd_CESCo
	if @@rowcount <= 0
	begin
		set @msj='Errir al eliminar Configuracion'
		rollback transaction
		return
	end
end
commit transaction
end
-- Leyenda --
-- JJ : 2010-12-17 : <Creacion del procedimiento almacenado
GO

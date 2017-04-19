SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--sp_help CfgEnvCot
CREATE procedure [user321].[Cfg_EnvioCotElim]
@RucE nvarchar(11),
@Cd_CECot int,
@msj varchar(100) output
as
begin
begin transaction
if exists ( select *from CfgEnvCot where RucE=@RucE and Cd_CECot=@Cd_CECot)
begin
	delete from CfgEnvCot where RucE=@RucE and  Cd_CECot=@Cd_CECot
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
-- JJ : 2010-12-20 : <Creacion del procedimiento almacenado>
GO

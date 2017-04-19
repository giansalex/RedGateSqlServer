SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_EnvioCorreoElim]
@RucE nvarchar(11),
@Cd_CEC int,
@msj varchar(100) output
as
begin
--declare @Principal bit
--select @Principal = EsPrincipal from CfgEnvCorreo where RucE=@RucE and Cd_CEC=@Cd_CEC 

begin transaction
if exists (select * from CfgEnvCorreo where RucE=@RucE and Cd_CEC=@Cd_CEC)
	begin
	delete from CfgEnvSC where Cd_CEC=@Cd_CEC and RucE=@RucE
	delete from CfgEnvCot where Cd_CEC=@Cd_CEC and RucE=@RucE
	delete from CfgEnvCorreo where Cd_CEC=@Cd_CEC and RucE=@RucE
		if @@rowcount <= 0
		begin
			set @msj = 'No se puede eliminar debido a que esta vinculado con Envio de Correo a SC o COT'
			rollback transaction
			return
		end
	end
commit transaction
end
-- Leyenda --
-- JJ : 2010-12-17 : <Creacion del procedimiento almacenado
GO

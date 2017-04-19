SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Cfg_EnvioCorreoElim_1]
@RucE nvarchar(11),
@Cd_CEC int,
@msj varchar(100) output
as
begin
declare @Principal bit
declare @Cd_Extra int
select @Principal = EsPrincipal from CfgEnvCorreo where RucE=@RucE and Cd_CEC=@Cd_CEC 

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
		else
		begin
			if(@Principal = 1)
			begin
				select top 1 @Cd_Extra = Cd_CEC from CfgEnvCorreo where RucE=@RucE
				if (@Cd_Extra is not null and @Cd_Extra != '')
				begin
					update CfgEnvCorreo set EsPrincipal = 1 where RucE=@RucE and Cd_CEC=@Cd_Extra
				end
			end
		end
		
	end
commit transaction
/*
if(@Principal = 1)
begin
	select top 1 @Cd_Extra = Cd_CEC from CfgEnvCorreo where RucE=@RucE
	if (@Cd_Extra is not null and @Cd_Extra != '')
	begin
		update CfgEnvCorreo set EsPrincipal = 1 where RucE=@RucE and Cd_CEC=@Cd_Extra
	end
end
*/
end
-- Leyenda --
-- JJ : 2010-12-17 : <Creacion del procedimiento almacenado
/*
declare @Cd_Extra int
select top 1 @Cd_Extra = Cd_CEC from CfgEnvCorreo where RucE='11111111111'
print @Cd_Extra
*/
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_CampoElim]
@RucE nvarchar(11),
@Cd_Cp nvarchar(2),
@msj varchar(100) output
as
if not exists (select * from Campo where RucE=@RucE and Cd_Cp=@Cd_Cp)
	set @msj = 'No existe Campo'
else
begin
	if  exists (select * from CampoV where RucE=@RucE and Cd_Cp=@Cd_Cp)
	begin
		set @msj = 'Campo tiene información vinculada. No puede ser eliminado'
		return
	end

	delete from Campo where RucE=@RucE and Cd_Cp=@Cd_Cp

	if @@rowcount <= 0
	   set @msj = 'Campo no pudo ser eliminado'
	else
	begin
		delete from VentaCfg where RucE=@RucE and Cd_Cp=@Cd_Cp
	end
end
print @msj
--DE  --> Vie26/12/08
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_GeneralRMElim]
@RucE nvarchar(11),
@NroReg int,
@msj varchar(100) output
as
if not exists (select * from GeneralRM where RucE=@RucE and NroReg=@NroReg)
	set @msj = 'No exists registro'
else
begin
	delete from GeneralRM where RucE=@RucE and NroReg=@NroReg
	
	if @@rowcount <= 0
		set @msj = 'No se pudo eliminar general RM'
end
print @msj
GO

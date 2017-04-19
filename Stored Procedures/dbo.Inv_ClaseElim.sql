SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ClaseElim]
@RucE nvarchar(11),
@Cd_CL char(3),
@msj varchar(100) output
as
if not exists (select * from Clase where RucE=@RucE and Cd_CL=@Cd_CL)
	set @msj = 'Clase no existe'
else
begin
	delete from ClaseSubSub where RucE=@RucE and Cd_CL=@Cd_CL
	delete from ClaseSub where RucE=@RucE and Cd_CL=@Cd_CL
	delete from Clase where RucE=@RucE and Cd_CL=@Cd_CL

	if @@rowcount <= 0
	   set @msj = 'Clase no pudo ser eliminado'
end
print @msj

GO

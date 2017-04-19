SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_SClaseElim]
@RucE nvarchar(11),
@Cd_CL char(3),
@Cd_CLS char(3),
@msj varchar(100) output
as
if not exists (select * from ClaseSub where RucE=@RucE and Cd_CL=@Cd_CL and Cd_CLS=@Cd_CLS)
	set @msj = 'Sub Clase no existe'
else
begin
	delete from ClaseSubSub where RucE=@RucE and Cd_CL=@Cd_CL and Cd_CLS=@Cd_CLS
	delete from ClaseSub where RucE=@RucE and Cd_CL=@Cd_CL and Cd_CLS=@Cd_CLS

	if @@rowcount <= 0
	   set @msj = 'Sub Clase no pudo ser eliminada'
end
print @msj
GO

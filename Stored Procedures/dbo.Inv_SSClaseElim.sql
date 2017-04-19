SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_SSClaseElim]
@RucE nvarchar(11),
@Cd_CL char(3),
@Cd_CLS char(3),
@Cd_CLSS char(3),
@msj varchar(100) output
as
if not exists (select * from ClaseSubSub where RucE=@RucE and Cd_CL=@Cd_CL and Cd_CLS=@Cd_CLS and Cd_CLSS=@Cd_CLSS)
	set @msj = 'Sub Sub Clase no existe'
else
begin
	delete from ClaseSubSub where RucE=@RucE and Cd_CL=@Cd_CL and Cd_CLS=@Cd_CLS and Cd_CLSS=@Cd_CLSS
	if @@rowcount <= 0
	   set @msj = 'SSub Sub Clase no pudo ser modificada'
end
print @msj
GO

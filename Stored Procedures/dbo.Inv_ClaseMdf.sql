SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ClaseMdf]
@RucE nvarchar(11),
@Cd_CL char(3),
@Nombre varchar(50),
@NCorto varchar(6),
@Estado bit,
@CA01 varchar(100),
@CA02 varchar(100),
@msj varchar(100) output
as
if not exists (select * from Clase where RucE=@RucE and Cd_CL=@Cd_CL)
	set @msj = 'Clase no existe'
else
begin
	update Clase set Nombre=@Nombre,NCorto=@NCorto,Estado=@Estado,CA01=@CA01,CA02=@CA02
	where RucE=@RucE and Cd_CL=@Cd_CL

	if @@rowcount <= 0
	   set @msj = 'Clase no pudo ser modificada'
end
print @msj
GO

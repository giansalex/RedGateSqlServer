SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_SSClaseMdf]
@RucE nvarchar(11),
@Cd_CL char(3),
@Cd_CLS char(3),
@Cd_CLSS char(3),
@Nombre varchar(50),
@NCorto varchar(6),
@Estado bit,
@CA01 varchar(100),
@CA02 varchar(100),
@msj varchar(100) output
as
if not exists (select * from ClaseSubSub where RucE=@RucE and Cd_CL=@Cd_CL and Cd_CLS=@Cd_CLS and Cd_CLSS=@Cd_CLSS)
	set @msj = 'Sub Sub Clase no existe'
else
begin
	update ClaseSubSub set RucE=@RucE,Cd_CL=@Cd_CL,Cd_CLS=@Cd_CLS,Cd_CLSS=@Cd_CLSS,Nombre=@Nombre, NCorto=@NCorto,
	Estado=@Estado,CA01=@CA01,CA02=@CA02
	where RucE=@RucE and Cd_CL=@Cd_CL and Cd_CLS=@Cd_CLS and Cd_CLSS=@Cd_CLSS
	
	if @@rowcount <= 0
	   set @msj = 'Sub Sub Clase no pudo ser modificada'
end
print @msj
GO

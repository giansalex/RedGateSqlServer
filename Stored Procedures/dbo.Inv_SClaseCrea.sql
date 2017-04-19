SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_SClaseCrea]
@RucE nvarchar(11),
@Cd_CL char(3),
@Cd_CLS char(3),
@Nombre varchar(50),
@NCorto varchar(6),
@Estado bit,
@CA01 varchar(100),
@CA02 varchar(100),
@msj varchar(100) output
as
if exists (select * from ClaseSub where RucE=@RucE and Cd_CL=@Cd_CL and Cd_CLS=@Cd_CLS)
	set @msj = 'Ya existe Sub Clase'
else
begin
	insert into ClaseSub(RucE,Cd_CL,Cd_CLS,Nombre,NCorto,Estado,CA01,CA02)
		     values(@RucE,@Cd_CL,@Cd_CLS,@Nombre,@NCorto,1,@CA01,@CA02)
	if @@rowcount <= 0
	   set @msj = 'Sub Clase no pudo ser ingresada'

end
print @msj
GO

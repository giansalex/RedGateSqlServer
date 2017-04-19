SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ClaseCrea]
@RucE nvarchar(11),
@Cd_CL char(3),
@Nombre varchar(50),
@NCorto varchar(6),
@Estado bit,
@CA01 varchar(100),
@CA02 varchar(100),
@msj varchar(100) output
as
if exists (select * from Clase where RucE=@RucE and Cd_CL=@Cd_CL)
	set @msj = 'Ya existe la Clase'
else
begin
	insert into Clase(RucE,Cd_CL,Nombre,NCorto,Estado,CA01,CA02)
		     values(@RucE,@Cd_CL,@Nombre,@NCorto,1,@CA01,@CA02)

	if @@rowcount <= 0
	   set @msj = 'Clase no pudo ser ingresado'

end
print @msj
GO

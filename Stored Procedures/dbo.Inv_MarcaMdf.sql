SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_MarcaMdf]
@RucE nvarchar(11),
@Cd_Mca char(3),
@Nombre varchar(50),
@Descrip varchar(50),
@NCorto varchar(5),
@Estado bit,
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@msj varchar(100) output
as
if not exists (select * from Marca where RucE = @RucE and Cd_Mca=@Cd_Mca)
	set @msj = 'Marca no existe.'
else
begin
	update Marca set Nombre=@Nombre, NCorto=@NCorto, Descrip=@Descrip, 
                         Estado=@Estado, CA01 =@CA01, CA02 =@CA02, CA03 =@CA03
	where RucE = @RucE and Cd_Mca=@Cd_Mca 
	
	if @@rowcount <= 0
	set @msj = 'Marca no pudo ser modificado.'	
end
print @msj

GO

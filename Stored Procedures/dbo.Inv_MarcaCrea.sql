SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_MarcaCrea]
@RucE nvarchar(11),
--@Cd_Mca nvarchar(2),
@Nombre varchar(50),
@Descrip varchar(100),
@NCorto varchar(5),
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
--@Estado bit,
@msj varchar(100) output,
@Cd_Mca char(3) output
as
if exists (select * from Marca where Nombre=@Nombre and RucE = @RucE)
	set @msj = 'Ya existe una Marca con el nombre ['+@Nombre+']'
else
begin
	set @Cd_Mca = user123.Cod_Mca(@RucE)
	insert into Marca(RucE,Cd_Mca,Nombre,Descrip,NCorto,Estado,CA01,CA02,CA03)
		   Values(@RucE,@Cd_Mca,@Nombre,@Descrip,@NCorto,1,@CA01,@CA02,@CA03)
	
	if @@rowcount <= 0
	set @msj = 'Marca no pudo ser registrado'	
end
print @msj


--MP : 21-02-2011 : <Modificacion del procedimiento almacenado>
GO

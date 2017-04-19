SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CategCrea]
--@Cd_Cat nvarchar(2),
@Nombre varchar(50),
@NCorto varchar(5),
--@Estado bit,
@msj varchar(100) output
as
if exists (select * from Categoria where Nombre=@Nombre)
	set @msj = 'Ya existe una categoria con el nombre ['+@Nombre+']'
else
begin
	insert into Categoria(Cd_Cat,Nombre,NCorto,Estado)
	values(user123.Cod_Cat(),@Nombre,@NCorto,1)	
	
	if @@rowcount <= 0
	set @msj = 'Categoria no pudo ser registrado'	
end
GO

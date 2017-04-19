SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CategMdf]
@Cd_Cat nvarchar(2),
@Nombre varchar(50),
@NCorto varchar(5),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from Categoria where Cd_Cat=@Cd_Cat)
	set @msj = 'Categoria no existe'
else
begin
	update Categoria set Nombre=@Nombre, NCorto=@NCorto, Estado=@Estado
	where Cd_Cat=@Cd_Cat

	if @@rowcount <= 0
	set @msj = 'Categoria no pudo ser modificado'	
end
GO

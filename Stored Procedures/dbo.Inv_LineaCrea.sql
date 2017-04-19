SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_LineaCrea]
--@Cd_Ln nvarchar(2),
@Nombre varchar(50),
@NCorto varchar(5),
--@Estado bit,
@msj varchar(100) output
as
if exists (select * from Linea where Nombre=@Nombre)
	set @msj = 'Ya existe una Linea con el nombre ['+@Nombre+']'
else
begin
	insert into Linea(Cd_Ln,Nombre,NCorto,Estado)
		   Values(user123.Cod_Ln(),@Nombre,@NCorto,1)
	
	if @@rowcount <= 0
	set @msj = 'Linea no pudo ser registrado'	
end
print @msj
GO

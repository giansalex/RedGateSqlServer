SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[TablaMdf]
@Cd_Tab char(4),@Nombre varchar(30),
@msj varchar(100) output
as

--set @Id_CTb = dbo.Id_CTb()

if not exists (select * from Tabla where Cd_Tab=@Cd_Tab)
	set @msj = 'No existe la tabla'
else 
begin
update Tabla set Nombre=@Nombre
		where 	Cd_Tab=@Cd_Tab
end
-- Leyenda --
-- MP : 2010-12-31 : <Creacion del procedimiento almacenado>

GO

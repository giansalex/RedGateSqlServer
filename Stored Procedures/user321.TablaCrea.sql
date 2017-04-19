SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[TablaCrea]
@Cd_Tab char(4),@Nombre varchar(30),
@msj varchar(100) output
as

--set @Id_CTb = dbo.Id_CTb()

if exists (select * from Tabla where Cd_Tab=@Cd_Tab)
	set @msj = 'Ya existe la tabla'
else 
begin
insert 	into 	Tabla(Cd_Tab,Nombre,Ventana)
	values	(@Cd_Tab,@Nombre,@Nombre)
end
-- Leyenda --
-- MP : 2010-12-31 : <Creacion del procedimiento almacenado>
GO

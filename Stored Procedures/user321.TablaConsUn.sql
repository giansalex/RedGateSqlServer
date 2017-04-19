SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[TablaConsUn]
@Cd_Tab char(4),
@msj varchar(100) output
as

if not exists (select top 1 *from Tabla where Cd_Tab=@Cd_Tab)
	set @msj='No se encontro tabla'
else 
Begin
	select 	con.Cd_Tab,con.Nombre
	from 	Tabla con
	where 	con.Cd_Tab=@Cd_Tab
end
-- Leyenda --
-- MP : 2010-12-31 : <Creacion del procedimiento almacenado>
GO

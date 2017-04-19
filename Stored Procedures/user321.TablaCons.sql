SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[TablaCons]
@msj varchar(100) output
as
if not exists (select top 1 *from Tabla)
	set @msj='No se encontro tablas'
else
begin
	select 	con.Cd_Tab,con.Nombre
	from 	Tabla con
end
-- Leyenda --
-- MP : 2010-12-31 : <Creacion del procedimiento almacenado>
GO

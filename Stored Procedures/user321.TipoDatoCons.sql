SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[TipoDatoCons]
@msj varchar(100) output
as

set @msj = ''

if not exists (select top 1 *from TipoDato)
	set @msj='No se encontro tipos de datos'
else
begin
	select Id_TDt, Descrip, Estado 
	from TipoDato
end
-- Leyenda --
-- MP : 2011-01-03 : <Creacion del procedimiento almacenado>







GO

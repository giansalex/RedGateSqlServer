SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_EstadoCtaCons]
@RucE nvarchar(11),
@msj varchar(100) output

as

begin
	if exists (select * from EstadoCta where RucE = @RucE)
		select * from EstadoCta where RucE = @RucE
	else
		set @msj = 'No hay registros de Estado de Cta.'
end
print @msj



-- Leyenda --
-- MP : 2011-05-25 : <Creacion del procedimiento almacenado>

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionDetElimTodos]
@RucE nvarchar(11),
@Cd_GR char(10),
@msj varchar(100) output

as
if not exists (select * from GuiaRemisionDet where RucE = @RucE and Cd_GR=@Cd_GR)
	set @msj = 'Detalle de Guia de Remision no existe'
else
begin
	delete from GuiaRemisionDet where RucE = @RucE and Cd_GR=@Cd_GR
	
	if @@rowcount <= 0
		set @msj = 'Detalle de Guia de Remision no pudo ser elimanda'			
end
print @msj

-- Leyenda --
-- FL : 2010-12-21	: <Creacion del procedimiento almacenado>


GO

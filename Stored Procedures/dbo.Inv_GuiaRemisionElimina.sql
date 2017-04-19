SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaRemisionElimina]
@RucE nvarchar(11),
@Cd_GR char(10),
@msj varchar(100) output
as
if not exists (select * from GuiaRemision where RucE=@RucE and Cd_GR=@Cd_GR)
	set @msj = 'Guia de Remision No Existe'
else
begin
	delete from guiaremision where RucE=@RucE and Cd_GR=@Cd_GR
	if @@rowcount <= 0
		set @msj = 'Guia de Remision no pudo ser eliminada'
end
print @msj

-- Leyenda --
-- FL : 2010-11-10 : <Creacion del procedimiento almacenado>
-- FL : 2010-12-21 : <Modificacion del procedimiento almacenado>


GO

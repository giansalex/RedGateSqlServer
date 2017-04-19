SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GRPtoLlegadaElimTodos]
@RucE nvarchar(11),
@Cd_GR char(10),
@msj varchar(100) output
as
if not exists (select * from GRPtoLlegada where RucE=@RucE  and Cd_GR= @Cd_GR)
	set @msj = 'Punto de llegada no existe'
else
begin
	delete from GRPtoLlegada where RucE= @RucE  and Cd_GR= @Cd_GR
	if @@rowcount <= 0
	set @msj = 'Punto de llegada no pudo ser eliminado'	
end
print @msj
-- Leyenda --
-- FL : 2010-12-21: <Creacion del procedimiento almacenado>


GO

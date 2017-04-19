SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_AsientoElimTodosXMtvoIngSal]  --<Procedimiento que elimina todos los asientos de un Movimiento de Ingreso y Salida>
@Cd_MIS char(3),
@Ejer varchar(4),
@msj varchar(100) output
as
if not exists (select * from Asiento where Cd_MIS=@Cd_MIS and Ejer=@Ejer)
	set @msj = 'No posee asientos con el cd_mis indicado'
else
begin
	delete from Asiento where Cd_MIS=@Cd_MIS and Ejer=@Ejer

	if @@rowcount <= 0
	set @msj = 'Los asientos no pudieron ser eliminados'
end
------------
--MM : 10-11-2010 - <Creacion del procedimiento almacenado>

GO

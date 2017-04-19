SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Vta_Venta2DetElim]
@RucE nvarchar (11),
@Cd_Vta nvarchar(10),
@msj varchar(100) output
as


begin
begin transaction
if exists (select * from VentaDet where RucE =@RucE and Cd_Vta = @Cd_Vta)
begin
	delete from VentaDet where RucE =@RucE and Cd_Vta = @Cd_Vta
	if @@rowcount  <= 0
	begin 
	set @msj = 'Error al eliminar Venta Detalle'
	rollback transaction
	return
	end
end 
commit transaction
end
-- Leyenda --
-- JJ : 2010-09-15 : <Creacion del procedimiento almacenado>
GO

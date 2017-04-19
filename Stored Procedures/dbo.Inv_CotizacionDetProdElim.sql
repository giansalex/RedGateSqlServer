SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionDetProdElim]
@RucE nvarchar(11),
@Cd_Cot char(10),
@ID_CtD int,
@Cadena varchar(100),
@msj varchar(100) output

as

begin
begin transaction

	exec ('delete from CotizacionProdDet where RucE='''+@RucE+''' and Cd_Cot='''+@Cd_Cot+''' and ID_CtD='''+@ID_CtD+''' and Item in ('+@Cadena+')')
	if @@rowcount <= 0
	begin
		Set @msj = 'Error al eliminar detalle del producto'
		rollback transaction
		return
	end

commit transaction
end

-- Leyenda --
-- DI : 05/03/2010 : <Creacion del procedimiento almacenado>
GO

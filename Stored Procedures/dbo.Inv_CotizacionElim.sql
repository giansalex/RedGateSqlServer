SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionElim]

@RucE nvarchar(11),
@Cd_Cot char(10),
@msj varchar(100) output

as
if not exists (select * from Cotizacion where RucE=@RucE and Cd_Cot=@Cd_Cot)
	Set @msj = 'No existe cotizacion con el codigo :'+@Cd_Cot
else
begin
begin transaction

	delete from CotizacionProdDet where RucE=@RucE and Cd_Cot=@Cd_Cot
	delete from CotizacionDet where RucE=@RucE and Cd_Cot=@Cd_Cot

	delete from Cotizacion where RucE=@RucE and Cd_Cot=@Cd_Cot
	if @@rowcount <= 0
	begin
		Set @msj = 'Error al eliminar cotizacion'
		rollback transaction
		return
	end
commit transaction
end

-- Leyenda --
-- DI : 05/03/2010 : <Creacion del procedimiento almacenado>
GO

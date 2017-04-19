SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionDetProdMdf]
@RucE nvarchar(11),
@Cd_Cot char(10),
@ID_CtD int,
@Item int,
@Cpto varchar(50),
@Valor varchar(50),
@msj varchar(100) output

as

if not exists (select * from CotizacionProdDet where RucE=@RucE and Cd_Cot=@Cd_Cot and ID_CtD=@ID_CtD and Item=@Item)
	Set @msj = 'No existe el item en detalle de producto'
else
begin
	update CotizacionProdDet Set
		Cpto = @Cpto,
		Valor = @Valor
	where RucE=@RucE and Cd_Cot=@Cd_Cot and ID_CtD=@ID_CtD and Item=@Item
	if @@rowcount <= 0
	begin
		Set @msj = 'Error al modificar detalle de producto'
	end
end
print @msj

-- Leyedan --
-- DI : 17/03/2010 : <Creacion del procedimiento almacenado>
GO

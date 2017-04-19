SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_CotizacionDetProdCrea]

/*
Declare @msj varchar(100)
exec Inv_CotizacionDetProdCrea '11111111111','2','Concepto4','Informacion 4',@msj output
print @msj
*/

@RucE nvarchar(11),
@Cd_Cot char(10),
@ID_CtD int,
--@Item int,
@Cpto varchar(50),
@Valor varchar(50),
@msj varchar(100) output

as

if exists (select * from CotizacionProdDet where RucE=@RucE and Cd_Cot=@Cd_Cot and ID_CtD=@ID_CtD and Item=user123.Itemx(@RucE,@Cd_Cot,@ID_CtD))
	Set @msj = 'Ya existe el item en detalle de producto de cotizacion'
else
begin
	insert into CotizacionProdDet(RucE,Cd_Cot,ID_CtD,Item,Cpto,Valor)
			       Values(@RucE,@Cd_Cot,@ID_CtD,user123.Itemx(@RucE,@Cd_Cot,@ID_CtD),@Cpto,@Valor)
	if @@rowcount <= 0
	begin
		Set @msj = 'Error al registrar detalle de producto de cotizacion'
	end
end
print @msj
-- Leyedan --
-- DI : 04/03/2010 : <Creacion del procedimiento almacenado>
GO

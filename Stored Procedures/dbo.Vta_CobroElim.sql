SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_CobroElim]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@ItmCo int,
@UsuMdf nvarchar(10),
@msj varchar(100) output
as

Declare @Cd_Vta nvarchar(15)
Set @Cd_Vta = ''

--Verificando la existencia del cobro
if not exists (select * from Cobro where RucE=@RucE and Ejer=@Ejer and ItmCo=@ItmCo) 
	Set @msj = 'Informacion seleccionada no existe'
else
begin
	
	--Obteniendo el codigo de venta del cobro a eliminar
	Set @Cd_Vta = (select Cd_Vta from Cobro where RucE=@RucE and Ejer=@Ejer and ItmCo=@ItmCo)
	
	--eliminando el registro seleccionado
	delete from Cobro where RucE=@RucE and Ejer=@Ejer and ItmCo=@ItmCo
	if @@rowcount <= 0
		Set @msj = 'No se pudo eliminar informacion de cobro'

	--Actualizando el campo Cobro a estado pendiente en la tabla ventas
	update Venta Set IB_Cbdo=NULL where RucE=@RucE and Eje=@Ejer and Cd_Vta=@Cd_Vta
	if @@rowcount <= 0
		Set @msj = 'No se pudo actualizar informacion en venta'	

	--comprobando la existencia de otros registros de ventas existentes al cobro seleccionado
	/*
	if exists (select * from Cobro where RucE=@RucE and Ejer=@Ejer and Cd_Vta=@Cd_Vta)
	begin
		--actualizando toda informacion de T a P del codigo de venta obtenido
		update Cobro Set IC_TipPag='P' where RucE=@RucE and Ejer=@Ejer and Cd_Vta=@Cd_Vta
		if @@rowcount <= 0
			Set @msj = 'No se pudo modificar informacion de cobro'
	end
	*/
end

--DIE : 21/08/2009 Mensaje : se creo el procedimiento almacenado Vta_CobroElim
GO

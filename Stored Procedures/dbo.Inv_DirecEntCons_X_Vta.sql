SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_DirecEntCons_X_Vta]
@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@Cd_Clt char(10) output,
@Direc varchar(100) output,
@msj varchar(100) output
as
begin
	select @Cd_Clt=Cd_Clt from Venta where RucE=@RucE and Cd_Vta=@Cd_Vta
	if(@Cd_Clt=null) set @msj='No hay Cliente asociado a la venta'
	else
	select Direc from DirecEnt where RucE = @RucE and Cd_Clt = @Cd_Clt and Estado = 1
end
print @msj
print @Cd_Clt
print @Direc
-- Leyenda --
-- PP : 2010-08-01 11:43:34.747	: <Creacion del procedimiento almacenado>
-- FL : 2010-09-03 <Se modifico el proc, ahora se pasa codigo de cliente en vez del codigo de venta>
-- FL : 2010-10-12 <Se modifico el proc, ahora recibe cd_vta y trae de cliente>
GO

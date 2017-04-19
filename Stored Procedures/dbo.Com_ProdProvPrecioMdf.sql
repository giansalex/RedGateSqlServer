SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_ProdProvPrecioMdf]
@RucE nvarchar(11),
@ID_PrecPrv int,
@Cd_Prv char(7),
@Cd_Prod char(7),
@ID_UMP int,
@Fecha smalldatetime,
@PrecioCom numeric(13,2),
@IB_IncIGV bit,
@Cd_Mda nvarchar(4),
@Obs nvarchar(100),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from ProdProvPrecio where RucE=@RucE and ID_PrecPrv=@ID_PrecPrv and Cd_Prv=@Cd_Prv and Cd_Prod=@Cd_Prod and ID_UMP=@ID_UMP)
	set @msj = 'Producto no existe'
else
begin
	update ProdProvPrecio
	set
	RucE = @RucE,ID_PrecPrv = @ID_PrecPrv,Cd_Prv = @Cd_Prv,Cd_Prod = @Cd_Prod,ID_UMP = @ID_UMP,
	Fecha = @Fecha,PrecioCom = @PrecioCom,IB_IncIGV = @IB_IncIGV,Cd_Mda = @Cd_Mda,Obs = @Obs,
	@Estado = Estado
	where RucE=@RucE and ID_PrecPrv=@ID_PrecPrv and Cd_Prv=@Cd_Prv and Cd_Prod=@Cd_Prod and ID_UMP=@ID_UMP
	if @@rowcount <= 0
	set @msj = 'Producto no pudo ser modificado'	
end
print @msj
-- Leyenda --
-- FL : 2010-08-23 : <Creacion del procedimiento almacenado>


GO

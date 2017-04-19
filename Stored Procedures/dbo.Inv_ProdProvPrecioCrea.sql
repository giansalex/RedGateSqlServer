SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_ProdProvPrecioCrea] -- <Procedimiento que registra los precios de un producto por proveedor>
@RucE nvarchar(11),
@ID_PrecPrv int output,
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
set @ID_PrecPrv = dbo.Id_PrecPrv(@RucE)
if exists (select * from ProdProvPrecio where RucE=@RucE and ID_PrecPrv=@ID_PrecPrv)
	set @msj = 'Ya se ha registrado ese precio para el producto'
else
begin
	insert into ProdProvPrecio(RucE,ID_PrecPrv,Cd_Prv,Cd_Prod,ID_UMP,Fecha,PrecioCom,IB_IncIGV,Cd_Mda,Obs,Estado)
	values(@RucE,@ID_PrecPrv,@Cd_Prv,@Cd_Prod,@ID_UMP,@Fecha,@PrecioCom,@IB_IncIGV,@Cd_Mda,@Obs,@Estado)	
	
	if @@rowcount <= 0
	set @msj = 'Precio no pudo ser registrado'	
end
GO

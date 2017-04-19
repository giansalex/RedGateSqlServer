SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_AgregarProProv] --<Procedimiento que registra los asientos contables>
@RucE nvarchar(11),
@Cd_Prv char(7),
@Cd_Prod char(7),
@ID_UMP int,
@Estado bit,
@msj varchar(100) output
as
if exists (select * from ProdProv where RucE= @RucE and Cd_Prv=@Cd_Prv and Cd_Prod=@Cd_Prod and ID_UMP=@ID_UMP and Estado=@Estado)
	set @msj = 'El proveedor ya cuenta con el producto'
else
begin
	insert into ProdProv(RucE,Cd_Prv,Cd_Prod,ID_UMP,Estado)
	values(@RucE,@Cd_Prv,@Cd_Prod,@ID_UMP,@Estado)	
end
------------
--FL: -16-08-2010 - <Creacion del procedimiento almacenado>
GO

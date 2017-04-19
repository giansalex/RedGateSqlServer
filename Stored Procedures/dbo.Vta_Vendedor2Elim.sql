SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_Vendedor2Elim]
@RucE nvarchar(11),
@Cd_Vdr char(7),
@msj varchar(100) output
as
if not exists (select * from Vendedor2 where RucE=@RucE and Cd_Vdr=@Cd_Vdr)
	set @msj = 'Vendedor no existe'
else if exists (select * from Venta where RucE=@RucE and Cd_Vdr=@Cd_Vdr)
	set @msj = 'Vendedor ' + @Cd_Vdr + ' no puede ser eliminado por tener data relacionada con Venta'
else
begin
	delete from Vendedor2 where Cd_Vdr=@Cd_Vdr and RucE=@RucE

	if @@rowcount <= 0
	set @msj = 'Vendedor no pudo ser eliminado'	
end
-- J 12/03/10 -> creacion


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaXCompraCrea]
@RucE nvarchar(11),
@Cd_GR char(10),
@Cd_Com char(10),
@msj varchar(100) output
as
if not exists(select * from GuiaXCompra where RucE = @RucE and Cd_GR = @Cd_GR and Cd_Com = @Cd_Com)
begin
	insert into GuiaXCompra(RucE,Cd_GR,Cd_Com)
	   values(@RucE,@Cd_GR,@Cd_Com)
	if @@rowcount <= 0
	   set @msj = 'Factura Compra no pudo ser registrada'	
end			
print @msj
-- Leyenda --
-- FL : 2010-10-20 : <Creacion del procedimiento almacenado>


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Vta_ActualizaVenta_PDF] 
 @RucE nvarchar(11),
 @Cd_Vta nvarchar(10),
 @DE_PDF varbinary(MAX),
 @msj varchar(100) output  
AS 
if not exists (select * from venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @msj = 'Venta no existe con codigo '+ @Cd_Vta
else
begin
	UPDATE [dbo].[Venta] SET DE_PDF = @DE_PDF
	where RucE=@RucE and Cd_Vta=@Cd_Vta
	if @@rowcount <= 0
		set @msj = 'No se pudo guarda el PDF'
end
GO

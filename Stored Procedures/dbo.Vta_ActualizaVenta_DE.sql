SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Vta_ActualizaVenta_DE] 
 @RucE nvarchar(11),
 @Cd_Vta nvarchar(10),
 @DE_FirmaDgt varchar(100),
 @DE_XML xml,
 @DE_CDR varbinary(max),
 @DE_FecEnvSNT date,
 @DE_EstEnvSNT char(2),
 @DE_EstEnvClt char(2),
 @msj varchar(100) output  
AS 
if not exists (select * from venta where RucE=@RucE and Cd_Vta=@Cd_Vta)
	set @msj = 'Venta no existe con codigo '+ @Cd_Vta
else
begin
	UPDATE [dbo].[Venta]
	SET   DE_FirmaDgt = @DE_FirmaDgt,
		  DE_XML = @DE_XML,
		  DE_CDR =  @DE_CDR,
		  DE_FecEnvSNT =@DE_FecEnvSNT,
		  DE_EstEnvSNT=@DE_EstEnvSNT,
		  DE_EstEnvClt= @DE_EstEnvClt
	where RucE=@RucE and Cd_Vta=@Cd_Vta
	if @@rowcount <= 0
		set @msj = 'Venta no pudo ser firmado'
end
print @msj
GO

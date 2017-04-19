SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_VinculoMdf]--Actualizacion de datos de vinculos para Persona referencia
@RucE nvarchar(11),
@Cd_Vin char(2),
@Descrip varchar(100),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from Vinculo where RucE= @RucE and Cd_Vin=@Cd_Vin)
	set @msj = 'Vinculo no existe'
else
begin
	update Vinculo set Descrip=@Descrip,Estado=@Estado
	where RucE= @RucE and Cd_Vin=@Cd_Vin

	if @@rowcount <= 0
	set @msj = 'Vinculo no pudo ser modificada'	
end


GO

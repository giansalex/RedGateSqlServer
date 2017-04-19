SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Inv_TipDocESMdf]
@RucE nvarchar(11),
@Cd_TDES char(2),
@Nombre varchar(50),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from TipDocES where RucE=@RucE and Cd_TDES=@Cd_TDES)
	set @msj = 'Tipo de documento no existe'
else
begin
	update TipDocES set Cd_TDES=@Cd_TDES,Nombre=@Nombre,Estado=@Estado
	where RucE=@RucE and Cd_TDES=@Cd_TDES
	
	if @@rowcount <= 0
	   set @msj = 'Tipo de documento no pudo ser modificado'
end
print @msj
GO

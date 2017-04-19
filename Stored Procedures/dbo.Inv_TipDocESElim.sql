SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TipDocESElim]
@RucE nvarchar (11),
@Cd_TDES char(2),
@msj varchar(100) output
as
if not exists (select * from TipDocES where RucE=@RucE and Cd_TDES=@Cd_TDES)
	set @msj = 'Tipo de Documento no no existe'
else
begin
	delete from TipDocES where RucE=@RucE and Cd_TDES=@Cd_TDES
	
	if @@rowcount <= 0
	   set @msj = 'Tipo de documento no pudo ser eliminado'
end
print @msj
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_TipDocESCrear]
@RucE nvarchar(11),
@Cd_TDES char(2),
@Nombre varchar(50),
@Estado bit,
@msj varchar(100) output
as
if exists (select * from TipDocES where RucE=@RucE and Cd_TDES=@Cd_TDES)
	Set @msj = 'Ya existe tipo de documento de Entrada/Salida' 
else
begin 
	insert into TipDocES(RucE,Cd_TDES,Nombre,Estado)
		   values(@RucE,@Cd_TDES,@Nombre,@Estado)
	if @@rowcount <= 0
		Set @msj = 'Error al registrar Tipo de Documento de Entrada/Salida'

end
-- Leyenda --
-- FL : 2011-06-08 : <Creacion del procedimiento almacenado>











GO

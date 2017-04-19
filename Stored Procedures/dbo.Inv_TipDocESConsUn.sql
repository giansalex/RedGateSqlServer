SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_TipDocESConsUn]
@RucE nvarchar(11),
@Cd_TDES char(2),
@msj varchar(100) output
as
if not exists (select * from TipDocES where RucE=@RucE and Cd_TDES =@Cd_TDES)
	set @msj = 'Tipo de Documento de Entrada/Salida no existe'
else
	select * from TipDocES where RucE=@RucE and Cd_TDES =@Cd_TDES
print @msj
-- Leyenda --
-- FL : 2011-06-08 : <Creacion del procedimiento almacenado>

GO

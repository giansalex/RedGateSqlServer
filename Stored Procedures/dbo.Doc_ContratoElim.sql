SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Doc_ContratoElim]
@RucE nvarchar(11),
@Cd_Ctt int,
@msj varchar(100) output

as

if not exists (Select * From Contrato Where RucE=@RucE and Cd_Ctt=@Cd_Ctt)
	Set @msj = 'No se encontro contrato'
else
Begin
	Delete From ContratoDet Where RucE=@RucE and Cd_Ctt=@Cd_Ctt
	Delete From Anexo Where RucE=@RucE and Cd_Ctt=@Cd_Ctt
	Delete From Contrato Where RucE=@RucE and Cd_Ctt=@Cd_Ctt

	if @@rowcount <= 0
		Set @msj = 'Error al eliminar contrato'
	End

-- Leyenda --
-- DI : 31/10/2011 <Se creo procedimiento almacenado>

GO

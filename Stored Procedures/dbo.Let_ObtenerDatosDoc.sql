SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Let_ObtenerDatosDoc]

@RucE nvarchar(11),
@Cd_Vta nvarchar(10),
@msj varchar(100) output

AS

If not exists (Select * From Venta Where RucE=@RucE and Cd_Vta=@Cd_Vta)
	Set @msj = 'No existe documento'
Else
Begin
	Select * From Venta Where RucE=@RucE and Cd_Vta=@Cd_Vta
End

-- Leyenda --
-- DI : 15/03/2012 <Creacion del SP>

GO

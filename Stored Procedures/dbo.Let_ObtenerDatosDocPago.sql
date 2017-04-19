SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Let_ObtenerDatosDocPago]

@RucE nvarchar(11),
@Cd_Com nvarchar(10),
@msj varchar(100) output

AS

If not exists (Select * From Compra Where RucE=@RucE and Cd_Com=@Cd_Com)
	Set @msj = 'No existe documento'
Else
Begin
	Select * From Compra Where RucE=RucE and Cd_Com=@Cd_Com
End

-- Leyenda --
-- DI : 09/04/2012 <Creacion del SP>

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_VerificarNroLtrPago]

@RucE nvarchar(11),
@NroLtr varchar(10),

@msj varchar(100) output

AS

If exists (Select * From Letra_Pago Where RucE=@RucE and NroLtr=@NroLtr)
Begin
	Set @msj = 'Ya existe Nro de Letra '+@NroLtr
End

Print @msj

-- Leyenda --
-- DI : 09/04/2012 <Creacion del SP>
GO

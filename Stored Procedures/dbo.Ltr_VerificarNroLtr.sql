SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_VerificarNroLtr]

@RucE nvarchar(11),
@NroLtr varchar(10),

@msj varchar(100) output

AS

If exists (Select * From Letra_Cobro Where RucE=@RucE and NroLtr=@NroLtr)
Begin
	Set @msj = 'Ya existe Nro de Letra '+@NroLtr
End

Print @msj

-- Leyenda --
-- DI : 18/01/2012 <Creacion del SP>
GO

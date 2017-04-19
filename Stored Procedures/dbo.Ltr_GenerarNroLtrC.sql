SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Ltr_GenerarNroLtrC]

@RucE nvarchar(11),
@NroLtr varchar(10) output,
@msj varchar(100)output

AS

Declare @n int, @cod varchar(10)
Select @n = count(*) From Letra_Cobro Where RucE=@RucE
If @n=0
	Set @cod = '0000000001'
Else
Begin
	Select @cod = max(NroLtr) From Letra_Cobro Where RucE=@RucE
	--Set @cod = right(@cod,8)
	Set @n = convert(int, @cod)+1
	Set @cod = right('0000000000'+ltrim(str(@n)), 10)
End

Set @NroLtr = @cod

Print @cod

-- Leyenda --
-- DI : 12/01/2012 <Creacion del SP>

GO

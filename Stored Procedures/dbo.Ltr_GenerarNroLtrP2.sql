SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[Ltr_GenerarNroLtrP2]

@RucE nvarchar(11),
@RefLtr nvarchar(10),
@NroLtr varchar(10) output,
@NroRenv varchar(10) output,
@Numero varchar(20)output,

@msj varchar(100)output

AS

/*
Declare @RucE nvarchar(11) Set @RucE='11111111111'
Declare @RefLtr nvarchar(10) Set @RefLtr=''
Declare @NroLtr varchar(10)
Declare @NroRenv varchar(10)
Declare @Numero varchar(20)
*/

Declare @cod varchar(10), @n int

if(@RefLtr = '')
Begin
	
	Select @n = count(*) From Letra_Pago Where RucE=@RucE
	If @n=0
		Set @cod = right('0000000001', 6)
	Else
	Begin
		Select @cod = max(NroLtr) From Letra_Pago Where RucE=@RucE
		--Set @cod = right(@cod,8)
		Set @n = convert(int, @cod)+1
		Set @cod = right('0000000000'+ltrim(str(@n)), 6)
	End

	Set @NroLtr = @cod
	Set @NroRenv = ''
	Set @Numero = @NroRenv+@NroLtr
End
Else
Begin

	Declare @rnv varchar(5)
	Select @n = Count(*) From Letra_Pago Where RucE=@RucE and NroLtr=@RefLtr and isnull(NroRenv,'')<>''
	If @n=0
		Set @cod = 'R01'
	Else
	Begin
		Select @cod = max(NroRenv) From Letra_Pago Where RucE=@RucE and NroLtr=@RefLtr and isnull(NroRenv,'')<>''
		Set @cod = right(@cod,2)
		Set @n = convert(int, @cod)+1
		Set @cod = 'R'+right('00'+ltrim(str(@n)),2)
	End
	
	Set @NroLtr = @RefLtr
	Set @NroRenv = @cod
	Set @Numero = @NroRenv+@NroLtr
End


Print @NroRenv 
Print @NroLtr 
Print @Numero


-- Leyenda --
-- DI : 09/04/2012 <Creacion del SP>


GO

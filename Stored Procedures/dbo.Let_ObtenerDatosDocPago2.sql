SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Let_ObtenerDatosDocPago2]

@RucE nvarchar(11),
@Cd_Com nvarchar(10),
@Cd_Vou nvarchar(10),
@msj varchar(100) output

AS

if(@Cd_Com<>'')
Begin

	If not exists (Select * From Compra Where RucE=@RucE and Cd_Com=@Cd_Com)
		Set @msj = 'No existe documento'
	Else
	Begin
		Select * From Compra Where RucE=@RucE and Cd_Com=@Cd_Com
	End
	
End
Else
Begin

	If not exists (Select * From Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou)
		Set @msj = 'No existe documento'
	Else
	Begin
		Select * From Voucher Where RucE=@RucE and Cd_Vou=@Cd_Vou
	End
	
End


-- Leyenda --
-- DI : 09/04/2012 <Creacion del SP>

GO
